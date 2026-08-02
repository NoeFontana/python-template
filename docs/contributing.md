# Contributing

Thank you for your interest in contributing to this project!

Coding agents should read `AGENTS.md` in the repository root, which is the
machine-facing subset of this guide.

## Development Setup

1. Fork the repository on GitHub
2. Clone your fork locally:

   ```bash
   git clone https://github.com/NoeFontana/python-template.git
   cd python-template
   ```

3. Install dependencies:

   ```bash
   just bootstrap
   ```

4. Set up pre-commit hooks:

   ```bash
   just pre-commit
   ```

`just` is the task surface for this project; run `just` with no arguments to
list every recipe. CI mirrors these recipes 1:1, so a green `just check`
locally means a green CI.

## Making Changes

1. Create a new branch for your feature:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and write tests

3. Run the test suite:

   ```bash
   just check
   ```

4. Commit your changes:

   ```bash
   git commit -m "Add your feature"
   ```

5. Push to your fork and create a pull request

## Decision records

Architecturally significant changes ship with an Architecture Decision Record
in `docs/adr/`. ADR-0001 defines the threshold; in short, a record is required
for changes that affect the public API or CLI, the data or error model, the
set of top-level dependencies or supported Python versions, the packaging and
release process, or any project-wide convention. Typo fixes, version bumps,
internal refactors, and test additions do not need one.

To create a record:

```bash
just adr short-kebab-title
```

That copies `docs/adr/template.md` to `docs/adr/NNNN-short-kebab-title.md`.
Leave the number as `NNNN` — **numbers are assigned on merge**, not on draft,
so that concurrent PRs don't collide and force renumbering. Ship the record in
the same PR as the change it describes; it starts at status `proposed` and
becomes `accepted` when the PR merges.

**An accepted record is never edited.** If circumstances change, write a new
record that supersedes it and set the old record's status line to
`superseded by ADR-NNNN`. That status edit is the only permitted modification
to an accepted record. The reasoning in the log is only trustworthy if it is
immutable.

The records themselves are not published to this site — they are engineering
history, not user documentation. The [decision record index](reference/adr-index.md)
lists their numbers, titles, and statuses.

## Documentation

Documentation follows [Diátaxis](https://diataxis.fr/). Every page belongs to
exactly one quadrant; decide which before you start writing:

| Quadrant | Directory | Purpose |
| --- | --- | --- |
| Tutorial | `docs/tutorials/` | Learning-oriented. A guaranteed-to-succeed path. |
| How-to | `docs/how-to/` | Task-oriented. One page per task the reader arrives with. |
| Reference | `docs/reference/` | Information-oriented. Mostly generated. |
| Explanation | `docs/explanation/` | Understanding-oriented. Why, not how. |

Two rules that CI enforces:

- **Generated pages are generated.** `reference/api.md` renders docstrings via
  mkdocstrings; `reference/cli.md` and `reference/adr-index.md` are written by
  the scripts in `tools/docs/`. Change the docstring or the generator, never
  the page. Run `just docs-index` and commit the result — CI regenerates and
  fails on any diff.
- **Every fenced `python` block runs as a test.** `just docs-test` runs them,
  along with the doctest examples in `src/`. Tutorial pages carry state across
  blocks using the `continuation` fence option; how-to blocks stand alone. Use
  `notest` only for a block that genuinely cannot execute.

```bash
just docs         # serve locally with auto-reload
just docs-test    # run every fenced block and docstring example
just docs-build   # mkdocs build --strict
```

## Code Style

This project uses:

- **ruff** for linting and formatting
- **pyright** for type checking
- **pytest** for testing

All checks must pass before merging.
