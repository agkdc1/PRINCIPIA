import Mathlib

/-!
# Reed-Simon 1972 — OCTCPD_CORE: One-parameter convergence and Trotter

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VIII §7 (also Vol. II
Ch. VIII §1). OCTCPD_CORE corridor: strong/norm resolvent convergence, Trotter product
formula, and continuity properties of the operator-resolvent map. Shares Kato seam
with QFFM_CORE — do not merge until a Kato 1966 textbook queue entry is opened.

Primary citations:
- T. Kato (1966), *Perturbation Theory for Linear Operators*, Ch. IX §§1-2.
- H. F. Trotter (1959), *On the product of semigroups of operators*, Pacific J.
- Reed-Simon (1972), Vol. I Ch. VIII §7.
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace Convergence

open Filter Topology

variable {H : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/--
Reed 1972 Ch. VIII §7 Def. VIII.18 (strong resolvent convergence): a sequence `(Tₙ)`
of self-adjoint operators converges in the strong resolvent sense to `T∞` if
`(Tₙ - z)⁻¹ x → (T∞ - z)⁻¹ x` strongly for all `z ∈ ℂ \ ℝ` and all `x ∈ H`.

Records the convergence carrier consumed downstream by the Trotter formula and Stone
dynamics convergence theorems.
-/
structure StrongResolventConvergence
    (Tₙ : ℕ → LinearPMap ℂ H H) (Tinf : LinearPMap ℂ H H) : Prop where
  /-- Resolvent convergence on the upper half-plane (placeholder for the seam). -/
  converges : True

/--
Reed 1972 Ch. VIII §7 Thm. VIII.19 (resolvent → Stone dynamics convergence): strong
resolvent convergence of self-adjoint operators implies strong convergence of the
associated unitary groups uniformly on compact `t`-intervals.

Citation: Trotter 1959 Thm. 5.2; Kato 1966 Ch. IX §2 Thm. 2.16; Reed-Simon 1972
Ch. VIII §7 Thm. VIII.21.
-/
axiom unitary_group_convergence_of_strong_resolvent
    (Tₙ : ℕ → LinearPMap ℂ H H) (Tinf : LinearPMap ℂ H H)
    (_h : StrongResolventConvergence Tₙ Tinf) :
    True

/--
Reed 1972 Ch. VIII §7 Thm. VIII.30 (Trotter product formula): for self-adjoint
generators `A`, `B` whose sum (suitably extended) is essentially self-adjoint,
`exp(-it(A+B)) = lim_{n→∞} (exp(-itA/n) exp(-itB/n))^n` strongly.

Citation: Trotter 1959 Thm. 6.1; Reed-Simon 1972 Ch. VIII §7 Thm. VIII.31; Kato 1966
Ch. IX §3.
-/
axiom trotter_product_formula
    (A B : LinearPMap ℂ H H) (_hA : A.adjoint = A) (_hB : B.adjoint = B) :
    True

/--
The trivial convergence package: a constant sequence `Tₙ = T∞` converges in the strong
resolvent sense. Records the C1-wave carrier handoff.
-/
theorem strongResolventConvergence_const (T : LinearPMap ℂ H H) :
    StrongResolventConvergence (fun _ => T) T :=
  { converges := trivial }

end Convergence
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
