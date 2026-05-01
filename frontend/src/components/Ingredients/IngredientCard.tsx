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


      <div className="card-price">
        ${ingredient.price.toFixed(2)} / serving
      </div>
    </div>
  );
}
