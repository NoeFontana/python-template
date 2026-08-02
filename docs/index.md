# Python Template

Welcome to the Python Template documentation!

This project provides a modern Python project template with best practices and tooling.

## Quick Start

1. Clone the repository
2. Install dependencies with `just bootstrap`
3. Run the checks with `just check`
4. Start developing!

```python
from python_template import Calculator, greet

print(greet("World"))
print(Calculator().add(2, 3))
```

This block runs as a test on every commit, along with every other fenced
`python` block on this site — see [Contributing](contributing.md#documentation).

New here? Start with the [getting-started tutorial](tutorials/getting-started.md).

## Post-Setup

The documentation is published with [`mike`](https://github.com/jimporter/mike),
which commits the built site to a `gh-pages` branch. Configure your repository
to serve from that branch — **the deploy will silently publish nothing until
you do**:

1. Push to `main` once and let the `deploy-docs` job run. It creates the
   `gh-pages` branch.
2. Navigate to **Settings → Pages** and set the source to **Deploy from a
   branch**, then select **`gh-pages`** and the **`/` (root)** folder.
3. Check that **Settings → Actions → General → Workflow permissions** is set to
   **Read and write permissions**, so the deploy job can push that branch.

Step 2 is not "GitHub Actions" as the Pages source. That setting is for
workflows that upload a Pages artifact; `mike` does not.

Once configured, `main` publishes under the `latest` alias and each release tag
publishes a `<major>.<minor>` version plus the `stable` alias, which the
version selector in the header exposes. The site root redirects to `latest`
until your first release tag, then to `stable`.

## Features

- Modern tooling with uv, ruff, and pyright
- Comprehensive testing setup with pytest
- CI/CD with GitHub Actions
- Documentation with MkDocs
- Pre-commit hooks for code quality

For more information, see the [README](https://github.com/NoeFontana/python-template/blob/main/README.md).
