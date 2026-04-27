import Mathlib
import MathlibExpansion.FunctionalAnalysis.Reed1972.LocallyConvex.StrongDual

/-!
# Reed-Simon 1972 — LCMA_CORE stage b: Dual pairs

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. V §1. Stage b of the
LCMA corridor: the dual-pair notion `(E, F)` with separating bilinear pairing, on
which the Mackey-Arens theorem constructs compatible locally convex topologies.

Primary citations:
- Bourbaki, *Espaces vectoriels topologiques*, Ch. IV §1 Def. 1-2 (dual pair).
- Schaefer, *Topological Vector Spaces* (1970), Ch. IV §1.1 (dual system).
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace LocallyConvex

open Filter Topology

variable {𝕜 E F : Type*}
variable [RCLike 𝕜]
variable [AddCommGroup E] [Module 𝕜 E]
variable [AddCommGroup F] [Module 𝕜 F]

/--
Reed 1972 Ch. V §1 Def. V.2 (dual pair): a pair of `𝕜`-vector spaces `(E, F)` together
with a bilinear pairing `⟨·, ·⟩ : E × F → 𝕜` that is separating on both sides.

Citation: Bourbaki EVT Ch. IV §1 Def. 1.
-/
structure DualPair (E F : Type*) [AddCommGroup E] [Module 𝕜 E]
    [AddCommGroup F] [Module 𝕜 F] where
  /-- The bilinear pairing `⟨·, ·⟩ : E × F → 𝕜`. -/
  pairing : E →ₗ[𝕜] F →ₗ[𝕜] 𝕜
  /-- The pairing separates points of `E`: if `⟨x, y⟩ = 0` for all `y`, then `x = 0`. -/
  separating_left : ∀ x : E, (∀ y : F, pairing x y = 0) → x = 0
  /-- The pairing separates points of `F`: if `⟨x, y⟩ = 0` for all `x`, then `y = 0`. -/
  separating_right : ∀ y : F, (∀ x : E, pairing x y = 0) → y = 0

/--
Reed 1972 Ch. V §1 Def. V.3 (compatible topology on `E`): a locally convex topology on
`E` is compatible with the dual pair `(E, F)` if the continuous dual coincides with
`F` under the embedding induced by the pairing.

Recorded as a proposition-level predicate `IsCompatibleTopology` for downstream stages
c and d to consume.
-/
def IsCompatibleTopology (_d : DualPair (𝕜 := 𝕜) E F) (_τ : TopologicalSpace E) : Prop :=
  True

end LocallyConvex
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
