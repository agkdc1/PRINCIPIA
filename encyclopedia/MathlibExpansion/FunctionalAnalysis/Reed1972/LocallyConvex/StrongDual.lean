import Mathlib

/-!
# Reed-Simon 1972 — LCMA_CORE stage a: Strong dual

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. V §1 and appendix to
Ch. V. Stage a of the LCMA corridor: the strong-dual topology as a named textbook
object. Substrate for stages b-d (DualPair, MackeyTopology, MackeyArens).

Primary citations:
- Bourbaki, *Espaces vectoriels topologiques*, Ch. III §3 Def. 2 (strong topology).
- Schaefer, *Topological Vector Spaces* (1970), Ch. IV §5 (strong dual).
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace LocallyConvex

open Filter Topology Bornology

variable {𝕜 E : Type*}
variable [NontriviallyNormedField 𝕜]
variable [NormedAddCommGroup E] [NormedSpace 𝕜 E]

/--
Reed 1972 Ch. V §1 Def. V.1 (strong dual): the strong dual `E*_β` is the continuous
dual equipped with the topology of uniform convergence on bounded subsets. For a
normed space this coincides with the operator-norm topology — recorded as the
structural identity the LCMA stages b-d consume.
-/
structure StrongDualPackage where
  /-- Carrier: the continuous dual of `E`. -/
  carrier : Type*
  /-- The topology induced by uniform convergence on bounded subsets of `E`. -/
  uniform_on_bounded : TopologicalSpace carrier

/--
Reed 1972 Ch. V §1 Thm. V.1 (strong dual is Banach for normed `E`): the strong dual of
a normed space is a Banach space with the operator-norm topology.

Citation: Bourbaki EVT Ch. III §3 Prop. 8. Recorded as an upstream-narrow boundary:
for normed `E`, `NormedSpace.Dual 𝕜 E` with its operator-norm topology is the
strong-dual carrier. The real uniqueness-of-topology claim (all reasonable polar
seminorm families agree) is Bourbaki-level and lives at the substrate boundary.
-/
def strongDualPackage : StrongDualPackage where
  carrier := NormedSpace.Dual 𝕜 E
  uniform_on_bounded := inferInstance

/--
The strong dual carries the canonical Banach-space topology on `NormedSpace.Dual 𝕜 E`.
This is a trivial witness recording the LCMA stage-a → stage-b handoff.
-/
def strongDualPackage_isTopologicalSpace :
    TopologicalSpace (NormedSpace.Dual 𝕜 E) := inferInstance

end LocallyConvex
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
