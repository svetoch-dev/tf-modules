output "vpc" {
  value = module.vpc.this
}

output "subnets" {
  value = {
    for subnet_name, subnet_obj in module.subnets :
    subnet_name => subnet_obj.this
  }
}

output "nat_gws" {
  value = {
    for nat_name, nat_obj in module.nat_gws :
    nat_name => nat_obj.this
  }
}

output "firewall_rules" {
  value = {
    for rule_name, rule_obj in module.firewall_rules :
    rule_name => rule_obj.this
  }
}

output "route_tables" {
  value = {
    for rule_name, rule_obj in module.route_tables :
    rule_name => rule_obj.this
  }
}
