import Mathlib.Analysis.InnerProductSpace.Orthonormal
import Mathlib.Data.Set.Countable
import Mathlib.Topology.Bases
import Mathlib.Topology.Compactness.Lindelof
import Mathlib.Topology.MetricSpace.Pseudo.Defs
import Mathlib.Topology.UniformSpace.Cauchy

/-!
# Separable orthonormal families

This file packages the basic countability bridge needed by the von Neumann
Chapter II queue: an orthonormal family in a separable Hilbert space has
countable range.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

variable {𝕜 : Type*} {E : Type*} {ι : Type*}
variable [RCLike 𝕜] [NormedAddCommGroup E] [_root_.InnerProductSpace 𝕜 E]

/-- The range of an orthonormal family is a discrete subspace. -/
theorem orthonormal_range_discrete {v : ι → E} (hv : Orthonormal 𝕜 v) :
    DiscreteTopology (Set.range v) := by
  classical
  let hs : Orthonormal 𝕜 (Subtype.val : Set.range v → E) := hv.toSubtypeRange
  refine DiscreteTopology.of_forall_le_dist zero_lt_one ?_
  intro x y hxy
  have hinner : @inner 𝕜 _ _ (x : E) (y : E) = 0 := by
    simpa [hxy] using (orthonormal_iff_ite.mp hs x y)
  have hxnorm : ‖(x : E)‖ = 1 := hs.1 x
  have hynorm : ‖(y : E)‖ = 1 := hs.1 y
  have hdist_sq : dist (x : E) (y : E) ^ 2 = 2 := by
    rw [dist_eq_norm]
    have hsq := norm_sub_sq (𝕜 := 𝕜) (x := (x : E)) (y := (y : E))
    rw [hsq, hxnorm, hynorm]
    have hre : RCLike.re (@inner 𝕜 _ _ (x : E) (y : E)) = 0 := by
      simpa [hinner]
    norm_num [hre]
  have hnonneg : 0 ≤ dist (x : E) (y : E) := by positivity
  have hdist : 1 ≤ dist (x : E) (y : E) := by nlinarith
  simpa using hdist

/-- An orthonormal family in a separable Hilbert space has countable range. -/
theorem orthonormal_set_countable_of_separable {v : ι → E}
    (hsep : TopologicalSpace.SeparableSpace E)
    (hv : Orthonormal 𝕜 v) : Set.Countable (Set.range v) := by
  letI : TopologicalSpace.SeparableSpace E := hsep
  letI : DiscreteTopology (Set.range v) := orthonormal_range_discrete hv
  letI : SecondCountableTopology E := UniformSpace.secondCountable_of_separable (α := E)
  letI : SecondCountableTopology (Set.range v) := inferInstance
  simpa using (_root_.countable_of_Lindelof_of_discrete : Countable (Set.range v))

end InnerProductSpace
end Analysis
end MathlibExpansion
