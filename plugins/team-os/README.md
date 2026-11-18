# team-os

Placeholder plugin for Builders Camp's ops skills. It ships no skills yet; installing it now only reserves the name so each person's install command stays the same when skills land.

The Team OS splits method from facts: this plugin brings the method (skills), and Notion holds the facts, read through each person's own Notion connector.

## Planned skills

| Skill | What it will do |
| --- | --- |
| `newsletter` | Draft the weekly Builders Camp newsletter (members and non-members) from live bootcamp and mentor data |
| `outreach` | Draft partner and prospect outreach |
| `mentors` | Mentor roster, availability, and booking context |
| `cheque-formacao` | Cheque-Formação rules, eligibility, and reimbursement status |
| `end-of-day-review` | End-of-day review: what was done, what's waiting on whom, what's pending |

## Planned Notion context

- **Index page**: where things live (Notion pages, Drive folders, Slack channels).
- **Decision log**: dated, newest first.
- **Program pages**: Product MBA, bootcamps, membership: what, when, who.
- **Glossary** of internal terms.

## Install

```bash
claude plugin marketplace add builders-camp/team-claude-config
claude plugin install team-os@builders-camp
```

In the Claude app, each person adds the `team-os` skills by hand once they exist.
