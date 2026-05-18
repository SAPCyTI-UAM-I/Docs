# Folder structure — SAPCyTI Docs

**Status:** Executed (2026-05-17) on branch `docs/reorganize-memory-bank`.

## Final tree

```text
Docs/
├── README.md, AGENTS.md, CANONICAL.md, external-references.md
├── onboarding/
├── vision/
├── requirements/
├── design/
├── technologies/
├── implementation/
└── sdd/
    ├── theory/
    ├── domain/
    ├── templates/
    └── specs/
```

## Route changelog


| Previous path                                           | New path                |
| ------------------------------------------------------- | ------------------------- |
| `vision/`                                               | `vision/`                 |
| `requirements/`                                         | `requirements/`           |
| `design/` + `ADD.md` + `ArchitecturalDrivers.md` (root) | `design/`                 |
| `technologies/`                                         | `technologies/`           |
| `implementation/`                                       | `implementation/`         |
| `SDD/`                                                  | `sdd/`                    |
| `sdd/theory/`                                           | `sdd/theory/` (merged) |
| `specifications/` (legacy)                              | Removed → `sdd/domain/` |


See `[CANONICAL.md](CANONICAL.md)` for updated source of truth.