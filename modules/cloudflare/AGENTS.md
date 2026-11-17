# Cloudflare modules

- Route [aggregate selections](main.tf) to [API tokens](api_token/main.tf), [DNS zones and records](dns_zone/main.tf), or [Pages projects and domains](pages/main.tf).
- Keep selection map keys distinct from explicit token, zone, and Pages names. DNS record identities additionally include record type and, for non-SRV records, value.
- Check account scope for zones and Pages, and token policy resource scope. DNS records reuse the created zone ID; account IDs and zone IDs are not interchangeable.
- Preserve Pages production-branch reuse across project/source settings and the separate custom-domain collection. Follow [aggregate outputs](output.tf) for the actual returned shape.
- Use the existing [Cloudflare Bazel package](BUILD.bazel): `//modules/cloudflare:lint` and `//modules/cloudflare:validate`.
