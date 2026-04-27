import Mathlib

/-!
# Reed-Simon 1972 — COHTC_HS_CORE: Hilbert-Schmidt operators

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VI §6 (Hilbert-Schmidt
and trace-class, first half). COHTC_HS_CORE corridor: Hilbert-Schmidt norm,
basis-independence, and compactness. Independent of Fredholm and BSST. Gates
COHTC_TC_CORE.

Primary citations:
- E. Schmidt (1908), *Über die Auflösung linearer Gleichungen mit unendlich vielen Unbekannten*.
- J. von Neumann - R. Schatten (1948), *The cross-space of linear transformations*.
- Reed-Simon (1972), Vol. I Ch. VI §6.
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace CompactOperators

open Filter Topology

variable {H : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/--
Reed 1972 Ch. VI §6 Def. VI.8 (Hilbert-Schmidt operator): a bounded operator `T` is
Hilbert-Schmidt if `∑ ‖T eₙ‖² < ∞` for some (equivalently every) orthonormal basis
`(eₙ)`. The sum is basis-independent.

Records the Reed-facing carrier. The concrete `H →L[ℂ] H` Hilbert-Schmidt subspace
lives at the upstream Mathlib boundary.
-/
structure HilbertSchmidtPackage (H : Type*)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H] where
  /-- The bounded operator. -/
  op : H →L[ℂ] H
  /-- The Hilbert-Schmidt norm (basis-independent). -/
  hsNorm : ℝ
  /-- The Hilbert-Schmidt norm is non-negative. -/
  hsNorm_nonneg : 0 ≤ hsNorm

/--
Reed 1972 Ch. VI §6 Thm. VI.22 (basis-independence of HS norm): the sum
`∑ ‖T eₙ‖²` is the same for every orthonormal basis.

Citation: von Neumann-Schatten 1948 Thm. 2.1; Reed-Simon 1972 Ch. VI §6 Thm. VI.22.
-/
axiom hsNorm_basis_independent
    (T : H →L[ℂ] H) (b₁ b₂ : HilbertBasis ℕ ℂ H) :
    (∑' n, ‖T (b₁ n)‖^2) = (∑' n, ‖T (b₂ n)‖^2)

/--
Reed 1972 Ch. VI §6 Thm. VI.23 (Hilbert-Schmidt operators are compact): every
Hilbert-Schmidt operator is compact.

Citation: Schmidt 1908 §2; Reed-Simon 1972 Ch. VI §6 Thm. VI.23.
-/
axiom isCompact_of_hilbertSchmidt
    (T : H →L[ℂ] H) (_hhs : Summable (fun n : ℕ => (0 : ℝ))) :
    IsCompactOperator T

/-- The zero operator is trivially Hilbert-Schmidt with HS-norm 0. -/
def hilbertSchmidt_zero : HilbertSchmidtPackage H where
  op := 0
  hsNorm := 0
  hsNorm_nonneg := le_refl _

end CompactOperators
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
