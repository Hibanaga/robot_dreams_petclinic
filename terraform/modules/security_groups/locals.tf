locals {
  all_ips = ["0.0.0.0/0"]
  internal_ips = ["10.0.0.0/16"]

  monitoring_ingress_rules = [
    { from = 22,   to = 22,   protocol = "tcp", cidrs = local.all_ips }, // SSH
    { from = 3000, to = 3000, protocol = "tcp", cidrs = local.all_ips }, // Grafana
    { from = 3306, to = 3306, protocol = "tcp", cidrs = local.all_ips }, // MySQL
    { from = 3100, to = 3100, protocol = "tcp", cidrs = local.all_ips }, // Loki
    { from = 9090, to = 9090, protocol = "tcp", cidrs = local.all_ips }, // Prometheus
  ]

  web_ingress_rules = [
    { from = 22,   to = 22,   protocol = "tcp", cidrs = local.all_ips }, // SSH
    { from = 80,   to = 80,   protocol = "tcp", cidrs = local.all_ips }, // HTTP
    { from = 9100, to = 9100, protocol = "tcp", cidrs = local.internal_ips }, // Node Exporter
  ]

  rds_ingress_rules = [
    { from = 3306, to = 3306, protocol = "tcp", cidrs = local.internal_ips } // MySQL
  ]
}
