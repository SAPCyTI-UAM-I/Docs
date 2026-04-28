---
description: Review code against a spec
globs:
---

# Review Code Against Spec

## Context to load
1. The spec that the code implements.
2. `technologies/testing.md` for testing conventions.
3. The actual code files to review.

## Checklist
1. **Scope:** Does the code implement exactly what the spec says? Nothing more, nothing less.
2. **Contracts:** Do classes, methods, and fields match the spec's technical design?
3. **Invariants:** Are domain invariants enforced in constructors/setters as specified?
4. **Tests:** Do tests cover all acceptance criteria and edge cases listed in the spec?
5. **Conventions:** Does the code follow naming, packaging, and layer rules from the agent rules?
6. **No leaks:** No cross-module imports, no framework imports in domain beyond `jakarta.persistence.*`.
7. **No extras:** No files, endpoints, or features outside the spec's scope.

## Output
- List of findings: `✅ Pass` or `❌ {issue} — spec section {N}`.
- Suggested fixes with code snippets if needed.
