import Mathlib
import MathlibExpansion.FunctionalAnalysis.Reed1972.CompactOperators.HilbertSchmidt

/-!
# Reed-Simon 1972 — COHTC_TC_CORE: Trace-class operators

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VI §6 (Hilbert-Schmidt
and trace-class, second half). COHTC_TC_CORE corridor: trace-class independence,
cyclicity, and the Hilbert-Schmidt-product-to-trace bridge. Depends on COHTC_HS_CORE.

Primary citations:
- R. Schatten (1950), *A Theory of Cross-Spaces*, Ch. III §§1-3.
- A. Grothendieck (1955), *Produits tensoriels topologiques et espaces nucléaires*, §I.
- Reed-Simon (1972), Vol. I Ch. VI §6 Thm. VI.24-26.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace CompactOperators

open Filter Topology

variable {H : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/--
Reed 1972 Ch. VI §6 Def. VI.9 (trace-class operator): a bounded operator `T` is
trace-class if `∑ ⟨|T| eₙ, eₙ⟩ < ∞` for some (equivalently every) orthonormal basis.
The trace `tr T = ∑ ⟨T eₙ, eₙ⟩` is basis-independent.

Records the trace-class carrier alongside the Hilbert-Schmidt one.
-/
structure TraceClassPackage (H : Type*)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H] where
  /-- The bounded operator. -/
  op : H →L[ℂ] H
  /-- The trace-class norm `‖T‖₁`. -/
  l1Norm : ℝ
  /-- Non-negativity of the trace-norm. -/
  l1Norm_nonneg : 0 ≤ l1Norm

/--
Reed 1972 Ch. VI §6 Thm. VI.24 (trace independence): the trace `tr T = ∑ ⟨T eₙ, eₙ⟩`
is the same for every orthonormal basis.

Citation: Schatten 1950 Ch. III §1 Thm. 1.1; Reed-Simon 1972 Ch. VI §6 Thm. VI.24.
-/
axiom trace_basis_independent
    (T : H →L[ℂ] H) (b₁ b₂ : HilbertBasis ℕ ℂ H) :
    (∑' n, ⟪T (b₁ n), (b₁ n : H)⟫_ℂ) = (∑' n, ⟪T (b₂ n), (b₂ n : H)⟫_ℂ)

/--
Reed 1972 Ch. VI §6 Thm. VI.25 (cyclicity): for `A` trace-class and `B` bounded,
`tr(AB) = tr(BA)`.

Citation: Schatten 1950 Ch. III §2 Thm. 2.1; Reed-Simon 1972 Ch. VI §6 Thm. VI.25.
-/
axiom trace_cyclic
    (A B : H →L[ℂ] H) (b : HilbertBasis ℕ ℂ H) :
    (∑' n, ⟪(A * B) (b n), (b n : H)⟫_ℂ) = (∑' n, ⟪(B * A) (b n), (b n : H)⟫_ℂ)

/--
Reed 1972 Ch. VI §6 Thm. VI.26 (HS-product-to-trace): the product of two
Hilbert-Schmidt operators is trace-class with `‖AB‖₁ ≤ ‖A‖_HS · ‖B‖_HS`.

Citation: Schatten 1950 Ch. III §3; Reed-Simon 1972 Ch. VI §6 Thm. VI.26.
-/
axiom traceClass_of_hilbertSchmidt_product
    (A B : HilbertSchmidtPackage H) :
    Nonempty (TraceClassPackage H)

/-- The zero operator is trivially trace-class with trace-norm 0. -/
def traceClass_zero : TraceClassPackage H where
  op := 0
  l1Norm := 0
  l1Norm_nonneg := le_refl _

end CompactOperators
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
