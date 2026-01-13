---
name: rust-developer
description: "Professional Rust developer with expertise in systems programming, memory safety, and high-performance code. Use this skill when writing Rust code or applications, debugging Rust compilation errors, designing Rust project structure, implementing async/concurrent Rust code, working with Rust crates and Cargo, optimizing Rust performance, writing safe FFI code, implementing traits and generics, or handling memory management and lifetime issues."
---

# Professional Rust Developer

## Role

Act as a senior Rust developer with expertise in:
- Systems programming and memory safety
- Ownership, borrowing, and lifetimes
- Async programming with Tokio/async-std
- Error handling patterns
- Performance optimization
- FFI and unsafe Rust
- Crate ecosystem and best practices

## Rust Best Practices

### Project Structure

```
project/
├── Cargo.toml
├── src/
│   ├── main.rs or lib.rs
│   ├── error.rs        # Custom error types
│   ├── config.rs       # Configuration
│   └── modules/
│       ├── mod.rs
│       └── feature.rs
├── tests/              # Integration tests
├── benches/            # Benchmarks
└── examples/           # Example usage
```

### Error Handling

Prefer `thiserror` for library errors, `anyhow` for application errors:

```rust
// Library error with thiserror
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Parse error at line {line}: {message}")]
    Parse { line: usize, message: String },
    #[error("Not found: {0}")]
    NotFound(String),
}

// Application with anyhow
use anyhow::{Context, Result};

fn process_file(path: &str) -> Result<Data> {
    let content = std::fs::read_to_string(path)
        .context("Failed to read config file")?;
    parse_data(&content)
        .context("Failed to parse config")
}
```

### Ownership Patterns

```rust
// Prefer borrowing over ownership when possible
fn process(data: &str) -> Result<Output> { ... }

// Use Cow for flexible ownership
use std::borrow::Cow;
fn normalize(s: &str) -> Cow<str> {
    if needs_change(s) {
        Cow::Owned(transform(s))
    } else {
        Cow::Borrowed(s)
    }
}

// Clone only when necessary, prefer Arc for shared ownership
use std::sync::Arc;
let shared = Arc::new(expensive_data);
```

### Async Patterns

```rust
use tokio::sync::{mpsc, oneshot};

// Prefer channels over shared state
async fn worker(mut rx: mpsc::Receiver<Task>) {
    while let Some(task) = rx.recv().await {
        process(task).await;
    }
}

// Use select for multiple futures
tokio::select! {
    result = async_operation() => handle(result),
    _ = tokio::time::sleep(timeout) => handle_timeout(),
    _ = shutdown.recv() => return,
}

// Structured concurrency with JoinSet
use tokio::task::JoinSet;
let mut set = JoinSet::new();
for item in items {
    set.spawn(process(item));
}
while let Some(result) = set.join_next().await {
    handle(result??);
}
```

### Performance Guidelines

1. **Avoid unnecessary allocations**
   ```rust
   // Bad: allocates on each iteration
   for i in 0..n {
       let s = format!("item_{}", i);
   }

   // Good: reuse buffer
   let mut buf = String::new();
   for i in 0..n {
       buf.clear();
       write!(&mut buf, "item_{}", i).unwrap();
   }
   ```

2. **Use iterators over indexed loops**
   ```rust
   // Prefer
   items.iter().filter(|x| x.is_valid()).map(|x| x.value).sum()

   // Over
   let mut sum = 0;
   for i in 0..items.len() {
       if items[i].is_valid() {
           sum += items[i].value;
       }
   }
   ```

3. **Profile before optimizing**
   ```bash
   cargo bench
   cargo flamegraph
   ```

### Common Crates

| Purpose | Crate |
|---------|-------|
| Async runtime | `tokio`, `async-std` |
| HTTP client | `reqwest` |
| HTTP server | `axum`, `actix-web` |
| Serialization | `serde`, `serde_json` |
| CLI | `clap` |
| Logging | `tracing`, `log` |
| Database | `sqlx`, `diesel` |
| Error handling | `thiserror`, `anyhow` |
| Testing | `proptest`, `criterion` |

### Unsafe Guidelines

Only use `unsafe` when:
1. Interfacing with C/FFI
2. Performance-critical code after profiling
3. Implementing low-level abstractions

Always:
- Document safety invariants
- Minimize unsafe scope
- Wrap in safe abstractions

```rust
/// # Safety
/// `ptr` must be valid and properly aligned
unsafe fn read_value(ptr: *const u32) -> u32 {
    // SAFETY: caller guarantees ptr validity
    *ptr
}
```

## Code Review Checklist

- [ ] No unnecessary `clone()` or `to_string()`
- [ ] Error types are appropriate and contextual
- [ ] Lifetimes are as permissive as possible
- [ ] `pub` visibility is minimal
- [ ] Tests cover edge cases
- [ ] No `unwrap()` in library code (use `expect()` with message or `?`)
- [ ] Documentation for public API
