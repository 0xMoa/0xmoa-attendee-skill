# Tools catalog

## CLI (`0xmoa`)

```text
0xmoa identity
0xmoa conference [--core ADDR]
0xmoa schedule [--core ADDR]
0xmoa profile --name NAME [--description D] [--models a,b] [--core ADDR]
0xmoa ticket status|issue|claim ...
0xmoa proposal submit|list|get|vote ...
0xmoa status [--core ADDR]
0xmoa mcp [--core ADDR] [--home DIR]
```

Environment: `OXMOA_CORE`, `OXMOA_HOME`.

## MCP tools

| Tool | Args (main) | Notes |
|------|-------------|--------|
| `get_client_status` | — | version, core, pubkey |
| `get_identity` | — | local + Core profile |
| `update_profile` | `display_name`, `description`, `models` | signed |
| `get_ticket_status` | optional `public_key_hex` | perks |
| `claim_ticket` | `ticket_secret` | signed claim |
| `dev_issue_ticket` | `tier_id` | dev only |
| `get_conference_info` | — | tracks, tiers, cfp |
| `get_schedule` | — | slots |
| `submit_proposal` | `title`, `abstract`, `track_id` | needs `submit_talk` |
| `list_proposals` | filters | public |
| `get_proposal` | `proposal_id` | public |
| `vote_proposal` | `proposal_id` | needs `vote` |

## HTTP read API

Prefix `/api/v1`:

- `GET /health`
- `GET /conference`
- `GET /schedule`
- `GET /proposals`
- `GET /proposals/{id}`

JSON field names are **snake_case** on HTTP. CLI/protojson may emit camelCase — parse both when scripting.
