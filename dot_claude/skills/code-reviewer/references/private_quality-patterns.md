# Code Quality Patterns

## Table of Contents
- [Naming](#naming)
- [Functions](#functions)
- [Error Handling](#error-handling)
- [Code Organization](#code-organization)
- [Common Anti-Patterns](#common-anti-patterns)

---

## Naming

### Good Naming
- Names reveal intent: `getUserById` not `getData`
- Consistent vocabulary: pick `fetch`/`get`/`retrieve` and stick with it
- Searchable: `MAX_RETRY_COUNT` not `5`
- Pronounceable: `customerAddress` not `custAddr`

### Naming Conventions
| Type | Convention | Example |
|------|-----------|---------|
| Boolean | is/has/can/should prefix | `isValid`, `hasPermission` |
| Functions | verb + noun | `calculateTotal`, `sendEmail` |
| Collections | plural | `users`, `orderItems` |
| Callbacks | on + event | `onSubmit`, `onClick` |

### Red Flags
- Single letter names (except `i`, `j` in loops)
- Generic names: `data`, `info`, `temp`, `result`
- Abbreviations that aren't universal
- Names that lie about what they do

---

## Functions

### Good Functions
- Do one thing well
- 20 lines or less (guideline, not rule)
- Few parameters (3 or fewer ideal)
- No side effects when name suggests pure operation
- Return early to avoid deep nesting

```python
# BAD - does multiple things
def process_user(user):
    validate_user(user)
    save_to_db(user)
    send_welcome_email(user)
    update_analytics(user)
    return user

# GOOD - single responsibility
def validate_user(user):
    if not user.email:
        raise ValueError("Email required")
    if not is_valid_email(user.email):
        raise ValueError("Invalid email format")
```

### Parameter Objects
When functions have many parameters, group related ones:

```python
# BAD
def create_order(user_id, product_id, quantity, shipping_street,
                 shipping_city, shipping_zip, billing_street, ...):

# GOOD
def create_order(user_id, product_id, quantity, shipping: Address, billing: Address):
```

---

## Error Handling

### Good Practices
- Fail fast: validate inputs early
- Be specific: catch specific exceptions, not all
- Preserve context: include original error in wrapped exceptions
- Handle at the right level: don't catch if you can't handle

```python
# BAD - swallows all errors
try:
    result = risky_operation()
except:
    pass

# BAD - catches too broadly
try:
    data = json.loads(user_input)
    result = process(data)
except Exception as e:
    log.error(e)

# GOOD - specific handling
try:
    data = json.loads(user_input)
except json.JSONDecodeError as e:
    raise ValidationError(f"Invalid JSON: {e}") from e
```

### Return Values vs Exceptions
- Use exceptions for exceptional conditions
- Use return values (Result types, None) for expected failures
- Don't use exceptions for control flow

---

## Code Organization

### File Structure
- One concept per file
- Related code grouped together
- Clear module boundaries
- Imports organized (stdlib, third-party, local)

### Dependency Direction
- High-level modules shouldn't depend on low-level details
- Depend on abstractions, not concretions
- Avoid circular dependencies

### Comments
- Explain why, not what
- Don't comment bad code, rewrite it
- Keep comments updated or delete them
- Use docstrings for public APIs

```python
# BAD - explains what (obvious from code)
# Increment counter by 1
counter += 1

# GOOD - explains why
# Rate limit requires 100ms between requests per API docs
await asyncio.sleep(0.1)
```

---

## Common Anti-Patterns

### God Objects
Classes that do too much. Split by responsibility.

### Deep Nesting
More than 3 levels of nesting. Use early returns, extract functions.

```python
# BAD
def process(items):
    if items:
        for item in items:
            if item.is_valid:
                if item.type == 'A':
                    # deep logic here

# GOOD
def process(items):
    if not items:
        return
    for item in items:
        process_item(item)

def process_item(item):
    if not item.is_valid:
        return
    if item.type == 'A':
        # logic here
```

### Magic Numbers/Strings
Use named constants for non-obvious values.

```python
# BAD
if response.status == 429:
    time.sleep(60)

# GOOD
RATE_LIMIT_STATUS = 429
RATE_LIMIT_WAIT_SECONDS = 60

if response.status == RATE_LIMIT_STATUS:
    time.sleep(RATE_LIMIT_WAIT_SECONDS)
```

### Copy-Paste Code
If you copy code, you'll need to fix bugs in multiple places. Extract shared logic.

### Premature Optimization
Write clear code first. Optimize only when needed, with measurements.

### Boolean Parameters
Confusing at call sites. Use enums or separate functions.

```python
# BAD - what does True mean?
send_email(user, True)

# GOOD
send_email(user, include_attachment=True)
# or
send_email_with_attachment(user)
```
