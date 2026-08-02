# ADR-0002: Documentation framework — Diátaxis on `mkdocs-material`, code-tested, gated in CI

- **Status:** accepted
- **Date:** 2026-08-02
- **Deciders:** project lead
- **Consulted:** —
- **Informed:** all contributors

## Context and problem statement

The template ships a working `mkdocs-material` site, but the site is four
files: a landing page, a hand-written reference stub, a contributing guide,
and a changelog. There is no information architecture, no discipline that
keeps examples true to the code, and no statement of what a project seeded
from this template is expected to document before it calls itself 1.0.

That gap matters more for a template than for a single project, because the
template propagates whatever shape it has. A project bootstrapped from an
IA-less template will grow an IA-less docs site by accretion, and the cost of
imposing structure rises with every page added.

The decision in front of us is the *framework*, not the content. What
information architecture does the docs site adopt, what discipline enforces
that the docs stay true to the code, what is auto-generated versus
hand-written, and who owns ongoing maintenance? Each sub-decision is small
individually; together they set the discoverability and trust posture of
every project seeded from this template.

This ADR triggers ADR-0001 §"Set a project-wide convention" (the Diátaxis
quadrant discipline applies to every contributor) and §"Add or remove a
top-level dependency" (`mkdocstrings`, `mike`, `pytest-markdown-docs`, and
the `lychee` CI action land as documentation-group dependencies).

## Decision drivers

- **The first-success window is short.** Someone evaluating a library has a
  budget of perhaps ten minutes to get a result out of it. If the docs
  framework doesn't produce that experience, no other quality of the project
  recovers the lost user.
- **Code-example rot is the failure mode that destroys trust.** A docs site
  whose tutorial doesn't run is worse than no docs site, because the reader
  concludes the project is unmaintained. The framework needs an enforcement
  mechanism, not a guideline — every fenced Python block in `docs/` runs as
  a test, full stop.
- **Auto-generated reference where possible.** Hand-written reference rots
  within two releases; generated reference rots only when the underlying code
  does, and the rot is then a CI failure rather than silent drift. The
  package already carries pyright-checked Google-style docstrings with
  doctest examples — that is a generation source sitting unused.
- **The framework must survive `setup.sh`.** Everything added here has to
  work after the bootstrap script rewrites the project name, package name,
  author, and GitHub handle across the tree. No page may hard-code a
  structure that only makes sense for a template.
- **No new runtime dependencies.** Per ADR-0001. The docs toolchain lives in
  the `[dependency-groups].docs` group; nothing here propagates into the
  installed package.
- **Agent-legibility.** Per ADR-0001, coding agents are first-class readers
  of this repository. Quadrant discipline and stable paths are what let an
  agent answer "where does this page go?" without asking.

## Considered options

The framework has six orthogonal axes. Each is decided independently; the
chosen design is the combination of one option per axis.

### Axis A — Information architecture

1. **Strict Diátaxis** — four top-level directories (`tutorials/`,
   `how-to/`, `reference/`, `explanation/`), no exceptions.
2. **Diátaxis plus one project-specific first-class section** — the four
   quadrants, plus license for a project to promote its single
   highest-leverage adoption surface (typically `migrate/`) to a top-level
   peer.
3. **Custom IA** — user-journey-driven sections (Get started, Common tasks,
   Reference, Architecture).
4. **Single-page docs** — one README at scale.

### Axis B — Toolchain

1. **mkdocs-material** with the Python plugin ecosystem.
2. **Sphinx** with myst-parser.
3. **Docusaurus** (React/Node).
4. **Custom Next.js / Astro site.**

### Axis C — Code-example discipline

1. **All fenced Python blocks tested in CI**, plus `--doctest-modules` on
   the package.
2. **Tutorials only** tested in CI; how-to and reference exempt.
3. **No automated testing** — convention only.

### Axis D — Reference generation

1. **Auto-generated everywhere possible** — API via mkdocstrings, CLI via
   the argparse parser, ADR index from the record front-matter.
2. **Hand-written, with generated cross-references.**
3. **Auto-generated API only**; hand-write CLI and index pages.

### Axis E — Versioning policy

1. **Per minor release** via the `mike` plugin; patch releases overwrite
   within a minor.
2. **Per patch release** — every 0.0.x has its own URL.
3. **Latest only** — stable URL, latest content, no history.

### Axis F — Maintenance ownership

1. **Project lead through 0.1.x**; reviewer rotation when external doc PRs
   become regular (>5/month).
2. **Dedicated docs maintainer from day one** (separate CODEOWNERS entry).
3. **Round-robin** across all contributors.

## Decision outcome

Chosen: **A2 + B1 + C1 + D1 + E1 + F1.**

### Information architecture (A2)

The docs site adopts Diátaxis with one licensed bend: a project may promote
exactly one project-specific section to a top-level peer when that section is
its dominant adoption surface. The canonical case is `migrate/` for a library
that competes with an incumbent — burying migration guides under `how-to/`
loses the highest-leverage adoption surface. The template ships the four
quadrants and documents the bend; it does not ship an empty `migrate/`.

Strict Diátaxis (A1) was rejected for exactly that reason. Custom IA (A3)
loses the quadrant discipline that prevents tutorial/how-to/reference/
explanation drift — which is the whole reason to adopt a framework rather
than improvise. A4 doesn't scale past a few hundred lines and defeats
auto-generated reference.

The IA tree lands as:

```
docs/
├── index.md                       # landing — value prop, install, 60-second example
├── tutorials/                     # learning-oriented; cap at 3
│   └── getting-started.md
├── how-to/                        # task-oriented; one page per task
│   └── index.md
├── reference/                     # information-oriented; mostly generated
│   ├── api.md                     # mkdocstrings, generated from docstrings
│   ├── cli.md                     # generated from the argparse parser
│   └── adr-index.md               # generated from docs/adr/ front-matter
├── explanation/                   # understanding-oriented
│   └── architecture-overview.md
├── contributing.md
└── changelog.md
```

`docs/adr/` and (where a project has one) `docs/engineering/` are **not
user-facing**. They stay in-tree, reviewed like code, and are excluded from
the published site via mkdocs 1.6's `draft_docs` — which keeps them visible
in `mkdocs serve` for local review while publishing nothing — together with
`not_in_nav` to suppress the `validation.nav.omitted_files` warning the repo
already enables. `reference/adr-index.md` exposes ADR numbers, titles, and
statuses for readers who want to dig deeper: a navigation shortcut, not a
re-render.

### Toolchain (B1)

mkdocs-material, which the repository already uses, with this plugin set:

- **mkdocstrings (Python handler)** — generates the API reference from the
  existing Google-style, pyright-checked docstrings. Already present.
- **mike** — versioned deployment, pinned by minor.
- **mkdocs-redirects** — preserves URLs across reorganisation. Cheap
  insurance for a site that is about to be reorganised.
- **lychee** — link checker, runs in CI.
- **pytest-markdown-docs** — runs every fenced Python block as a test.
- **codespell** — already wired through pre-commit; extended to `docs/`.

Sphinx (B2) was rejected: RST-encumbered even with myst-parser, heavyweight,
and the modern Python audience is on mkdocs-material via Astral, Polars, and
pydantic. Docusaurus (B3) and a custom site (B4) were rejected: both
introduce a Node.js toolchain the project does not otherwise have, for a
documentation site.

### Code-example discipline (C1)

Every fenced code block in `docs/` tagged `python` runs as a test. A
tutorial-breaking PR fails CI. The harness treats:

- **Tutorials**: blocks run end-to-end in sequence; state carries between
  blocks within a page, so a broken first block breaks the rest.
- **How-to guides**: blocks run in isolation; each block is its own test.
- **Reference**: examples live in docstrings and run under
  `pytest --doctest-modules src/`. The reference page renders those
  docstrings, so a passing docstring example is a passing reference example.

Doc tests run as a separate pytest invocation with `--no-cov`, because the
repository's `addopts` carries `--cov-fail-under=85` scoped to the package
and a docs run would trip it for reasons that have nothing to do with docs.

C2 (tutorials only) was rejected: how-to guides are the most-clicked pages in
adoption, and a broken how-to guide is a broken adoption funnel. C3
(convention only) was rejected: hand-discipline doesn't survive contributor
turnover, and it certainly doesn't survive agents.

### Reference generation (D1)

Auto-generation everywhere it is mechanically possible:

- **API** — mkdocstrings reads the existing docstrings. One page, one
  `:::` directive per public module. No hand-written API prose.
- **CLI** — a small generator walks the `create_parser()` argparse tree and
  emits `reference/cli.md` (commands, flags, defaults, exit codes). The
  generator lives at `tools/docs/gen_cli_reference.py` and runs in CI; CI
  fails if the committed page differs from the generated one.
- **ADR index** — generated from `docs/adr/*.md` by
  `tools/docs/gen_adr_index.py`: number, title, status, date, sorted by
  number, with superseded records struck through.

D2 was rejected because hand-written reference rots silently. D3 was rejected
because the ADR index and CLI reference are precisely the pages a human is
most likely to forget to update.

### Versioning (E1)

`mike` versions the docs per minor release. Patch releases overwrite within
their minor; minor releases spawn a new versioned URL. The `stable` alias
points at the latest tagged release, `latest` at `main`.

E2 (per patch) adds noise to the version selector and creates a back-porting
treadmill. E3 (latest only) breaks the reader pinned to 0.1.5 the moment
0.2.0 ships, which is the trust contract this whole ADR is about.

**Implementation consequence, called out because it is not free:** the
repository previously deployed with `actions/upload-pages-artifact` +
`actions/deploy-pages`, and GitHub Pages was configured with *GitHub Actions*
as its source. `mike` publishes by committing to a `gh-pages` branch. Adopting
E1 means replacing the deploy job with `mike deploy --push --update-aliases`
and switching the Pages source to *Deploy from a branch → `gh-pages`*.
`docs/index.md` §"Post-Setup" documents that setting and must be updated in
the same PR, or every project seeded from the template gets a broken deploy.

### Maintenance ownership (F1)

Docs maintenance sits with the project lead through 0.1.x. Once external doc
PRs become regular (>5/month), a reviewer rotation establishes and a separate
`CODEOWNERS` entry for `docs/` follows.

The single most important ongoing discipline: **every PR that changes a
public symbol updates the docstring in the same PR.** Generated reference
handles the rest. CI catches the easy cases (missing docstring via ruff's
`D` rules, broken example via the doc-test gate); reviewers catch the hard
case — the docstring exists but is now misleading.

### CI gates

Six gates, five of them new:

1. **Docstring coverage** — ruff's `D` rules, already selected in
   `[tool.ruff.lint]`. No new tool.
2. **Code-example testing** — `uv run pytest --markdown-docs docs/ --no-cov`
   and `uv run pytest --doctest-modules src/ --no-cov`, wired into
   `just check`.
3. **Link checking** — `lychee` on the rendered site for every PR touching
   `docs/`. External links checked on a weekly schedule instead of per-PR;
   external link checks are too flaky for a merge gate.
4. **Build success** — `mkdocs build --strict`. Already in CI; kept.
5. **Spelling** — `codespell` extended to `docs/`. Already in pre-commit;
   promoted to a CI step so it gates on PRs from forks.
6. **Generated-page freshness** — regenerate `reference/cli.md` and
   `reference/adr-index.md`, `git diff --exit-code`. Prevents the generated
   pages from silently drifting from their sources.

## What this ADR explicitly does *not* decide

- **Specific tutorial / how-to content.** This ADR sets the framework, the
  gates, and the IA. Content lands PR by PR with code-example testing as the
  quality bar.
- **The docs quality bar for downstream projects.** A project seeded from
  the template inherits the framework, not a content checklist.
- **AI-generated prose.** Hard no. The audience is technical and recognises
  the smell; the trust cost outweighs the time saved. This covers
  LLM-written tutorials, explanations, "improve clarity" passes, and docs
  chatbots. Agents may *scaffold* structure and run the gates; the prose is
  written by a human. The docs are the answer; if the docs aren't, fix the
  docs.
- **Translations.** English only. Localisation is a 1.0+ conversation if it
  happens at all.
- **Video tutorials.** High production cost, high rot rate, narrow audience.
- **Third-party analytics on the docs site.** GitHub Pages defaults only.
  Readers in research and corporate environments treat third-party telemetry
  as a compliance event, for no measurable docs-quality gain.
- **A custom domain.** Default Pages URL until a project has a reason.

## Consequences

- **Positive.** First-success time becomes a designed property rather than
  an accident. Reference pages cannot drift from the code without failing
  CI. The ADR log gains a consumption surface. Every project seeded from the
  template starts with an IA instead of accreting one.
- **Negative.** Real setup cost, and a permanent tax: every PR that touches
  a public symbol now also touches the docs that demonstrate it. The plugin
  set is one more thing to keep current. The `mike` migration touches the
  deploy job and the Pages repository setting, which is exactly the kind of
  change that breaks silently for downstream users of the template. The
  minor-version freeze means a docs error shipped in a minor stays pinned for
  that minor's lifetime — mitigated by the patch-overwrite policy.
- **Neutral.** No new runtime dependencies. The CI surface grows by four
  gates, each small and well-bounded. `just check` gets slower by the
  duration of the doc-test run.

## Pros and cons of the options

### A. Information architecture

- **A1 strict Diátaxis.** 👍 unambiguous quadrants. 👎 buries the dominant
  adoption surface under `how-to/`.
- **A2 Diátaxis + one licensed peer (chosen).** 👍 quadrant discipline
  preserved where it pays; promotion available where it matters. 👎 a bend
  that strict Diátaxis advocates will question.
- **A3 custom IA.** 👍 maximum flexibility. 👎 loses the discipline that
  prevents drift.
- **A4 single page.** 👍 one URL. 👎 doesn't scale; defeats generated
  reference.

### B. Toolchain

- **B1 mkdocs-material (chosen).** 👍 already in place; mature plugin
  ecosystem; mkdocstrings generates the API reference. 👎 plugin set to
  maintain.
- **B2 Sphinx.** 👍 academic-Python heritage. 👎 RST-encumbered;
  heavyweight.
- **B3 Docusaurus.** 👍 powerful. 👎 Node.js dependency.
- **B4 custom site.** 👍 maximum control. 👎 wrong place to out-engineer a
  documentation problem.

### C. Code-example testing

- **C1 all blocks tested (chosen).** 👍 zero rot. 👎 every doc-touching PR
  runs the docs.
- **C2 tutorials only.** 👍 cheaper. 👎 broken how-to guides break adoption.
- **C3 convention only.** 👍 zero CI cost. 👎 doesn't survive turnover.

### D. Reference generation

- **D1 generate everywhere possible (chosen).** 👍 reference is
  mechanically true to the code. 👎 setup cost; generators to maintain.
- **D2 hand-written + cross-refs.** 👍 cleaner prose. 👎 rots silently.
- **D3 API only.** 👍 less machinery. 👎 leaves the two pages most likely
  to be forgotten unautomated.

### E. Versioning

- **E1 per minor (chosen).** 👍 clean URL story at 0.x velocity. 👎
  requires migrating the deploy job and the Pages setting.
- **E2 per patch.** 👍 every release pinned. 👎 noisy selector.
- **E3 latest only.** 👍 simplest; matches the previous deploy. 👎 breaks
  pinned readers.

### F. Ownership

- **F1 lead through 0.1.x (chosen).** 👍 consistent voice. 👎 single point
  of failure.
- **F2 dedicated maintainer.** 👍 clear ownership. 👎 no one to dedicate.
- **F3 round-robin.** 👍 spreads context. 👎 too thin to catch IA drift.

## Links and references

- ADR-0001 — Record architecture decisions. The generated ADR index is a
  consumption surface ADR-0001 implicitly created.
- `AGENTS.md` — points agents at `docs/adr/` and at this framework's gates.
- `docs/contributing.md` — gains a §"Documentation" section pointing
  contributors at the gates.
- [Diátaxis](https://diataxis.fr/) — the documentation framework.
- [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) — the
  toolchain.
- [Astral docs](https://docs.astral.sh/) (uv, ruff) — reference for concise
  modern Python docs at the top of the field.
