# Wiki Approval API

> **Unofficial companion plugin** for [redmine_wiki_approval](https://github.com/FloWalchs/redmine_wiki_approval) by Florian Walchshofer.
> This plugin is independently developed and is not affiliated with the original author.

A companion plugin that exposes the Wiki Approval workflow as a REST API.

Uses Wiki Approval's models (`WikiApprovalWorkflow`, `WikiApprovalWorkflowSteps`) directly — no own models or migrations.

## Requirements

- Redmine 5.0.0 or higher
- `redmine_wiki_approval` plugin 0.9.0 or higher

## Installation

1. Copy the plugin folder to Redmine's `plugins/` directory:

```bash
cp -r redmine_wiki_approval_api /path/to/redmine/plugins/
```

2. Restart Redmine:

```bash
sudo systemctl restart redmine
```

No migration needed (no database tables).

## Workflow

```
PUT  update   →  Draft
POST submit   →  Pending  →  Approver accepts/rejects via web UI
POST release  →  Released (bypasses approval, admin only)
```

## Endpoints

| Method | URL | Description |
|--------|-----|-------------|
| PUT | `/projects/:id/wiki_draft/:title.json` | Save draft (auto-creates page) |
| POST | `/projects/:id/wiki_draft/:title/release.json` | Immediate release (admin only) |
| POST | `/projects/:id/wiki_draft/:title/submit.json` | Submit for approval |
| GET | `/projects/:id/wiki_draft/approvers.json` | List approvers |
| GET | `/projects/:id/wiki_draft/pending.json` | Pending approvals |
| GET | `/projects/:id/wiki_draft/statuses.json` | Bulk approval statuses |
| GET | `/projects/:id/wiki_draft/:title/status.json` | Workflow status |
| GET | `/projects/:id/wiki_draft/my_tasks.json` | My pending tasks |
| GET | `/projects/:id/wiki_meta/index.json` | Wiki page metadata (ID/title/hierarchy) |

## Permissions

| Endpoint | Required Permission |
|----------|-------------------|
| update | `:wiki_draft_create` |
| release | `admin` or `:wiki_approval_grant` |
| submit, approvers | `:wiki_approval_start` |
| pending, my_tasks | `:wiki_approval_grant` |
| status, statuses, wiki_meta | `:view_wiki_pages` |

## Authentication

All endpoints require Redmine API key authentication:

```bash
# Header
curl -H "X-Redmine-API-Key: YOUR_KEY" http://redmine/projects/myproject/wiki_draft/PageTitle.json

# Query parameter
curl http://redmine/projects/myproject/wiki_draft/PageTitle.json?key=YOUR_KEY
```

## Examples

```bash
# Save draft
curl -X PUT http://redmine/projects/myproject/wiki_draft/PageTitle.json \
  -H "X-Redmine-API-Key: YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"wiki_page": {"text": "Page content", "comments": "Change reason"}}'

# Submit for approval
curl -X POST http://redmine/projects/myproject/wiki_draft/PageTitle/submit.json \
  -H "X-Redmine-API-Key: YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"step": 1, "step_type": "or", "principal_ids": [5, 6]}]}'
```

## License

MIT License. See [LICENSE](LICENSE) for details.
