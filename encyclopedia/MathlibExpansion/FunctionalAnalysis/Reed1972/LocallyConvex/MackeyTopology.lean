import Mathlib
import MathlibExpansion.FunctionalAnalysis.Reed1972.LocallyConvex.DualPair

/-!
# Reed-Simon 1972 — LCMA_CORE stage c: Mackey topology

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. V §1. Stage c of the
LCMA corridor: the Mackey topology `τ(E, F)`, the finest locally convex topology on
`E` compatible with the dual pair `(E, F)`. Substrate for stage d (Mackey-Arens
theorem) and downstream weak-topology arguments.

Primary citations:
- Mackey, *On infinite-dimensional linear spaces* (1946), §3 Thm. 1.
- Bourbaki, *Espaces vectoriels topologiques*, Ch. IV §2 Def. 1 (Mackey topology).
- Schaefer, *Topological Vector Spaces* (1970), Ch. IV §3.2.
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
Reed 1972 Ch. V §1 Def. V.4 (Mackey topology `τ(E, F)`): the topology on `E` of
uniform convergence on absolutely convex weakly compact subsets of `F`. Structurally
the finest locally convex topology on `E` compatible with the pair `(E, F)`.

Recorded as a structural carrier. The actual topology construction (polar of an
absolutely convex weakly compact set) lives at the Bourbaki TVS substrate boundary.
-/
structure MackeyTopologyPackage (d : DualPair (𝕜 := 𝕜) E F) where
  /-- The Mackey topology on `E`, recorded as a `TopologicalSpace` carrier. -/
  mackeyTop : TopologicalSpace E
  /-- The Mackey topology is compatible with the dual pair. -/
  compatible : IsCompatibleTopology (𝕜 := 𝕜) d mackeyTop

/--
Reed 1972 Ch. V §1 Thm. V.2 (Mackey topology exists): for any dual pair `(E, F)` a
Mackey topology exists. Upstream-narrow axiom citing Mackey 1946 and Bourbaki TVS
Ch. IV §2.

The polar construction (weakly compact absolutely convex sets in `F`) sits at the
Bourbaki TVS substrate boundary: the Reed-facing claim is that such a topology
exists and is compatible.
-/
axiom exists_mackeyTopology (d : DualPair (𝕜 := 𝕜) E F) :
    Nonempty (MackeyTopologyPackage (𝕜 := 𝕜) d)

end LocallyConvex
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
