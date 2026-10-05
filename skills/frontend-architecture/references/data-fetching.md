# Data Fetching (fetch + React Query)

## Thin fetch Wrapper (`shared/api/client.ts`)

One wrapper for the whole app — no axios, no per-feature fetch logic.

```ts
export class ApiError extends Error {
  constructor(public status: number, public body: unknown) {
    super(`Request failed with status ${status}`);
  }
}

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const token = localStorage.getItem('auth.token');
  const res = await fetch(path, {
    ...init,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...init?.headers,
    },
  });
  if (!res.ok) {
    const body = await res.json().catch(() => null);
    throw new ApiError(res.status, body);
  }
  if (res.status === 204) return undefined as T;
  return (await res.json()) as T;
}

export const apiGet = <T>(path: string) => request<T>(path);
export const apiPost = <T>(path: string, body: unknown) =>
  request<T>(path, { method: 'POST', body: JSON.stringify(body) });
export const apiPut = <T>(path: string, body: unknown) =>
  request<T>(path, { method: 'PUT', body: JSON.stringify(body) });
export const apiDelete = (path: string) =>
  request<void>(path, { method: 'DELETE' });
```

## Queries and Mutations (per Feature)

```tsx
// features/orders/hooks/useOrders.ts
import { useQuery } from '@tanstack/react-query';
import { ordersApi } from '../api/ordersApi';
import { orderKeys } from '../api/queryKeys';

export function useOrders() {
  return useQuery({ queryKey: orderKeys.all, queryFn: ordersApi.list });
}
```

```tsx
// features/orders/hooks/useCreateOrder.ts
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { ordersApi } from '../api/ordersApi';
import { orderKeys } from '../api/queryKeys';

export function useCreateOrder() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ordersApi.create,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: orderKeys.all });
    },
  });
}
```

## Rules

1. `fetch` appears only in `shared/api/client.ts` and feature `api/*Api.ts` files.
2. Query keys live in `api/queryKeys.ts` per feature — never inline string arrays in hooks.
3. Every mutation invalidates or updates its queries in `onSuccess`; handle `onError` with a user-visible message.
4. Loading/error/empty states are handled in components for every query.
5. Optimistic updates are the exception, not the default — and must include rollback in `onError`.
6. Auth tokens and storage access live in `shared/api/` — never in components or domain files.
