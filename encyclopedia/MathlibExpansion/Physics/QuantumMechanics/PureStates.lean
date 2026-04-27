import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.Projection
import Mathlib.LinearAlgebra.Projectivization.Basic

/-!
# Pure-state projectors

This file packages the rank-one projector attached to a ray in a complex
Hilbert space.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Physics
namespace QuantumMechanics

variable {E : Type*}
variable [NormedAddCommGroup E] [_root_.InnerProductSpace ℂ E] [CompleteSpace E]

local notation "⟪" x ", " y "⟫" => @inner ℂ _ _ x y

/-- The rank-one orthogonal projector attached to a nonzero vector. -/
def pureProjector (φ : E) : E →L[ℂ] E :=
  (ℂ ∙ φ).subtypeL ∘L orthogonalProjection (ℂ ∙ φ)

/-- The projector onto a unit ray has the textbook rank-one formula. -/
theorem pureProjector_apply (φ ψ : E) (hφ : ‖φ‖ = 1) :
    pureProjector φ ψ = ⟪φ, ψ⟫ • φ := by
  simpa [pureProjector] using orthogonalProjection_unit_singleton (𝕜 := ℂ) hφ ψ

/-- Pure projectors are self-adjoint. -/
theorem pureProjector_isSelfAdjoint (φ : E) :
    IsSelfAdjoint (pureProjector φ) := by
  simpa [pureProjector] using orthogonalProjection_isSelfAdjoint (𝕜 := ℂ) (U := ℂ ∙ φ)

/-- Pure projectors are idempotent on unit vectors. -/
theorem pureProjector_apply_apply (φ ψ : E) (hφ : ‖φ‖ = 1) :
    pureProjector φ (pureProjector φ ψ) = pureProjector φ ψ := by
  change (orthogonalProjection (ℂ ∙ φ) (pureProjector φ ψ) : E) = pureProjector φ ψ
  refine (orthogonalProjection_eq_self_iff (K := ℂ ∙ φ) (v := pureProjector φ ψ)).2 ?_
  change (orthogonalProjection (ℂ ∙ φ) ψ : E) ∈ ℂ ∙ φ
  exact (orthogonalProjection (ℂ ∙ φ) ψ).2

end QuantumMechanics
end Physics
end MathlibExpansion
