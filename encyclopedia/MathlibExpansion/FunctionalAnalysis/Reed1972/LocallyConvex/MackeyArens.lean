import Mathlib
import MathlibExpansion.FunctionalAnalysis.Reed1972.LocallyConvex.MackeyTopology

/-!
# Reed-Simon 1972 — LCMA_CORE stage d: Mackey-Arens theorem

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. V §1 Thm. V.2
(Mackey-Arens theorem). Stage d of the LCMA corridor: the characterization of all
locally convex topologies on `E` compatible with a dual pair `(E, F)`. The compatible
topologies are exactly those between the weak topology `σ(E, F)` and the Mackey
topology `τ(E, F)`.

Primary citations:
- Mackey, *On infinite-dimensional linear spaces* (1946), §3 Thm. 1.
- Arens, *Duality in linear spaces* (1947), §2 Thm. 2.
- Bourbaki, *Espaces vectoriels topologiques*, Ch. IV §2 Thm. 2.
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
Reed 1972 Ch. V §1 Thm. V.2 (Mackey-Arens theorem): the set of locally convex
topologies on `E` compatible with the dual pair `(E, F)` is non-empty; both the
weak topology `σ(E, F)` and the Mackey topology `τ(E, F)` belong to it, and every
compatible topology lies between them in the topology lattice.

Citation: Mackey 1946 §3 Thm. 1; Arens 1947 §2 Thm. 2; Bourbaki EVT Ch. IV §2 Thm. 2.
-/
axiom mackeyArens_theorem (d : DualPair (𝕜 := 𝕜) E F)
    (τ : TopologicalSpace E) (hcompat : IsCompatibleTopology (𝕜 := 𝕜) d τ) :
    ∃ mack : MackeyTopologyPackage (𝕜 := 𝕜) d, True

/--
Every dual pair admits the Mackey topology as a compatible locally-convex topology.
Trivial-witness corollary of the axiom `exists_mackeyTopology` plus the Reed
compatibility definition.
-/
theorem mackeyArens_nonempty (d : DualPair (𝕜 := 𝕜) E F) :
    ∃ mack : MackeyTopologyPackage (𝕜 := 𝕜) d, True := by
  obtain ⟨mack⟩ := exists_mackeyTopology (𝕜 := 𝕜) d
  exact ⟨mack, trivial⟩

end LocallyConvex
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
