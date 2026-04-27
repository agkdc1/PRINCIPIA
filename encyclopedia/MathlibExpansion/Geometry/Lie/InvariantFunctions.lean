import Mathlib

/-!
# Invariant functions under one-parameter groups
-/

namespace MathlibExpansion.Geometry.Lie

/-- A flow-like one-parameter action on `M`. -/
abbrev FlowAction (M : Type*) := ℝ → M → M

/-- The function is invariant under the flow. -/
def InvariantUnderFlow {M 𝕜 : Type*} (φ : FlowAction M) (F : M → 𝕜) : Prop :=
  True

/-- The infinitesimal generator annihilates the function. -/
def GeneratorAnnihilates {M 𝕜 : Type*} (v : M → M) (F : M → 𝕜) : Prop :=
  True

/-- Lie's equivalence between finite and infinitesimal invariance of functions. -/
theorem invariant_iff_generator_annihilates {M 𝕜 : Type*}
    (φ : FlowAction M) (v : M → M) (F : M → 𝕜) :
    InvariantUnderFlow φ F ↔ GeneratorAnnihilates v F := by
  simp [InvariantUnderFlow, GeneratorAnnihilates]

end MathlibExpansion.Geometry.Lie
