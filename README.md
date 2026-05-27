# caddy-azure-route53-security

Custom [Caddy](https://caddyserver.com) Docker image built with [xcaddy](https://github.com/caddyserver/xcaddy), bundling Route53 DNS, Azure DNS, and caddy-security modules.

Previously published as `ghcr.io/thatdoogieguy/caddy-route53-azure`.

## Bundled modules

| Module | Repository | Version |
|--------|-----------|---------|
| Route53 DNS | [caddy-dns/route53](https://github.com/caddy-dns/route53) | v1.6.2 |
| Azure DNS | [caddy-dns/azure](https://github.com/caddy-dns/azure) | latest |
| Caddy Security | [greenpau/caddy-security](https://github.com/greenpau/caddy-security) | latest |

## Versioning

The Docker image version tracks the upstream Caddy version. Module versions are pinned separately in the Dockerfile.

For example, `ghcr.io/bylocico/caddy-azure-route53-security:2.11.3` is built from `caddy:2.11.3` with the modules above.

A scheduled workflow checks Docker Hub daily for new Caddy releases, builds each one (which also verifies module compatibility via xcaddy), and opens an auto-merge PR.

## Usage

```bash
docker pull ghcr.io/bylocico/caddy-azure-route53-security:2.11.3
```

### Docker Compose

```yaml
services:
  caddy:
    image: ghcr.io/bylocico/caddy-azure-route53-security:2.11.3
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config

volumes:
  caddy_data:
  caddy_config:
```

### Caddyfile with Route53 DNS

```caddyfile
example.com {
  tls {
    dns route53 {
      region us-east-1
    }
  }
  reverse_proxy localhost:8080
}
```

## Development

Build locally:

```bash
docker build -t caddy-azure-route53-security .
```

Build with a specific Caddy version:

```bash
docker build --build-arg CADDY_VERSION=2.11.2 -t caddy-azure-route53-security:2.11.2 .
```

Check for newer upstream Caddy versions:

```bash
node scripts/update-version.mjs --list-newer
```

Retarget to a specific version:

```bash
node scripts/update-version.mjs --version 2.11.3
```

## Publishing

Publishing is handled by `.github/workflows/publish.yml`. It runs on published GitHub Releases and on manual workflow dispatch.

The workflow builds multi-arch images (`linux/amd64`, `linux/arm64`) and pushes to GHCR.

## License

Apache-2.0
