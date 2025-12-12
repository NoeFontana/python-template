# Python Template

[![CI](https://github.com/NoeFontana/python-template/workflows/CI/badge.svg)](https://github.com/NoeFontana/python-template/actions)
[![Code style: ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![Checked with pyright](https://microsoft.github.io/pyright/img/pyright_badge.svg)](https://microsoft.github.io/pyright/)
[![Python 3.11+](https://img.shields.io/badge/python-3.11+-blue.svg)](https://www.python.org/downloads/)

A production-ready Python project template featuring modern tooling and strict quality standards.

**Stack:** [uv](https://github.com/astral-sh/uv) (package management), [Ruff](https://github.com/astral-sh/ruff) (linting/formatting), [Pyright](https://github.com/microsoft/pyright) (static analysis), [Pytest](https://docs.pytest.org/) (testing).

## Quick Start

Ensure you have [uv](https://docs.astral.sh/uv/) installed (`curl -LsSf https://astral.sh/uv/install.sh | sh`).

```bash
# Install dependencies
uv sync

# Run the CLI
uv run python-template greet World
```

## Application Usage

The package exposes a CLI tool `python-template` with the following commands:

### Greeting

Send a customizable greeting.

```bash
$ uv run python-template greet Alice --greeting "Hi"
Hi, Alice!
```

### Calculator

Perform basic arithmetic operations (add, sub, mul, div).

```bash
$ uv run python-template calc add 5 3
Result: 8.0
```

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

## Contributing

See `CONTRIBUTING.md` for detailed guidelines on setting up your environment and submitting PRs.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.
