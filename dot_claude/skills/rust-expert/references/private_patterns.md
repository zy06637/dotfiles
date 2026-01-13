# Common Rust Patterns

## Table of Contents
- [Ownership Patterns](#ownership-patterns)
- [Error Handling Patterns](#error-handling-patterns)
- [Design Patterns](#design-patterns)
- [Concurrency Patterns](#concurrency-patterns)
- [Testing Patterns](#testing-patterns)
- [Performance Patterns](#performance-patterns)

## Ownership Patterns

### RAII (Resource Acquisition Is Initialization)
```rust
struct TempFile {
    path: PathBuf,
}

impl TempFile {
    fn new(path: impl Into<PathBuf>) -> std::io::Result<Self> {
        let path = path.into();
        File::create(&path)?;
        Ok(Self { path })
    }
}

impl Drop for TempFile {
    fn drop(&mut self) {
        let _ = std::fs::remove_file(&self.path);
    }
}
```

### Interior Mutability
```rust
use std::cell::{Cell, RefCell};
use std::sync::{Mutex, RwLock};

// Single-threaded
struct Counter {
    count: Cell<u32>,        // Copy types
    history: RefCell<Vec<u32>>, // Non-Copy types
}

// Multi-threaded
struct SharedCounter {
    count: Mutex<u32>,
    cache: RwLock<HashMap<String, String>>,
}
```

### Cow (Clone on Write)
```rust
use std::borrow::Cow;

fn process_name(name: Cow<'_, str>) -> Cow<'_, str> {
    if name.contains(' ') {
        Cow::Owned(name.replace(' ', "_"))
    } else {
        name  // No allocation if no modification needed
    }
}
```

## Error Handling Patterns

### Custom Error Types
```rust
use thiserror::Error;

#[derive(Debug, Error)]
pub enum ServiceError {
    #[error("Database error: {0}")]
    Database(#[from] sqlx::Error),

    #[error("Validation failed: {field} - {message}")]
    Validation { field: String, message: String },

    #[error("Resource not found: {0}")]
    NotFound(String),

    #[error(transparent)]
    Other(#[from] anyhow::Error),
}

impl ServiceError {
    pub fn validation(field: impl Into<String>, msg: impl Into<String>) -> Self {
        Self::Validation {
            field: field.into(),
            message: msg.into(),
        }
    }
}
```

### Result Extension Trait
```rust
pub trait ResultExt<T> {
    fn context_with<F, S>(self, f: F) -> anyhow::Result<T>
    where
        F: FnOnce() -> S,
        S: Into<String>;
}

impl<T, E: std::error::Error + Send + Sync + 'static> ResultExt<T> for Result<T, E> {
    fn context_with<F, S>(self, f: F) -> anyhow::Result<T>
    where
        F: FnOnce() -> S,
        S: Into<String>,
    {
        self.map_err(|e| anyhow::anyhow!(e).context(f().into()))
    }
}
```

## Design Patterns

### Builder Pattern
```rust
#[derive(Default)]
pub struct RequestBuilder {
    url: Option<String>,
    method: Method,
    headers: HashMap<String, String>,
    timeout: Option<Duration>,
}

impl RequestBuilder {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn url(mut self, url: impl Into<String>) -> Self {
        self.url = Some(url.into());
        self
    }

    pub fn header(mut self, key: impl Into<String>, value: impl Into<String>) -> Self {
        self.headers.insert(key.into(), value.into());
        self
    }

    pub fn timeout(mut self, duration: Duration) -> Self {
        self.timeout = Some(duration);
        self
    }

    pub fn build(self) -> Result<Request, BuildError> {
        let url = self.url.ok_or(BuildError::MissingUrl)?;
        Ok(Request {
            url,
            method: self.method,
            headers: self.headers,
            timeout: self.timeout.unwrap_or(Duration::from_secs(30)),
        })
    }
}
```

### Newtype Pattern
```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct UserId(pub u64);

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct OrderId(pub u64);

impl UserId {
    pub fn new(id: u64) -> Self {
        Self(id)
    }

    pub fn as_u64(&self) -> u64 {
        self.0
    }
}

// Serde support
impl<'de> Deserialize<'de> for UserId {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        u64::deserialize(deserializer).map(UserId)
    }
}
```

### State Machine Pattern
```rust
pub struct Draft;
pub struct Published;
pub struct Archived;

pub struct Article<State> {
    content: String,
    _state: PhantomData<State>,
}

impl Article<Draft> {
    pub fn new(content: String) -> Self {
        Self { content, _state: PhantomData }
    }

    pub fn publish(self) -> Article<Published> {
        Article { content: self.content, _state: PhantomData }
    }
}

impl Article<Published> {
    pub fn archive(self) -> Article<Archived> {
        Article { content: self.content, _state: PhantomData }
    }
}
```

### Type State Pattern for Validation
```rust
pub struct Unvalidated;
pub struct Validated;

pub struct Email<State = Unvalidated> {
    value: String,
    _state: PhantomData<State>,
}

impl Email<Unvalidated> {
    pub fn new(value: String) -> Self {
        Self { value, _state: PhantomData }
    }

    pub fn validate(self) -> Result<Email<Validated>, ValidationError> {
        if self.value.contains('@') && self.value.contains('.') {
            Ok(Email { value: self.value, _state: PhantomData })
        } else {
            Err(ValidationError::InvalidEmail)
        }
    }
}

impl Email<Validated> {
    pub fn as_str(&self) -> &str {
        &self.value
    }
}
```

## Concurrency Patterns

### Actor Pattern with Channels
```rust
use tokio::sync::mpsc;

enum Message {
    Increment,
    Get(oneshot::Sender<u64>),
    Stop,
}

struct CounterActor {
    receiver: mpsc::Receiver<Message>,
    count: u64,
}

impl CounterActor {
    fn new(receiver: mpsc::Receiver<Message>) -> Self {
        Self { receiver, count: 0 }
    }

    async fn run(&mut self) {
        while let Some(msg) = self.receiver.recv().await {
            match msg {
                Message::Increment => self.count += 1,
                Message::Get(reply) => { let _ = reply.send(self.count); }
                Message::Stop => break,
            }
        }
    }
}

#[derive(Clone)]
struct CounterHandle {
    sender: mpsc::Sender<Message>,
}

impl CounterHandle {
    pub fn new() -> Self {
        let (sender, receiver) = mpsc::channel(32);
        let mut actor = CounterActor::new(receiver);
        tokio::spawn(async move { actor.run().await });
        Self { sender }
    }

    pub async fn increment(&self) {
        let _ = self.sender.send(Message::Increment).await;
    }
}
```

### Parallel Processing with Rayon
```rust
use rayon::prelude::*;

fn process_items(items: Vec<Item>) -> Vec<Result> {
    items
        .par_iter()
        .map(|item| expensive_computation(item))
        .collect()
}

// With progress reporting
fn process_with_progress(items: Vec<Item>) -> Vec<Result> {
    let total = items.len();
    let processed = AtomicUsize::new(0);

    items
        .par_iter()
        .map(|item| {
            let result = expensive_computation(item);
            let count = processed.fetch_add(1, Ordering::Relaxed);
            if count % 100 == 0 {
                println!("Progress: {}/{}", count, total);
            }
            result
        })
        .collect()
}
```

## Testing Patterns

### Test Fixtures with rstest
```rust
use rstest::{rstest, fixture};

#[fixture]
fn database() -> TestDatabase {
    TestDatabase::new()
}

#[fixture]
fn user(database: TestDatabase) -> User {
    database.create_user("test@example.com")
}

#[rstest]
fn test_user_creation(user: User) {
    assert_eq!(user.email, "test@example.com");
}

#[rstest]
#[case("hello", "HELLO")]
#[case("world", "WORLD")]
fn test_uppercase(#[case] input: &str, #[case] expected: &str) {
    assert_eq!(input.to_uppercase(), expected);
}
```

### Property-Based Testing
```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn test_parse_roundtrip(s in "[a-z]{1,10}") {
        let parsed: MyType = s.parse().unwrap();
        assert_eq!(parsed.to_string(), s);
    }

    #[test]
    fn test_addition_commutative(a in 0i32..1000, b in 0i32..1000) {
        assert_eq!(a + b, b + a);
    }
}
```

## Performance Patterns

### Lazy Initialization
```rust
use once_cell::sync::Lazy;
use std::sync::OnceLock;

// Global static
static CONFIG: Lazy<Config> = Lazy::new(|| {
    Config::from_env().expect("Failed to load config")
});

// Per-instance lazy field (std library)
struct Service {
    client: OnceLock<Client>,
}

impl Service {
    fn client(&self) -> &Client {
        self.client.get_or_init(|| Client::new())
    }
}
```

### String Interning
```rust
use std::collections::HashSet;
use std::sync::RwLock;

static INTERNED: Lazy<RwLock<HashSet<&'static str>>> =
    Lazy::new(|| RwLock::new(HashSet::new()));

fn intern(s: String) -> &'static str {
    let read = INTERNED.read().unwrap();
    if let Some(&interned) = read.get(s.as_str()) {
        return interned;
    }
    drop(read);

    let mut write = INTERNED.write().unwrap();
    let leaked: &'static str = Box::leak(s.into_boxed_str());
    write.insert(leaked);
    leaked
}
```

### SmallVec for Stack Allocation
```rust
use smallvec::SmallVec;

// Store up to 8 elements on stack, heap-allocate beyond that
type Tags = SmallVec<[String; 8]>;

fn process_tags(tags: Tags) {
    // Most cases: no heap allocation
    for tag in tags {
        println!("{}", tag);
    }
}
```
