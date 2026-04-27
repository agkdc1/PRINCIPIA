import Mathlib.Analysis.InnerProductSpace.Projection
import Mathlib.Analysis.InnerProductSpace.Subspace

/-!
# Fourier-series packaging for raw orthonormal families

This file records the closure-of-span / orthogonal-residual shell that is used
by the von Neumann queue before a family is bundled as a `HilbertBasis`.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

variable {𝕜 : Type*} {E : Type*} {ι : Type*}
variable [RCLike 𝕜] [NormedAddCommGroup E] [_root_.InnerProductSpace 𝕜 E] [CompleteSpace E]

/-- The closed linear span of a family. -/
def closedSpan (v : ι → E) : Submodule 𝕜 E :=
  (Submodule.span 𝕜 (Set.range v)).topologicalClosure

instance closedSpan.completeSpace (v : ι → E) :
    CompleteSpace (closedSpan (𝕜 := 𝕜) (E := E) (ι := ι) v) := by
  unfold closedSpan
  infer_instance

/-- Each vector in the family lies in its closed span. -/
theorem mem_closedSpan (v : ι → E) (i : ι) :
    v i ∈ closedSpan (𝕜 := 𝕜) (E := E) (ι := ι) v :=
  Submodule.le_topologicalClosure _ <| Submodule.subset_span <| Set.mem_range_self i

/-- The closed-span projection gives the textbook residual-orthogonality package. -/
theorem exists_projection_with_orthogonal_residual (v : ι → E) (x : E) :
    ∃ g ∈ closedSpan (𝕜 := 𝕜) (E := E) (ι := ι) v,
      ∀ i, @inner 𝕜 _ _ (x - g) (v i) = 0 := by
  let U : Submodule 𝕜 E := closedSpan (𝕜 := 𝕜) (E := E) (ι := ι) v
  refine ⟨orthogonalProjection U x, ?_, ?_⟩
  · show (orthogonalProjection U x : E) ∈ U
    exact Submodule.coe_mem _
  · intro i
    exact orthogonalProjection_inner_eq_zero (K := U) x (v i) (by simpa [U] using mem_closedSpan v i)

end InnerProductSpace
end Analysis
end MathlibExpansion
