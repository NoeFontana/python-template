# Template Instructions

To onboard a new project using this template, follow this exact 3-step process:

1. Click "Use this template".
2. Clone locally.
3. Run bash init.sh.

---

# python-template

A new Python project.

## Post-Setup

To ensure GitHub Actions can successfully deploy your MkDocs documentation to GitHub Pages, you must configure your repository settings:

1. Navigate to **Settings -> Pages** in your new repository and set the source to **GitHub Actions**.
2. Check that **Settings -> Actions -> General -> Workflow permissions** is set to **Read and write permissions** so the deploy job can push the `gh-pages` branch successfully.

## Application Usage

The package exposes a CLI tool `python-template` with sample commands.

## Development

This project uses a `src` layout and strict type checking.

| Task           | Command                                      |
|----------------|----------------------------------------------|
| Test           | `uv run pytest` (or `make test`)             |
| Lint & Format  | `uv run ruff check .` / `uv run ruff format .` |
| Type Check     | `uv run pyright`                             |
| Docs           | `uv run mkdocs serve`                        |
| Run All Checks | `make check`                                 |

### Pre-commit Hooks

Enforce quality standards locally before committing:

```bash
uv run pre-commit install
```

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.

---
Author: Noé Fontana (<noe.fontana.pro@gmail.com>)
GitHub: [NoeFontana](https://github.com/NoeFontana)
