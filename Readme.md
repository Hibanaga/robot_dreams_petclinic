# HM-32

```textmate
hibana@mac robot_dreams_petclinic % cd ansible 
hibana@mac ansible % ansible-vault encrypt ansible/group_vars/all/vault.yml
[WARNING]: Error getting vault password file (default): The vault password file /Users/hibana/PhpstormProjects/robot_dreams_petclinic/ansible/vault_pass.txt was not found
ERROR! The vault password file /Users/hibana/PhpstormProjects/robot_dreams_petclinic/ansible/vault_pass.txt was not found
hibana@mac robot_dreams_petclinic % ansible-vault encrypt ansible/group_vars/all/vault.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful

hibana@mac ansible % ansible-inventory -i inventory/aws_ec2.yml --graph
@all:
  |--@ungrouped:
  |--@aws_ec2:
hibana@mac ansible % ansible-inventory -i inventory/aws_ec2.yml --list
{
    "_meta": {
        "hostvars": {}
    },
    "all": {
        "children": [
            "ungrouped",
            "aws_ec2"
        ]
    }
}
```

Terraform
```textmate
hibana@mac terraform % terraform validate

Success! The configuration is valid.

hibana@mac terraform %   terraform plan


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami                                  = "ami-00c8ac9147e19828e"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t3.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "europe-stockholm-ssh-rsa-keygen"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + region                               = "eu-north-1"
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Environment" = "development"
          + "Name"        = "ansible-demo"
        }
      + tags_all                             = {
          + "Environment" = "development"
          + "Name"        = "ansible-demo"
        }
      + tenancy                              = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

  # aws_internet_gateway.ansible_gateway will be created
  + resource "aws_internet_gateway" "ansible_gateway" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + region   = "eu-north-1"
      + tags     = {
          + "Name" = "ansible-gateway"
        }
      + tags_all = {
          + "Name" = "ansible-gateway"
        }
      + vpc_id   = (known after apply)
    }

  # aws_route_table.public_route_table will be created
  + resource "aws_route_table" "public_route_table" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + region           = "eu-north-1"
      + route            = [
          + {
              + cidr_block                 = "0.0.0.0/0"
              + gateway_id                 = (known after apply)
                # (11 unchanged attributes hidden)
            },
        ]
      + tags             = {
          + "Name" = "ansible-public-route-table"
        }
      + tags_all         = {
          + "Name" = "ansible-public-route-table"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table_association.public_route_association will be created
  + resource "aws_route_table_association" "public_route_association" {
      + id             = (known after apply)
      + region         = "eu-north-1"
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_security_group.ansible_access will be created
  + resource "aws_security_group" "ansible_access" {
      + arn                    = (known after apply)
      + description            = "Allow SSH and HTTP"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
                # (1 unchanged attribute hidden)
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
                # (1 unchanged attribute hidden)
            },
        ]
      + name                   = "allow_ssh_http"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + region                 = "eu-north-1"
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "ansible-access"
        }
      + tags_all               = {
          + "Name" = "ansible-access"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.public_subnet will be created
  + resource "aws_subnet" "public_subnet" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = (known after apply)
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + region                                         = "eu-north-1"
      + tags                                           = {
          + "Name" = "ansible-public-subnet"
        }
      + tags_all                                       = {
          + "Name" = "ansible-public-subnet"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.ansible_vpc will be created
  + resource "aws_vpc" "ansible_vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + region                               = "eu-north-1"
      + tags                                 = {
          + "Name" = "ansible-demo-vpc"
        }
      + tags_all                             = {
          + "Name" = "ansible-demo-vpc"
        }
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + aws_vpc_id    = (known after apply)
  + web_public_ip = (known after apply)

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

...


Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

aws_vpc_id = "vpc-09493a801159295d8"
web_public_ip = "13.48.24.158"
```