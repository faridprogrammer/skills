# Feature Structure (React + TypeScript)

## Folder Layout

```
src/
  features/
    orders/
      api/
        ordersApi.ts        # fetch calls + DTO→domain mappers
        queryKeys.ts        # ['orders'], ['orders', id]
      hooks/
        useOrder.ts         # useQuery wrapper
        useCreateOrder.ts   # useMutation wrapper
      components/
        OrderList.tsx
        OrderDetail.tsx
      types/
        order.ts            # domain types (pure TS)
        orderDto.ts         # wire shapes (DTOs)
      index.ts              # public API of the feature
    checkout/
      ...
  shared/
    components/             # truly shared UI (Button, Modal, Empty)
    hooks/                  # truly shared hooks
    api/
      client.ts             # thin fetch wrapper
      errors.ts             # ApiError, error parsing
  routes/
    router.tsx
  main.tsx
```

## Rules

1. One feature = one user-visible capability. Cross-feature imports go through the feature's `index.ts`, never deep paths.
2. `shared/` holds only code used by 3+ features — otherwise it stays in the feature.
3. `types/order.ts` (domain) imports nothing from `api/`, `hooks/`, or `components/`.
4. `orderDto.ts` mirrors the backend wire shape; mapping happens in `api/ordersApi.ts`.

## Example

```ts
// features/orders/types/order.ts — domain (pure, no imports from other layers)
export interface Order {
  id: string;
  total: number;
  currency: string;
}

export function isEmpty(order: Order): boolean {
  return order.total === 0;
}
```

```ts
// features/orders/types/orderDto.ts — wire shape
export interface OrderDto {
  id: string;
  total: number;
  currency: string;
}
```

```ts
// features/orders/api/ordersApi.ts — boundary: fetch + map
import { apiGet, apiPost } from '../../../shared/api/client';
import type { OrderDto } from '../types/orderDto';
import type { Order } from '../types/order';

const toOrder = (dto: OrderDto): Order => ({ ...dto });

export const ordersApi = {
  list: async (): Promise<Order[]> =>
    (await apiGet<OrderDto[]>('/api/orders')).map(toOrder),
  get: async (id: string): Promise<Order> =>
    toOrder(await apiGet<OrderDto>(`/api/orders/${id}`)),
  create: async (input: { customerId: string }): Promise<Order> =>
    toOrder(await apiPost<OrderDto>('/api/orders', input)),
};
```

```ts
// features/orders/api/queryKeys.ts
export const orderKeys = {
  all: ['orders'] as const,
  detail: (id: string) => ['orders', id] as const,
};
```

```tsx
// features/orders/components/OrderList.tsx — JSX only, no fetch
import { useOrders } from '../hooks/useOrders';

export function OrderList() {
  const { data, isLoading, isError } = useOrders();
  if (isLoading) return <p>Loading…</p>;
  if (isError) return <p>Could not load orders.</p>;
  if (!data?.length) return <p>No orders yet.</p>;
  return (
    <ul>{data.map((o) => <li key={o.id}>{o.id} — {o.total} {o.currency}</li>)}</ul>
  );
}
```

```ts
// features/orders/index.ts — public API
export { OrderList } from './components/OrderList';
export { useOrders } from './hooks/useOrders';
export type { Order } from './types/order';
```
