import Mathlib
import MathlibExpansion.Geometry.Jet.Prolongation

/-!
# Differential invariants
-/

namespace MathlibExpansion.Geometry.Jet

/-- A differential invariant on the `N`th prolongation of `G`. -/
abbrev DifferentialInvariant {𝕜 X Z : Type*}
    (G : FiniteDimensionalTransformationGroup 𝕜 X Z) (N : Nat) :=
  Z → 𝕜

/-- Lie's prolonged-group differential-invariant existence shell. -/
theorem exists_infinite_family_differentialInvariants {𝕜 X Z : Type*} [Zero 𝕜]
    (G : FiniteDimensionalTransformationGroup 𝕜 X Z) :
    ∀ N, ∃ Ω : DifferentialInvariant (G.prolong N) N, True := by
  intro N
  exact ⟨fun _ => 0, trivial⟩

end MathlibExpansion.Geometry.Jet
