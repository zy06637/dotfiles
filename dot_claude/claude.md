# Actions
- After completing the addition of a specific feature, you must update the current repository’s `README` accordingly. If a `README_CN` also exists, it must be updated at the same time.
- When analyzing the causes of a problem or providing a problem-solving approach, repeatedly consider whether there is only one correct answer and whether other possible causes exist.
- When analyzing the causes of a problem, list all possible causes in descending order of likelihood. If there are too many causes, list the top ten. Do not perform any file creation or modification operations.
- When making plans, ask as many questions as possible—don't make decisions on your own.
- When an issue is identified in a file within the project (e.g., formatting or syntax), check and correct all files of the same type.
- When an issue is identified in a paragraph within a file of the project (e.g., formatting or syntax), check and correct all other paragraphs in the file.
- Whenever my actions or behavior deviate from best practices, I need to be provided with clear and effective guidance.

# Python Execution

- **DO NOT** use `python` command directly.
- Always prefer using the repository-scoped virtual environment (venv).
- Use `python3` command to execute Python scripts.
- If a project has a venv, activate it first or use the venv's Python directly (e.g., `.venv/bin/python3` or `venv/bin/python3`).

# When starting the development of a new project or refactoring an existing one, the following rules must be followed:
This project adopts a layered “atomic architecture” that emphasizes clarity, maintainability, and high cohesion with low coupling.

## 1. L1 Entry Layer

* Contains **a single entry module only**, serving as the system’s sole external access point.
* Responsible for initialization, coordinating calls between layers, global exception handling, and log routing.
* **Must not implement any business logic**; it is limited to process orchestration.

## 2. L2 Coordination Layer

* Acts as the “commander,” “data dispatcher,” and “interface adapter”: orchestrates atomic capabilities, manages data flow, and encapsulates external APIs.
* Must provide clear interface contracts (including input/output types, error codes, and invocation protocols).
* **May depend only on the L3 Molecular Layer and must not directly invoke the L4 Atomic Layer**.

## 3. L3 Molecular Layer

* Consists of **business function units** composed of multiple atomic capabilities (e.g., user registration workflows, image preprocessing pipelines, model inference chains).
* **Molecules must not depend on or call each other**—all collaboration must be mediated through the Coordination Layer.
* Supports independent unit testing and version replacement.

## 4. L4 Atomic Layer

* Each atom is a **single-responsibility, minimal runnable unit** (e.g., a function, a pure class, or a stateless service).
* A single atomic implementation is recommended to be ≤ 80 lines of logical code (excluding comments and blank lines) to ensure readability and testability.
* **Atoms must not call each other or share state**—all composition is performed in the Molecular Layer.

## General Constraints

* **Strictly one-way dependency direction**: L1 → L2 → L3 → L4. Reverse or cross-layer dependencies are prohibited.
* **Directory structure should explicitly reflect the layering** (e.g., `/entry`, `/coordinator`, `/molecules`, `/atoms`).
* **Each layer exposes clearly defined interfaces/contracts**, hiding internal implementation details (encapsulation).
* Supports horizontal scalability: new features are added by introducing new atoms/molecules without modifying existing code (Open–Closed Principle).

## Terminal Configuration

When working with kitty terminal configuration, always check for conflicting settings in both the main kitty.conf and any include files. Fish shell can override cursor settings - check ~/.config/fish/config.fish if cursor changes aren't applying.

## Database

For SQLite databases synced via iCloud, always implement retry logic with exponential backoff to handle transient I/O errors during sync operations.

## Plugin Development

When creating plugins or packages, validate JSON schema compliance (marketplace.json, plugin.json) and directory naming conventions BEFORE committing. Double-check that old naming artifacts are fully cleaned up.

## Safety Rules

- When asked to revert or remove a specific feature, only remove exactly what was requested. Do NOT remove related features unless explicitly told to. Always confirm scope before making destructive changes.

## Implementation Rules

- When implementing features, always produce working code — never leave stub/placeholder implementations. If the full implementation is complex, implement the core logic first rather than wiring up empty handlers.

## Project-Specific Notes

### Rust TUI Editor (kenotex)

CJK/multi-byte character width handling is critical. When implementing any visual/cursor/rendering feature, always account for wide characters (Chinese, Japanese, Korean) using `unicode_width`. Test with multi-byte content.

### Invest Analysis Workflow

Analyst sub-agents may hit context limits. When launching parallel analyst agents, use simplified/condensed prompts to avoid "Prompt is too long" errors. If an agent fails, relaunch with a shorter prompt automatically.
