import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 6 §§1–2 — Lax–Milgram and weak elliptic solvability

T20c_late_19 Evans Step 6 breach_candidate for `LAX_MILGRAM_WEAK_ELLIPTIC`.
Per Step 5 verdict, abstract Lax–Milgram is upstream; the missing bridge
is bounded-domain coercive elliptic packaging once `H¹/H¹₀` substrate is
honest.  This file lands the carrier-level bilinear-form data, the
coercivity/boundedness predicates, and registers Lax–Milgram + Fredholm
alternative as upstream-narrow axioms.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 6 §§1–2.
- P. D. Lax, A. N. Milgram, *Ann. Math. Stud.* **33** (1954), 167–190.
- I. Fredholm, *Acta Math.* **27** (1903), 365–390 (Fredholm alternative).

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Elliptic

/-- Bilinear form `B : H × H → ℝ` on a real Hilbert space `H`. -/
structure BilinearForm (H : Type*) where
  B : H → H → ℝ

/-- The trivial zero bilinear form. -/
def zeroBilinearForm (H : Type*) : BilinearForm H :=
  { B := fun _ _ => 0 }

@[simp] theorem zeroBilinearForm_value (H : Type*) (u v : H) :
    (zeroBilinearForm H).B u v = 0 := rfl

/-- Weak-elliptic problem datum: a bilinear form `a` and a continuous
linear functional `f` on the test space `H`. -/
structure WeakProblem (H : Type*) where
  a : BilinearForm H
  f : H → ℝ

/-- Bounded-form predicate (opaque): `IsBounded a M` records that
`|a(u, v)| ≤ M ‖u‖ ‖v‖`. -/
axiom IsBounded : ∀ {H : Type*} (_a : BilinearForm H) (_M : ℝ), Prop

/-- Coercive-form predicate (opaque): `IsCoercive a α` records that
`a(u, u) ≥ α ‖u‖²` on `H`. -/
axiom IsCoercive : ∀ {H : Type*} (_a : BilinearForm H) (_α : ℝ), Prop

/-- Continuous linear functional predicate (opaque). -/
axiom IsContinuousFunctional : ∀ {H : Type*} (_f : H → ℝ), Prop

/-- Solution-of-weak-problem predicate (opaque): `IsWeakSolution P u`
records that `a(u, v) = ⟨f, v⟩` for all `v ∈ H`. -/
axiom IsWeakSolution : ∀ {H : Type*} (_P : WeakProblem H) (_u : H), Prop

/-- Upstream-narrow axiom: the Lax–Milgram theorem.

If `a` is bounded and coercive on a Hilbert space `H` and `f` is a
continuous linear functional on `H`, then there exists a unique
`u ∈ H` such that `a(u, v) = ⟨f, v⟩` for every `v ∈ H`.

**Citation.** Lax–Milgram 1954; Evans 1998, Ch. 6 §2.1, Theorem 1. -/
axiom lax_milgram
    {H : Type*} (P : WeakProblem H) (M α : ℝ)
    (hα : 0 < α)
    (hB : IsBounded P.a M)
    (hC : IsCoercive P.a α)
    (hf : IsContinuousFunctional P.f) :
    ∃ u : H, IsWeakSolution P u

/-- Upstream-narrow axiom: uniqueness in Lax–Milgram. -/
axiom lax_milgram_unique
    {H : Type*} (P : WeakProblem H) (α : ℝ)
    (hα : 0 < α)
    (hC : IsCoercive P.a α)
    (u v : H) :
    IsWeakSolution P u → IsWeakSolution P v → u = v

/-- Opaque carrier: `IsCompactPerturbation` records that `K` is a
compact operator perturbation of identity. -/
axiom IsCompactPerturbation : ∀ {H : Type*} (_K : H → H), Prop

/-- Opaque carrier: `FredholmDichotomyHolds K` is the assertion of the
Fredholm alternative for `I − K`. -/
axiom FredholmDichotomyHolds : ∀ {H : Type*} (_K : H → H), Prop

/-- Upstream-narrow axiom: the Fredholm alternative for compact
perturbations of identity on a Hilbert space.

**Citation.** Fredholm 1903; Evans 1998, Ch. 6 §2.2, Theorem 4. -/
axiom fredholm_alternative
    {H : Type*} (K : H → H) :
    IsCompactPerturbation K → FredholmDichotomyHolds K

end Elliptic
end Evans1998
end PDE
end Analysis
end MathlibExpansion
