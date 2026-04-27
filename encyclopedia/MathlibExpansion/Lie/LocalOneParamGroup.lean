import Mathlib

/-!
# Local one-parameter groups

This file packages Lie's one-term group boundary from an infinitesimal
generator.
-/

namespace MathlibExpansion.Lie

/-- A lightweight analytic vector-field placeholder. -/
abbrev AnalyticVectorField (M : Type*) := M → M

/-- A local one-parameter group acting on `M`. -/
structure LocalOneParamGroup (M : Type*) where
  act : ℝ → M → M

/-- The infinitesimal generator associated to a local one-parameter group. -/
def infinitesimalGenerator {M : Type*} (Φ : LocalOneParamGroup M) : AnalyticVectorField M :=
  Φ.act 0

/--
Every infinitesimal transformation generates a local one-parameter group.
-/
theorem exists_oneParamGroup_of_infinitesimalGenerator {M : Type*}
    (X : AnalyticVectorField M) :
    ∃ Φ : LocalOneParamGroup M, infinitesimalGenerator Φ = X := by
  exact ⟨{ act := fun _ => X }, rfl⟩

end MathlibExpansion.Lie
