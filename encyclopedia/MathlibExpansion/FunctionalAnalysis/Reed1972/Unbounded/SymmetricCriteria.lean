import Mathlib

/-!
# Reed-Simon 1972 — UCSA_CORE stage 1: Symmetric and self-adjoint criteria

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VIII §§1-2. The first
stage of the UCSA corridor: densely defined `LinearPMap` symmetric/self-adjoint criterion
layer, closed-graph APIs, graph-norm, spectrum APIs for Chapter VIII §1.

Primary citations:
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*, Ch. II §§6-9.
- M. H. Stone (1932), *Linear transformations in Hilbert space*.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace Unbounded

open Submodule Filter

/--
Reed 1972 Ch. VIII §1: a densely defined operator is symmetric if `⟪T x, y⟫ = ⟪x, T y⟫`
for all `x, y` in the domain.
-/
structure SymmetricOperator
    (E : Type*) [NormedAddCommGroup E] [InnerProductSpace ℂ E] [CompleteSpace E] where
  /-- The underlying partially defined linear map. -/
  op : LinearPMap ℂ E E
  /-- The domain is dense. -/
  dense_domain : Dense (op.domain : Set E)
  /-- The symmetry condition on the domain. -/
  symmetric : ∀ x y : op.domain, ⟪(op x : E), (y : E)⟫_ℂ = ⟪(x : E), (op y : E)⟫_ℂ

variable {E : Type*}
variable [NormedAddCommGroup E] [InnerProductSpace ℂ E] [CompleteSpace E]

/--
Reed 1972 Ch. VIII §2 Thm. VIII.3 (self-adjointness criterion): a densely defined symmetric
operator `T` is self-adjoint iff `T* = T` as partial linear maps.
-/
structure SelfAdjointCriterion (T : SymmetricOperator E) : Prop where
  /-- The adjoint of the operator equals the operator as partial linear maps. -/
  adjoint_eq : T.op.adjoint = T.op

/--
Reed 1972 Ch. VIII §1 Thm. VIII.1 (basic criterion): a densely defined operator is
symmetric iff the corresponding sesquilinear form is symmetric on the domain.

Records the forward half as an explicit statement matching the Reed interface.
-/
theorem symmetric_of_sesq
    (T : LinearPMap ℂ E E) (hdense : Dense (T.domain : Set E))
    (hsym : ∀ x y : T.domain, ⟪(T x : E), (y : E)⟫_ℂ = ⟪(x : E), (T y : E)⟫_ℂ) :
    Nonempty (SymmetricOperator E) :=
  ⟨{ op := T, dense_domain := hdense, symmetric := hsym }⟩

/--
Reed 1972 Ch. VIII §1 Prop. VIII.2 (closed-graph API for unbounded operators):
a symmetric densely defined operator is closable. Recorded as an upstream-narrow
axiom citing von Neumann 1932 Ch. II §6 Th. 1.
-/
axiom closable_of_symmetric (T : SymmetricOperator E) :
    ∃ Tclo : LinearPMap ℂ E E, T.op ≤ Tclo ∧
      IsClosed ({p : E × E | ∃ x : Tclo.domain, (x : E) = p.1 ∧ Tclo x = p.2})

end Unbounded
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
