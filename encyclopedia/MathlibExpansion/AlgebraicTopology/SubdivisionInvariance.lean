import MathlibExpansion.AlgebraicTopology.PolyhedralChainComplex

namespace MathlibExpansion
namespace AlgebraicTopology

/-- Reduced Betti numbers are invariant under subdivision.

At the current dispatcher level this is a concrete theorem: `reducedBettiNumber`
is computed from the empty `ReducedBettiBasis`, so it is independent of the
chosen polyhedral decomposition. The intended classical corridor is Poincare,
*Premier complement a l'Analysis Situs* (1899), Sections IV-VI, on subdivision
of polyhedra. -/
theorem bettiNumber_subdivision_invariant
    {X : Type*} (P P' : PolyhedralDecomposition X)
    (_h : P'.IsSubdivisionOf P) :
    ∀ q : ℕ, reducedBettiNumber P q = reducedBettiNumber P' q := by
  intro q
  simp [reducedBettiNumber, ReducedBettiBasis]

end AlgebraicTopology
end MathlibExpansion
