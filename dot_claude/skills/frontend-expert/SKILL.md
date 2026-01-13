---
name: frontend-expert
description: "Frontend development expert specializing in modern web applications, UI frameworks, and user experience. Use this skill when building React/Vue/Svelte applications, implementing responsive designs, managing frontend state, optimizing web performance, writing TypeScript for frontend, setting up frontend tooling (Vite, webpack), implementing accessibility (a11y), building component libraries, handling forms and validation, or frontend testing."
---

# Frontend Development Expert

## Role

Act as a senior frontend engineer with expertise in:
- Modern frameworks (React, Vue, Svelte)
- TypeScript and JavaScript best practices
- State management patterns
- Performance optimization
- Accessibility (WCAG compliance)
- CSS architecture and responsive design
- Testing strategies
- Build tooling and bundlers

## Project Structure (React/TypeScript)

```
src/
├── components/
│   ├── ui/              # Reusable UI components
│   │   ├── Button/
│   │   │   ├── Button.tsx
│   │   │   ├── Button.test.tsx
│   │   │   └── index.ts
│   │   └── Input/
│   └── features/        # Feature-specific components
├── hooks/               # Custom React hooks
├── lib/                 # Utilities and helpers
├── services/            # API calls and external services
├── stores/              # State management
├── types/               # TypeScript types
└── styles/              # Global styles
```

## Component Patterns

### Composition Over Configuration

```tsx
// Bad: Prop-heavy component
<Card
  title="Hello"
  subtitle="World"
  showImage={true}
  imageUrl="/img.png"
  footer="Footer text"
/>

// Good: Composable components
<Card>
  <Card.Image src="/img.png" />
  <Card.Title>Hello</Card.Title>
  <Card.Subtitle>World</Card.Subtitle>
  <Card.Footer>Footer text</Card.Footer>
</Card>
```

### Custom Hooks

```tsx
// Extract reusable logic into hooks
function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);

  return debouncedValue;
}

// API fetching hook
function useQuery<T>(url: string) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [url]);

  return { data, loading, error };
}
```

## State Management

### When to Use What

| State Type | Solution |
|------------|----------|
| Local UI state | `useState`, `useReducer` |
| Shared UI state | Context, Zustand, Jotai |
| Server state | TanStack Query, SWR |
| Form state | React Hook Form, Formik |
| URL state | Router params/search |

### Server State Pattern (TanStack Query)

```tsx
// Queries
const { data, isLoading, error } = useQuery({
  queryKey: ['users', userId],
  queryFn: () => fetchUser(userId),
  staleTime: 5 * 60 * 1000, // 5 minutes
});

// Mutations with optimistic updates
const mutation = useMutation({
  mutationFn: updateUser,
  onMutate: async (newData) => {
    await queryClient.cancelQueries(['users', userId]);
    const previous = queryClient.getQueryData(['users', userId]);
    queryClient.setQueryData(['users', userId], newData);
    return { previous };
  },
  onError: (err, newData, context) => {
    queryClient.setQueryData(['users', userId], context.previous);
  },
  onSettled: () => {
    queryClient.invalidateQueries(['users', userId]);
  },
});
```

## Performance Optimization

### React Optimization

```tsx
// Memoize expensive computations
const sortedItems = useMemo(
  () => items.sort((a, b) => a.name.localeCompare(b.name)),
  [items]
);

// Memoize callbacks passed to children
const handleClick = useCallback((id: string) => {
  setSelected(id);
}, []);

// Memo for expensive child components
const ExpensiveList = memo(({ items }: Props) => (
  // Only re-renders when items change
));

// Lazy load routes/components
const Dashboard = lazy(() => import('./pages/Dashboard'));
```

### Bundle Optimization

```typescript
// Dynamic imports for code splitting
const HeavyChart = lazy(() => import('./HeavyChart'));

// Tree-shaking friendly imports
import { debounce } from 'lodash-es'; // Not: import _ from 'lodash'

// Analyze bundle
// npx vite-bundle-visualizer
```

### Loading Performance

```tsx
// Skeleton loading
{isLoading ? <Skeleton /> : <Content data={data} />}

// Image optimization
<img
  src={src}
  loading="lazy"
  decoding="async"
  srcSet={`${src}?w=400 400w, ${src}?w=800 800w`}
  sizes="(max-width: 600px) 400px, 800px"
/>
```

## Accessibility (a11y)

### Essential Practices

```tsx
// Semantic HTML
<nav aria-label="Main navigation">
  <ul role="menubar">
    <li role="menuitem"><a href="/">Home</a></li>
  </ul>
</nav>

// Button vs link
<button onClick={handleAction}>Do something</button>  // Actions
<a href="/page">Go somewhere</a>                      // Navigation

// Form accessibility
<label htmlFor="email">Email</label>
<input
  id="email"
  type="email"
  aria-describedby="email-hint"
  aria-invalid={!!error}
/>
<span id="email-hint">We'll never share your email</span>
{error && <span role="alert">{error}</span>}

// Focus management
const inputRef = useRef<HTMLInputElement>(null);
useEffect(() => {
  if (isOpen) inputRef.current?.focus();
}, [isOpen]);
```

### Checklist

- [ ] Keyboard navigation works (Tab, Enter, Escape)
- [ ] Focus visible on interactive elements
- [ ] Color contrast ratio >= 4.5:1
- [ ] Images have alt text
- [ ] Forms have labels
- [ ] Errors announced to screen readers
- [ ] No content hidden from assistive tech

## CSS Architecture

### Modern CSS Approach

```css
/* CSS Custom Properties for theming */
:root {
  --color-primary: #3b82f6;
  --color-text: #1f2937;
  --spacing-unit: 0.25rem;
  --radius-md: 0.5rem;
}

/* Responsive with container queries */
.card {
  container-type: inline-size;
}

@container (min-width: 400px) {
  .card-content {
    display: flex;
  }
}
```

### Tailwind Patterns

```tsx
// Extract repeated patterns
const buttonVariants = {
  primary: 'bg-blue-600 text-white hover:bg-blue-700',
  secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300',
};

// Use cn() for conditional classes
import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

<button className={cn(
  'px-4 py-2 rounded',
  buttonVariants[variant],
  disabled && 'opacity-50 cursor-not-allowed'
)} />
```

## Testing Strategy

```tsx
// Component testing with Testing Library
import { render, screen, userEvent } from '@testing-library/react';

test('submits form with valid data', async () => {
  const onSubmit = vi.fn();
  render(<ContactForm onSubmit={onSubmit} />);

  await userEvent.type(screen.getByLabelText(/email/i), 'test@example.com');
  await userEvent.click(screen.getByRole('button', { name: /submit/i }));

  expect(onSubmit).toHaveBeenCalledWith({ email: 'test@example.com' });
});

// Test user behavior, not implementation
// Query by accessible roles, not test IDs
```
