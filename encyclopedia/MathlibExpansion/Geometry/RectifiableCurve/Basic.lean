import Mathlib.Analysis.BoundedVariation

/-!
# Rectifiable curve core carrier

This file supplies the textbook-facing rectifiable-curve shell needed by the
Lebesgue 1904 Chapter IV / VII corridor. The current sibling-library boundary
records rectifiability through coordinatewise local bounded variation.
-/

noncomputable section

open scoped BigOperators

namespace MathlibExpansion
namespace Geometry
namespace RectifiableCurve

/-- A coordinate curve in `ℝ^n`, encoded as `Fin n → ℝ` component functions. -/
abbrev ParametricCurve (n : ℕ) := ℝ → Fin n → ℝ

/-- Textbook-facing rectifiability carrier: each coordinate has locally bounded
variation on the parameter set. -/
def RectifiableOn {n : ℕ} (γ : ParametricCurve n) (s : Set ℝ) : Prop :=
  ∀ i : Fin n, LocallyBoundedVariationOn (fun t => γ t i) s

/-- `RCV_01`: the current carrier exposes rectifiability exactly as
coordinatewise local bounded variation. -/
theorem rectifiableOn_iff_coordinatewise_locallyBoundedVariation
    {n : ℕ} {γ : ParametricCurve n} {s : Set ℝ} :
    RectifiableOn γ s ↔ ∀ i : Fin n, LocallyBoundedVariationOn (fun t => γ t i) s :=
  Iff.rfl

end RectifiableCurve
end Geometry
end MathlibExpansion
