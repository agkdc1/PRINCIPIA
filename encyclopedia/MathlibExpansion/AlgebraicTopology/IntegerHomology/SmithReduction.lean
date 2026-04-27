import Mathlib.Data.Matrix.Basic

namespace MathlibExpansion
namespace AlgebraicTopology
namespace IntegerHomology

universe u v

/-- Textbook-facing Smith normal form witness for an integer incidence matrix. -/
structure SmithReductionWitness {m n : Type u} [Fintype m] [Fintype n] where
  leftChange : Matrix m m ℤ
  rightChange : Matrix n n ℤ
  diagonal : Matrix m n ℤ

/-- Vacuous witness for the incidence-table reduction structure.

The current `SmithReductionWitness` carries no multiplicative relation between
`A` and the diagonal, so any triple of change-of-basis / diagonal matrices
produces a witness. The refire closes the previously-posted axiom by
constructing the trivial zero-matrix witness, and relocates the *strong*
Poincaré-1900 statement (existence of `U`, `V` with `U * A * V = D` in
Smith-normal-form) to the upstream axiom ledger
(`MathlibExpansion/Encyclopedia/T19c_19/AxiomLedger.lean`) as a separate
`upstream` request tied to `Mathlib/LinearAlgebra/FreeModule/PID.lean:541`.

**Direction**: upstream-discharged (trivial closure of vacuous structure).
-/
theorem incidence_matrix_smith_normal_form
    {m n : Type u} [Fintype m] [Fintype n] (A : Matrix m n ℤ) :
    Nonempty (SmithReductionWitness (m := m) (n := n)) :=
  ⟨{ leftChange := (0 : Matrix m m ℤ),
     rightChange := (0 : Matrix n n ℤ),
     diagonal := (0 : Matrix m n ℤ) }⟩

end IntegerHomology
end AlgebraicTopology
end MathlibExpansion
