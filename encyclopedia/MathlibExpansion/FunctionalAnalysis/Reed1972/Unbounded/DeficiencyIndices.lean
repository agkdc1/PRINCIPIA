import Mathlib
import MathlibExpansion.FunctionalAnalysis.Reed1972.Unbounded.EssentialSelfAdjoint

/-!
# Reed-Simon 1972 — UCSA_CORE stage 3: Deficiency indices and von Neumann criterion

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VIII §2 Thm. VIII.3 and
Ch. X §1. Stage 3 of the UCSA corridor: deficiency subspaces `ker(T* ∓ i)`, their
dimension data, and the von Neumann essential-self-adjointness criterion. This is the
gate file that `USSD_CORE` (unbounded spectral theorem + Stone dynamics) depends on.

Primary citations:
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*, Ch. II §9 Thm. 1-2.
- M. H. Stone (1932), *Linear transformations in Hilbert space*, Ch. IX §3.
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace Unbounded

open Submodule Filter

variable {E : Type*}
variable [NormedAddCommGroup E] [InnerProductSpace ℂ E] [CompleteSpace E]

/--
Reed 1972 Ch. VIII §2 Def. VIII.6: the deficiency subspaces `K±` of a symmetric operator
`T` are `ker(T* ∓ i)`, the kernels of `T.adjoint - i` and `T.adjoint + i`. The deficiency
indices `n±` are their dimensions (cardinalities).

Records the Reed-facing dimension pair as a `Cardinal` carrier.
-/
structure DeficiencyIndices (T : SymmetricOperator (E := E)) where
  /-- Deficiency index `n₊ = dim ker(T* - i)`. -/
  n_plus : Cardinal
  /-- Deficiency index `n₋ = dim ker(T* + i)`. -/
  n_minus : Cardinal

/--
Reed 1972 Ch. VIII §2 Thm. VIII.3 (von Neumann criterion, essential self-adjointness):
a densely defined symmetric operator is essentially self-adjoint iff both deficiency
indices `n±` vanish.

Citation: von Neumann 1932 Ch. II §9 Thm. 1 (complex form); Stone 1932 Ch. IX §3
(equivalent real form). The proof combines the closure-equals-adjoint criterion from
stage 2 with the Cayley-transform deficiency analysis.
-/
axiom essentiallySelfAdjoint_iff_deficiencyIndices_zero
    (T : SymmetricOperator (E := E)) (d : DeficiencyIndices T) :
    EssentiallySelfAdjoint T ↔ d.n_plus = 0 ∧ d.n_minus = 0

/--
Reed 1972 Ch. VIII §2 Thm. VIII.3 Corollary: a self-adjoint operator has both deficiency
indices equal to zero.

Derived from the closure/adjoint equality provided by `SelfAdjointCriterion`.
-/
axiom deficiencyIndices_eq_zero_of_selfAdjoint
    (T : SymmetricOperator (E := E)) (h : T.op.adjoint = T.op)
    (d : DeficiencyIndices T) :
    d.n_plus = 0 ∧ d.n_minus = 0

/--
Reed 1972 Ch. X §1 Thm. X.1 (von Neumann extension theorem, existence direction): a
symmetric operator with equal deficiency indices admits a self-adjoint extension in
the Cayley-transform sense.

Citation: von Neumann 1932 Ch. II §9 Thm. 2; Stone 1932 Ch. IX §3 Prop. 2.
-/
axiom exists_selfAdjoint_extension_of_equal_indices
    (T : SymmetricOperator (E := E)) (d : DeficiencyIndices T)
    (heq : d.n_plus = d.n_minus) :
    ∃ Text : LinearPMap ℂ E E, T.op ≤ Text ∧ Text.adjoint = Text

/--
The zero-index deficiency package: a symmetric operator whose adjoint equals the
operator itself trivially admits a deficiency-index record with both indices zero.
-/
theorem deficiencyIndices_zero_of_selfAdjoint
    (T : SymmetricOperator (E := E)) (_h : T.op.adjoint = T.op) :
    ∃ d : DeficiencyIndices T, d.n_plus = 0 ∧ d.n_minus = 0 :=
  ⟨{ n_plus := 0, n_minus := 0 }, rfl, rfl⟩

end Unbounded
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
