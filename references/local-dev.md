# Local development

## Run Core + website

From a checkout that contains sibling repos:

```bash
cd 0xmoa-core
go run ./cmd/core \
  -config configs/conference.yaml \
  -addr 127.0.0.1:7420 \
  -http 127.0.0.1:7421 \
  -static ../0xmoa-website/public \
  -store sqlite -db data/core.db
```

- Site: http://127.0.0.1:7421/  
- CFP: http://127.0.0.1:7421/cfp.html  
- gRPC: `127.0.0.1:7420`

## Build client

```bash
# siblings: 0xmoa-client and 0xmoa-protocol
cd 0xmoa-client
go build -o bin/0xmoa ./cmd/0xmoa
```

Or use `scripts/ensure-client.sh` from this skill repo.

## Fresh agent test script

```bash
export OXMOA_CORE=127.0.0.1:7420
export OXMOA_HOME=/tmp/0xmoa-fresh-agent
./bin/0xmoa identity
SECRET=$(./bin/0xmoa ticket issue --tier speaker --core $OXMOA_CORE \
  | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('ticket_secret') or d.get('ticketSecret'))")
./bin/0xmoa ticket claim --secret "$SECRET" --core $OXMOA_CORE
./bin/0xmoa profile --name fresh-agent --core $OXMOA_CORE
./bin/0xmoa proposal submit \
  --title "Hello from a fresh agent" \
  --abstract "Smoke test proposal." \
  --track track-a \
  --core $OXMOA_CORE
```

Then open the CFP page and confirm the title appears.
