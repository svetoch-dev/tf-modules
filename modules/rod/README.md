# Rod modules
This modules are dedicated for [rod](https://github.com/svetoch-dev/rod) template


To know more check [this](https://github.com/svetoch-dev/rod/blob/master/docs/design/tf-module-structure.md) design doc

## Vedro on Yandex Cloud

Set `env.cloud.organization_id` to the organization that owns the YC cloud
when the default Vedro service account is enabled.
The controller's cloud service account and Kubernetes service account are both
named `vedrosa`; the KSA is in namespace `vedro`.

The common `cloud/yc` module grants:

- Folder: `storage.admin` and `iam.serviceAccounts.admin` to manage buckets,
  bucket access, managed service accounts and static S3 keys, including cleanup
  with `deletionPolicy: Delete`.
- Cloud: `resource-manager.viewer` to resolve the cloud and its folders.
- Organization: `organization-manager.users.viewer` to resolve Reference users
  by email.

`iam.serviceAccounts.admin` includes permission to use service accounts, so a
separate `iam.serviceAccounts.user` grant is unnecessary. Service account and
bucket management permissions apply to the configured folder. References to
service accounts in other folders require permissions in those folders.

These defaults apply to internal and product environments. The cloud service
account name `vedrosa` must be unique within its YC cloud. See the
[YC role reference](https://yandex.cloud/en/docs/iam/roles-reference).
