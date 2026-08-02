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
