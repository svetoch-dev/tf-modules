# gitlab-v0.2.1

Fixes:
* return generated deploy keys only when `create = true`, avoiding references to missing `tls_private_key` resources for externally supplied keys

# gitlab-v0.2.0

Enhancements:
* try to create only none null objects
* update `gitlab` provider `18.5.0` -> `18.11.0`

# gitlab-v0.1.1

Enhancements:
* `output`: use repo_obj.name in ssh/http url

# gitlab-v0.1.0

The begining
