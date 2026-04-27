import Mathlib

/-!
# Special linear homogeneous Lie examples
-/

namespace MathlibExpansion.Lie.Examples

/-- A placeholder carrier for Lie's special linear homogeneous algebra. -/
abbrev SpecialLinearHomogeneousLie (K : Type*) (n : Nat) :=
  Matrix (Fin (n + 1)) (Fin (n + 1)) K

/--
The full-matrix placeholder is not a simple Lie algebra in dimension one.

This discharges the former broad axiom
`specialLinearHomogeneous_isSimple : ∀ n, LieAlgebra.IsSimple K (Matrix (Fin (n+1)) (Fin (n+1)) K)`,
which was not a citation-backed version of Lie's special-linear simplicity theorem: at `n = 0`
the carrier is the abelian Lie algebra of `1 x 1` matrices.
-/
theorem specialLinearHomogeneous_not_isSimple_zero {K : Type*} [Field K] :
    ¬ LieAlgebra.IsSimple K (SpecialLinearHomogeneousLie K 0) := by
  intro h
  apply h.non_abelian
  exact ⟨fun A B => by
    rw [LieRing.of_associative_ring_bracket]
    ext i j
    fin_cases i
    fin_cases j
    simp [Matrix.mul_apply, Fin.sum_univ_one, mul_comm]⟩

end MathlibExpansion.Lie.Examples
