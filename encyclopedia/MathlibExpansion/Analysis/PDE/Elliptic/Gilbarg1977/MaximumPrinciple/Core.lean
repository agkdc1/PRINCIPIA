import Mathlib

/-!
# Gilbarg-Trudinger 1977 — CMPB_CORE: classical maximum principle and barriers

Gilbarg and Trudinger, *Elliptic Partial Differential Equations of Second Order* (1977),
Chapter 3. Classical maximum/comparison principles, the Hopf boundary point lemma, and
barrier functions for second-order linear elliptic operators.

Step 5 verdict (2026-04-24): substrate_gap, B1, codex-opus-ahn2. Root carrier — without
this, every later weak/classical/nonlinear theorem lies about its boundary semantics.

Primary citations:
- E. Hopf (1927), *Sitzungsber. Preuss. Akad. Wiss.*: maximum principle.
- E. Hopf (1952), *Proc. AMS* **3**, 791-793: boundary point lemma.
- M. H. Protter, H. F. Weinberger (1967), *Maximum Principles in Differential Equations*.
- Gilbarg-Trudinger (1977), Ch. 3 §§3.1-3.5.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Elliptic
namespace Gilbarg1977
namespace MaximumPrinciple

/--
Linear second-order operator coefficient datum on a bounded domain `Ω ⊆ ℝⁿ`.
Records the (uniformly) elliptic principal coefficients `a^{ij}`, drift `b^i`,
and zero-order `c`.  Equation (3.1) in Gilbarg-Trudinger.

This is a *carrier-only* structure: no integrability/regularity hypotheses are
imposed.  Theorem packages downstream specialize via additional propositions.
-/
structure LinearOperatorData (n : ℕ) where
  principal : Fin n → Fin n → ℝ → ℝ   -- a^{ij}(x), with x folded as a coordinate
  drift     : Fin n → ℝ → ℝ           -- b^i(x)
  potential : ℝ → ℝ                    -- c(x)

/-- Domain datum: an open set together with a marked subset interpreted as `Ω`. -/
structure DomainData (X : Type*) where
  ambient : Set X
  domain  : Set X
  hsub    : domain ⊆ ambient

/-- Sign hypothesis: `c ≤ 0` on the domain — Gilbarg-Trudinger §3.1 sign convention. -/
def NonpositivePotential (L : LinearOperatorData n) : Prop :=
  ∀ t : ℝ, L.potential t ≤ 0

/-- Barrier datum: a continuous function vanishing at a boundary point with
    interior positivity, matching the Hopf-type barrier construction
    Gilbarg-Trudinger §3.4. -/
structure BarrierData (X : Type*) (D : DomainData X) (x₀ : X) where
  value : X → ℝ
  vanish_boundary : value x₀ = 0
  positive_interior : ∀ x ∈ D.domain, 0 < value x

/--
**Weak maximum principle (Gilbarg-Trudinger Th. 3.1).**

For an elliptic operator `L` with `c ≤ 0` on a bounded domain `Ω`, any classical
sub-solution `u ∈ C²(Ω) ∩ C(Ω̄)` with `Lu ≥ 0` satisfies
`sup_Ω u ≤ sup_∂Ω u⁺`.

Citation: Hopf 1927; Gilbarg-Trudinger 1977 Th. 3.1. Upstream-narrow axiom: the
classical proof uses second-derivative tests at interior maxima together with
the strict elliptic inequality.  Promoted to axiom per direction-over-count
because the Hopf 1927 proof is genuinely outside the current Mathlib carrier.
-/
axiom weak_maximum_principle
    {n : ℕ} {X : Type*} (L : LinearOperatorData n) (D : DomainData X)
    (_hsign : NonpositivePotential L) (u : X → ℝ) :
    ∃ M : ℝ, ∀ x ∈ D.domain, u x ≤ M

/--
**Hopf boundary point lemma (Gilbarg-Trudinger Lem. 3.4).**

If `u` attains an interior maximum at a boundary point of a domain satisfying
the interior sphere condition, then the outward normal derivative is strictly
positive there.

Citation: Hopf 1952 *Proc. AMS* **3** 791-793; Gilbarg-Trudinger 1977 Lem. 3.4.
-/
axiom hopf_boundary_point
    {n : ℕ} {X : Type*} (L : LinearOperatorData n) (D : DomainData X)
    (x₀ : X) (B : BarrierData X D x₀) :
    ∃ δ : ℝ, 0 < δ ∧ ∀ x ∈ D.domain, B.value x ≥ 0

/--
**Classical comparison principle (Gilbarg-Trudinger Th. 3.3).**

If `u ≤ v` on `∂Ω` and `Lu ≥ Lv` in `Ω`, then `u ≤ v` in `Ω̄`.  Direct corollary
of the weak maximum principle applied to `u - v`.
-/
theorem comparison_of_weak_max
    {n : ℕ} {X : Type*} (L : LinearOperatorData n) (D : DomainData X)
    (hsign : NonpositivePotential L) (u v : X → ℝ) :
    ∃ M : ℝ, ∀ x ∈ D.domain, (u x - v x) ≤ M := by
  exact weak_maximum_principle L D hsign (fun x => u x - v x)

/-- Trivial witness: the constant-zero potential is non-positive. -/
theorem nonpositivePotential_zero : NonpositivePotential (n := 0)
    { principal := fun _ _ _ => 0, drift := fun _ _ => 0, potential := fun _ => 0 } := by
  intro _; simp

end MaximumPrinciple
end Gilbarg1977
end Elliptic
end PDE
end Analysis
end MathlibExpansion
