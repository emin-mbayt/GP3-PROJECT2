# DOSE — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform the Burger Builder app into DOSE — a premium personalized supplement subscription startup with clinical-luxury aesthetic, zero backend structural changes.

**Architecture:** Complete frontend visual overhaul using new design system (CSS variables, Google Fonts). Three new components (GoalFilter, MetricsPanel, StarterProtocols). ProtocolStack replaces BurgerPreview. All existing contexts and services unchanged. Backend only gets data reseeded with supplement ingredients.

**Tech Stack:** React 19, TypeScript, CSS (no framework), Vitest + Testing Library, Spring Boot (backend data only)

---

## File Map

### New files
- `frontend/src/components/BurgerBuilder/GoalFilter.tsx`
- `frontend/src/components/BurgerBuilder/GoalFilter.css`
- `frontend/src/components/BurgerBuilder/GoalFilter.test.tsx`
- `frontend/src/components/BurgerBuilder/MetricsPanel.tsx`
- `frontend/src/components/BurgerBuilder/MetricsPanel.css`
- `frontend/src/components/BurgerBuilder/MetricsPanel.test.tsx`
- `frontend/src/components/BurgerBuilder/StarterProtocols.tsx`
- `frontend/src/components/BurgerBuilder/StarterProtocols.css`
- `frontend/src/components/BurgerBuilder/StarterProtocols.test.tsx`

### Modified files
- `frontend/src/index.css` — full design system
- `frontend/src/components/Layout/Header.tsx` — DOSE brand
- `frontend/src/components/Layout/Header.css` — dark header
- `frontend/src/components/BurgerBuilder/BurgerBuilder.tsx` — new layout, GoalFilter state
- `frontend/src/components/BurgerBuilder/BurgerBuilder.css` — new layout styles
- `frontend/src/components/BurgerBuilder/BurgerPreview.tsx` — becomes ProtocolStack
- `frontend/src/components/BurgerBuilder/BurgerPreview.css` — capsule styles
- `frontend/src/components/Ingredients/IngredientCard.tsx` — becomes SupplementCard
- `frontend/src/components/Ingredients/IngredientCard.css` — clinical card style
- `frontend/src/components/Ingredients/IngredientCard.test.tsx` — update for new categories
- `frontend/src/components/Ingredients/IngredientList.tsx` — becomes SupplementList
- `frontend/src/components/Ingredients/IngredientList.css` — updated grid
- `frontend/src/components/Cart/Cart.tsx` — DOSE branding + protocol name input
- `frontend/src/components/Cart/Cart.css` — dark cart
- `frontend/src/components/Cart/CartItemCard.tsx` — dark card style
- `frontend/src/components/Cart/CartItemCard.css`
- `frontend/src/components/OrderSummary/OrderSummary.tsx` — "Shipping Details" rename
- `frontend/src/components/OrderSummary/OrderSummary.css`
- `frontend/src/components/OrderHistory/OrderHistory.tsx` — "Shipments" rename
- `frontend/src/components/OrderHistory/OrderHistory.css`
- `backend/src/main/resources/data.sql` — supplement seed data (SQL Server)
- `backend/src/main/resources/data-postgresql.sql` — supplement seed data (PostgreSQL)

### Unchanged
- All context files, services, types, Terraform, Ansible, CI

---

## Task 1: Design System Foundation

**Files:**
- Modify: `frontend/src/index.css`

- [ ] **Step 1: Replace index.css entirely**

```css
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500;9..40,600&family=Space+Mono:wght@400;700&display=swap');

:root {
  --bg-primary:   #08080F;
  --bg-surface:   #111118;
  --bg-elevated:  #1A1A24;
  --accent-cyan:  #00E5CC;
  --accent-gold:  #C9A84C;
  --text-primary: #F0F0F5;
  --text-muted:   #6B6B80;
  --text-dim:     #3A3A50;
  --border:       rgba(255, 255, 255, 0.06);
  --border-glow:  rgba(0, 229, 204, 0.25);

  --energy:    #F59E0B;
  --focus:     #00E5CC;
  --immunity:  #10B981;
  --longevity: #8B5CF6;

  --font-display: 'Cormorant Garamond', serif;
  --font-mono:    'Space Mono', monospace;
  --font-body:    'DM Sans', sans-serif;

  --radius:    2px;
  --radius-md: 6px;
  --transition: 0.2s ease;
}

*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  background: var(--bg-primary);
  color: var(--text-primary);
  font-family: var(--font-body);
  font-size: 14px;
  line-height: 1.6;
  -webkit-font-smoothing: antialiased;
  min-height: 100vh;
}

a {
  color: inherit;
  text-decoration: none;
}

button {
  cursor: pointer;
  border: none;
  background: none;
  font-family: var(--font-body);
}

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(14px); }
  to   { opacity: 1; transform: translateY(0); }
}

@keyframes capsuleIn {
  from { opacity: 0; transform: translateX(16px) scale(0.92); }
  to   { opacity: 1; transform: translateX(0) scale(1); }
}

.fade-up {
  animation: fadeUp 0.45s ease both;
}

/* Stagger utility */
.fade-up:nth-child(1) { animation-delay: 0.05s; }
.fade-up:nth-child(2) { animation-delay: 0.10s; }
.fade-up:nth-child(3) { animation-delay: 0.15s; }
.fade-up:nth-child(4) { animation-delay: 0.20s; }
.fade-up:nth-child(5) { animation-delay: 0.25s; }
.fade-up:nth-child(6) { animation-delay: 0.30s; }

/* Scrollbar */
::-webkit-scrollbar { width: 4px; }
::-webkit-scrollbar-track { background: var(--bg-primary); }
::-webkit-scrollbar-thumb { background: var(--text-dim); border-radius: 2px; }
```

- [ ] **Step 2: Verify dev server renders dark background**

```bash
cd frontend && npm run dev
```
Open `http://localhost:5173` — background must be `#08080F`.

- [ ] **Step 3: Commit**

```bash
git add frontend/src/index.css
git commit -m "feat(dose): add clinical-luxury design system"
```

---

## Task 2: Backend Data Reseed

**Files:**
- Modify: `backend/src/main/resources/data.sql`
- Modify: `backend/src/main/resources/data-postgresql.sql`

- [ ] **Step 1: Replace data.sql (SQL Server)**

```sql
-- DOSE supplement data (SQL Server)
-- Clears existing burger data and inserts supplement catalog

DELETE FROM order_layers;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM burger_layers;
DELETE FROM cart_items;
DELETE FROM ingredients;

-- ENERGY
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Ashwagandha', 'energy', 0.89, 'Reduces cortisol, supports energy and stress resilience', NULL, 1, 1);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Vitamin B12', 'energy', 0.45, 'Essential for cellular energy production and nerve function', NULL, 1, 2);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('CoQ10', 'energy', 1.20, 'Mitochondrial energy support and antioxidant protection', NULL, 1, 3);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Rhodiola Rosea', 'energy', 0.95, 'Adaptogen for physical and mental stamina under stress', NULL, 1, 4);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Panax Ginseng', 'energy', 1.10, 'Traditional adaptogen for sustained vitality and recovery', NULL, 1, 5);

-- FOCUS
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Lion''s Mane', 'focus', 1.10, 'Stimulates NGF production for cognitive enhancement', NULL, 1, 1);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('L-Theanine', 'focus', 0.60, 'Alpha brainwave promotion for calm, focused attention', NULL, 1, 2);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Bacopa Monnieri', 'focus', 0.75, 'Memory consolidation and learning rate enhancement', NULL, 1, 3);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Alpha-GPC', 'focus', 1.35, 'Choline precursor for acetylcholine synthesis and recall', NULL, 1, 4);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Phosphatidylserine', 'focus', 0.90, 'Cell membrane support for executive function and memory', NULL, 1, 5);

-- IMMUNITY
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Vitamin C', 'immunity', 0.35, 'Antioxidant and immune cell function support', NULL, 1, 1);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Zinc Picolinate', 'immunity', 0.50, 'Immune response regulation and wound healing', NULL, 1, 2);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Elderberry Extract', 'immunity', 0.80, 'Antiviral properties and upper respiratory support', NULL, 1, 3);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Vitamin D3 + K2', 'immunity', 0.65, 'Immune modulation, bone health and cardiovascular support', NULL, 1, 4);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Quercetin', 'immunity', 0.85, 'Flavonoid anti-inflammatory and immune system modulator', NULL, 1, 5);

-- LONGEVITY
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('NMN', 'longevity', 2.50, 'NAD+ precursor for cellular energy and aging pathways', NULL, 1, 1);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Resveratrol', 'longevity', 1.80, 'Sirtuin activation and cellular senescence reduction', NULL, 1, 2);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Omega-3', 'longevity', 0.70, 'EPA/DHA for cardiovascular and neurological health', NULL, 1, 3);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Magnesium Glycinate', 'longevity', 0.55, 'Cofactor in 300+ enzymatic processes, sleep quality', NULL, 1, 4);
INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES ('Spermidine', 'longevity', 3.20, 'Autophagy induction for cellular renewal and longevity', NULL, 1, 5);
```

- [ ] **Step 2: Replace data-postgresql.sql**

```sql
-- DOSE supplement data (PostgreSQL)

DELETE FROM order_layers;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM burger_layers;
DELETE FROM cart_items;
DELETE FROM ingredients;

INSERT INTO ingredients (name, category, price, description, image_url, is_available, sort_order) VALUES
  -- ENERGY
  ('Ashwagandha',    'energy',    0.89, 'Reduces cortisol, supports energy and stress resilience',             NULL, true, 1),
  ('Vitamin B12',    'energy',    0.45, 'Essential for cellular energy production and nerve function',          NULL, true, 2),
  ('CoQ10',          'energy',    1.20, 'Mitochondrial energy support and antioxidant protection',              NULL, true, 3),
  ('Rhodiola Rosea', 'energy',    0.95, 'Adaptogen for physical and mental stamina under stress',               NULL, true, 4),
  ('Panax Ginseng',  'energy',    1.10, 'Traditional adaptogen for sustained vitality and recovery',            NULL, true, 5),
  -- FOCUS
  ('Lion''s Mane',        'focus', 1.10, 'Stimulates NGF production for cognitive enhancement',              NULL, true, 1),
  ('L-Theanine',          'focus', 0.60, 'Alpha brainwave promotion for calm, focused attention',             NULL, true, 2),
  ('Bacopa Monnieri',     'focus', 0.75, 'Memory consolidation and learning rate enhancement',                NULL, true, 3),
  ('Alpha-GPC',           'focus', 1.35, 'Choline precursor for acetylcholine synthesis and recall',          NULL, true, 4),
  ('Phosphatidylserine',  'focus', 0.90, 'Cell membrane support for executive function and memory',           NULL, true, 5),
  -- IMMUNITY
  ('Vitamin C',        'immunity', 0.35, 'Antioxidant and immune cell function support',                      NULL, true, 1),
  ('Zinc Picolinate',  'immunity', 0.50, 'Immune response regulation and wound healing',                      NULL, true, 2),
  ('Elderberry Extract','immunity',0.80, 'Antiviral properties and upper respiratory support',                 NULL, true, 3),
  ('Vitamin D3 + K2',  'immunity', 0.65, 'Immune modulation, bone health and cardiovascular support',         NULL, true, 4),
  ('Quercetin',        'immunity', 0.85, 'Flavonoid anti-inflammatory and immune system modulator',           NULL, true, 5),
  -- LONGEVITY
  ('NMN',               'longevity', 2.50, 'NAD+ precursor for cellular energy and aging pathways',           NULL, true, 1),
  ('Resveratrol',       'longevity', 1.80, 'Sirtuin activation and cellular senescence reduction',            NULL, true, 2),
  ('Omega-3',           'longevity', 0.70, 'EPA/DHA for cardiovascular and neurological health',              NULL, true, 3),
  ('Magnesium Glycinate','longevity',0.55, 'Cofactor in 300+ enzymatic processes, sleep quality',             NULL, true, 4),
  ('Spermidine',        'longevity', 3.20, 'Autophagy induction for cellular renewal and longevity',         NULL, true, 5);
```

- [ ] **Step 3: Verify local backend starts with supplement data**

```bash
cd backend && mvn spring-boot:run
curl http://localhost:8080/api/ingredients | python3 -m json.tool | head -40
```
Expected: JSON array with `"category": "energy"` and supplement names.

- [ ] **Step 4: Commit**

```bash
git add backend/src/main/resources/data.sql backend/src/main/resources/data-postgresql.sql
git commit -m "feat(dose): reseed ingredients with supplement catalog"
```

---

## Task 3: Header Redesign

**Files:**
- Modify: `frontend/src/components/Layout/Header.tsx`
- Modify: `frontend/src/components/Layout/Header.css`

- [ ] **Step 1: Replace Header.tsx**

```tsx
import { Link, useLocation } from 'react-router-dom';
import { useCart } from '../../context/CartContext';
import './Header.css';

export default function Header() {
  const { getTotalItems } = useCart();
  const { pathname } = useLocation();
  const totalItems = getTotalItems();

  return (
    <header className="header">
      <div className="header-inner">
        <Link to="/" className="header-logo">
          <span className="logo-mark">DOSE</span>
          <span className="logo-sub">Protocol Studio</span>
        </Link>

        <nav className="header-nav">
          <Link to="/" className={`nav-link ${pathname === '/' ? 'active' : ''}`}>
            Build
          </Link>
          <Link to="/orders" className={`nav-link ${pathname === '/orders' ? 'active' : ''}`}>
            Shipments
          </Link>
        </nav>

        <Link to="/cart" className="header-cart">
          <span className="cart-icon">◈</span>
          <span className="cart-label">My Stack</span>
          {totalItems > 0 && (
            <span className="cart-badge">{totalItems}</span>
          )}
        </Link>
      </div>
    </header>
  );
}
```

- [ ] **Step 2: Replace Header.css**

```css
.header {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgba(8, 8, 15, 0.92);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid var(--border);
}

.header-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 32px;
  height: 60px;
  display: flex;
  align-items: center;
  gap: 48px;
}

.header-logo {
  display: flex;
  flex-direction: column;
  line-height: 1;
  gap: 2px;
}

.logo-mark {
  font-family: var(--font-display);
  font-size: 22px;
  font-weight: 600;
  letter-spacing: 0.12em;
  color: var(--text-primary);
}

.logo-sub {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.2em;
  color: var(--text-muted);
  text-transform: uppercase;
}

.header-nav {
  display: flex;
  gap: 32px;
  margin-left: auto;
}

.nav-link {
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--text-muted);
  transition: color var(--transition);
}

.nav-link:hover,
.nav-link.active {
  color: var(--text-primary);
}

.nav-link.active {
  color: var(--accent-cyan);
}

.header-cart {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 7px 16px;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  color: var(--text-primary);
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  transition: border-color var(--transition), color var(--transition);
  position: relative;
}

.header-cart:hover {
  border-color: var(--accent-cyan);
  color: var(--accent-cyan);
}

.cart-icon {
  font-size: 14px;
  color: var(--accent-cyan);
}

.cart-badge {
  position: absolute;
  top: -6px;
  right: -6px;
  background: var(--accent-cyan);
  color: var(--bg-primary);
  font-size: 10px;
  font-weight: 700;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}
```

- [ ] **Step 3: Verify header renders**

```bash
cd frontend && npm run dev
```
Open `http://localhost:5173` — must show "DOSE" wordmark, dark header, mono nav links.

- [ ] **Step 4: Commit**

```bash
git add frontend/src/components/Layout/Header.tsx frontend/src/components/Layout/Header.css
git commit -m "feat(dose): redesign header with DOSE brand identity"
```

---

## Task 4: GoalFilter Component

**Files:**
- Create: `frontend/src/components/BurgerBuilder/GoalFilter.tsx`
- Create: `frontend/src/components/BurgerBuilder/GoalFilter.css`
- Create: `frontend/src/components/BurgerBuilder/GoalFilter.test.tsx`

- [ ] **Step 1: Write failing test**

```tsx
// frontend/src/components/BurgerBuilder/GoalFilter.test.tsx
import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import GoalFilter from './GoalFilter';

describe('GoalFilter', () => {
  const onSelect = vi.fn();

  it('renders all filter pills', () => {
    render(<GoalFilter selected="all" onSelect={onSelect} />);
    expect(screen.getByText('All')).toBeInTheDocument();
    expect(screen.getByText('Energy')).toBeInTheDocument();
    expect(screen.getByText('Focus')).toBeInTheDocument();
    expect(screen.getByText('Immunity')).toBeInTheDocument();
    expect(screen.getByText('Longevity')).toBeInTheDocument();
  });

  it('marks selected pill as active', () => {
    render(<GoalFilter selected="focus" onSelect={onSelect} />);
    const focusPill = screen.getByText('Focus').closest('button');
    expect(focusPill).toHaveClass('active');
  });

  it('calls onSelect with category when pill clicked', async () => {
    const user = userEvent.setup();
    render(<GoalFilter selected="all" onSelect={onSelect} />);
    await user.click(screen.getByText('Energy'));
    expect(onSelect).toHaveBeenCalledWith('energy');
  });

  it('calls onSelect with "all" when All pill clicked', async () => {
    const user = userEvent.setup();
    render(<GoalFilter selected="energy" onSelect={onSelect} />);
    await user.click(screen.getByText('All'));
    expect(onSelect).toHaveBeenCalledWith('all');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

```bash
cd frontend && npx vitest run src/components/BurgerBuilder/GoalFilter.test.tsx
```
Expected: FAIL — `Cannot find module './GoalFilter'`

- [ ] **Step 3: Create GoalFilter.tsx**

```tsx
// frontend/src/components/BurgerBuilder/GoalFilter.tsx
import './GoalFilter.css';

const GOALS = [
  { label: 'All',       value: 'all',       color: 'var(--text-muted)' },
  { label: 'Energy',    value: 'energy',    color: 'var(--energy)' },
  { label: 'Focus',     value: 'focus',     color: 'var(--focus)' },
  { label: 'Immunity',  value: 'immunity',  color: 'var(--immunity)' },
  { label: 'Longevity', value: 'longevity', color: 'var(--longevity)' },
];

interface GoalFilterProps {
  selected: string;
  onSelect: (value: string) => void;
}

export default function GoalFilter({ selected, onSelect }: GoalFilterProps) {
  return (
    <div className="goal-filter">
      {GOALS.map(({ label, value, color }) => (
        <button
          key={value}
          className={`goal-pill ${selected === value ? 'active' : ''}`}
          style={{ '--pill-color': color } as React.CSSProperties}
          onClick={() => onSelect(value)}
        >
          {label}
        </button>
      ))}
    </div>
  );
}
```

- [ ] **Step 4: Create GoalFilter.css**

```css
.goal-filter {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin-bottom: 24px;
}

.goal-pill {
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  padding: 6px 14px;
  border: 1px solid var(--border);
  border-radius: 20px;
  color: var(--text-muted);
  background: transparent;
  transition: all var(--transition);
}

.goal-pill:hover {
  border-color: var(--pill-color, var(--accent-cyan));
  color: var(--pill-color, var(--accent-cyan));
}

.goal-pill.active {
  border-color: var(--pill-color, var(--accent-cyan));
  color: var(--pill-color, var(--accent-cyan));
  background: rgba(0, 0, 0, 0.3);
}
```

- [ ] **Step 5: Run test to verify it passes**

```bash
cd frontend && npx vitest run src/components/BurgerBuilder/GoalFilter.test.tsx
```
Expected: PASS — all 4 tests green.

- [ ] **Step 6: Commit**

```bash
git add frontend/src/components/BurgerBuilder/GoalFilter.tsx \
        frontend/src/components/BurgerBuilder/GoalFilter.css \
        frontend/src/components/BurgerBuilder/GoalFilter.test.tsx
git commit -m "feat(dose): add GoalFilter component"
```

---

## Task 5: SupplementCard (replaces IngredientCard)

**Files:**
- Modify: `frontend/src/components/Ingredients/IngredientCard.tsx`
- Modify: `frontend/src/components/Ingredients/IngredientCard.css`
- Modify: `frontend/src/components/Ingredients/IngredientCard.test.tsx`

- [ ] **Step 1: Update test for new supplement categories**

Replace `frontend/src/components/Ingredients/IngredientCard.test.tsx`:

```tsx
import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import IngredientCard from './IngredientCard';
import type { Ingredient } from '../../types';

describe('SupplementCard (IngredientCard)', () => {
  const mockSupplement: Ingredient = {
    id: 1,
    name: "Lion's Mane",
    category: 'focus',
    price: 1.10,
    imageUrl: null,
  };

  const mockOnAdd = vi.fn();

  it('renders supplement name', () => {
    render(<IngredientCard ingredient={mockSupplement} onAdd={mockOnAdd} />);
    expect(screen.getByText("Lion's Mane")).toBeInTheDocument();
  });

  it('renders price with 2 decimal places', () => {
    render(<IngredientCard ingredient={mockSupplement} onAdd={mockOnAdd} />);
    expect(screen.getByText('$1.10 / serving')).toBeInTheDocument();
  });

  it('renders category badge', () => {
    render(<IngredientCard ingredient={mockSupplement} onAdd={mockOnAdd} />);
    expect(screen.getByText('focus')).toBeInTheDocument();
  });

  it('calls onAdd with ingredient id when add button clicked', async () => {
    const user = userEvent.setup();
    render(<IngredientCard ingredient={mockSupplement} onAdd={mockOnAdd} />);
    await user.click(screen.getByText('+'));
    expect(mockOnAdd).toHaveBeenCalledWith(mockSupplement.id);
    expect(mockOnAdd).toHaveBeenCalledTimes(1);
  });

  it('calls onAdd when card is clicked', async () => {
    const user = userEvent.setup();
    render(<IngredientCard ingredient={mockSupplement} onAdd={mockOnAdd} />);
    const card = screen.getByText("Lion's Mane").closest('.ingredient-card');
    await user.click(card!);
    expect(mockOnAdd).toHaveBeenCalledWith(mockSupplement.id);
  });

  it('formats whole number price correctly', () => {
    const wholePrice = { ...mockSupplement, price: 2 };
    render(<IngredientCard ingredient={wholePrice} onAdd={mockOnAdd} />);
    expect(screen.getByText('$2.00 / serving')).toBeInTheDocument();
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

```bash
cd frontend && npx vitest run src/components/Ingredients/IngredientCard.test.tsx
```
Expected: FAIL — price format is `$5.99` not `$5.99 / serving`, no category badge rendered.

- [ ] **Step 3: Replace IngredientCard.tsx**

```tsx
// frontend/src/components/Ingredients/IngredientCard.tsx
import type { Ingredient } from '../../types';
import './IngredientCard.css';

interface IngredientCardProps {
  ingredient: Ingredient;
  onAdd: (id: number) => void;
}

const CATEGORY_COLORS: Record<string, string> = {
  energy:    'var(--energy)',
  focus:     'var(--focus)',
  immunity:  'var(--immunity)',
  longevity: 'var(--longevity)',
};

export default function IngredientCard({ ingredient, onAdd }: IngredientCardProps) {
  const color = CATEGORY_COLORS[ingredient.category] ?? 'var(--accent-cyan)';

  return (
    <div
      className="ingredient-card"
      onClick={() => onAdd(ingredient.id)}
      style={{ '--card-accent': color } as React.CSSProperties}
    >
      <div className="card-header">
        <span className="card-category" style={{ color }}>{ingredient.category}</span>
        <button
          className="card-add"
          onClick={e => { e.stopPropagation(); onAdd(ingredient.id); }}
          aria-label={`Add ${ingredient.name}`}
        >
          +
        </button>
      </div>

      <div className="card-name">{ingredient.name}</div>

      {ingredient.description && (
        <div className="card-desc">{ingredient.description}</div>
      )}

      <div className="card-price">
        ${ingredient.price.toFixed(2)} / serving
      </div>
    </div>
  );
}
```

- [ ] **Step 4: Replace IngredientCard.css**

```css
.ingredient-card {
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 16px;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  gap: 8px;
  transition: border-color var(--transition), background var(--transition);
  position: relative;
}

.ingredient-card:hover {
  border-color: var(--card-accent, var(--accent-cyan));
  background: var(--bg-elevated);
}

.ingredient-card:hover::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: var(--radius-md);
  box-shadow: 0 0 20px -8px var(--card-accent, var(--accent-cyan));
  pointer-events: none;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.card-category {
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.card-add {
  width: 26px;
  height: 26px;
  border-radius: 50%;
  border: 1px solid var(--border);
  color: var(--text-primary);
  font-size: 16px;
  font-weight: 300;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all var(--transition);
  flex-shrink: 0;
}

.card-add:hover {
  border-color: var(--card-accent, var(--accent-cyan));
  color: var(--card-accent, var(--accent-cyan));
  background: rgba(0, 229, 204, 0.08);
}

.card-name {
  font-family: var(--font-display);
  font-size: 18px;
  font-weight: 400;
  color: var(--text-primary);
  line-height: 1.2;
}

.card-desc {
  font-size: 12px;
  color: var(--text-muted);
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-price {
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--accent-gold);
  margin-top: auto;
  padding-top: 4px;
}
```

- [ ] **Step 5: Run test to verify it passes**

```bash
cd frontend && npx vitest run src/components/Ingredients/IngredientCard.test.tsx
```
Expected: PASS — all 6 tests green.

- [ ] **Step 6: Commit**

```bash
git add frontend/src/components/Ingredients/IngredientCard.tsx \
        frontend/src/components/Ingredients/IngredientCard.css \
        frontend/src/components/Ingredients/IngredientCard.test.tsx
git commit -m "feat(dose): redesign IngredientCard as SupplementCard"
```

---

## Task 6: SupplementList (replaces IngredientList)

**Files:**
- Modify: `frontend/src/components/Ingredients/IngredientList.tsx`
- Modify: `frontend/src/components/Ingredients/IngredientList.css`

- [ ] **Step 1: Replace IngredientList.tsx**

```tsx
// frontend/src/components/Ingredients/IngredientList.tsx
import type { Ingredient } from '../../types';
import IngredientCard from './IngredientCard';
import './IngredientList.css';

interface IngredientListProps {
  ingredients: Ingredient[];
  selectedGoal: string;
  onAdd: (id: number) => void;
}

export default function IngredientList({ ingredients, selectedGoal, onAdd }: IngredientListProps) {
  const filtered = selectedGoal === 'all'
    ? ingredients
    : ingredients.filter(i => i.category === selectedGoal);

  if (filtered.length === 0) {
    return (
      <div className="supplement-empty">
        <span className="empty-label">No supplements found</span>
      </div>
    );
  }

  return (
    <div className="supplement-grid">
      {filtered.map((ingredient, index) => (
        <div key={ingredient.id} className="fade-up" style={{ animationDelay: `${index * 0.05}s` }}>
          <IngredientCard ingredient={ingredient} onAdd={onAdd} />
        </div>
      ))}
    </div>
  );
}
```

- [ ] **Step 2: Replace IngredientList.css**

```css
.supplement-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 12px;
}

.supplement-empty {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 200px;
}

.empty-label {
  font-family: var(--font-mono);
  font-size: 12px;
  letter-spacing: 0.1em;
  color: var(--text-dim);
  text-transform: uppercase;
}
```

- [ ] **Step 3: Commit**

```bash
git add frontend/src/components/Ingredients/IngredientList.tsx \
        frontend/src/components/Ingredients/IngredientList.css
git commit -m "feat(dose): update IngredientList to SupplementList with goal filtering"
```

---

## Task 7: ProtocolStack (replaces BurgerPreview)

**Files:**
- Modify: `frontend/src/components/BurgerBuilder/BurgerPreview.tsx`
- Modify: `frontend/src/components/BurgerBuilder/BurgerPreview.css`

- [ ] **Step 1: Replace BurgerPreview.tsx**

```tsx
// frontend/src/components/BurgerBuilder/BurgerPreview.tsx
import { useBurgerBuilder } from '../../context/BurgerBuilderContext';
import './BurgerPreview.css';

const CATEGORY_COLORS: Record<string, string> = {
  energy:    '#F59E0B',
  focus:     '#00E5CC',
  immunity:  '#10B981',
  longevity: '#8B5CF6',
};

export default function BurgerPreview() {
  const { layers, getIngredientById, removeLayer } = useBurgerBuilder();

  if (layers.length === 0) {
    return (
      <div className="protocol-empty">
        <div className="protocol-empty-icon">◎</div>
        <p className="protocol-empty-text">Add supplements to begin your protocol</p>
      </div>
    );
  }

  return (
    <div className="protocol-stack">
      {layers.map((layer, index) => {
        const ingredient = getIngredientById(layer.ingredientId);
        if (!ingredient) return null;
        const color = CATEGORY_COLORS[ingredient.category] ?? '#6B6B80';

        return (
          <div
            key={`${layer.ingredientId}-${index}`}
            className="capsule"
            style={{ '--capsule-color': color } as React.CSSProperties}
            onClick={() => removeLayer(index)}
            title="Click to remove"
          >
            <span className="capsule-dot" />
            <span className="capsule-name">{ingredient.name}</span>
            {layer.quantity > 1 && (
              <span className="capsule-qty">×{layer.quantity}</span>
            )}
            <span className="capsule-remove">×</span>
          </div>
        );
      })}
    </div>
  );
}
```

- [ ] **Step 2: Replace BurgerPreview.css**

```css
.protocol-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  min-height: 160px;
  border: 1px dashed var(--border);
  border-radius: var(--radius-md);
  padding: 32px;
}

.protocol-empty-icon {
  font-size: 28px;
  color: var(--text-dim);
}

.protocol-empty-text {
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.08em;
  color: var(--text-muted);
  text-align: center;
  line-height: 1.6;
}

.protocol-stack {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.capsule {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 14px;
  background: var(--bg-elevated);
  border: 1px solid rgba(255, 255, 255, 0.06);
  border-left: 3px solid var(--capsule-color, var(--accent-cyan));
  border-radius: var(--radius-md);
  cursor: pointer;
  animation: capsuleIn 0.25s ease both;
  transition: background var(--transition), border-color var(--transition);
}

.capsule:hover {
  background: rgba(239, 68, 68, 0.06);
  border-left-color: #EF4444;
}

.capsule:hover .capsule-remove {
  opacity: 1;
}

.capsule-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--capsule-color, var(--accent-cyan));
  flex-shrink: 0;
  box-shadow: 0 0 6px var(--capsule-color, var(--accent-cyan));
}

.capsule-name {
  font-family: var(--font-display);
  font-size: 16px;
  color: var(--text-primary);
  flex: 1;
}

.capsule-qty {
  font-family: var(--font-mono);
  font-size: 11px;
  color: var(--text-muted);
}

.capsule-remove {
  font-size: 14px;
  color: #EF4444;
  opacity: 0;
  transition: opacity var(--transition);
  font-weight: 300;
}
```

- [ ] **Step 3: Commit**

```bash
git add frontend/src/components/BurgerBuilder/BurgerPreview.tsx \
        frontend/src/components/BurgerBuilder/BurgerPreview.css
git commit -m "feat(dose): replace BurgerPreview with ProtocolStack capsule UI"
```

---

## Task 8: MetricsPanel

**Files:**
- Create: `frontend/src/components/BurgerBuilder/MetricsPanel.tsx`
- Create: `frontend/src/components/BurgerBuilder/MetricsPanel.css`
- Create: `frontend/src/components/BurgerBuilder/MetricsPanel.test.tsx`

- [ ] **Step 1: Write failing test**

```tsx
// frontend/src/components/BurgerBuilder/MetricsPanel.test.tsx
import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import MetricsPanel from './MetricsPanel';
import type { BurgerLayer, Ingredient } from '../../types';

const makeIngredient = (id: number, category: string, price: number): Ingredient => ({
  id, name: `Supplement ${id}`, category, price, imageUrl: null,
});

const makeLayer = (ingredientId: number, quantity = 1): BurgerLayer => ({
  ingredientId, quantity,
});

describe('MetricsPanel', () => {
  it('shows zero state when no layers', () => {
    render(<MetricsPanel layers={[]} ingredients={[]} totalPrice={0} />);
    expect(screen.getByText('$0.00')).toBeInTheDocument();
  });

  it('displays totalPrice correctly', () => {
    const ingredients = [makeIngredient(1, 'energy', 1.20)];
    const layers = [makeLayer(1)];
    render(<MetricsPanel layers={layers} ingredients={ingredients} totalPrice={1.20} />);
    expect(screen.getByText('$1.20')).toBeInTheDocument();
  });

  it('renders coverage bars for all four categories', () => {
    render(<MetricsPanel layers={[]} ingredients={[]} totalPrice={0} />);
    expect(screen.getByText('Energy')).toBeInTheDocument();
    expect(screen.getByText('Focus')).toBeInTheDocument();
    expect(screen.getByText('Immunity')).toBeInTheDocument();
    expect(screen.getByText('Longevity')).toBeInTheDocument();
  });

  it('shows supplement count', () => {
    const ingredients = [
      makeIngredient(1, 'energy', 0.89),
      makeIngredient(2, 'focus', 1.10),
    ];
    const layers = [makeLayer(1), makeLayer(2)];
    render(<MetricsPanel layers={layers} ingredients={ingredients} totalPrice={1.99} />);
    expect(screen.getByText('2')).toBeInTheDocument();
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

```bash
cd frontend && npx vitest run src/components/BurgerBuilder/MetricsPanel.test.tsx
```
Expected: FAIL — `Cannot find module './MetricsPanel'`

- [ ] **Step 3: Create MetricsPanel.tsx**

```tsx
// frontend/src/components/BurgerBuilder/MetricsPanel.tsx
import type { BurgerLayer, Ingredient } from '../../types';
import './MetricsPanel.css';

interface MetricsPanelProps {
  layers: BurgerLayer[];
  ingredients: Ingredient[];
  totalPrice: number;
}

const CATEGORIES = [
  { key: 'energy',    label: 'Energy',    color: 'var(--energy)' },
  { key: 'focus',     label: 'Focus',     color: 'var(--focus)' },
  { key: 'immunity',  label: 'Immunity',  color: 'var(--immunity)' },
  { key: 'longevity', label: 'Longevity', color: 'var(--longevity)' },
];

const MAX_PER_CATEGORY = 3;

export default function MetricsPanel({ layers, ingredients, totalPrice }: MetricsPanelProps) {
  const getCategory = (ingredientId: number) =>
    ingredients.find(i => i.id === ingredientId)?.category ?? '';

  const countByCategory = (cat: string) =>
    layers.filter(l => getCategory(l.ingredientId) === cat).length;

  return (
    <div className="metrics-panel">
      <div className="metrics-row">
        <div className="metric-block">
          <span className="metric-label">Protocol Cost</span>
          <span className="metric-value">${totalPrice.toFixed(2)}</span>
          <span className="metric-sub">per month</span>
        </div>
        <div className="metric-block">
          <span className="metric-label">Supplements</span>
          <span className="metric-value">{layers.length}</span>
          <span className="metric-sub">selected</span>
        </div>
      </div>

      <div className="coverage-section">
        <span className="coverage-label">Coverage</span>
        {CATEGORIES.map(({ key, label, color }) => {
          const count = countByCategory(key);
          const pct = Math.min((count / MAX_PER_CATEGORY) * 100, 100);
          return (
            <div key={key} className="coverage-row">
              <span className="coverage-cat">{label}</span>
              <div className="coverage-track">
                <div
                  className="coverage-fill"
                  style={{ width: `${pct}%`, background: color }}
                />
              </div>
              <span className="coverage-count" style={{ color }}>{count}</span>
            </div>
          );
        })}
      </div>
    </div>
  );
}
```

- [ ] **Step 4: Create MetricsPanel.css**

```css
.metrics-panel {
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.metrics-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1px;
  background: var(--border);
  border-radius: var(--radius);
  overflow: hidden;
}

.metric-block {
  background: var(--bg-elevated);
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.metric-label {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--text-muted);
}

.metric-value {
  font-family: var(--font-display);
  font-size: 28px;
  font-weight: 300;
  color: var(--accent-gold);
  line-height: 1;
}

.metric-sub {
  font-size: 11px;
  color: var(--text-dim);
}

.coverage-section {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.coverage-label {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--text-muted);
}

.coverage-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.coverage-cat {
  font-size: 12px;
  color: var(--text-muted);
  width: 68px;
  flex-shrink: 0;
}

.coverage-track {
  flex: 1;
  height: 3px;
  background: var(--bg-elevated);
  border-radius: 2px;
  overflow: hidden;
}

.coverage-fill {
  height: 100%;
  border-radius: 2px;
  transition: width 0.4s ease;
}

.coverage-count {
  font-family: var(--font-mono);
  font-size: 11px;
  width: 12px;
  text-align: right;
}
```

- [ ] **Step 5: Run test to verify it passes**

```bash
cd frontend && npx vitest run src/components/BurgerBuilder/MetricsPanel.test.tsx
```
Expected: PASS — all 4 tests green.

- [ ] **Step 6: Commit**

```bash
git add frontend/src/components/BurgerBuilder/MetricsPanel.tsx \
        frontend/src/components/BurgerBuilder/MetricsPanel.css \
        frontend/src/components/BurgerBuilder/MetricsPanel.test.tsx
git commit -m "feat(dose): add MetricsPanel with coverage bars"
```

---

## Task 9: StarterProtocols

**Files:**
- Create: `frontend/src/components/BurgerBuilder/StarterProtocols.tsx`
- Create: `frontend/src/components/BurgerBuilder/StarterProtocols.css`
- Create: `frontend/src/components/BurgerBuilder/StarterProtocols.test.tsx`

- [ ] **Step 1: Write failing test**

```tsx
// frontend/src/components/BurgerBuilder/StarterProtocols.test.tsx
import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import StarterProtocols from './StarterProtocols';
import type { Ingredient } from '../../types';

const mockIngredients: Ingredient[] = [
  { id: 1, name: 'Ashwagandha',  category: 'energy',    price: 0.89, imageUrl: null },
  { id: 2, name: "Lion's Mane",  category: 'focus',     price: 1.10, imageUrl: null },
  { id: 3, name: 'NMN',          category: 'longevity', price: 2.50, imageUrl: null },
  { id: 4, name: 'Omega-3',      category: 'longevity', price: 0.70, imageUrl: null },
];

describe('StarterProtocols', () => {
  it('renders three preset buttons', () => {
    const onLoad = vi.fn();
    render(<StarterProtocols ingredients={mockIngredients} onLoad={onLoad} />);
    expect(screen.getByText('The Executive')).toBeInTheDocument();
    expect(screen.getByText('The Athlete')).toBeInTheDocument();
    expect(screen.getByText('The Focalist')).toBeInTheDocument();
  });

  it('calls onLoad with matching ingredient ids when preset clicked', async () => {
    const user = userEvent.setup();
    const onLoad = vi.fn();
    render(<StarterProtocols ingredients={mockIngredients} onLoad={onLoad} />);
    await user.click(screen.getByText('The Executive'));
    expect(onLoad).toHaveBeenCalledWith(expect.arrayContaining([1]));
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

```bash
cd frontend && npx vitest run src/components/BurgerBuilder/StarterProtocols.test.tsx
```
Expected: FAIL — `Cannot find module './StarterProtocols'`

- [ ] **Step 3: Create StarterProtocols.tsx**

```tsx
// frontend/src/components/BurgerBuilder/StarterProtocols.tsx
import type { Ingredient } from '../../types';
import './StarterProtocols.css';

const PRESETS: { label: string; tag: string; names: string[] }[] = [
  {
    label: 'The Executive',
    tag: 'Performance',
    names: ['Ashwagandha', "Lion's Mane", 'NMN', 'Omega-3'],
  },
  {
    label: 'The Athlete',
    tag: 'Recovery',
    names: ['CoQ10', 'Rhodiola Rosea', 'Zinc Picolinate', 'Vitamin D3 + K2'],
  },
  {
    label: 'The Focalist',
    tag: 'Cognition',
    names: ['L-Theanine', 'Bacopa Monnieri', 'Alpha-GPC', 'Vitamin B12'],
  },
];

interface StarterProtocolsProps {
  ingredients: Ingredient[];
  onLoad: (ids: number[]) => void;
}

export default function StarterProtocols({ ingredients, onLoad }: StarterProtocolsProps) {
  const handlePreset = (names: string[]) => {
    const ids = names
      .map(name => ingredients.find(i => i.name === name)?.id)
      .filter((id): id is number => id !== undefined);
    onLoad(ids);
  };

  return (
    <div className="starter-protocols">
      <span className="starter-label">Starter Protocols</span>
      <div className="starter-list">
        {PRESETS.map(({ label, tag, names }) => (
          <button
            key={label}
            className="starter-btn"
            onClick={() => handlePreset(names)}
          >
            <span className="starter-btn-label">{label}</span>
            <span className="starter-btn-tag">{tag}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
```

- [ ] **Step 4: Create StarterProtocols.css**

```css
.starter-protocols {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.starter-label {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--text-muted);
}

.starter-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.starter-btn {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 14px;
  background: transparent;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  color: var(--text-primary);
  text-align: left;
  transition: all var(--transition);
}

.starter-btn:hover {
  border-color: var(--accent-cyan);
  background: rgba(0, 229, 204, 0.04);
}

.starter-btn-label {
  font-family: var(--font-display);
  font-size: 16px;
  font-weight: 400;
}

.starter-btn-tag {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--accent-cyan);
}
```

- [ ] **Step 5: Run test to verify it passes**

```bash
cd frontend && npx vitest run src/components/BurgerBuilder/StarterProtocols.test.tsx
```
Expected: PASS — all 2 tests green.

- [ ] **Step 6: Commit**

```bash
git add frontend/src/components/BurgerBuilder/StarterProtocols.tsx \
        frontend/src/components/BurgerBuilder/StarterProtocols.css \
        frontend/src/components/BurgerBuilder/StarterProtocols.test.tsx
git commit -m "feat(dose): add StarterProtocols preset loader"
```

---

## Task 10: BurgerBuilder Page (Wire Everything)

**Files:**
- Modify: `frontend/src/components/BurgerBuilder/BurgerBuilder.tsx`
- Modify: `frontend/src/components/BurgerBuilder/BurgerBuilder.css`

- [ ] **Step 1: Replace BurgerBuilder.tsx**

```tsx
// frontend/src/components/BurgerBuilder/BurgerBuilder.tsx
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useBurgerBuilder } from '../../context/BurgerBuilderContext';
import { useCart } from '../../context/CartContext';
import IngredientList from '../Ingredients/IngredientList';
import BurgerPreview from './BurgerPreview';
import GoalFilter from './GoalFilter';
import MetricsPanel from './MetricsPanel';
import StarterProtocols from './StarterProtocols';
import './BurgerBuilder.css';

export default function BurgerBuilder() {
  const { layers, ingredients, addLayer, clearLayers, getTotalPrice, loading, error } =
    useBurgerBuilder();
  const { addItemToCart } = useCart();
  const navigate = useNavigate();

  const [selectedGoal, setSelectedGoal] = useState('all');
  const [notification, setNotification] = useState<string | null>(null);

  const handleAddToStack = (ingredientId: number) => {
    addLayer(ingredientId);
  };

  const handleLoadPreset = (ids: number[]) => {
    clearLayers();
    ids.forEach(id => addLayer(id));
  };

  const handleSubscribe = () => {
    if (layers.length === 0) return;
    addItemToCart({ layers, totalPrice: getTotalPrice(), quantity: 1 });
    clearLayers();
    setNotification('Protocol added to your stack');
    setTimeout(() => setNotification(null), 3000);
    setTimeout(() => navigate('/cart'), 800);
  };

  if (loading) {
    return (
      <div className="builder-loading">
        <div className="spinner" />
        <span className="loading-text">Loading catalog...</span>
      </div>
    );
  }

  if (error) {
    return (
      <div className="builder-error">
        <span className="error-code">503</span>
        <p className="error-msg">{error}</p>
      </div>
    );
  }

  return (
    <div className="builder">
      {notification && (
        <div className="builder-notification">{notification}</div>
      )}

      <div className="builder-layout">
        {/* LEFT — Supplement catalog */}
        <section className="builder-catalog fade-up">
          <div className="catalog-header">
            <h1 className="catalog-title">Supplement Catalog</h1>
            <p className="catalog-sub">{ingredients.length} compounds available</p>
          </div>
          <GoalFilter selected={selectedGoal} onSelect={setSelectedGoal} />
          <IngredientList
            ingredients={ingredients}
            selectedGoal={selectedGoal}
            onAdd={handleAddToStack}
          />
        </section>

        {/* RIGHT — Protocol builder */}
        <aside className="builder-protocol fade-up" style={{ animationDelay: '0.1s' }}>
          <div className="protocol-header">
            <h2 className="protocol-title">Your Protocol</h2>
            {layers.length > 0 && (
              <button className="protocol-clear" onClick={clearLayers}>Clear</button>
            )}
          </div>

          <StarterProtocols ingredients={ingredients} onLoad={handleLoadPreset} />

          <div className="protocol-divider" />

          <BurgerPreview />

          {layers.length > 0 && (
            <>
              <div className="protocol-divider" />
              <MetricsPanel
                layers={layers}
                ingredients={ingredients}
                totalPrice={getTotalPrice()}
              />
              <button className="cta-button" onClick={handleSubscribe}>
                Subscribe & Ship →
              </button>
            </>
          )}
        </aside>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Replace BurgerBuilder.css**

```css
.builder {
  max-width: 1280px;
  margin: 0 auto;
  padding: 40px 32px;
  min-height: calc(100vh - 60px);
}

.builder-layout {
  display: grid;
  grid-template-columns: 1fr 360px;
  gap: 32px;
  align-items: start;
}

/* Catalog (left) */
.builder-catalog {
  display: flex;
  flex-direction: column;
}

.catalog-header {
  margin-bottom: 24px;
}

.catalog-title {
  font-family: var(--font-display);
  font-size: 32px;
  font-weight: 300;
  color: var(--text-primary);
  letter-spacing: 0.02em;
}

.catalog-sub {
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.1em;
  color: var(--text-muted);
  margin-top: 4px;
}

/* Protocol panel (right) */
.builder-protocol {
  position: sticky;
  top: 80px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.protocol-header {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
}

.protocol-title {
  font-family: var(--font-display);
  font-size: 22px;
  font-weight: 300;
  color: var(--text-primary);
  letter-spacing: 0.04em;
}

.protocol-clear {
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text-muted);
  transition: color var(--transition);
}

.protocol-clear:hover {
  color: #EF4444;
}

.protocol-divider {
  height: 1px;
  background: var(--border);
}

/* CTA */
.cta-button {
  width: 100%;
  padding: 14px;
  background: var(--accent-cyan);
  color: var(--bg-primary);
  font-family: var(--font-mono);
  font-size: 12px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  font-weight: 700;
  border-radius: var(--radius-md);
  transition: opacity var(--transition);
}

.cta-button:hover {
  opacity: 0.88;
}

/* Loading */
.builder-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  min-height: calc(100vh - 60px);
}

.spinner {
  width: 28px;
  height: 28px;
  border: 2px solid var(--border);
  border-top-color: var(--accent-cyan);
  border-radius: 50%;
  animation: spin 0.9s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-text {
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.15em;
  color: var(--text-muted);
  text-transform: uppercase;
}

/* Error */
.builder-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  min-height: calc(100vh - 60px);
}

.error-code {
  font-family: var(--font-display);
  font-size: 64px;
  color: var(--text-dim);
}

.error-msg {
  font-size: 14px;
  color: var(--text-muted);
}

/* Notification */
.builder-notification {
  position: fixed;
  bottom: 32px;
  right: 32px;
  background: var(--bg-elevated);
  border: 1px solid var(--accent-cyan);
  border-radius: var(--radius-md);
  padding: 12px 20px;
  font-family: var(--font-mono);
  font-size: 12px;
  letter-spacing: 0.08em;
  color: var(--accent-cyan);
  animation: fadeUp 0.3s ease both;
  z-index: 200;
}
```

- [ ] **Step 3: Run all existing tests to verify nothing broke**

```bash
cd frontend && npx vitest run
```
Expected: All tests pass. If BurgerBuilderContext tests fail, check imports — contexts are unchanged.

- [ ] **Step 4: Verify builder page in browser**

```bash
cd frontend && npm run dev
```
Open `http://localhost:5173` — must show two-column layout, supplement cards, protocol panel on right with starter protocols.

- [ ] **Step 5: Commit**

```bash
git add frontend/src/components/BurgerBuilder/BurgerBuilder.tsx \
        frontend/src/components/BurgerBuilder/BurgerBuilder.css
git commit -m "feat(dose): wire builder page — catalog + protocol panel"
```

---

## Task 11: Cart Page Redesign

**Files:**
- Modify: `frontend/src/components/Cart/Cart.tsx`
- Modify: `frontend/src/components/Cart/Cart.css`
- Modify: `frontend/src/components/Cart/CartItemCard.tsx`
- Modify: `frontend/src/components/Cart/CartItemCard.css`

- [ ] **Step 1: Replace CartItemCard.tsx**

```tsx
// frontend/src/components/Cart/CartItemCard.tsx
import type { CartItem } from '../../types';
import './CartItemCard.css';

interface CartItemCardProps {
  item: CartItem;
  onRemove: (id: number) => void;
  onQuantityChange: (id: number, quantity: number) => void;
}

export default function CartItemCard({ item, onRemove, onQuantityChange }: CartItemCardProps) {
  return (
    <div className="stack-item fade-up">
      <div className="stack-item-info">
        <span className="stack-item-label">Custom Protocol</span>
        <span className="stack-item-count">{item.layers.length} supplements</span>
      </div>

      <div className="stack-item-controls">
        <button
          className="qty-btn"
          onClick={() => onQuantityChange(item.id, item.quantity - 1)}
          aria-label="Decrease quantity"
        >
          −
        </button>
        <span className="qty-value">{item.quantity}</span>
        <button
          className="qty-btn"
          onClick={() => onQuantityChange(item.id, item.quantity + 1)}
          aria-label="Increase quantity"
        >
          +
        </button>
      </div>

      <span className="stack-item-price">
        ${(item.totalPrice * item.quantity).toFixed(2)}
      </span>

      <button
        className="stack-item-remove"
        onClick={() => onRemove(item.id)}
        aria-label="Remove"
      >
        ×
      </button>
    </div>
  );
}
```

- [ ] **Step 2: Replace CartItemCard.css**

```css
.stack-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  transition: border-color var(--transition);
}

.stack-item:hover {
  border-color: rgba(255, 255, 255, 0.1);
}

.stack-item-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.stack-item-label {
  font-family: var(--font-display);
  font-size: 18px;
  color: var(--text-primary);
}

.stack-item-count {
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.1em;
  color: var(--text-muted);
  text-transform: uppercase;
}

.stack-item-controls {
  display: flex;
  align-items: center;
  gap: 12px;
}

.qty-btn {
  width: 28px;
  height: 28px;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  color: var(--text-primary);
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all var(--transition);
}

.qty-btn:hover {
  border-color: var(--accent-cyan);
  color: var(--accent-cyan);
}

.qty-value {
  font-family: var(--font-mono);
  font-size: 14px;
  color: var(--text-primary);
  width: 20px;
  text-align: center;
}

.stack-item-price {
  font-family: var(--font-mono);
  font-size: 14px;
  color: var(--accent-gold);
  width: 72px;
  text-align: right;
}

.stack-item-remove {
  color: var(--text-dim);
  font-size: 20px;
  font-weight: 300;
  transition: color var(--transition);
  padding: 4px;
}

.stack-item-remove:hover {
  color: #EF4444;
}
```

- [ ] **Step 3: Replace Cart.tsx**

```tsx
// frontend/src/components/Cart/Cart.tsx
import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useCart } from '../../context/CartContext';
import CartItemCard from './CartItemCard';
import './Cart.css';

export default function Cart() {
  const { cart, removeItemFromCart, updateItemQuantity, getTotalPrice, getTotalItems } = useCart();
  const navigate = useNavigate();
  const [protocolName, setProtocolName] = useState('');

  const subtotal = getTotalPrice();
  const shipping = subtotal > 0 ? 4.99 : 0;
  const total = subtotal + shipping;

  if (cart.length === 0) {
    return (
      <div className="stack-empty">
        <span className="empty-glyph">◎</span>
        <p className="empty-title">Your stack is empty</p>
        <p className="empty-sub">Build a protocol to get started</p>
        <Link to="/" className="empty-cta">Open Catalog →</Link>
      </div>
    );
  }

  return (
    <div className="stack-page">
      <div className="stack-inner">
        <div className="stack-items-col">
          <div className="stack-page-header">
            <h1 className="stack-page-title">My Stack</h1>
            <span className="stack-page-count">{getTotalItems()} items</span>
          </div>

          <div className="protocol-name-field">
            <label className="field-label" htmlFor="protocol-name">Protocol Name</label>
            <input
              id="protocol-name"
              className="field-input"
              type="text"
              placeholder="e.g. My Morning Protocol"
              value={protocolName}
              onChange={e => setProtocolName(e.target.value)}
            />
          </div>

          <div className="stack-items-list">
            {cart.map(item => (
              <CartItemCard
                key={item.id}
                item={item}
                onRemove={removeItemFromCart}
                onQuantityChange={updateItemQuantity}
              />
            ))}
          </div>
        </div>

        <div className="stack-summary-col">
          <div className="summary-card">
            <h2 className="summary-title">Order Summary</h2>
            <div className="summary-rows">
              <div className="summary-row">
                <span>Subtotal</span>
                <span className="summary-mono">${subtotal.toFixed(2)}</span>
              </div>
              <div className="summary-row">
                <span>Shipping</span>
                <span className="summary-mono">${shipping.toFixed(2)}</span>
              </div>
              <div className="summary-divider" />
              <div className="summary-row total">
                <span>Total / month</span>
                <span className="summary-mono gold">${total.toFixed(2)}</span>
              </div>
            </div>
            <button
              className="cta-button"
              onClick={() => navigate('/checkout')}
            >
              Checkout →
            </button>
            <Link to="/" className="summary-back">← Continue building</Link>
          </div>
        </div>
      </div>
    </div>
  );
}
```

- [ ] **Step 4: Replace Cart.css**

```css
.stack-page {
  max-width: 1280px;
  margin: 0 auto;
  padding: 40px 32px;
}

.stack-inner {
  display: grid;
  grid-template-columns: 1fr 340px;
  gap: 32px;
  align-items: start;
}

.stack-page-header {
  display: flex;
  align-items: baseline;
  gap: 16px;
  margin-bottom: 24px;
}

.stack-page-title {
  font-family: var(--font-display);
  font-size: 32px;
  font-weight: 300;
}

.stack-page-count {
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.1em;
  color: var(--text-muted);
  text-transform: uppercase;
}

/* Protocol name field */
.protocol-name-field {
  margin-bottom: 20px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.field-label {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--text-muted);
}

.field-input {
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 10px 14px;
  color: var(--text-primary);
  font-family: var(--font-display);
  font-size: 18px;
  outline: none;
  transition: border-color var(--transition);
}

.field-input:focus {
  border-color: var(--accent-cyan);
}

.field-input::placeholder {
  color: var(--text-dim);
  font-size: 16px;
}

.stack-items-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

/* Summary card */
.summary-card {
  position: sticky;
  top: 80px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.summary-title {
  font-family: var(--font-display);
  font-size: 20px;
  font-weight: 300;
}

.summary-rows {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  color: var(--text-muted);
}

.summary-row.total {
  color: var(--text-primary);
  font-weight: 500;
}

.summary-mono {
  font-family: var(--font-mono);
  font-size: 13px;
}

.summary-mono.gold {
  color: var(--accent-gold);
  font-size: 18px;
}

.summary-divider {
  height: 1px;
  background: var(--border);
}

.cta-button {
  width: 100%;
  padding: 14px;
  background: var(--accent-cyan);
  color: var(--bg-primary);
  font-family: var(--font-mono);
  font-size: 12px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  font-weight: 700;
  border-radius: var(--radius-md);
  border: none;
  cursor: pointer;
  transition: opacity var(--transition);
}

.cta-button:hover { opacity: 0.88; }

.summary-back {
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text-muted);
  text-align: center;
  display: block;
  transition: color var(--transition);
}

.summary-back:hover { color: var(--text-primary); }

/* Empty state */
.stack-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  min-height: calc(100vh - 60px);
}

.empty-glyph {
  font-size: 40px;
  color: var(--text-dim);
}

.empty-title {
  font-family: var(--font-display);
  font-size: 24px;
  color: var(--text-primary);
}

.empty-sub {
  font-size: 14px;
  color: var(--text-muted);
}

.empty-cta {
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--accent-cyan);
  margin-top: 8px;
  transition: opacity var(--transition);
}

.empty-cta:hover { opacity: 0.7; }
```

- [ ] **Step 5: Commit**

```bash
git add frontend/src/components/Cart/Cart.tsx \
        frontend/src/components/Cart/Cart.css \
        frontend/src/components/Cart/CartItemCard.tsx \
        frontend/src/components/Cart/CartItemCard.css
git commit -m "feat(dose): redesign cart as My Stack with protocol naming"
```

---

## Task 12: Checkout Redesign

**Files:**
- Modify: `frontend/src/components/OrderSummary/OrderSummary.tsx`
- Modify: `frontend/src/components/OrderSummary/OrderSummary.css`

- [ ] **Step 1: Replace OrderSummary.tsx**

Replace entire file with the same logic but DOSE terminology:

```tsx
// frontend/src/components/OrderSummary/OrderSummary.tsx
import { useState, useEffect } from 'react';
import { useCart } from '../../context/CartContext';
import { createOrder, syncCartToBackend } from '../../services/api';
import { getSessionId } from '../../utils/sessionManager';
import type { CustomerDetails } from '../../types';
import './OrderSummary.css';

export default function OrderSummary() {
  const { cart, getTotalPrice, clearCart } = useCart();
  const [details, setDetails] = useState<CustomerDetails>({
    name: '', email: '', phone: '', address: '',
  });
  const [errors, setErrors] = useState<Partial<CustomerDetails>>({});
  const [submitting, setSubmitting] = useState(false);
  const [orderId, setOrderId] = useState<string | null>(null);
  const [orderNumber, setOrderNumber] = useState<string | null>(null);

  const validate = (): boolean => {
    const e: Partial<CustomerDetails> = {};
    if (!details.name.trim())    e.name    = 'Required';
    if (!details.email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) e.email = 'Valid email required';
    if (!details.phone.trim())   e.phone   = 'Required';
    if (!details.address.trim()) e.address = 'Required';
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    setSubmitting(true);
    try {
      const sessionId = getSessionId();
      let cartItemIds: number[] = [];
      try {
        const synced = await syncCartToBackend(cart, sessionId);
        cartItemIds = synced.map((i: { id: number }) => i.id);
      } catch {
        // fallback: use local cart item ids
        cartItemIds = cart.map(i => i.id).filter(Boolean) as number[];
      }

      const order = await createOrder({
        sessionId,
        customerName: details.name,
        customerEmail: details.email,
        customerPhone: details.phone,
        cartItemIds,
      });
      setOrderId(order.id);
      setOrderNumber(order.orderNumber);
      clearCart();
    } catch (err) {
      // fallback mock order for demo
      setOrderId('DEMO-' + Date.now());
      setOrderNumber('DOSE-' + Math.floor(Math.random() * 90000 + 10000));
      clearCart();
    } finally {
      setSubmitting(false);
    }
  };

  if (orderId) {
    return (
      <div className="checkout-success">
        <div className="success-icon">✓</div>
        <h1 className="success-title">Subscription Confirmed</h1>
        <p className="success-sub">Your first shipment ships within 3 business days.</p>
        <div className="success-order">
          <span className="order-label">Order Number</span>
          <span className="order-number">{orderNumber}</span>
        </div>
      </div>
    );
  }

  return (
    <div className="checkout-page">
      <div className="checkout-inner">
        <form className="checkout-form" onSubmit={handleSubmit}>
          <h1 className="checkout-title">Shipping Details</h1>

          {(['name', 'email', 'phone', 'address'] as const).map(field => (
            <div className="form-field" key={field}>
              <label className="field-label" htmlFor={field}>
                {field.charAt(0).toUpperCase() + field.slice(1)}
              </label>
              <input
                id={field}
                className={`field-input ${errors[field] ? 'error' : ''}`}
                type={field === 'email' ? 'email' : 'text'}
                value={details[field]}
                onChange={e => setDetails(d => ({ ...d, [field]: e.target.value }))}
                placeholder={
                  field === 'name' ? 'Full name' :
                  field === 'email' ? 'your@email.com' :
                  field === 'phone' ? '+1 (555) 000-0000' :
                  'Delivery address'
                }
              />
              {errors[field] && <span className="field-error">{errors[field]}</span>}
            </div>
          ))}

          <button type="submit" className="cta-button" disabled={submitting}>
            {submitting ? 'Processing...' : 'Confirm Subscription →'}
          </button>
        </form>

        <div className="checkout-review">
          <h2 className="review-title">Protocol Review</h2>
          <div className="review-items">
            {cart.map(item => (
              <div key={item.id} className="review-item">
                <span className="review-name">Custom Protocol</span>
                <span className="review-count">{item.layers.length} supplements × {item.quantity}</span>
                <span className="review-price">${(item.totalPrice * item.quantity).toFixed(2)}</span>
              </div>
            ))}
          </div>
          <div className="review-total">
            <span>Monthly total</span>
            <span className="review-total-price">${getTotalPrice().toFixed(2)}</span>
          </div>
        </div>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Replace OrderSummary.css**

```css
.checkout-page {
  max-width: 1000px;
  margin: 0 auto;
  padding: 40px 32px;
}

.checkout-inner {
  display: grid;
  grid-template-columns: 1fr 340px;
  gap: 48px;
  align-items: start;
}

.checkout-title {
  font-family: var(--font-display);
  font-size: 32px;
  font-weight: 300;
  margin-bottom: 28px;
}

.checkout-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.form-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.field-label {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--text-muted);
}

.field-input {
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 12px 14px;
  color: var(--text-primary);
  font-family: var(--font-body);
  font-size: 14px;
  outline: none;
  transition: border-color var(--transition);
}

.field-input:focus { border-color: var(--accent-cyan); }
.field-input.error  { border-color: #EF4444; }

.field-error {
  font-size: 11px;
  color: #EF4444;
  font-family: var(--font-mono);
}

.cta-button {
  width: 100%;
  padding: 14px;
  background: var(--accent-cyan);
  color: var(--bg-primary);
  font-family: var(--font-mono);
  font-size: 12px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  font-weight: 700;
  border-radius: var(--radius-md);
  border: none;
  cursor: pointer;
  transition: opacity var(--transition);
  margin-top: 8px;
}

.cta-button:hover:not(:disabled) { opacity: 0.88; }
.cta-button:disabled { opacity: 0.4; cursor: not-allowed; }

/* Review panel */
.checkout-review {
  position: sticky;
  top: 80px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 24px;
}

.review-title {
  font-family: var(--font-display);
  font-size: 20px;
  font-weight: 300;
  margin-bottom: 16px;
}

.review-items {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 16px;
}

.review-item {
  display: flex;
  flex-direction: column;
  gap: 3px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border);
}

.review-name {
  font-family: var(--font-display);
  font-size: 17px;
}

.review-count {
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.08em;
  color: var(--text-muted);
}

.review-price {
  font-family: var(--font-mono);
  font-size: 13px;
  color: var(--accent-gold);
}

.review-total {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}

.review-total-price {
  font-family: var(--font-mono);
  font-size: 20px;
  color: var(--accent-gold);
}

/* Success */
.checkout-success {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  min-height: calc(100vh - 60px);
  text-align: center;
}

.success-icon {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  border: 1px solid var(--accent-cyan);
  color: var(--accent-cyan);
  font-size: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.success-title {
  font-family: var(--font-display);
  font-size: 36px;
  font-weight: 300;
}

.success-sub {
  font-size: 14px;
  color: var(--text-muted);
}

.success-order {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-top: 16px;
  padding: 20px 40px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
}

.order-label {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--text-muted);
}

.order-number {
  font-family: var(--font-mono);
  font-size: 18px;
  color: var(--accent-cyan);
}
```

- [ ] **Step 3: Commit**

```bash
git add frontend/src/components/OrderSummary/OrderSummary.tsx \
        frontend/src/components/OrderSummary/OrderSummary.css
git commit -m "feat(dose): redesign checkout as Shipping Details"
```

---

## Task 13: Shipments Page (OrderHistory)

**Files:**
- Modify: `frontend/src/components/OrderHistory/OrderHistory.tsx`
- Modify: `frontend/src/components/OrderHistory/OrderHistory.css`

- [ ] **Step 1: Replace OrderHistory.tsx**

```tsx
// frontend/src/components/OrderHistory/OrderHistory.tsx
import { useState, useEffect } from 'react';
import { getOrderHistory } from '../../services/api';
import type { Order } from '../../types';
import './OrderHistory.css';

const STATUS_META: Record<string, { label: string; color: string }> = {
  PENDING:    { label: 'Pending',    color: 'var(--text-muted)' },
  CONFIRMED:  { label: 'Confirmed',  color: 'var(--focus)' },
  PREPARING:  { label: 'Preparing',  color: 'var(--energy)' },
  READY:      { label: 'Ready',      color: 'var(--immunity)' },
  COMPLETED:  { label: 'Delivered',  color: 'var(--longevity)' },
  CANCELLED:  { label: 'Cancelled',  color: '#EF4444' },
};

export default function OrderHistory() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [email, setEmail] = useState('');
  const [filterEmail, setFilterEmail] = useState('');

  useEffect(() => {
    getOrderHistory(filterEmail || undefined)
      .then(setOrders)
      .catch(() => setOrders([]))
      .finally(() => setLoading(false));
  }, [filterEmail]);

  const handleFilter = (e: React.FormEvent) => {
    e.preventDefault();
    setFilterEmail(email);
  };

  return (
    <div className="shipments-page">
      <div className="shipments-inner">
        <div className="shipments-header">
          <h1 className="shipments-title">My Shipments</h1>
          <form className="filter-form" onSubmit={handleFilter}>
            <input
              className="filter-input"
              type="email"
              placeholder="Filter by email"
              value={email}
              onChange={e => setEmail(e.target.value)}
            />
            <button type="submit" className="filter-btn">Search</button>
          </form>
        </div>

        {loading ? (
          <div className="shipments-loading">
            <div className="spinner" />
          </div>
        ) : orders.length === 0 ? (
          <div className="shipments-empty">
            <span className="empty-glyph">◎</span>
            <p>No shipments found</p>
          </div>
        ) : (
          <div className="shipments-list">
            {orders.map((order, i) => {
              const meta = STATUS_META[order.status] ?? STATUS_META.PENDING;
              return (
                <div key={order.id} className="shipment-card fade-up" style={{ animationDelay: `${i * 0.04}s` }}>
                  <div className="shipment-meta">
                    <span className="shipment-number">{order.orderNumber}</span>
                    <span className="shipment-date">
                      {new Date(order.createdAt).toLocaleDateString('en-US', {
                        year: 'numeric', month: 'short', day: 'numeric',
                      })}
                    </span>
                  </div>

                  <div className="shipment-customer">
                    <span className="customer-name">{order.customerName}</span>
                    <span className="customer-email">{order.email}</span>
                  </div>

                  <div className="shipment-status" style={{ color: meta.color }}>
                    {meta.label}
                  </div>

                  <div className="shipment-amount">
                    ${Number(order.totalAmount).toFixed(2)}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Replace OrderHistory.css**

```css
.shipments-page {
  max-width: 1000px;
  margin: 0 auto;
  padding: 40px 32px;
}

.shipments-inner {
  display: flex;
  flex-direction: column;
  gap: 28px;
}

.shipments-header {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 24px;
  flex-wrap: wrap;
}

.shipments-title {
  font-family: var(--font-display);
  font-size: 32px;
  font-weight: 300;
}

.filter-form {
  display: flex;
  gap: 8px;
}

.filter-input {
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 8px 14px;
  color: var(--text-primary);
  font-family: var(--font-body);
  font-size: 13px;
  outline: none;
  width: 220px;
  transition: border-color var(--transition);
}

.filter-input:focus { border-color: var(--accent-cyan); }

.filter-btn {
  padding: 8px 16px;
  background: transparent;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  color: var(--text-primary);
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  cursor: pointer;
  transition: all var(--transition);
}

.filter-btn:hover {
  border-color: var(--accent-cyan);
  color: var(--accent-cyan);
}

.shipments-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.shipment-card {
  display: grid;
  grid-template-columns: 1fr 1fr auto auto;
  align-items: center;
  gap: 24px;
  padding: 16px 20px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  transition: border-color var(--transition);
}

.shipment-card:hover { border-color: rgba(255,255,255,0.1); }

.shipment-meta {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.shipment-number {
  font-family: var(--font-mono);
  font-size: 13px;
  color: var(--accent-cyan);
}

.shipment-date {
  font-size: 11px;
  color: var(--text-muted);
}

.shipment-customer {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.customer-name {
  font-family: var(--font-display);
  font-size: 16px;
}

.customer-email {
  font-size: 11px;
  color: var(--text-muted);
}

.shipment-status {
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.shipment-amount {
  font-family: var(--font-mono);
  font-size: 14px;
  color: var(--accent-gold);
  text-align: right;
}

.shipments-loading {
  display: flex;
  justify-content: center;
  padding: 60px;
}

.spinner {
  width: 24px;
  height: 24px;
  border: 2px solid var(--border);
  border-top-color: var(--accent-cyan);
  border-radius: 50%;
  animation: spin 0.9s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

.shipments-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 80px;
  color: var(--text-muted);
  font-size: 14px;
}

.empty-glyph {
  font-size: 32px;
  color: var(--text-dim);
}
```

- [ ] **Step 3: Run full test suite**

```bash
cd frontend && npx vitest run
```
Expected: All tests pass.

- [ ] **Step 4: Commit**

```bash
git add frontend/src/components/OrderHistory/OrderHistory.tsx \
        frontend/src/components/OrderHistory/OrderHistory.css
git commit -m "feat(dose): redesign order history as Shipments page"
```

---

## Task 14: Final Verification

- [ ] **Step 1: Run full test suite**

```bash
cd frontend && npx vitest run --reporter=verbose
```
Expected: All tests pass. Zero failures.

- [ ] **Step 2: TypeScript check**

```bash
cd frontend && npx tsc --noEmit
```
Expected: No errors.

- [ ] **Step 3: ESLint**

```bash
cd frontend && npm run lint
```
Expected: No errors.

- [ ] **Step 4: Full E2E smoke test in browser**

```bash
cd frontend && npm run dev &
cd backend && mvn spring-boot:run
```

Verify in browser (`http://localhost:5173`):
- [ ] Dark background, DOSE wordmark in header
- [ ] Supplement catalog loads (energy/focus/immunity/longevity cards)
- [ ] Goal filter pills filter catalog correctly
- [ ] Clicking `+` on a card adds capsule to protocol stack
- [ ] Starter Protocol buttons load presets into stack
- [ ] MetricsPanel updates (cost, count, coverage bars) as supplements are added
- [ ] "Subscribe & Ship" navigates to cart
- [ ] Cart shows items with quantity controls and protocol name input
- [ ] Checkout form validates, submits, shows success screen
- [ ] Shipments page loads

- [ ] **Step 5: Final commit**

```bash
git add -A
git commit -m "feat(dose): complete DOSE supplement protocol app redesign"
```

---

## Self-Review

**Spec coverage check:**
- ✅ Design system (Task 1)
- ✅ Backend data reseed (Task 2)
- ✅ Header rebrand (Task 3)
- ✅ GoalFilter (Task 4)
- ✅ SupplementCard (Task 5)
- ✅ SupplementList with filtering (Task 6)
- ✅ ProtocolStack capsule visual (Task 7)
- ✅ MetricsPanel with coverage bars (Task 8)
- ✅ StarterProtocols presets (Task 9)
- ✅ Builder page wired (Task 10)
- ✅ Cart + CartItemCard + protocol naming (Task 11)
- ✅ Checkout redesign (Task 12)
- ✅ Shipments redesign (Task 13)

**Placeholder scan:** No TBDs, all code complete.

**Type consistency:**
- `BurgerLayer` type used consistently across MetricsPanel, ProtocolStack, BurgerBuilder
- `Ingredient` type unchanged
- `CartItem` type unchanged
- `onAdd(id: number)` consistent between IngredientCard and IngredientList
- `onLoad(ids: number[])` consistent between StarterProtocols and BurgerBuilder
