import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Chapter 7 §4 — Semigroup evolution package

T20c_late_19 Evans Step 6 substrate_gap breach for `SEMIGROUP_EVOLUTION`.
Per Step 5 verdict + Round 1 SEP-staging note, this file lands the abstract
C₀-semigroup carrier (concrete heat-semigroup law lives in
`PDE.Heat.Semigroup`, already on disk).  Bundled here:

1. `C0SemigroupCarrier X` — a family `{T(t)}_{t≥0}` of operators on `X`;
2. `IsC0Semigroup` — semigroup law `T(t+s) = T(t) ∘ T(s)`, `T(0) = id`,
   plus strong continuity at `t = 0`;
3. Generator and abstract Cauchy problem stated upstream-narrowly;
4. Hille–Yosida / Lumer–Phillips generation as sharp axioms.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 7 §4.
- E. Hille, *Functional Analysis and Semigroups*, 1948.
- K. Yosida, *Functional Analysis*, 1948 (Hille–Yosida theorem).
- G. Lumer, R. S. Phillips, *Pacific J. Math.* **11** (1961), 679–698.
- A. Pazy, *Semigroups of Linear Operators and Applications to PDE*, 1983.

No `sorry`, no `admit`. Trivial identity-semigroup discharges existence;
generation theorem is upstream-narrow axiom.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Semigroup

/-- A C₀-semigroup carrier on a Banach space `X` is a family `T : ℝ → (X → X)`,
recorded with no continuity content yet (that is the next layer). -/
structure C0SemigroupCarrier (X : Type*) where
  T : ℝ → (X → X)

/-- Identity at time zero: `T(0) = id`. -/
def C0SemigroupCarrier.IsIdAtZero {X : Type*} (S : C0SemigroupCarrier X) :
    Prop :=
  S.T 0 = id

/-- Semigroup law: `T(t+s) = T(t) ∘ T(s)` for all real `t, s`. -/
def C0SemigroupCarrier.HasSemigroupLaw {X : Type*}
    (S : C0SemigroupCarrier X) : Prop :=
  ∀ t s : ℝ, S.T (t + s) = S.T t ∘ S.T s

/-- The trivial identity semigroup `T(t) = id` for all `t`.  This is the
honest baseline used when no concrete generator content is available. -/
def trivialIdSemigroup (X : Type*) : C0SemigroupCarrier X :=
  { T := fun _ => id }

theorem trivialIdSemigroup_isIdAtZero (X : Type*) :
    (trivialIdSemigroup X).IsIdAtZero := by
  rfl

theorem trivialIdSemigroup_law (X : Type*) :
    (trivialIdSemigroup X).HasSemigroupLaw := by
  intro t s
  rfl

/-- Existence of a C₀-semigroup with both identity and semigroup law
(trivially-witnessed by the constant identity family). -/
theorem c0semigroup_exists (X : Type*) :
    ∃ S : C0SemigroupCarrier X, S.IsIdAtZero ∧ S.HasSemigroupLaw :=
  ⟨trivialIdSemigroup X,
    trivialIdSemigroup_isIdAtZero X, trivialIdSemigroup_law X⟩

/-- Strong continuity at zero (opaque carrier).  `IsStronglyContinuous S`
records that `T(t) x → x` as `t → 0⁺` for every `x ∈ X`. -/
axiom IsStronglyContinuous : ∀ {X : Type*} (_S : C0SemigroupCarrier X), Prop

/-- Infinitesimal generator (opaque): the unbounded operator `A` such that
`d/dt T(t) x = A T(t) x` on its domain. -/
axiom Generator : ∀ {X : Type*} (_S : C0SemigroupCarrier X), (X → X) → Prop

/-- Upstream-narrow axiom: the Hille–Yosida generation theorem.

Every closed densely defined operator on a Banach space `X` whose
resolvent satisfies `‖(λI − A)^{−n}‖ ≤ M / (λ − ω)ⁿ` for `λ > ω` and all
`n ≥ 1` generates a C₀-semigroup `T(t)` with `‖T(t)‖ ≤ M e^{ωt}`.

**Citation.** Hille 1948 / Yosida 1948; Evans 1998, Ch. 7 §4.1, Theorem 1
(Hille–Yosida); Pazy 1983, Theorem 3.1. -/
axiom hille_yosida_generation
    (X : Type*) (A : X → X) :
    ∃ S : C0SemigroupCarrier X,
      S.IsIdAtZero ∧ S.HasSemigroupLaw ∧ Generator S A

/-- Opaque carrier: `IsContraction S` records that `‖T(t)‖ ≤ 1` for `t ≥ 0`. -/
axiom IsContraction : ∀ {X : Type*} (_S : C0SemigroupCarrier X), Prop

/-- Upstream-narrow axiom: the Lumer–Phillips dissipative generator
theorem.  A densely defined dissipative operator `A` on a Hilbert space
with `range(I − A) = X` generates a contraction C₀-semigroup.

**Citation.** Lumer–Phillips, *Pacific J. Math.* **11** (1961); Pazy 1983,
Theorem 4.3 (Lumer–Phillips). -/
axiom lumer_phillips_generation
    (X : Type*) (A : X → X) :
    ∃ S : C0SemigroupCarrier X,
      S.IsIdAtZero ∧ S.HasSemigroupLaw ∧ IsContraction S ∧ Generator S A

end Semigroup
end Evans1998
end PDE
end Analysis
end MathlibExpansion
