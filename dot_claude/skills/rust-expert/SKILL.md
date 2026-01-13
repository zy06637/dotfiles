---
name: rust-expert
description: Professional Rust developer with expertise in systems programming, memory safety, and high-performance code. Use this skill when planning Rust projects, writing Rust code or applications, debugging Rust compilation errors, designing Rust project structure, implementing async/concurrent Rust code, working with Rust crates and Cargo, optimizing Rust performance, writing safe FFI code, implementing traits and generics, or handling memory management and lifetime issues.
---

# Rust Expert

Expert guidance for planning and developing Rust projects with emphasis on idiomatic code, memory safety, and performance.

## Project Planning Workflow

When planning a new Rust project:

1. **Define project scope** - Identify core functionality and boundaries
2. **Choose project type** - Binary (`--bin`) vs library (`--lib`) vs workspace
3. **Design module structure** - Follow atomic architecture principles (see below)
4. **Select dependencies** - Prefer well-maintained crates with minimal transitive deps
5. **Define error handling strategy** - Custom errors vs `anyhow`/`thiserror`
6. **Plan async strategy** - `tokio` vs `async-std` vs sync-only

### Atomic Architecture for Rust

Map the layered atomic architecture to Rust modules:

```
src/
├── main.rs           # L1 Entry: initialization, CLI parsing, orchestration
├── coordinator/      # L2 Coordination: orchestrates molecules, external APIs
│   └── mod.rs
├── molecules/        # L3 Molecular: composed business logic units
│   ├── mod.rs
│   └── user_flow.rs
└── atoms/            # L4 Atomic: single-responsibility pure functions/types
    ├── mod.rs
    ├── validators.rs
    └── transforms.rs
```

**Key constraints:**
- One-way dependency: `main → coordinator → molecules → atoms`
- Atoms: pure functions, no side effects, ≤80 LOC each
- Molecules: compose atoms, no inter-molecule dependencies
- Coordinator: orchestrates molecules, handles external I/O

## Code Development Guidelines

### Ownership & Borrowing

```rust
// Prefer borrowing over cloning
fn process(data: &str) -> Result<()>  // Good
fn process(data: String) -> Result<()>  // Only if ownership needed

// Use Cow for flexibility
fn process(data: Cow<'_, str>) -> String

// Lifetime elision - let compiler infer when possible
fn first_word(s: &str) -> &str  // Lifetimes elided
```

### Error Handling

```rust
// Define domain errors with thiserror
#[derive(Debug, thiserror::Error)]
pub enum AppError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Invalid input: {0}")]
    InvalidInput(String),
}

// Use anyhow for applications, thiserror for libraries
// Propagate with ? operator, avoid unwrap() in production
```

### Structs & Enums

```rust
// Builder pattern for complex construction
#[derive(Default)]
pub struct Config {
    pub timeout: Duration,
    pub retries: u32,
}

impl Config {
    pub fn timeout(mut self, t: Duration) -> Self {
        self.timeout = t;
        self
    }
}

// Newtype pattern for type safety
pub struct UserId(u64);
pub struct OrderId(u64);  // Can't accidentally mix these
```

### Traits & Generics

```rust
// Prefer trait bounds over concrete types
fn process<T: AsRef<str>>(input: T) -> Result<()>

// Use impl Trait for simpler signatures
fn make_iter() -> impl Iterator<Item = u32>

// Extension traits for adding methods to foreign types
trait StringExt {
    fn truncate_safe(&self, len: usize) -> &str;
}
```

### Async/Concurrent Code

```rust
// Prefer tokio for async runtime
#[tokio::main]
async fn main() -> Result<()>

// Use channels for communication
let (tx, rx) = tokio::sync::mpsc::channel(100);

// Prefer Arc<Mutex<T>> sparingly; channels often better
// Use RwLock when reads >> writes
```

## Quick Reference

| Task | Approach |
|------|----------|
| CLI parsing | `clap` with derive macros |
| Serialization | `serde` + `serde_json`/`toml` |
| HTTP client | `reqwest` (async) or `ureq` (sync) |
| HTTP server | `axum` or `actix-web` |
| Logging | `tracing` + `tracing-subscriber` |
| Testing | Built-in `#[test]`, `rstest` for fixtures |
| Benchmarking | `criterion` |
| Error handling | `thiserror` (lib) / `anyhow` (app) |

## Resources

For detailed patterns and examples:
- **[references/patterns.md](references/patterns.md)** - Common Rust idioms and patterns
- **[references/project-structure.md](references/project-structure.md)** - Project organization templates
