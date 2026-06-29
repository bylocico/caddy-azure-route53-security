ARG CADDY_VERSION=2.11.4
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
  --with github.com/caddy-dns/route53@v1.6.2 \
  --with github.com/caddy-dns/azure@v0.6.0 \
  --with github.com/greenpau/caddy-security@v1.1.64

FROM caddy:${CADDY_VERSION}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
