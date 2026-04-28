---
description: Implement a spec — generate code from an approved SPEC file
globs:
---

# Implement Spec

## Context to load
1. Read ONLY the spec file provided by the user. It is self-contained.
2. Do NOT read Architecture.md, progress.md, or technologies/*.md unless the spec explicitly says a section is needed and you cannot proceed without it.

## Steps
1. Read the spec completely before writing any code.
2. Identify all files listed in the spec's "Technical Design" and "Files to Create/Modify" sections.
3. Implement each file following the spec's contracts (fields, types, invariants, exceptions).
4. Write tests as specified in the spec's "Testing Strategy" section.
5. Verify all Acceptance Criteria are met.
6. Do NOT create files outside the spec's scope.

## Output format
- One commit per logical unit (e.g., domain model, adapter, migration).
- Commit message: `feat({module}): SPEC-{NNN} {short description}`
