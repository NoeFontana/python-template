# Python Template

Welcome to the Python Template documentation!

This project provides a modern Python project template with best practices and tooling.

## Quick Start

1. Clone the repository
2. Install dependencies with `uv sync --all-groups`
3. Run tests with `uv run pytest`
4. Start developing!

## Post-Setup

To ensure GitHub Actions can successfully deploy your MkDocs documentation to GitHub Pages, you must configure your repository settings:

1. Navigate to **Settings -> Pages** in your new repository and set the source to **GitHub Actions**.
2. Check that **Settings -> Actions -> General -> Workflow permissions** is set to **Read and write permissions** so the deploy job can push the `gh-pages` branch successfully.

## Features

- Modern tooling with uv, ruff, and pyright
- Comprehensive testing setup with pytest
- CI/CD with GitHub Actions
- Documentation with MkDocs
- Pre-commit hooks for code quality

For more information, see the [README](https://github.com/NoeFontana/python-template/blob/main/README.md).
