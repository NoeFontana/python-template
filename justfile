# The single task surface for python-template. CI mirrors these recipes 1:1.

default:
    @just --list

# Sync the venv with every dependency group. Run once after clone.
bootstrap:
    uv sync --all-groups

# Run the test suite.
test:
    uv run pytest

# Run the test suite with an HTML coverage report.
test-cov:
    uv run pytest --cov --cov-report=html --cov-report=term

# Lint and type-check. Pure checks; does not mutate files.
lint:
    uv run ruff check .
    uv run ruff format --check .
    uv run pyright

# Check spelling. Configured by [tool.codespell] in pyproject.toml.
spell:
    uv run --with codespell codespell

# Format and auto-fix safe lint issues.
fmt:
    uv run ruff format .
    uv run ruff check --fix .

# Run every fenced Python block in docs/ and every docstring example.
docs-test:
    uv run pytest --markdown-docs docs/ --no-cov
    uv run pytest --doctest-modules src/ --no-cov

# The default gate: lint, type-check, tests, and documentation examples.
check: lint test docs-test

# Serve the documentation locally with auto-reload.
docs:
    uv run mkdocs serve

# Build the documentation site into site/.
docs-build:
    uv run mkdocs build --strict

# Regenerate the generated documentation pages.
docs-index:
    uv run python tools/docs/gen_adr_index.py
    uv run python tools/docs/gen_cli_reference.py

# Scaffold a new ADR from the template (usage: just adr use-uv).
adr TITLE:
    @cp docs/adr/template.md docs/adr/NNNN-{{ TITLE }}.md
    @echo "Created docs/adr/NNNN-{{ TITLE }}.md — number assigned on merge"

# Install the pre-commit hooks.
pre-commit:
    uv run pre-commit install

# Run the pre-commit hooks against every file.
pre-commit-run:
    uv run pre-commit run --all-files

# Build the distribution artifacts.
build:
    uv build

# Publish to PyPI (requires PYPI_TOKEN).
publish:
    uv publish

# Upgrade every locked dependency.
update:
    uv sync --upgrade

# Remove build artifacts and caches.
clean:
    rm -rf build/ dist/ site/ htmlcov/ .coverage coverage.xml
    rm -rf .pytest_cache/ .ruff_cache/
    find . -type d -name "*.egg-info" -exec rm -rf {} +
    find . -type d -name __pycache__ -exec rm -rf {} +
    find . -type f -name "*.pyc" -delete

# Print versions of all required toolchains.
versions:
    @echo "uv:     $(uv --version)"
    @echo "just:   $(just --version)"
    @echo "python: $(uv run python --version)"
