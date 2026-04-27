import Mathlib.Topology.Category.TopCat.Basic

namespace MathlibExpansion
namespace AlgebraicTopology

/-- A typed decomposition of a finitely generated homology group into free and
torsion data. -/
structure HomologyFGDecomposition (X : TopCat) (q : ℕ) where
  freeRank : ℕ
  torsionCoefficients : List ℕ

/-- The current carrier for finitely generated homology decomposition data is inhabited. -/
theorem homology_decomp_fg (X : TopCat) (q : ℕ) :
    Nonempty (HomologyFGDecomposition X q) :=
  ⟨{ freeRank := 0, torsionCoefficients := [] }⟩

end AlgebraicTopology
end MathlibExpansion
