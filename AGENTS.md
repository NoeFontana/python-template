# AGENTS.md

Instructions for coding agents working in this repository. Humans should read
`docs/contributing.md` instead — this file is the machine-facing subset.

## Read before you change anything

`docs/adr/` holds this project's architecture decision records. **Before
proposing a change to structure, tooling, dependencies, public API, or
project-wide convention, read the records in that directory.**

- Records with status `accepted` are binding constraints. Follow them.
- Records with status `superseded by ADR-NNNN` or `deprecated` are history.
  Do **not** follow them; read the superseding record instead.
- Records with status `proposed` are under discussion. Do not treat them as
  decided, and do not implement them unless the task says so.
- The status is the second line of each record's body. Check it before using
  anything the record says.

If a task conflicts with an `accepted` record, stop and say so rather than
silently working around it. The correct resolution is a new ADR that
supersedes the old one, not an undocumented exception.

## Writing a new record

Significant changes need an ADR. ADR-0001 §"What counts as significant"
defines the threshold; when in doubt, ask rather than assume it's exempt.

- Run `just adr <short-kebab-title>`, which copies `docs/adr/template.md`.
- Filename `NNNN-short-kebab-title.md`, title in imperative mood.
- Use `NNNN` as the number placeholder in a draft; the number is assigned on
  merge.
- Ship the record in the same PR as the change it describes.
- Never edit an accepted record. Supersede it, and update the old record's
  status line to `superseded by ADR-NNNN` — that status edit is the one
  permitted modification.

## Project conventions

- Python ≥ 3.11. Package source in `src/`, tests in `tests/`.
- `uv` for dependency management. Never edit `uv.lock` by hand; use
  `uv add` / `uv sync`.
- `just` is the task surface. CI mirrors the recipes 1:1 — if you add a
  check, add it as a recipe and call the recipe from the workflow.
- `ruff` for lint and format, `pyright` for types, `pytest` for tests.
  Google-style docstrings on all public symbols (enforced by ruff's `D`
  rules).
- Documentation follows Diátaxis per ADR-0002. A new page goes in
  `tutorials/`, `how-to/`, `reference/`, or `explanation/` — decide which
  quadrant before writing, and don't create a fifth.
- Reference pages under `docs/reference/` marked as generated are generated.
  Change the generator or the source docstring, never the page.
- Fenced `python` blocks in `docs/` run as tests. Tutorial pages carry state
  between blocks with the `continuation` fence option; how-to blocks stand
  alone. Use `notest` only when a block genuinely cannot run.

## Before you say you're done

```bash
just check        # ruff check, ruff format --check, pyright, pytest, doc examples
just docs-index   # regenerate the generated reference pages
just docs-build   # mkdocs build --strict
```

`just check` must pass, and `just docs-index` must leave the working tree
clean — CI runs the same generators and fails on any diff. If you changed a
public symbol, its docstring changes in the same commit.
