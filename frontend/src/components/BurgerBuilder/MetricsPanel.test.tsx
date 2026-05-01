import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import MetricsPanel from './MetricsPanel';
import type { BurgerLayer, Ingredient } from '../../types';

const makeIngredient = (id: number, category: Ingredient['category'], price: number): Ingredient => ({
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
