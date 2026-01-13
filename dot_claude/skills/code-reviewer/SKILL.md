---
name: code-reviewer
description: Comprehensive code review for security, performance, maintainability, and best practices. Use this skill proactively after writing significant code, or when user requests a code review, asks to "review this code", "check my code", "find bugs", or similar. Applies to any programming language.
---

# Code Reviewer

Perform thorough code reviews covering security vulnerabilities, performance issues, maintainability concerns, and adherence to best practices.

## When to Review

**Automatic triggers** (use proactively):
- After writing or modifying 50+ lines of code
- After implementing new features or bug fixes
- After refactoring significant portions of code

**Manual triggers** (user requests):
- "Review this code", "Check my changes", "Find bugs"
- "Is this code secure?", "Any issues with this?"

## Review Process

### 1. Understand Context

Before reviewing, understand:
- What the code is meant to do
- The broader system context (if visible)
- Any constraints or requirements mentioned

### 2. Systematic Analysis

Review in this order, checking each category:

**Security** (see references/security-checklist.md for details)
- Input validation and sanitization
- Authentication/authorization flaws
- Injection vulnerabilities (SQL, command, XSS)
- Sensitive data exposure
- Insecure dependencies

**Correctness**
- Logic errors and edge cases
- Off-by-one errors, null/undefined handling
- Race conditions in async code
- Error handling completeness

**Performance**
- Unnecessary computation or I/O
- N+1 queries, missing indexes
- Memory leaks, unbounded growth
- Inefficient algorithms for data size

**Maintainability** (see references/quality-patterns.md for details)
- Clear naming and structure
- Appropriate abstractions
- Code duplication
- Testability

### 3. Report Format

Structure review output as:

```
## Code Review Summary

**Overall Assessment**: [Good/Needs Changes/Significant Issues]

### Critical Issues
[Security vulnerabilities, bugs that will cause failures]

### Recommendations
[Performance improvements, maintainability suggestions]

### Positive Notes
[Well-written aspects worth highlighting]
```

## Review Depth

Match review depth to context:

| Scenario | Depth |
|----------|-------|
| Quick bug fix | Focus on correctness, security |
| New feature | Full review, all categories |
| Refactor | Focus on maintainability, correctness |
| User asks "quick look" | High-level issues only |

## Key Principles

1. **Be specific** - Point to exact lines, show fixed code
2. **Prioritize** - Critical issues first, nitpicks last (or omit)
3. **Explain why** - Help the author understand, not just fix
4. **Be constructive** - Suggest improvements, don't just criticize
5. **Acknowledge good code** - Reinforce positive patterns

## References

- `references/security-checklist.md` - Detailed security review criteria
- `references/quality-patterns.md` - Code quality patterns and anti-patterns
