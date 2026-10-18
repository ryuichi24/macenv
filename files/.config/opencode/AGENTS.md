# Global coding instructions

## Formatting and linting

- Follow each repository's AGENTS.md and existing tooling configuration.
- After modifying code, run the appropriate formatter and linter.
- Fix issues introduced by your changes and rerun affected checks.
- After further edits, rerun formatting and relevant checks.
- If tools are unavailable or checks fail, report that explicitly.
- Never claim a check passed unless you actually ran it successfully.

## Git hooks

- Respect repository Git hooks.
- If a hook fails, fix the issue before retrying.
- Never bypass hooks with `--no-verify` or disable `core.hooksPath`.
- Only create commits when explicitly requested.
