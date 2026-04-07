output "bucket" {
  value = module.bucket.this
}

output "objects" {
  value = {
    for object_name, object_obj in module.objects :
    object_name => object_obj.this
  }
}
