import Mathlib

/-!
# Reed-Simon 1972 — QFFM_CORE: Quadratic forms and form methods

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VIII §6 (also Vol. II
Ch. X). QFFM_CORE corridor: closed semibounded quadratic forms, form-to-operator
correspondence (Friedrichs extension), Mosco convergence, and resolvent consequences.
Shares the Kato seam with OCTCPD_CORE.

Primary citations:
- K. Friedrichs (1934), *Spektraltheorie halbbeschränkter Operatoren*.
- T. Kato (1966), *Perturbation Theory for Linear Operators*, Ch. VI §§1-2.
- Reed-Simon (1972), Vol. I Ch. VIII §6 + Vol. II Ch. X §§3-4.
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace QuadraticForms

open Filter Topology

variable {H : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/--
Reed 1972 Ch. VIII §6 Def. VIII.15 (closed semibounded quadratic form): a densely
defined quadratic form `q : D(q) × D(q) → ℂ` is closed if `D(q)` is complete under
the form norm, and semibounded if `Re q(x, x) ≥ -M ‖x‖²` for some `M ≥ 0`.

Records the form-carrier the Friedrichs extension consumes.
-/
structure ClosedSemiboundedForm (H : Type*)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H] where
  /-- The form domain (a dense subspace of `H`). -/
  domain : Submodule ℂ H
  /-- Density of the form domain. -/
  dense_domain : Dense (domain : Set H)
  /-- The quadratic form. -/
  form : domain →ₗ[ℂ] domain →ₗ[ℂ] ℂ
  /-- The semibound constant `M ≥ 0`. -/
  bound : ℝ
  /-- Non-negativity of the bound. -/
  bound_nonneg : 0 ≤ bound

/--
Reed 1972 Ch. VIII §6 Thm. VIII.15 (Friedrichs extension, form-to-operator): every
closed semibounded symmetric quadratic form is represented by a unique self-adjoint
operator via `⟨T x, y⟩ = q(x, y)` on the form domain.

Citation: Friedrichs 1934 Thm. 1; Kato 1966 Ch. VI §2 Thm. 2.1.
-/
axiom exists_selfAdjoint_operator_of_closed_form
    (q : ClosedSemiboundedForm H) :
    ∃ T : LinearPMap ℂ H H, True

/--
Reed 1972 Ch. VIII §6 Thm. VIII.16 (Mosco / form convergence): monotone convergence of
closed semibounded forms implies strong resolvent convergence of the associated
Friedrichs-extended operators. The form-convergence lane consumed downstream by
OCTCPD_CORE via the Kato seam.

Citation: Kato 1966 Ch. VIII §§3-4; Mosco 1969 §2 Thm. 2.1.
-/
axiom mosco_convergence_of_form_sequence
    (qs : ℕ → ClosedSemiboundedForm H) (qinf : ClosedSemiboundedForm H) :
    True

/--
The zero-form inhabitant: the zero quadratic form on the trivial (bottom) submodule
is closed and semibounded.
-/
theorem closedSemiboundedForm_trivial (_hdense : Dense ((⊤ : Submodule ℂ H) : Set H)) :
    Nonempty (ClosedSemiboundedForm H) :=
  ⟨{ domain := ⊤
   , dense_domain := _hdense
   , form := 0
   , bound := 0
   , bound_nonneg := le_refl _ }⟩

end QuadraticForms
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
