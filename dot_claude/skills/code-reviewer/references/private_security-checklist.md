# Security Review Checklist

## Table of Contents
- [Injection Vulnerabilities](#injection-vulnerabilities)
- [Authentication & Authorization](#authentication--authorization)
- [Data Exposure](#data-exposure)
- [Input Validation](#input-validation)
- [Cryptography](#cryptography)
- [Dependencies](#dependencies)

---

## Injection Vulnerabilities

### SQL Injection
- [ ] Parameterized queries or prepared statements used
- [ ] No string concatenation with user input in queries
- [ ] ORM used correctly (beware raw query methods)

```python
# BAD
query = f"SELECT * FROM users WHERE id = {user_id}"

# GOOD
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
```

### Command Injection
- [ ] No shell=True with user input
- [ ] Arguments passed as arrays, not strings
- [ ] User input not in system commands

```python
# BAD
os.system(f"convert {filename} output.png")

# GOOD
subprocess.run(["convert", filename, "output.png"], check=True)
```

### XSS (Cross-Site Scripting)
- [ ] User content HTML-escaped before rendering
- [ ] React/Vue/Angular auto-escaping not bypassed (dangerouslySetInnerHTML)
- [ ] CSP headers configured
- [ ] No eval() or innerHTML with user data

### Path Traversal
- [ ] User input not used directly in file paths
- [ ] Path normalized and validated against allowed directory
- [ ] No ".." sequences in user-provided paths

```python
# BAD
file_path = f"/uploads/{user_filename}"

# GOOD
safe_name = os.path.basename(user_filename)
file_path = os.path.join("/uploads", safe_name)
```

---

## Authentication & Authorization

### Authentication
- [ ] Passwords hashed with bcrypt/argon2/scrypt (not MD5/SHA1)
- [ ] Timing-safe comparison for secrets
- [ ] Rate limiting on login attempts
- [ ] Session tokens are random and unpredictable
- [ ] Sessions invalidated on logout

### Authorization
- [ ] Every endpoint checks authorization
- [ ] Object-level authorization (user can only access their data)
- [ ] No reliance on client-side authorization checks
- [ ] Principle of least privilege applied

```python
# BAD - only checks if logged in
@login_required
def view_document(doc_id):
    return Document.query.get(doc_id)

# GOOD - checks ownership
@login_required
def view_document(doc_id):
    doc = Document.query.get(doc_id)
    if doc.owner_id != current_user.id:
        abort(403)
    return doc
```

---

## Data Exposure

### Sensitive Data
- [ ] No secrets in code (API keys, passwords)
- [ ] Secrets loaded from environment/vault
- [ ] Sensitive fields excluded from logs
- [ ] PII not logged or exposed in errors
- [ ] .env and credential files in .gitignore

### API Responses
- [ ] Only necessary fields returned
- [ ] No internal IDs or debug info in production
- [ ] Error messages don't reveal system details

```python
# BAD
return {"user": user.__dict__, "error": str(exception)}

# GOOD
return {"user": {"id": user.id, "name": user.name}}
```

---

## Input Validation

### General
- [ ] All user input validated on server side
- [ ] Validation whitelist-based (allow known good)
- [ ] Type, length, format, and range checked
- [ ] Reject invalid input, don't try to sanitize

### File Uploads
- [ ] File type validated by content, not extension
- [ ] File size limits enforced
- [ ] Uploaded files stored outside webroot
- [ ] Filenames sanitized

---

## Cryptography

- [ ] TLS/HTTPS used for all connections
- [ ] Strong algorithms (AES-256, RSA-2048+, SHA-256+)
- [ ] No custom crypto implementations
- [ ] Random values from secure sources (secrets module, not random)
- [ ] IVs/nonces never reused

```python
# BAD
import random
token = ''.join(random.choices(string.ascii_letters, k=32))

# GOOD
import secrets
token = secrets.token_urlsafe(32)
```

---

## Dependencies

- [ ] Dependencies from trusted sources
- [ ] No known vulnerabilities (check with npm audit, pip-audit, etc.)
- [ ] Dependencies pinned to specific versions
- [ ] Minimal dependencies (reduce attack surface)
- [ ] Regular updates scheduled
