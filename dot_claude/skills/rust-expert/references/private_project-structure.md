# Rust Project Structure Templates

## Table of Contents
- [Binary Application](#binary-application)
- [Library Crate](#library-crate)
- [Workspace (Monorepo)](#workspace-monorepo)
- [Web API Service](#web-api-service)
- [CLI Application](#cli-application)

## Binary Application

Basic binary with atomic architecture:

```
my-app/
├── Cargo.toml
├── src/
│   ├── main.rs              # L1 Entry
│   ├── lib.rs               # Re-exports for integration tests
│   ├── coordinator/         # L2 Coordination
│   │   ├── mod.rs
│   │   └── app.rs           # Main application coordinator
│   ├── molecules/           # L3 Molecular
│   │   ├── mod.rs
│   │   ├── user_flow.rs
│   │   └── data_pipeline.rs
│   └── atoms/               # L4 Atomic
│       ├── mod.rs
│       ├── validators.rs
│       ├── transforms.rs
│       └── formatters.rs
├── tests/
│   └── integration_test.rs
└── benches/
    └── benchmark.rs
```

### Cargo.toml Template
```toml
[package]
name = "my-app"
version = "0.1.0"
edition = "2021"
rust-version = "1.75"

[dependencies]
anyhow = "1.0"
thiserror = "1.0"
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter"] }
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1.0", features = ["full"] }

[dev-dependencies]
rstest = "0.18"
criterion = "0.5"

[[bench]]
name = "benchmark"
harness = false

[profile.release]
lto = true
codegen-units = 1
```

### main.rs Template
```rust
use anyhow::Result;
use tracing_subscriber::EnvFilter;

mod coordinator;
mod molecules;
mod atoms;

fn main() -> Result<()> {
    // Initialize logging
    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    // Parse args, load config
    let config = coordinator::Config::from_env()?;

    // Run application
    coordinator::run(config)
}
```

## Library Crate

```
my-lib/
├── Cargo.toml
├── src/
│   ├── lib.rs               # Public API, re-exports
│   ├── error.rs             # Error types (public)
│   ├── types.rs             # Core types (public)
│   ├── molecules/           # L3 Molecular (internal)
│   │   ├── mod.rs
│   │   └── processor.rs
│   └── atoms/               # L4 Atomic (internal)
│       ├── mod.rs
│       └── utils.rs
├── examples/
│   └── basic.rs
└── tests/
    └── api_test.rs
```

### lib.rs Template
```rust
//! My library description.
//!
//! # Example
//! ```
//! use my_lib::Client;
//! let client = Client::new();
//! ```

mod atoms;
mod molecules;

mod error;
mod types;

pub use error::{Error, Result};
pub use types::{Config, Client};

// Re-export commonly used items
pub mod prelude {
    pub use crate::{Client, Config, Error, Result};
}
```

## Workspace (Monorepo)

```
my-workspace/
├── Cargo.toml               # Workspace root
├── crates/
│   ├── core/                # Shared core library
│   │   ├── Cargo.toml
│   │   └── src/
│   │       └── lib.rs
│   ├── api/                 # API server binary
│   │   ├── Cargo.toml
│   │   └── src/
│   │       └── main.rs
│   ├── cli/                 # CLI binary
│   │   ├── Cargo.toml
│   │   └── src/
│   │       └── main.rs
│   └── common/              # Shared utilities
│       ├── Cargo.toml
│       └── src/
│           └── lib.rs
└── tests/
    └── e2e/                 # End-to-end tests
```

### Workspace Cargo.toml
```toml
[workspace]
resolver = "2"
members = ["crates/*"]

[workspace.package]
version = "0.1.0"
edition = "2021"
rust-version = "1.75"
license = "MIT"

[workspace.dependencies]
# Internal crates
core = { path = "crates/core" }
common = { path = "crates/common" }

# External dependencies (centralized versions)
anyhow = "1.0"
thiserror = "1.0"
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1.0", features = ["full"] }
tracing = "0.1"

[workspace.lints.rust]
unsafe_code = "forbid"

[workspace.lints.clippy]
all = "warn"
pedantic = "warn"
```

### Member Cargo.toml
```toml
[package]
name = "api"
version.workspace = true
edition.workspace = true

[dependencies]
core.workspace = true
common.workspace = true
anyhow.workspace = true
tokio.workspace = true

[lints]
workspace = true
```

## Web API Service

```
api-service/
├── Cargo.toml
├── src/
│   ├── main.rs              # L1 Entry: server setup
│   ├── lib.rs
│   ├── coordinator/         # L2 Coordination
│   │   ├── mod.rs
│   │   ├── routes.rs        # Route definitions
│   │   └── state.rs         # Shared state
│   ├── molecules/           # L3 Molecular: handlers
│   │   ├── mod.rs
│   │   ├── users.rs         # User handlers
│   │   └── orders.rs        # Order handlers
│   ├── atoms/               # L4 Atomic
│   │   ├── mod.rs
│   │   ├── db.rs            # Database operations
│   │   ├── auth.rs          # Authentication
│   │   └── validation.rs    # Input validation
│   └── error.rs             # API error types
├── migrations/
│   └── 001_initial.sql
└── tests/
    └── api_tests.rs
```

### Axum API main.rs
```rust
use anyhow::Result;
use axum::Router;
use tokio::net::TcpListener;
use tracing_subscriber::EnvFilter;

mod coordinator;
mod molecules;
mod atoms;
mod error;

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    let state = coordinator::AppState::new().await?;
    let app = coordinator::routes::create_router(state);

    let listener = TcpListener::bind("0.0.0.0:3000").await?;
    tracing::info!("Listening on {}", listener.local_addr()?);

    axum::serve(listener, app).await?;
    Ok(())
}
```

### API Dependencies
```toml
[dependencies]
axum = { version = "0.7", features = ["macros"] }
tokio = { version = "1.0", features = ["full"] }
tower = "0.4"
tower-http = { version = "0.5", features = ["cors", "trace"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
sqlx = { version = "0.7", features = ["runtime-tokio", "postgres"] }
anyhow = "1.0"
thiserror = "1.0"
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter"] }
```

## CLI Application

```
my-cli/
├── Cargo.toml
├── src/
│   ├── main.rs              # L1 Entry: clap setup
│   ├── lib.rs
│   ├── coordinator/         # L2 Coordination
│   │   ├── mod.rs
│   │   └── commands.rs      # Command dispatch
│   ├── molecules/           # L3 Molecular: command handlers
│   │   ├── mod.rs
│   │   ├── init.rs
│   │   ├── build.rs
│   │   └── deploy.rs
│   └── atoms/               # L4 Atomic
│       ├── mod.rs
│       ├── config.rs
│       ├── fs.rs
│       └── output.rs
└── tests/
    └── cli_tests.rs
```

### CLI main.rs with clap
```rust
use anyhow::Result;
use clap::{Parser, Subcommand};

mod coordinator;
mod molecules;
mod atoms;

#[derive(Parser)]
#[command(name = "mycli", version, about)]
struct Cli {
    /// Enable verbose output
    #[arg(short, long, global = true)]
    verbose: bool,

    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Initialize a new project
    Init {
        /// Project name
        name: String,
        /// Project template
        #[arg(short, long, default_value = "default")]
        template: String,
    },
    /// Build the project
    Build {
        /// Build in release mode
        #[arg(short, long)]
        release: bool,
    },
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    atoms::output::init_logging(cli.verbose);

    match cli.command {
        Commands::Init { name, template } => {
            molecules::init::run(&name, &template)
        }
        Commands::Build { release } => {
            molecules::build::run(release)
        }
    }
}
```

### CLI Dependencies
```toml
[dependencies]
clap = { version = "4.0", features = ["derive"] }
anyhow = "1.0"
thiserror = "1.0"
indicatif = "0.17"  # Progress bars
console = "0.15"    # Terminal colors
dialoguer = "0.11"  # Interactive prompts
```
