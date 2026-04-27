import MathlibExpansion.Roots.ContinuousGaloisCohomology

/-!
# Mazur1989 Profinite-Factorization Wall — Re-Export

Module-hygiene dodge per doctrine v2: downstream Mazur1989 consumers
import **only this module** to access the profinite-factorization wall for
locally constant `H¹`, never the full
`MathlibExpansion.Roots.ContinuousGaloisCohomology` surface.

The re-exported definition is `LocallyConstantH1ProfiniteFactorizationWall`.
No bodies, no new definitions, no transitive contamination.
-/

namespace MathlibExpansion.Roots.Mazur1989

/-- Re-exported profinite-factorization wall under the Mazur1989 namespace.

See `MathlibExpansion.Roots.ContinuousGaloisCohomology.LocallyConstantH1ProfiniteFactorizationWall`
for the original definition and its missing-primitive documentation. -/
abbrev LocallyConstantH1ProfiniteFactorizationWall :=
  @MathlibExpansion.Roots.ContinuousGaloisCohomology.LocallyConstantH1ProfiniteFactorizationWall

end MathlibExpansion.Roots.Mazur1989
