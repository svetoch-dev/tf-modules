output "vpcs" {
  value = {
    for network_name, network_obj in module.network :
    network_name => network_obj.vpc
  }
}

output "project" {
  value = {
    id     = module.enable_apis.project_id
    region = var.project.region
  }
}

output "subnets" {
  value = {
    for network_name, network_obj in module.network :
    network_name => network_obj.subnets
  }
}

output "nats" {
  value = {
    for network_name, network_obj in module.network :
    network_name => network_obj.nats
  }
}

output "service_peering" {
  value = {
    for network_name, network_obj in module.network :
    network_name => network_obj.service_peering
  }
}

output "iam" {
  value = module.iam
}

output "cloudsql_postgres" {
  value = module.cloudsql_postgres
}

output "redis" {
  value = module.redis
}

output "cloudrun_services" {
  value = {
    for cloudrun_service_name, cloudrun_service_obj in module.cloudrun_services :
    cloudrun_service_name => cloudrun_service_obj.cloudrun_service
  }
}

output "cloudrun_jobs" {
  value = {
    for cloudrun_job_name, cloudrun_job_obj in module.cloudrun_jobs :
    cloudrun_job_name => cloudrun_job_obj.cloudrun_job
  }
}

output "application_lbs" {
  value = {
    for application_lb_name, application_lb_obj in module.application_lbs :
    application_lb_name => application_lb_obj.application_lb
  }
}

output "kms" {
  value = {
    for kms_name, kms_obj in module.kms :
    kms_name => kms_obj
  }
}

output "tasks" {
  value = {
    for task_name, task_obj in module.cloud_tasks :
    task_name => task_obj.task
  }
}

output "vms" {
  value = {
    for vm_name, vm_obj in module.vms :
    vm_name => vm_obj.vm
  }
}

output "alloydbs" {
  value = {
    for db_name, db_obj in module.alloydbs :
    db_name => db_obj
  }
}
