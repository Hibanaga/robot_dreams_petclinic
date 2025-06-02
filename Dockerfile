FROM node:18-alpine

COPY package*.json .

RUN npm install --production

COPY . .

EXPOSE 8080

CMD ["node", "index.js"]