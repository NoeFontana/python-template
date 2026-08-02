# ADR-0001: Record architecture decisions

- **Status:** accepted
- **Date:** 2026-08-02
- **Deciders:** project lead
- **Consulted:** —
- **Informed:** all contributors

## Context and problem statement

Any project seeded from this template will accumulate a long tail of small
but consequential design decisions: where the package boundary sits, which
dependencies are allowed to become top-level, how errors are modelled, what
counts as public API, how much of the tooling is negotiable per project.

If those decisions live only in PR descriptions, chat threads, and
contributors' heads, three things go wrong as the project grows:

1. **Decisions get relitigated.** Six months later, someone proposes a change
   that violates an earlier decision but doesn't know the earlier decision
   exists or why it was made. The discussion is repeated from scratch,
   sometimes with a different outcome, often without learning from the
   original trade-offs.
2. **Newcomers can't catch up.** There's no good answer to "why is the project
   structured this way?" except reading three years of git history.
3. **Reasoning is lost.** The decision survives in the code but the *why*
   doesn't, so future maintainers can't tell which constraints still apply
   and which have evaporated.

A fourth failure mode has become load-bearing since 2024: **coding agents
relitigate decisions faster and more confidently than humans do.** An agent
with no access to project history will happily re-introduce a dependency that
was removed on purpose, or restructure a module whose shape was chosen for a
reason it cannot see. A written decision log is the cheapest available
mechanism for putting those constraints back in front of the agent.

This is a well-understood problem with a well-understood solution: keep a
journal of architecturally significant decisions in the repository, beside
the code they describe.

## Decision drivers

- Decisions must be discoverable by new contributors without tribal knowledge.
- Decisions must be discoverable by coding agents without bespoke tooling —
  plain Markdown, stable paths, machine-readable status.
- The process must be lightweight enough that people actually use it; if it
  feels like writing a thesis, contributors will route around it.
- Decisions must be linkable from PRs, code comments, and other docs.
- Records must be immutable once accepted, so that historical reasoning isn't
  silently rewritten.

## Considered options

1. **Wiki / Notion / external doc.** Easy to write, but lives outside the
   code, drifts out of sync, requires separate access management, and is
   invisible to any agent working from a checkout.
2. **Long-form design docs in `docs/`.** Better than a wiki, but tends to
   produce a small number of large documents that nobody updates rather than
   a steady stream of focused decisions.
3. **Architecture Decision Records (ADRs)** in `docs/adr/`, one Markdown
   file per decision, in a numbered sequence, immutable once accepted.

## Decision outcome

Chosen option: **ADRs in `docs/adr/`**, using the
[MADR](https://adr.github.io/madr/) format.

The format is described in `docs/adr/template.md`. The lifecycle is described
in `docs/contributing.md`. In short: significant changes start as a `proposed`
ADR in a PR, are discussed, and become `accepted` on merge. Once accepted, an
ADR is not edited; if circumstances change, a later ADR supersedes it and
sets the older one's status to `superseded by ADR-NNNN`.

### What counts as "significant"

ADRs are required for changes that:

- Affect the public API of the package or its CLI.
- Change the data model, error model, or concurrency model.
- Add or remove a top-level dependency, a build target, or a supported
  Python version.
- Change the packaging, release, or versioning process.
- Set a project-wide convention (style, naming, layout, docs).

ADRs are *not* required for typo fixes, dependency version bumps, internal
refactors with no API impact, or test additions.

### Numbering and naming

- ADRs are numbered sequentially starting from `0001`. Numbers are assigned
  on merge, not on draft, to avoid renumbering churn from concurrent PRs.
  A PR may carry `NNNN` as a placeholder until then.
- Filenames are `NNNN-short-kebab-title.md`. The title is in imperative mood
  ("use uv for dependency management", not "uv-based dependency management").
- Statuses: `proposed`, `accepted`, `superseded by ADR-NNNN`, `deprecated`.
- The status line is the second line of the file body, not only front-matter,
  so that any tool or agent that chunks the document sees it immediately.

### Visibility

`docs/adr/` is committed to git and reviewed like code, but it is **not
published to the documentation site**. It is internal engineering history,
not user-facing documentation. ADR-0002 §"Information architecture" specifies
the mkdocs mechanism (`draft_docs` / `not_in_nav`) and the generated
`reference/adr-index.md` page that exposes titles and statuses to users who
want to dig deeper.

### Relationship to the template

This ADR and ADR-0002 ship with the project template itself. A project seeded
from the template inherits both as its own ADR-0001 and ADR-0002; they are
template-level decisions that the new project has adopted by construction.
A project that wants to diverge writes a superseding ADR rather than editing
these.

## Consequences

- **Positive.** Newcomers have a single place to read project history.
  Decisions accumulate context that compounds in value over time. PRs become
  shorter because the rationale lives in the ADR, not the commit message.
  Coding agents get a stable, greppable constraint surface.
- **Negative.** Light overhead per significant change. Some contributors
  will resist writing prose; the burden falls on reviewers to ask for an ADR
  when one is missing. An ADR log that accumulates stale `accepted` records
  makes agents *more* rigid rather than better informed — the superseding
  discipline is not optional.
- **Neutral.** ADRs are a discipline, not a tool. They work to the extent
  the team takes them seriously; they fail silently if treated as paperwork.

## Links and references

- Michael Nygard, [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
  (the original 2011 article).
- [adr.github.io](https://adr.github.io/) — community resources, tools, and
  format variants.
- [MADR](https://adr.github.io/madr/) — the specific Markdown format used here.
- `AGENTS.md` — the agent entry point that points at this directory.
- ADR-0002 — documentation framework; specifies how ADRs surface (and don't)
  on the docs site.
