locals {
  all_ips = ["0.0.0.0/0"]
  internal_ips = ["10.0.0.0/16"]

  moninotring_ingress_rules = [
    { from = 22,   to = 22,   protocol = "tcp", cidrs = local.all_ips },
    { from = 3000, to = 3100, protocol = "tcp", cidrs = local.all_ips },
    { from = 9090, to = 9090, protocol = "tcp", cidrs = local.all_ips },
  ]

  web_ingress_rules = [
    { from = 22,   to = 22,   protocol = "tcp", cidrs = local.all_ips },
    { from = 9100, to = 9100, protocol = "tcp", cidrs = local.internal_ips },
    { from = 80,   to = 80,   protocol = "tcp", cidrs = local.all_ips },
  ]
}
