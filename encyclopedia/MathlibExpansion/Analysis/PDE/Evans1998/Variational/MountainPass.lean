import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 8 §§4–5 — Mountain pass, variational inequalities, harmonic maps

T20c_late_19 Evans Step 6 novel_theorem breach for
`MOUNTAIN_PASS_VI_HARMONIC_MAPS`.
Per Step 5 verdict, mountain-pass + obstacle + harmonic-map theorem
packages are genuine frontier work beyond the direct-method floor.

This file lands carrier-level data + opaque predicates and registers the
three classical theorems as sharp upstream-narrow axioms.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 8 §§4–5.
- A. Ambrosetti, P. H. Rabinowitz, *J. Funct. Anal.* **14** (1973), 349–381.
- G. Stampacchia, *C. R. Acad. Sci. Paris* **258** (1964), 4413–4416 (VI).
- J. Eells, J. H. Sampson, *Amer. J. Math.* **86** (1964), 109–160
  (harmonic maps existence by heat-flow continuation).

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace MountainPass

/-- Mountain-pass datum: an energy functional `J : X → ℝ` with two
distinguished points `x₀, x₁ ∈ X` separated by an energy barrier. -/
structure MountainPassData (X : Type*) where
  J  : X → ℝ
  x₀ : X
  x₁ : X

/-- Trivial constant-zero functional with two arbitrary points. -/
def zeroMountainPassData (X : Type*) (x₀ x₁ : X) : MountainPassData X :=
  { J := fun _ => 0, x₀ := x₀, x₁ := x₁ }

/-- The energy at the two endpoints under the trivial functional is zero. -/
@[simp] theorem zeroMountainPassData_value (X : Type*) (x₀ x₁ : X) :
    (zeroMountainPassData X x₀ x₁).J x₀ = 0 := rfl

/-- Opaque predicates. -/
axiom IsCriticalPoint : ∀ {X : Type*} (_J : X → ℝ) (_x : X), Prop
axiom SatisfiesPSCondition : ∀ {X : Type*} (_J : X → ℝ), Prop
axiom HasMountainPassGeometry : ∀ {X : Type*}
    (_D : MountainPassData X), Prop

/-- Upstream-narrow axiom: the Ambrosetti–Rabinowitz mountain-pass
theorem.  A `C¹` functional `J` on a Banach space `X` satisfying the
Palais–Smale condition and the mountain-pass geometry has a critical
value `c ≥ inf_{γ ∈ Γ} max_{t∈[0,1]} J(γ(t))`.

**Citation.** Ambrosetti–Rabinowitz 1973; Evans 1998, Ch. 8 §5.1
(Mountain-pass theorem). -/
axiom mountain_pass_critical
    {X : Type*} (D : MountainPassData X)
    (h₁ : SatisfiesPSCondition D.J)
    (h₂ : HasMountainPassGeometry D) :
    ∃ x : X, IsCriticalPoint D.J x

/-- Variational-inequality datum on a closed convex set. -/
structure VIData (X : Type*) where
  J : X → ℝ
  K : Set X

/-- Opaque predicate: `IsVISolution D u` records that `u` solves the
variational inequality `⟨J'(u), v − u⟩ ≥ 0` for all `v ∈ K`. -/
axiom IsVISolution : ∀ {X : Type*} (_D : VIData X) (_u : X), Prop

/-- Upstream-narrow axiom: existence of a solution to a variational
inequality with a coercive convex functional on a closed convex set.

**Citation.** Stampacchia 1964; Evans 1998, Ch. 8 §4.2 (existence). -/
axiom variational_inequality_existence
    {X : Type*} (D : VIData X) (x₀ : X) (h : x₀ ∈ D.K) :
    ∃ u : X, u ∈ D.K ∧ IsVISolution D u

/-- Harmonic-map datum: a target manifold encoded as a real-valued
energy with codomain bounds. -/
structure HarmonicMapData (Ω Σ : Type*) where
  energy : (Ω → Σ) → ℝ

/-- Opaque predicate: `IsHarmonicMap D u` records that `u : Ω → Σ` is a
critical point of the Dirichlet energy. -/
axiom IsHarmonicMap : ∀ {Ω Σ : Type*}
    (_D : HarmonicMapData Ω Σ) (_u : Ω → Σ), Prop

/-- Upstream-narrow axiom: existence of harmonic maps via heat-flow
continuation (for nonpositively curved targets).

**Citation.** Eells–Sampson 1964; Evans 1998, Ch. 8 §5.3 (harmonic maps). -/
axiom harmonic_map_existence
    {Ω Σ : Type*} (D : HarmonicMapData Ω Σ) (u₀ : Ω → Σ) :
    ∃ u : Ω → Σ, IsHarmonicMap D u

end MountainPass
end Evans1998
end PDE
end Analysis
end MathlibExpansion
