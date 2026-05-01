# DOSE — Personalized Supplement Protocol App
**Date:** 2025-05-01  
**Team:** Terraformers, Group 3  
**Status:** Approved for implementation

---

## Concept

DOSE is a personalized supplement protocol subscription startup. Users browse a curated catalog of supplements, build their daily stack, name their protocol, and subscribe for monthly shipment. The app positions itself as a precision-health product — clinical, premium, data-driven.

**Tagline:** *"Your biology is unique. Your protocol shouldn't be generic."*

**Key differentiator from other groups:** Complete concept and visual identity change. No food, no restaurant. A fundable health-tech startup product built on the same infrastructure.

---

## Backend Changes (Minimal)

No schema changes. No API changes. No infrastructure changes.

**Only change:** reseed `data.sql` with supplement ingredients.

| Old category | New category | Example ingredients |
|---|---|---|
| buns | energy | Ashwagandha, Vitamin B12, CoQ10, Rhodiola |
| patties | focus | Lion's Mane, L-Theanine, Bacopa, Alpha-GPC |
| toppings | immunity | Vitamin C, Zinc, Elderberry, Vitamin D3 |
| sauces | longevity | NMN, Resveratrol, Omega-3, Magnesium |

All API endpoints, DB schema, session management, order lifecycle — untouched.

---

## Frontend Changes (Complete Overhaul)

### Terminology Mapping

| Old | New |
|---|---|
| Burger Builder | Protocol Builder |
| Ingredient | Supplement |
| Burger stack / preview | Protocol Stack |
| Add to Cart | Add to Protocol |
| Cart | My Stack |
| Place Order | Subscribe & Ship |
| Order History | My Shipments |
| Category: buns/patties/toppings/sauces | energy/focus/immunity/longevity |

### Design System

**Aesthetic:** Clinical Luxury — Aesop meets Bloomberg Terminal  
**DFII Score:** 14/15

**Colors (CSS variables):**
```css
--bg-primary:   #08080F
--bg-surface:   #111118
--bg-elevated:  #1A1A24
--accent-cyan:  #00E5CC
--accent-gold:  #C9A84C
--text-primary: #F0F0F5
--text-muted:   #6B6B80
--border:       rgba(255,255,255,0.06)
--energy:       #F59E0B
--focus:        #00E5CC
--immunity:     #10B981
--longevity:    #8B5CF6
```

**Typography:**
- Display: `Cormorant Garamond` (Google Fonts) — pharmaceutical gravitas
- Data/specs: `Space Mono` (Google Fonts) — mg counts, prices, metrics
- UI/Body: `DM Sans` (Google Fonts) — clean, modern

**Motion:**
- Page load: staggered fade-up entrance (CSS, no library)
- Capsule stack: animate on add/remove
- Cards: subtle cyan glow on hover
- Nothing decorative

---

## New Features

### 1. Starter Protocols (Presets)
Three one-click preset protocol loads on the builder page:
- **The Executive** — Ashwagandha + Lion's Mane + NMN + Omega-3
- **The Athlete** — CoQ10 + Rhodiola + Zinc + Vitamin D3
- **The Focalist** — L-Theanine + Bacopa + Alpha-GPC + Vitamin B12

Clicking a preset loads those supplements into the protocol stack instantly.

### 2. Protocol Naming
Input field on the Stack/Cart page: "Name your protocol" (e.g. "My Morning Stack"). Stored as cart item note or order note. Displayed on checkout and shipment history.

### 3. Live Metrics Panel
Shown on the right panel of the builder, updates in real-time as supplements are added:
- **Daily cost** (sum of selected supplements / 30 days)
- **Total mg** (sum of all ingredient quantities × unit mg)
- **Coverage bars** — 4 bars (Energy / Focus / Immunity / Longevity), fill based on how many supplements from each category are selected

### 4. Goal Filter
Horizontal pill filter on the supplement catalog: All · Energy · Focus · Immunity · Longevity. Filters the visible catalog. Maps to ingredient categories.

### 5. Capsule Stack Preview
CSS-rendered visual: selected supplements shown as stacked oval/pill shapes, color-coded by category. Animates when supplement is added (slides in from right). Replaces the emoji burger stack.

---

## Page Layouts

### Builder (`/`)
```
HEADER: DOSE wordmark | goal filter pills | [My Stack N]

TWO COLUMN:
LEFT 60% — Supplement Catalog
  - Goal filter (All / Energy / Focus / Immunity / Longevity)
  - Grid of SupplementCards
    Each card: Name · Benefit tag · Dose per serving · Price · [+ Add]

RIGHT 40% — Your Protocol
  - Preset protocol buttons (The Executive / The Athlete / The Focalist)
  - Capsule stack visual (animated CSS pills)
  - Coverage bars (Energy / Focus / Immunity / Longevity)
  - Daily cost + Total mg metrics
  - [Subscribe & Ship →] CTA
  - [Clear Protocol] link
```

### Stack / Cart (`/cart`)
```
- Protocol name input
- List of selected supplements with quantity controls
- Summary: subtotal, shipping (flat), total
- [Proceed to Checkout]
```

### Checkout (`/checkout`)
```
- Shipping Details form (name, email, phone, address)
- Protocol review panel
- [Confirm Subscription] button
- Success screen with order number
```

### Shipments (`/orders`)
```
- Filter by email
- Shipment cards: protocol name, order number, date, status, total
- Status badges: PENDING → CONFIRMED → PREPARING → READY → DELIVERED
```

---

## File Changes

### Modified files
- `frontend/src/index.css` — full design system variables
- `frontend/src/components/Layout/Header.tsx` + `Header.css`
- `frontend/src/components/BurgerBuilder/BurgerBuilder.tsx` + `.css`
- `frontend/src/components/BurgerBuilder/BurgerPreview.tsx` + `.css` → becomes `ProtocolStack`
- `frontend/src/components/Ingredients/IngredientList.tsx` + `.css` → `SupplementList`
- `frontend/src/components/Ingredients/IngredientCard.tsx` + `.css` → `SupplementCard`
- `frontend/src/components/Cart/Cart.tsx` + `.css`
- `frontend/src/components/Cart/CartItemCard.tsx` + `.css`
- `frontend/src/components/OrderSummary/OrderSummary.tsx` + `.css`
- `frontend/src/components/OrderHistory/OrderHistory.tsx` + `.css`
- `backend/src/main/resources/data.sql` — reseed with supplement data

### New files
- `frontend/src/components/BurgerBuilder/StarterProtocols.tsx`
- `frontend/src/components/BurgerBuilder/MetricsPanel.tsx`
- `frontend/src/components/BurgerBuilder/GoalFilter.tsx`

### Unchanged
- All context files (BurgerBuilderContext, CartContext)
- All service files (api.ts)
- All type definitions
- All backend Java files
- All Terraform/Ansible/CI files

---

## Self-Review

- No placeholders or TBDs
- Architecture consistent throughout
- Scope is focused — frontend redesign + data reseed only
- All requirements unambiguous
- Backend untouched — zero infra risk
