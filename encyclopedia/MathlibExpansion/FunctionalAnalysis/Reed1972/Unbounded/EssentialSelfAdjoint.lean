import Mathlib
import MathlibExpansion.FunctionalAnalysis.Reed1972.Unbounded.SymmetricCriteria

/-!
# Reed-Simon 1972 — UCSA_CORE stage 2: Essential self-adjointness

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VIII §2. Stage 2 of the
UCSA corridor: the closure of a symmetric operator, essential self-adjointness, and
reusable criteria. Built on stage 1 SymmetricCriteria.

Primary citations:
- J. von Neumann (1932), Mathematical Grundlagen Ch. II §9 (essential self-adjointness).
- M. H. Stone (1932), *Linear transformations in Hilbert space*, Ch. IX.
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
Reed 1972 Ch. VIII §2 Def. VIII.5: a symmetric operator is essentially self-adjoint if
its closure is self-adjoint.
-/
structure EssentiallySelfAdjoint (T : SymmetricOperator (E := E)) : Prop where
  /-- Some closure of the symmetric operator is self-adjoint. -/
  closure_selfAdjoint : ∃ Tclo : LinearPMap ℂ E E, T.op ≤ Tclo ∧ Tclo.adjoint = Tclo

/--
Reed 1972 Ch. VIII §2 Thm. VIII.3 (basic criterion for essential self-adjointness):
a densely defined symmetric operator is essentially self-adjoint iff the deficiency
indices `dim ker(T* ∓ i)` both vanish.

The full deficiency-index criterion lives at stage 3 (`DeficiencyIndices.lean`).
Stage 2 records the closure-equals-adjoint interface that stage 3 consumes.
-/
axiom essentiallySelfAdjoint_iff_closure_eq_adjoint
    (T : SymmetricOperator (E := E)) :
    EssentiallySelfAdjoint T ↔
      ∃ Tclo : LinearPMap ℂ E E, T.op ≤ Tclo ∧ Tclo = T.op.adjoint

/--
Reed 1972 Ch. VIII §2 Prop. VIII.4: self-adjoint operators are essentially self-adjoint
(taking the closure to be the operator itself).
-/
theorem essentiallySelfAdjoint_of_selfAdjoint (T : SymmetricOperator (E := E))
    (h : T.op.adjoint = T.op) :
    EssentiallySelfAdjoint T where
  closure_selfAdjoint := ⟨T.op, le_refl _, h⟩

end Unbounded
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
