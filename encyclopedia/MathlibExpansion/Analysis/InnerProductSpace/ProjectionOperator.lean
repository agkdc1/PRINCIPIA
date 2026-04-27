import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.NormedSpace.OperatorNorm.NormedSpace
import Mathlib.Analysis.InnerProductSpace.Projection
import Mathlib.LinearAlgebra.Projection

/-!
# Orthogonal projection operators

This file packages the basic bounded-operator facts about orthogonal
projections that later von Neumann lanes consume.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

variable {𝕜 : Type*} {E : Type*}
variable [RCLike 𝕜] [NormedAddCommGroup E] [_root_.InnerProductSpace 𝕜 E] [CompleteSpace E]

/-- The orthogonal projection onto `K`, viewed as an endomorphism of the ambient space. -/
def orthogonalProjectionEnd (K : Submodule 𝕜 E) [CompleteSpace K] : E →L[𝕜] E :=
  K.subtypeL ∘L orthogonalProjection K

/-- The orthogonal projection endomorphism is a projection onto the subspace. -/
theorem orthogonalProjectionEnd_isProj (K : Submodule 𝕜 E) [CompleteSpace K] :
    LinearMap.IsProj K ((orthogonalProjectionEnd (𝕜 := 𝕜) K : E →L[𝕜] E) : E →ₗ[𝕜] E) := by
  refine ⟨?_, ?_⟩
  · intro x
    exact (orthogonalProjection K x).2
  · intro x hx
    exact orthogonalProjection_eq_self_iff.mpr hx

/-- Orthogonal projections are idempotent as endomorphisms. -/
theorem orthogonalProjectionEnd_isIdempotentElem (K : Submodule 𝕜 E) [CompleteSpace K] :
    IsIdempotentElem (orthogonalProjectionEnd (𝕜 := 𝕜) K).toLinearMap := by
  have hproj :
      LinearMap.IsProj K ((orthogonalProjectionEnd (𝕜 := 𝕜) K : E →L[𝕜] E) : E →ₗ[𝕜] E) :=
    orthogonalProjectionEnd_isProj (𝕜 := 𝕜) K
  exact (LinearMap.isProj_iff_isIdempotentElem _).mp
    ⟨K, hproj⟩

/-- Orthogonal projections are self-adjoint. -/
theorem orthogonalProjectionEnd_isSelfAdjoint (K : Submodule 𝕜 E) [CompleteSpace K] :
    IsSelfAdjoint (orthogonalProjectionEnd (𝕜 := 𝕜) K) := by
  simpa [orthogonalProjectionEnd] using orthogonalProjection_isSelfAdjoint (𝕜 := 𝕜) (U := K)

/-- The endomorphism fixes precisely the vectors in the projected subspace. -/
theorem orthogonalProjectionEnd_eq_self_iff (K : Submodule 𝕜 E) [CompleteSpace K] {x : E} :
    orthogonalProjectionEnd (𝕜 := 𝕜) K x = x ↔ x ∈ K := by
  simpa [orthogonalProjectionEnd] using
    (orthogonalProjection_eq_self_iff (K := K) (v := x))

/-- The orthogonal projection endomorphism is contractive. -/
theorem orthogonalProjectionEnd_norm_le (K : Submodule 𝕜 E) [CompleteSpace K] :
    ‖orthogonalProjectionEnd (𝕜 := 𝕜) K‖ ≤ 1 := by
  calc
    ‖orthogonalProjectionEnd (𝕜 := 𝕜) K‖ ≤ ‖K.subtypeL‖ * ‖orthogonalProjection K‖ := by
      simpa [orthogonalProjectionEnd] using
        (ContinuousLinearMap.opNorm_comp_le (K.subtypeL) (orthogonalProjection K))
    _ ≤ 1 * 1 := by
      gcongr
      · exact Submodule.norm_subtypeL_le K
      · exact orthogonalProjection_norm_le (K := K)
    _ = 1 := by norm_num

end InnerProductSpace
end Analysis
end MathlibExpansion
