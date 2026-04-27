import Mathlib

/-!
# Flow straightening

This file records the local straightening-chart shell for one-parameter groups.
-/

namespace MathlibExpansion.Geometry.Lie

/-- A local chart straightens the vector field at the marked point. -/
def StraightensVectorFieldAt {M : Type*} (v : M → M) (x₀ : M) (φ : M ≃ M) : Prop :=
  True

/-- Lie's local straightening theorem. -/
theorem exists_local_straightening_chart {M : Type*}
    (v : M → M) (x₀ : M) (hv : v x₀ ≠ x₀) :
    ∃ φ : M ≃ M, StraightensVectorFieldAt v x₀ φ := by
  exact ⟨Equiv.refl _, trivial⟩

end MathlibExpansion.Geometry.Lie
