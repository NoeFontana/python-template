# Template Instructions

To onboard a new project using this template, follow this exact 3-step process:

1. Click "Use this template".
2. Clone locally.
3. Run `bash setup.sh`.

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

This project uses a `src` layout and strict type checking. [`just`](https://github.com/casey/just)
is the task surface; run `just` with no arguments to list every recipe. CI
invokes the same recipes, so a green `just check` locally means a green CI.

| Task            | Command           |
|-----------------|-------------------|
| Install         | `just bootstrap`  |
| Test            | `just test`       |
| Lint, format & type check | `just lint` |
| Auto-fix        | `just fmt`        |
| Docs (serve)    | `just docs`       |
| Test doc examples | `just docs-test` |
| Regenerate generated pages | `just docs-index` |
| Run all checks  | `just check`      |

### Pre-commit Hooks

Enforce quality standards locally before committing:

```bash
just pre-commit
```

### Architecture decisions

Significant decisions are recorded in [`docs/adr/`](docs/adr/). Read them
before proposing changes to structure, tooling, dependencies, or public API.
Agents should start at [`AGENTS.md`](AGENTS.md). Create a new record with
`just adr short-kebab-title`.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.

---
Author: Noé Fontana (<noe.fontana.pro@gmail.com>)
GitHub: [NoeFontana](https://github.com/NoeFontana)
