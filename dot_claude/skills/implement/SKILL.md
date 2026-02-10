---
name: implement
description: "Spawn a 3-agent team to implement a planned feature: one agent writes code, one writes tests (in parallel), and one updates documentation. Use this skill after a plan has been written — either via /plan, EnterPlanMode, or any other planning method. Invoke with `/implement` or `/implement path/to/plan.md`."
---

# Implement — Parallel Feature Implementation Team

After a plan has been finalized, this skill spawns a coordinated 3-agent team to execute it in parallel.

## Workflow

### Step 1: Locate the Plan

Find the implementation plan using this priority order:

1. **Argument**: If the user passed a file path as argument (e.g., `/implement path/to/plan.md`), use that file.
2. **task_plan.md**: Check the current working directory for `task_plan.md` (created by `planning-with-files` skill).
3. **Recent context**: If a plan was discussed in the current conversation (e.g., via EnterPlanMode), use that plan from conversation context.
4. **Ask**: If no plan is found, ask the user to provide the plan location.

Read the plan file contents — you will pass the full plan text to each agent.

### Step 2: Detect Project Context

Before spawning the team, gather project context by running these checks in parallel:

- Check if `README.md` exists in the project root
- Check if `README_CN.md` exists in the project root
- Check if a `docs/` directory exists in the project root
- Read CLAUDE.md (project-level) if it exists, to understand project conventions
- Identify the test framework/pattern by checking existing test files (e.g., `tests/`, `src/**/*_test.*`, `**/*.test.*`, `**/test_*.*`)
- Identify the build/run commands (Cargo.toml → Rust, package.json → Node, pyproject.toml → Python, etc.)

### Step 3: Create Team and Tasks

Create a team named `implement-feature` with yourself as team lead.

Create **3 tasks** in the task list:

1. **"Implement feature code"** — assigned to `coder`
2. **"Write test cases"** — assigned to `tester`
3. **"Update documentation"** — assigned to `docs-writer`

The `docs-writer` task should be marked as blocked by the `coder` task (task 1 blocks task 3), because documentation needs to reflect what was actually implemented. The `tester` task runs in parallel with `coder` — no dependency.

### Step 4: Spawn Agents

Spawn **3 agents** using the Task tool. The `coder` and `tester` agents should be spawned in parallel. The `docs-writer` agent should be spawned after the coder finishes.

All agents must use `subagent_type: "general-purpose"` and include `team_name: "implement-feature"`.

#### Agent: `coder`

```
Name: coder
Mode: default
```

Prompt template (fill in `{plan}` and `{project_conventions}`):

```
You are the CODE WRITER on an implementation team.

## Your Task
Implement the feature described in the plan below. Write production-quality code.

## Plan
{plan}

## Project Conventions
{project_conventions}

## Rules
- Read existing code before modifying files. Understand patterns before writing.
- Follow existing code style, naming conventions, and architecture patterns.
- Only implement what the plan specifies — no extra features or refactoring.
- Write working code, not stubs or placeholders.
- After finishing, mark your task as completed using TaskUpdate.
- Send a message to the team lead summarizing what files were created/modified.
```

#### Agent: `tester`

```
Name: tester
Mode: default
```

Prompt template (fill in `{plan}`, `{test_framework}`, `{test_patterns}`):

```
You are the TEST WRITER on an implementation team.

## Your Task
Write comprehensive test cases for the feature described in the plan below. Work based on the PLAN (not the implementation) — you are writing tests in parallel with the coder.

## Plan
{plan}

## Test Framework & Patterns
{test_framework}

Existing test patterns found:
{test_patterns}

## Rules
- Write tests based on the plan's requirements and expected behavior.
- Follow existing test patterns and conventions in the project.
- Cover: happy path, edge cases, error cases, boundary conditions.
- Place test files in the conventional location for this project.
- If the coder's implementation doesn't exist yet when you run tests, that's expected — focus on writing correct test code.
- After finishing, mark your task as completed using TaskUpdate.
- Send a message to the team lead summarizing what test files were created and what they cover.
```

#### Agent: `docs-writer`

**Spawn this agent AFTER the `coder` agent completes.** The docs agent needs to see the actual implementation.

```
Name: docs-writer
Mode: default
```

Prompt template (fill in `{plan}`, `{has_readme}`, `{has_readme_cn}`, `{has_docs_dir}`, `{changed_files_summary}`):

```
You are the DOCUMENTATION WRITER on an implementation team.

## Your Task
Update project documentation to reflect the newly implemented feature.

## Plan
{plan}

## What Was Implemented
{changed_files_summary}

## Documentation Scope

Determine the appropriate documentation level based on the feature's significance:

### For significant features (new user-facing functionality, new commands, new config options, API changes):
{readme_instructions}
{docs_instructions}

### For minor improvements (internal refactors, small bug fixes, performance tweaks):
- Only update docs/ if a relevant doc file already covers the area
- Skip README updates unless the improvement is user-visible

## Rules
- Read existing documentation before modifying. Match tone and style.
- README/README_CN must stay in sync — if you update one, update the other with equivalent content.
- Do not add documentation for implementation details that users don't need to know.
- Be concise. Documentation should help users, not impress them.
- After finishing, mark your task as completed using TaskUpdate.
- Send a message to the team lead summarizing what documentation was updated.
```

Where:
- `{readme_instructions}`: If README.md exists → "Update README.md with the new feature description, usage, and examples." Otherwise → "No README.md found, skip."
- Same for README_CN.md
- `{docs_instructions}`: If docs/ exists → "Update or create relevant files in docs/ to document the feature." Otherwise → "No docs/ directory found, skip doc files."

### Step 5: Coordinate

As team lead:

1. Wait for `coder` and `tester` to complete (they run in parallel).
2. Once `coder` completes, spawn the `docs-writer` agent with the coder's summary of changes.
3. Once all 3 agents complete, summarize the results to the user:
   - Files created/modified by coder
   - Test files and coverage by tester
   - Documentation updates by docs-writer
4. If any agent reports issues, relay them to the user.
5. Run the project's test command (e.g., `cargo test`, `npm test`, `pytest`) to verify everything works together.
6. Shut down all agents and clean up the team.

### Step 6: Final Report

Present to the user:

```
## Implementation Complete

### Code Changes
- [list of files created/modified]

### Tests
- [list of test files and what they cover]

### Documentation
- [list of docs updated]

### Verification
- [test run results]
```
