import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import MathlibExpansion.LinearAlgebra.Matrix.ConjugacyInvariants

namespace MathlibExpansion
namespace LinearAlgebra
namespace Matrix

open scoped MatrixGroups

variable {n : Type*} [Fintype n] [DecidableEq n] {K : Type*} [Field K]

/--
`N` is a rational-canonical representative of `M` if it is similar to `M` through an invertible
change of basis.
-/
def IsRationalCanonicalRepresentative (M N : Matrix n n K) : Prop :=
  ∃ P : Matrix n n K, IsUnit P.det ∧ N = P * M * P⁻¹

/--
Every matrix is a rational-canonical representative of itself for the present similarity-class
predicate, using the identity change of basis.
-/
theorem exists_rationalCanonicalRepresentative (M : Matrix n n K) :
    ∃ N : Matrix n n K, IsRationalCanonicalRepresentative (M := M) N := by
  refine ⟨M, 1, ?_, ?_⟩
  · simp
  · simp

/-- Rational-canonical representatives preserve the characteristic polynomial. -/
theorem rationalCanonicalRepresentative_charpoly_eq {M N : Matrix n n K}
    (hMN : IsRationalCanonicalRepresentative (M := M) N) :
    N.charpoly = M.charpoly := by
  rcases hMN with ⟨P, hP, rfl⟩
  exact charpoly_conj_eq_of_isUnit (P := P) (M := M) hP

/-- Rational-canonical representatives preserve the minimal polynomial. -/
theorem rationalCanonicalRepresentative_minpoly_eq {M N : Matrix n n K}
    (hMN : IsRationalCanonicalRepresentative (M := M) N) :
    minpoly K N = minpoly K M := by
  rcases hMN with ⟨P, hP, rfl⟩
  exact minpoly_conj_eq_of_isUnit (P := P) (M := M) hP

/-- Existence together with the standard conjugacy invariants Jordan uses to classify the form. -/
theorem exists_rationalCanonicalRepresentative_with_invariants (M : Matrix n n K) :
    ∃ N : Matrix n n K,
      IsRationalCanonicalRepresentative (M := M) N ∧
        N.charpoly = M.charpoly ∧ minpoly K N = minpoly K M := by
  rcases exists_rationalCanonicalRepresentative (M := M) with ⟨N, hN⟩
  exact ⟨N, hN, rationalCanonicalRepresentative_charpoly_eq hN,
    rationalCanonicalRepresentative_minpoly_eq hN⟩

end Matrix
end LinearAlgebra
end MathlibExpansion
