---
description: Write a new spec from a task in phaseX.md
globs:
---

# Write Spec

## Context to load
1. The task description from the relevant `phaseX.md`.
2. The relevant section(s) of `design/Architecture.md` — only the section referenced by the task, not the whole file.
3. The relevant HU from `vision/HU/HU-XX.md`.
4. `technologies/{area}.md` for the area being specified (backend, frontend, testing).
5. The template: `sdd/templates/SPEC-TEMPLATE.md`.

## Steps
1. Read the task and identify the bounded context, drivers, and affected layers.
2. Read the Architecture.md section for the relevant domain model / component.
3. Copy the essential context (3-10 lines) from Architecture.md into the spec's "Architectural Context" field — do NOT just reference, include the relevant snippet.
4. Fill all template sections. Leave nothing as placeholder.
5. Define concrete acceptance criteria (testable, not vague).
6. List exact file paths to create/modify.
7. Define edge cases and error handling.
8. Set `Status: 🔲 Draft`.

## Output
- One spec file: `sdd/specs/iteration-{N}/SPEC-{NNN}_{kebab-case}.md`
- Update `sdd/SPEC_INDEX.md` with the new entry.
- Link the spec from the task in `phaseX.md`.
