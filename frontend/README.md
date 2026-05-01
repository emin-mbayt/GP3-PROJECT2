# DOSE — Protocol Studio (Frontend)

Premium personalized supplement subscription platform. Users build a custom protocol stack from 20 science-backed supplements across four goal categories, then subscribe for monthly delivery.

**Tech:** React 19 + TypeScript + Vite + Context API

---

## Features

- **Protocol Studio**: Build a personalized supplement stack filtered by goal (Energy, Focus, Immunity, Longevity)
- **Starter Protocols**: One-click presets — The Executive, The Athlete, The Focalist
- **Metrics Panel**: Live coverage bars and cost tracker per protocol
- **My Stack**: Cart management with quantity controls and order summary
- **Subscription Checkout**: Customer details form with order confirmation
- **Shipment History**: Full order tracking with status badges
- **Demo Mode**: Falls back to sample supplement data if backend is unavailable

---

## Tech Stack

- **React 19** with **TypeScript**
- **Vite** — fast dev server and build
- **React Router DOM** — routing
- **Axios** — API client
- **Context API** — global state (cart + protocol builder)
- **CSS custom properties** — design system (no framework)

---

## Design System

Clinical Luxury aesthetic. Dark background with Cormorant Garamond display type, Space Mono labels, DM Sans body. Accent palette: cyan (`#00E5CC`) + gold (`#C9A84C`).

Category colors: Energy `#F59E0B` · Focus `#00E5CC` · Immunity `#10B981` · Longevity `#8B5CF6`

---

## Project Structure

```
frontend/
├── src/
│   ├── components/
│   │   ├── BurgerBuilder/    # Protocol Studio — GoalFilter, BurgerPreview, MetricsPanel, StarterProtocols
│   │   ├── Cart/             # My Stack — cart items and order summary sidebar
│   │   ├── Ingredients/      # SupplementCard and SupplementList
│   │   ├── Layout/           # Header and layout wrapper
│   │   └── OrderSummary/     # Checkout form and success state
│   ├── context/
│   │   ├── CartContext.tsx           # Cart state + localStorage persistence
│   │   └── BurgerBuilderContext.tsx  # Protocol builder state
│   ├── services/
│   │   └── api.ts            # API client
│   ├── types/
│   │   └── index.ts          # TypeScript interfaces
│   ├── utils/
│   │   └── sessionManager.ts
│   ├── App.tsx
│   └── index.css             # Design system variables + global styles
├── public/
├── package.json
├── tsconfig.json
└── vite.config.ts
```

---

## Getting Started

```bash
npm install
# Create .env with:
# VITE_API_BASE_URL=http://localhost:8080
npm run dev
# → http://localhost:5173
```

### Scripts

| Command | Action |
|---------|--------|
| `npm run dev` | Dev server on :5173 |
| `npm run build` | Production build → dist/ |
| `npm run lint` | ESLint |
| `npm test` | Vitest watch mode |
| `npm run test:coverage` | Coverage report |

---

## Testing

**Vitest** + **React Testing Library** — 53 tests.

| Suite | Tests |
|-------|-------|
| Session manager | 6 |
| CartContext | 11 |
| BurgerBuilderContext | 13 |
| GoalFilter | 4 |
| MetricsPanel | 4 |
| StarterProtocols | 2 |
| IngredientCard | 6 |
| API service | 7 |

```bash
npm test              # watch
npm run test:coverage # coverage report → coverage/
```

---

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/ingredients` | All supplements |
| GET | `/api/ingredients/{category}` | By category |
| POST | `/api/cart/items` | Add to cart |
| GET | `/api/cart/{sessionId}` | Get cart |
| DELETE | `/api/cart/items/{itemId}` | Remove item |
| POST | `/api/orders` | Create order |
| GET | `/api/orders/{orderId}` | Get order |
| GET | `/api/orders/history` | All orders |
