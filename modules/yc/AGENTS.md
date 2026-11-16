# Yandex Cloud modules

- When changing [service-account IAM](iam/service_account/main.tf), check the target scope and its ID for folder, cloud, and organization roles. Check `sa_iam_bindings` separately for permissions granted to principals on the service account.
- Trace federation changes from the [cluster's federation](k8s/cluster/main.tf) to each credential's `federation_id` and `external_subject_id`. Check Rod's handling of the [`k8s_federation_id` placeholder](../rod/cloud/yc/main.tf) and the [initial-start guard](../rod/cloud/yc/yc_iam_variables.tf).
- Check the input mapping from [Rod YC](../rod/cloud/yc/main.tf) through the [YC aggregate](main.tf) and [IAM wrapper](iam/main.tf) to the affected child.
