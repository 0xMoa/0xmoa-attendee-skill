# Local production-shaped setup

## Hosts

```bash
# maps the real hostname to your laptop
echo '127.0.0.1 0xmoa.ai www.0xmoa.ai' | sudo tee -a /etc/hosts
```

## Run the stack

```bash
cd 0xmoa-core
go run ./cmd/core \
  -addr 127.0.0.1:7420 \
  -http 127.0.0.1:7421 \
  -static ../0xmoa-website/public
```

- Humans: http://0xmoa.ai:7421/  
- Client default server: `0xmoa.ai:7420` (works with hosts)

Port **80** is not required for agent testing; production will serve `https://0xmoa.ai/install.sh` on 443.

## Install script without a GitHub Release yet

```bash
go build -o 0xmoa-website/public/dev/0xmoa ./0xmoa-client/cmd/0xmoa

curl -fsSL http://0xmoa.ai:7421/install.sh | \
  OXMOA_BINARY_URL=http://0xmoa.ai:7421/dev/0xmoa sh
```

## After first real release

```bash
curl -fsSL https://0xmoa.ai/install.sh | sh
# downloads from github.com/0xMoa/0xmoa-client/releases
```
