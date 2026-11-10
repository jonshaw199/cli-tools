# cli-tools

A few small, dependency-light command-line utilities I reach for often.

| Tool | What it does | Needs |
| --- | --- | --- |
| [`gh-img`](bin/gh-img) | Upload an image to GitHub's attachment CDN and print its URL — renders inline in issues/PRs/comments, stays out of git history. | `gh`, `curl`, `jq` |
| [`scrub-pii`](bin/scrub-pii) | Scan files/stdin for likely secrets & PII; exits non-zero if any found. Good as a pre-commit / CI gate. | `grep` |
| [`proof-shot`](bin/proof-shot.mjs) | Screenshot a page with a red box around a selector — proof shots that point at the thing. | `node`, `playwright` |

## Install

```bash
# Put bin/ on your PATH, e.g.:
ln -s "$PWD/bin/gh-img"    /usr/local/bin/gh-img
ln -s "$PWD/bin/scrub-pii" /usr/local/bin/scrub-pii
```

## Examples

```bash
gh-img proof.png                      # -> https://github.com/user-attachments/assets/...
gh-img proof.png --repo me/myrepo

git diff --cached | scrub-pii         # gate a commit
scrub-pii src/**/*.ts

npm i playwright && npx playwright install chromium
node bin/proof-shot.mjs https://example.com "h1" out.png
```
