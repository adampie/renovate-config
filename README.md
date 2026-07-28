# renovate-config

Shared [Renovate](https://docs.renovatebot.com/) preset for the org: one place
for dependency-update policy.

## Usage

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["github>adampie/renovate-config:default.json5"]
}
```

The `:default.json5` suffix is required. Renovate only auto-discovers a preset
named `default.json` (or the deprecated `renovate.json`), so a bare
`github>adampie/renovate-config` fails with "Cannot find preset's package" and
blocks Renovate for the consuming repo.

`default.json5` sits on top of `config:best-practices`:

- 7-day minimum release age.
- Automerge minor/patch/pin/digest and lock-file updates; majors reviewed on the
  dashboard, one PR per major.
- Vulnerability fixes from GitHub alerts + OSV, summarised on the dashboard.
- No schedule imposed: each repo sets its own cadence (this repo runs weekly).

Override anything per repo by adding config after `extends`.

## Layout

- `default.json5`: org preset consumers extend.
- `renovate.json5`: this repo, extending the preset plus a weekly schedule.
- `mise.toml`: pinned tools and the `validate` / `zizmor` tasks.
- `hk.pkl`: pre-commit hooks (validate presets, audit workflows).
- `.github/workflows/validate.yml`: CI runs both on PRs and pushes to `main`.

## Development

```sh
mise install       # pinned toolchain
hk install         # wire pre-commit hooks (once)
mise run validate  # validate presets
mise run zizmor    # audit workflows (needs a token)
```

`renovate-config-validator` checks syntax and schema only; it does not fetch
remote presets, so a broken `extends` target passes locally and only surfaces on
Renovate's next run.

The hook and CI call the same `mise run` tasks.
[zizmor](https://docs.zizmor.sh/) runs offline in the hook, online in CI.
