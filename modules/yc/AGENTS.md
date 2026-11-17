# Yandex Cloud modules

- Follow [aggregate calls](main.tf) into [IAM](iam/main.tf), [network](network/main.tf), [Kubernetes](k8s/main.tf), [DNS](dns/main.tf), [S3](s3/main.tf), or [registry](ycr/main.tf). [Client configuration](client_config/main.tf) is directly callable.
- In [service-account IAM](iam/service_account/main.tf), distinguish folder, cloud, and organization role scopes and IDs from `sa_iam_bindings`, which grant principals access to the account itself. Check [principal conversion](iam/member/main.tf) for name-based members.
- Trace [cluster federation](k8s/cluster/main.tf) to credential `federation_id` and `external_subject_id`. For Rod callers, check the [federation placeholder and subnet aliases](../rod/cloud/yc/main.tf) and [initial-start guard](../rod/cloud/yc/yc_iam_variables.tf).
- Verify supplied network/subnet IDs and cluster/node-group wiring; aggregate ordering does not automatically select sibling IDs. Preserve optional default security-group and service-account behavior.
- Use the existing [YC Bazel package](BUILD.bazel) for `//modules/yc:lint` and `//modules/yc:validate`.
