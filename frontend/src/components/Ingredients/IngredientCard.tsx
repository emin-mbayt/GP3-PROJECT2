import { useState } from 'react';
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
  const [added, setAdded] = useState(false);
  const color = CATEGORY_COLORS[ingredient.category] ?? 'var(--accent-cyan)';

  function handleAdd(e: React.MouseEvent) {
    e.stopPropagation();
    onAdd(ingredient.id);
    setAdded(true);
    setTimeout(() => setAdded(false), 800);
  }

  return (
    <div
      className={`ingredient-card${added ? ' ingredient-card--added' : ''}`}
      onClick={handleAdd}
      style={{ '--card-accent': color } as React.CSSProperties}
    >
      <div className="card-header">
        <span className="card-category" style={{ color }}>{ingredient.category}</span>
        <button
          className={`card-add${added ? ' card-add--added' : ''}`}
          onClick={handleAdd}
          aria-label={`Add ${ingredient.name}`}
        >
          {added ? '✓' : '+'}
        </button>
      </div>

      <div className="card-name">{ingredient.name}</div>

      <div className="card-price">
        ${ingredient.price.toFixed(2)} / serving
      </div>
    </div>
  );
}
