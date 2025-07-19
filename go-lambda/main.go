package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ses"
)

var sesClient *ses.SES
var sender string

func init() {
	sess := session.Must(session.NewSession())
	sesClient = ses.New(sess)
	sender = os.Getenv("SES_SENDER")
}

func handler(ctx context.Context, event events.DynamoDBEvent) error {
	for _, record := range event.Records {
		if record.EventName != "INSERT" && record.EventName != "MODIFY" {
			continue
		}

		newImage := record.Change.NewImage
		emailAttr, emailOk := newImage["email"]
		nameAttr, nameOk := newImage["name"]
		idAttr, idOk := newImage["userId"]

		if !emailOk || !nameOk || !idOk {
			log.Println("Missing required fields in DynamoDB record")
			continue
		}

		email := trimQuotes(emailAttr.String())
		name := trimQuotes(nameAttr.String())
		userId := trimQuotes(idAttr.String())

		log.Printf("Preparing to send email to: %s (name: %s, userId: %s)", email, name, userId)

		body := fmt.Sprintf("Hello %s,\nYour userId is %s.", name, userId)
		var subject string
		switch record.EventName {
		case "INSERT":
			subject = "Welcome – Your Account Was Created"
		case "MODIFY":
			subject = "Your Account Details Were Updated"
		default:
			subject = "Account Notification"
		}

		input := &ses.SendEmailInput{
			Source: &sender,
			Destination: &ses.Destination{
				ToAddresses: []*string{&email},
			},
			Message: &ses.Message{
				Subject: &ses.Content{Data: &subject},
				Body: &ses.Body{
					Text: &ses.Content{Data: &body},
				},
			},
		}

		output, err := sesClient.SendEmail(input)
		if err != nil {
			log.Printf("Failed to send email to %s: %v", email, err)
			return err
		}

		log.Printf("Email successfully sent to %s. SES Message ID: %s", email, *output.MessageId)
	}

	return nil
}

func main() {
	lambda.Start(handler)
}

func trimQuotes(s string) string {
	return strings.Trim(s, `"`)
}
