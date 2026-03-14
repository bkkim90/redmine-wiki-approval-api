# Wiki Approval API

> **Unofficial companion plugin** for [redmine_wiki_approval](https://github.com/FloWalchs/redmine_wiki_approval) by Florian Walchshofer.
> This plugin is independently developed and is not affiliated with the original author.

Redmine Wiki Approval 플러그인의 승인 워크플로우를 REST API로 노출하는 컴패니언 플러그인.

자체 모델/마이그레이션 없이 Wiki Approval의 모델(`WikiApprovalWorkflow`, `WikiApprovalWorkflowSteps`)을 직접 사용한다.

## 요구사항

- Redmine 5.0.0 이상
- `redmine_wiki_approval` 플러그인 0.9.0 이상

## 설치

1. 플러그인 폴더를 Redmine의 `plugins/` 디렉토리에 복사:

```bash
cp -r redmine_wiki_approval_api /path/to/redmine/plugins/
```

2. Redmine 재시작:

```bash
sudo systemctl restart redmine
```

마이그레이션은 필요 없다 (자체 DB 테이블 없음).

## 워크플로우

```
PUT  update   →  Draft 상태
POST submit   →  Pending 상태  →  승인자가 웹 UI에서 승인/반려
POST release  →  Released 상태 (승인 우회, 관리 전용)
```

## 엔드포인트

| Method | URL | 설명 |
|--------|-----|------|
| PUT | `/projects/:id/wiki_draft/:title.json` | 초안 저장 (페이지 자동 생성) |
| POST | `/projects/:id/wiki_draft/:title/release.json` | 즉시 배포 (관리 전용) |
| POST | `/projects/:id/wiki_draft/:title/submit.json` | 승인 제출 |
| GET | `/projects/:id/wiki_draft/approvers.json` | 승인자 목록 |
| GET | `/projects/:id/wiki_draft/pending.json` | 승인 대기 문서 |
| GET | `/projects/:id/wiki_draft/statuses.json` | 전체 문서 승인 상태 (bulk) |
| GET | `/projects/:id/wiki_draft/:title/status.json` | 워크플로우 상태 |
| GET | `/projects/:id/wiki_draft/my_tasks.json` | 내 승인 대기 목록 |
| GET | `/projects/:id/wiki_meta/index.json` | 위키 페이지 메타 (ID/제목/계층) |

## 권한

| 엔드포인트 | 필요 권한 |
|-----------|----------|
| update | `:wiki_draft_create` |
| release | `admin` 또는 `:wiki_approval_grant` |
| submit, approvers | `:wiki_approval_start` |
| pending, my_tasks | `:wiki_approval_grant` |
| status, statuses, wiki_meta | `:view_wiki_pages` |

## 인증

모든 엔드포인트는 Redmine API 키 인증 필수:

```bash
# 헤더 방식
curl -H "X-Redmine-API-Key: YOUR_KEY" http://redmine/projects/myproject/wiki_draft/PageTitle.json

# 쿼리 파라미터 방식
curl http://redmine/projects/myproject/wiki_draft/PageTitle.json?key=YOUR_KEY
```

## 사용 예시

```bash
# 초안 저장
curl -X PUT http://redmine/projects/myproject/wiki_draft/PageTitle.json \
  -H "X-Redmine-API-Key: YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"wiki_page": {"text": "본문 내용", "comments": "변경 사유"}}'

# 승인 제출
curl -X POST http://redmine/projects/myproject/wiki_draft/PageTitle/submit.json \
  -H "X-Redmine-API-Key: YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"step": 1, "step_type": "or", "principal_ids": [5, 6]}]}'
```

## 라이선스

MIT License. See [LICENSE](LICENSE) for details.
