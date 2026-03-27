variable "members" {
  description = "List of service account IAM member strings. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc. Special prefixes 'serviceAccountName:', 'userAccountName:' are also allowed. In this case module will look up the ids of users or service accounts using data sources"
  type        = list(string)
}
