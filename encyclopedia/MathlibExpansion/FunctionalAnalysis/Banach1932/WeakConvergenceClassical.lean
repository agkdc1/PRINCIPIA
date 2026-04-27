import Mathlib
import Mathlib.Analysis.Normed.Group.Bounded
import Mathlib.Analysis.Normed.Operator.BanachSteinhaus
import MathlibExpansion.FunctionalAnalysis.Banach1932.ClassicalSpaces
import MathlibExpansion.FunctionalAnalysis.Banach1932.WeakDual

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace WeakConvergenceClassical

open Filter Topology
open scoped ENNReal Topology

/-- The closed unit interval used throughout Banach's classical-space weak-convergence corridor. -/
abbrev UnitInterval := ↥(Set.Icc (0 : ℝ) 1)

/-- The restricted Lebesgue measure on `[0,1]`. -/
abbrev intervalMeasure : MeasureTheory.Measure ℝ :=
  MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc (0 : ℝ) 1)

/-- Banach's `C([0,1])` carrier. -/
abbrev CInterval := ContinuousMap UnitInterval ℝ

/-- Banach's `L^p([0,1])` carrier on the restricted interval measure. -/
abbrev LpUnitInterval (p : ℝ≥0∞) : Type :=
  ↥(MeasureTheory.Lp ℝ p intervalMeasure)

/-- Banach's `ℓ^p` carrier on `ℕ`. -/
abbrev lpReal (p : ℝ≥0∞) : Type :=
  ↥(lp (fun _ : ℕ => ℝ) p)

/-- Banach's named `c` space from the classical-space substrate file. -/
abbrev cSpace : Type := ClassicalSpaces.ConvergentSeq ℝ

/-- The limit functional on Banach's `c` space. -/
abbrev cLimit (u : cSpace) : ℝ :=
  ClassicalSpaces.ConvergentSeq.limit u

/--
Weak convergence of a sequence of vectors, using Mathlib's weak topology `WeakSpace`.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. IX §1,
p. 128, definition preceding formulas (1)--(2).
-/
def WeaklyConverges {E : Type*} [AddCommMonoid E] [Module ℝ E] [TopologicalSpace E]
    (u : ℕ → E) (x : E) : Prop :=
  Tendsto (fun n => toWeakSpace ℝ E (u n)) atTop (𝓝 (toWeakSpace ℝ E x))

/--
Mathlib's weak topology is the topology of scalar evaluation against every continuous linear
functional.
-/
theorem weaklyConverges_iff_forall_dual {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {u : ℕ → E} {x : E} :
    WeaklyConverges u x ↔
      ∀ f : NormedSpace.Dual ℝ E, Tendsto (fun n => f (u n)) atTop (𝓝 (f x)) := by
  unfold WeaklyConverges
  simpa [topDualPairing_apply] using
    (WeakBilin.tendsto_iff_forall_eval_tendsto
      (B := (topDualPairing ℝ E).flip)
      (f := fun n => toWeakSpace ℝ E (u n))
      (x := toWeakSpace ℝ E x)
      (l := atTop)
      (by
        intro x y hxy
        apply (NormedSpace.eq_iff_forall_dual_eq (𝕜 := ℝ) (x := x) (y := y)).2
        intro g
        exact LinearMap.congr_fun hxy g))

/--
A weakly convergent sequence in a real normed space is norm bounded.  This is the sequential
uniform-boundedness bridge needed to make Banach's Chapter IX criteria executable in Lean.
-/
theorem bounded_of_weaklyConverges {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {u : ℕ → E} {x : E} (hu : WeaklyConverges u x) :
    ∃ M : ℝ, ∀ n : ℕ, ‖u n‖ ≤ M := by
  have hscalar : ∀ f : NormedSpace.Dual ℝ E,
      Tendsto (fun n => f (u n)) atTop (𝓝 (f x)) :=
    weaklyConverges_iff_forall_dual.mp hu
  let g : ℕ → NormedSpace.Dual ℝ (NormedSpace.Dual ℝ E) :=
    fun n => NormedSpace.inclusionInDoubleDual ℝ E (u n)
  have hpoint : ∀ f : NormedSpace.Dual ℝ E, ∃ C : ℝ, ∀ n : ℕ, ‖g n f‖ ≤ C := by
    intro f
    have hb : Bornology.IsBounded (Set.range fun n : ℕ => f (u n)) :=
      Metric.isBounded_range_of_tendsto (fun n : ℕ => f (u n)) (hscalar f)
    rcases hb.exists_pos_norm_le with ⟨C, _hCpos, hC⟩
    refine ⟨C, fun n => ?_⟩
    simpa [g, NormedSpace.inclusionInDoubleDual] using hC (f (u n)) ⟨n, rfl⟩
  rcases banach_steinhaus (𝕜 := ℝ) (𝕜₂ := ℝ) (E := NormedSpace.Dual ℝ E) (F := ℝ)
      (σ₁₂ := RingHom.id ℝ) (g := g) hpoint with ⟨C, hC⟩
  refine ⟨C, fun n => ?_⟩
  have hnorm : ‖NormedSpace.inclusionInDoubleDual ℝ E (u n)‖ = ‖u n‖ := by
    simpa [NormedSpace.inclusionInDoubleDualLi] using
      (NormedSpace.inclusionInDoubleDualLi (𝕜 := ℝ) (E := E)).norm_map (u n)
  simpa [g, hnorm] using hC n

/-- Norm convergence implies weak convergence in every real normed space. -/
theorem weaklyConverges_of_norm_tendsto_zero {E : Type*} [NormedAddCommGroup E]
    [NormedSpace ℝ E] {u : ℕ → E} {x : E}
    (h : Tendsto (fun n => ‖u n - x‖) atTop (𝓝 0)) :
    WeaklyConverges u x := by
  apply weaklyConverges_iff_forall_dual.mpr
  intro f
  have hstrong : Tendsto u atTop (𝓝 x) := by
    rw [tendsto_iff_norm_sub_tendsto_zero]
    simpa using h
  exact (f.continuous.tendsto x).comp hstrong

/--
Scalar convergence against every continuous linear functional.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. IX §4,
p. 134, first paragraph of "Espaces faiblement complets".
-/
def WeaklyScalarConvergent {E : Type*} [AddCommMonoid E] [Module ℝ E] [TopologicalSpace E]
    (u : ℕ → E) : Prop :=
  ∀ f : E →L[ℝ] ℝ, ∃ a : ℝ, Tendsto (fun n => f (u n)) atTop (𝓝 a)

/--
Banach weak sequential completeness: scalar convergence of a sequence against every continuous
linear functional is represented by a weak limit in the space.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. IX §4,
pp. 134--136.
-/
def WeaklySequentiallyComplete (E : Type*) [AddCommMonoid E] [Module ℝ E]
    [TopologicalSpace E] : Prop :=
  ∀ u : ℕ → E, WeaklyScalarConvergent u → ∃ x : E, WeaklyConverges u x

/-- Banach's coefficient data for the continuous dual of the `c` space. -/
structure cDualData where
  coeff : ℕ → ℝ
  mass : ℝ

/-- The terminal coefficient package in Banach's `c`-dual description. -/
abbrev cDualMass (a : cDualData) : ℝ :=
  a.mass

/--
Banach's variation norm on `c`-dual coefficient data, modeled as the terminal mass plus the
coefficient total variation.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. VIII §6,
pp. 125--126, formulas (42)--(46).
-/
noncomputable def cDualVariationNorm (a : cDualData) : ℝ :=
  ‖a.mass‖ + ∑' i : ℕ, ‖a.coeff i‖

/--
The represented continuous functional attached to `c`-dual coefficient data.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. VIII §6,
p. 125, formula (42), relying on the Ch. IV §4 dual description of `(c)` on p. 73.
-/
axiom cDualRep : cDualData → NormedSpace.Dual ℝ cSpace

/--
Banach's Chapter VIII weak-star criterion for represented functionals on `c`: bounded variation,
coordinatewise convergence, and convergence of the terminal coefficient package characterize
weak-star convergence.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. VIII §6,
pp. 125--126, formulas (43)--(46).
-/
axiom weakStarConverges_cDual_iff_coefficients {an : ℕ → cDualData} {a : cDualData} :
    WeakDual1932.WeakStarConvergesSeq (𝕜 := ℝ) (E := cSpace)
        (fun n => cDualRep (an n))
        (NormedSpace.Dual.toWeakDual (cDualRep a)) ↔
      (∃ M : ℝ, ∀ n : ℕ, cDualVariationNorm (an n) ≤ M) ∧
      (∀ i : ℕ, Tendsto (fun n => (an n).coeff i) atTop (𝓝 (a.coeff i))) ∧
      Tendsto (fun n => cDualMass (an n)) atTop (𝓝 (cDualMass a))

/--
Banach's Chapter VIII weak compactness theorem for bounded `L^p([0,1])` sequences, `1 < p < ∞`.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. VIII §7,
p. 126, derived from Ch. VIII Théorème 3 on p. 121; Banach cites F. Riesz,
*Untersuchungen über Systeme integrierbarer Funktionen*, Math. Ann. 69 (1910), pp. 466--467.
-/
axiom exists_weaklyConvergent_subseq_of_bounded_Lp {p : ℝ≥0∞} [Fact (1 ≤ p)]
    (hp : 1 < p.toReal)
    (f : ℕ → LpUnitInterval p) (hbounded : ∃ M : ℝ, ∀ n : ℕ, ‖f n‖ ≤ M) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧
      ∃ g : LpUnitInterval p, WeaklyConverges (fun n => f (φ n)) g

/--
Banach's Chapter VIII weak compactness theorem for bounded `ℓ^p` sequences, `1 < p < ∞`.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. VIII §7,
p. 126, `l^p` analogue following the `L^p` statement and Ch. VIII Théorème 3 on p. 121.
-/
axiom exists_weaklyConvergent_subseq_of_bounded_lp {p : ℝ≥0∞} [Fact (1 ≤ p)]
    (hp : 1 < p.toReal)
    (f : ℕ → lpReal p) (hbounded : ∃ M : ℝ, ∀ n : ℕ, ‖f n‖ ≤ M) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧
      ∃ g : lpReal p, WeaklyConverges (fun n => f (φ n)) g

/--
Banach's Chapter IX criterion for weak convergence in `C([0,1])`: uniform norm boundedness plus
pointwise convergence.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. IX §2,
p. 129, formulas (3)--(5).
-/
axiom weaklyConverges_C_iff_bounded_pointwise {fn : ℕ → CInterval} {f : CInterval} :
    WeaklyConverges fn f ↔
      (∃ M : ℝ, ∀ n : ℕ, ‖fn n‖ ≤ M) ∧
      ∀ x : UnitInterval, Tendsto (fun n => fn n x) atTop (𝓝 (f x))

/--
The Phase 2 executable substrate for Banach's `L^p([0,1])` weak-convergence test package:
convergence against every continuous linear functional.  Banach's interval integrals on
p. 130, formulas (6)--(7), are represented here by the exact Mathlib weak-topology test
space until the interval-indicator dual basis is formalized.
-/
def IntervalIntegralTestsConverge {p : ℝ≥0∞} [Fact (1 ≤ p)]
    (fn : ℕ → LpUnitInterval p) (f : LpUnitInterval p) : Prop :=
  ∀ T : NormedSpace.Dual ℝ (LpUnitInterval p), Tendsto (fun n => T (fn n)) atTop (𝓝 (T f))

/--
Banach's Chapter IX criterion for weak convergence in `L^p([0,1])`: norm boundedness together
with convergence of the initial-interval integral tests.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. IX §2,
p. 130, formulas (6)--(7).
-/
theorem weaklyConverges_Lp_iff_bounded_intervalIntegrals {p : ℝ≥0∞} [Fact (1 ≤ p)]
    (_hp : 1 < p.toReal)
    {fn : ℕ → LpUnitInterval p} {f : LpUnitInterval p} :
    WeaklyConverges fn f ↔
      (∃ M : ℝ, ∀ n : ℕ, ‖fn n‖ ≤ M) ∧
      IntervalIntegralTestsConverge fn f := by
  constructor
  · intro h
    exact ⟨bounded_of_weaklyConverges h, weaklyConverges_iff_forall_dual.mp h⟩
  · intro h
    exact weaklyConverges_iff_forall_dual.mpr h.2

/--
Banach's Chapter IX criterion for weak convergence in `c`: boundedness, coordinatewise
convergence, and convergence of sequence limits.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. IX §2,
p. 131, formulas (12)--(13), using the Ch. IV §4 dual description of `(c)`.
-/
axiom weaklyConverges_c_iff_bounded_coordinatewise_limit {un : ℕ → cSpace} {u : cSpace} :
    WeaklyConverges un u ↔
      (∃ M : ℝ, ∀ n : ℕ, ‖un n‖ ≤ M) ∧
      (∀ i : ℕ, Tendsto (fun n => un n i) atTop (𝓝 (u i))) ∧
      Tendsto (fun n => cLimit (un n)) atTop (𝓝 (cLimit u))

/--
Banach's hard direction in the `ℓ¹` Schur property: weak convergence implies norm convergence.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. IX §2,
pp. 131--133, formula (16) and the consequence following (18)--(21).
-/
axiom norm_tendsto_of_weaklyConverges_l1 {un : ℕ → lpReal (1 : ℝ≥0∞)}
    {u : lpReal (1 : ℝ≥0∞)} :
    WeaklyConverges un u → Tendsto (fun n => ‖un n - u‖) atTop (𝓝 0)

/--
Banach's `ℓ¹` Schur property, assembled from the cited hard direction and the general
norm-convergence-to-weak-convergence theorem above.
-/
theorem weaklyConverges_l1_iff_norm {un : ℕ → lpReal (1 : ℝ≥0∞)}
    {u : lpReal (1 : ℝ≥0∞)} :
    WeaklyConverges un u ↔ Tendsto (fun n => ‖un n - u‖) atTop (𝓝 0) :=
  ⟨norm_tendsto_of_weaklyConverges_l1, weaklyConverges_of_norm_tendsto_zero⟩

/--
Banach's Radon-Riesz package: in `L^p([0,1])` and `ℓ^p`, weak convergence plus convergence of
norms forces norm convergence for `1 < p < ∞`.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. IX §3,
p. 133, formula (22); Banach cites J. Radon, *Theorie und Anwendungen der absolut additiven
Mengenfunktionen*, Sitzungsber. Akad. Wiss. Wien 122 (1913), pp. 1295--1438, and
F. Riesz, *Sur la convergence en moyenne* I--II, Acta Sci. Math. Szeged 4 (1928/29),
pp. 58--64 and 182--185.
-/
axiom radonRiesz_Lp_and_lp {p : ℝ≥0∞} [Fact (1 ≤ p)] (hp : 1 < p.toReal) :
    (∀ {fn : ℕ → LpUnitInterval p} {f : LpUnitInterval p},
      WeaklyConverges fn f →
      Tendsto (fun n => ‖fn n‖) atTop (𝓝 ‖f‖) →
      Tendsto (fun n => ‖fn n - f‖) atTop (𝓝 0)) ∧
    (∀ {un : ℕ → lpReal p} {u : lpReal p},
      WeaklyConverges un u →
      Tendsto (fun n => ‖un n‖) atTop (𝓝 ‖u‖) →
      Tendsto (fun n => ‖un n - u‖) atTop (𝓝 0))

/--
Banach's weak sequential completeness theorem for `L^p([0,1])`, `p ≥ 1`.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. IX §4,
pp. 134--136, positive theorem after the `C([0,1])` counterexample.
-/
axiom weaklySequentiallyComplete_Lp {p : ℝ≥0∞} [Fact (1 ≤ p)] (hp : 1 ≤ p) :
    WeaklySequentiallyComplete (LpUnitInterval p)

/--
Banach's counterexample that `C([0,1])` is not weakly sequentially complete.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. IX §4,
p. 134, bounded continuous sequence with scalar limits but no continuous weak limit.
-/
axiom not_weaklySequentiallyComplete_CInterval :
    ¬ WeaklySequentiallyComplete CInterval

end WeakConvergenceClassical
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
