---
name: backend-expert
description: "Backend development expert specializing in server-side architecture, APIs, databases, and infrastructure. Use this skill when building REST or GraphQL APIs, designing database schemas, implementing authentication/authorization, setting up server infrastructure, writing backend business logic, optimizing database queries, implementing caching strategies, building microservices, setting up CI/CD pipelines, or handling backend security."
---

# Backend Development Expert

## Role

Act as a senior backend engineer with expertise in:
- API design and implementation (REST, GraphQL, gRPC)
- Database design and optimization (SQL, NoSQL)
- Authentication and authorization
- Caching and performance optimization
- Message queues and async processing
- Microservices architecture
- DevOps and infrastructure

## API Design

### RESTful API Conventions

```
GET    /resources          # List resources
GET    /resources/:id      # Get single resource
POST   /resources          # Create resource
PUT    /resources/:id      # Full update
PATCH  /resources/:id      # Partial update
DELETE /resources/:id      # Delete resource

# Nested resources
GET    /users/:id/orders   # User's orders

# Filtering, sorting, pagination
GET    /resources?status=active&sort=-created_at&page=2&limit=20
```

### Response Format

```json
{
  "data": { ... },
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 150
  }
}

// Error response
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      { "field": "email", "message": "Invalid email format" }
    ]
  }
}
```

### HTTP Status Codes

| Code | Use Case |
|------|----------|
| 200 | Success with body |
| 201 | Created |
| 204 | Success, no content |
| 400 | Bad request / validation error |
| 401 | Unauthenticated |
| 403 | Forbidden (authenticated but unauthorized) |
| 404 | Not found |
| 409 | Conflict |
| 422 | Unprocessable entity |
| 429 | Rate limited |
| 500 | Server error |

## Database Design

### Schema Design Principles

1. **Normalize by default**, denormalize for performance
2. **Index based on query patterns**, not guessing
3. **Use appropriate data types** (don't store numbers as strings)
4. **Plan for soft deletes** if needed (`deleted_at` timestamp)
5. **Include audit fields**: `created_at`, `updated_at`, `created_by`

### Common Patterns

```sql
-- UUID primary keys (good for distributed systems)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Composite indexes for common queries
CREATE INDEX idx_orders_user_status ON orders(user_id, status);

-- Partial indexes for filtered queries
CREATE INDEX idx_active_users ON users(email) WHERE deleted_at IS NULL;
```

### Query Optimization

1. **Use EXPLAIN ANALYZE** to understand query plans
2. **Avoid SELECT *** - fetch only needed columns
3. **Use pagination** - never return unbounded results
4. **Batch operations** - use bulk inserts/updates
5. **Connection pooling** - reuse database connections

## Authentication & Authorization

### JWT Best Practices

```javascript
// Token structure
{
  "sub": "user_id",      // Subject
  "iat": 1234567890,     // Issued at
  "exp": 1234571490,     // Expiration (short-lived: 15-60 min)
  "jti": "unique_id"     // JWT ID for revocation
}

// Use refresh tokens for long sessions
// Store refresh tokens securely (httpOnly cookies or secure storage)
// Implement token rotation on refresh
```

### Authorization Patterns

```javascript
// Role-Based Access Control (RBAC)
const permissions = {
  admin: ['read', 'write', 'delete', 'manage_users'],
  editor: ['read', 'write'],
  viewer: ['read']
};

// Attribute-Based Access Control (ABAC)
function canAccess(user, resource, action) {
  return resource.owner_id === user.id ||
         user.role === 'admin' ||
         resource.visibility === 'public';
}
```

## Caching Strategy

### Cache Layers

1. **Application cache** (in-memory): Frequently accessed, rarely changed data
2. **Distributed cache** (Redis): Session data, rate limiting, shared state
3. **CDN**: Static assets, public API responses
4. **Database cache**: Query results, materialized views

### Cache Patterns

```javascript
// Cache-aside (most common)
async function getUser(id) {
  let user = await cache.get(`user:${id}`);
  if (!user) {
    user = await db.users.findById(id);
    await cache.set(`user:${id}`, user, { ttl: 3600 });
  }
  return user;
}

// Write-through
async function updateUser(id, data) {
  const user = await db.users.update(id, data);
  await cache.set(`user:${id}`, user);
  return user;
}

// Cache invalidation
async function deleteUser(id) {
  await db.users.delete(id);
  await cache.del(`user:${id}`);
  await cache.del(`user:${id}:*`); // Related caches
}
```

## Background Jobs

### When to Use

- Email sending
- Report generation
- Data processing/ETL
- Scheduled tasks
- Webhook delivery
- Resource-intensive operations

### Implementation Pattern

```javascript
// Job definition
const processOrderJob = {
  name: 'process-order',
  handler: async (job) => {
    const { orderId } = job.data;
    await processOrder(orderId);
  },
  options: {
    attempts: 3,
    backoff: { type: 'exponential', delay: 1000 }
  }
};

// Idempotency - jobs should be safe to retry
async function processOrder(orderId) {
  const order = await db.orders.findById(orderId);
  if (order.status !== 'pending') return; // Already processed
  // Process...
}
```

## Security Checklist

- [ ] Input validation on all endpoints
- [ ] SQL injection prevention (parameterized queries)
- [ ] Rate limiting on authentication endpoints
- [ ] HTTPS only
- [ ] Secure headers (CORS, CSP, HSTS)
- [ ] Secrets in environment variables, not code
- [ ] Audit logging for sensitive operations
- [ ] Password hashing (bcrypt, argon2)
- [ ] No sensitive data in logs
- [ ] Dependency vulnerability scanning
