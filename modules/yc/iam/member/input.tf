variable "member" {
  description = "service account IAM member string. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc. Special prefixes 'serviceAccountName:', 'userAccountName:' are also allowed. In this case module will look up the id of user or service account using data sources"
  type        = string
}
