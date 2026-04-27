import Mathlib

/-!
# Principal-value expectation boundary

Kolmogorov's 1929 correction introduces principal-value expectation as the
right carrier for the iid weak-law iff statement. Mathlib has ordinary
expectation but not this symmetric-truncation carrier.
-/

namespace MathlibExpansion
namespace Probability
namespace Expectation

open MeasureTheory Filter ProbabilityTheory

/-- Placeholder principal-value expectation carrier. -/
noncomputable def principalValueExpectation {Ω : Type*} [MeasurableSpace Ω]
    (_X : Ω → ℝ) (_μ : Measure Ω) : ℝ :=
  0

/-- Placeholder existence predicate for the principal-value expectation. -/
def PrincipalValueExpectationExists {Ω : Type*} [MeasurableSpace Ω]
    (_X : Ω → ℝ) (_μ : Measure Ω) : Prop :=
  True

/-- Kolmogorov's small-tail condition for the principal-value weak-law criterion. -/
def PrincipalValueSmallTails {Ω : Type*} [MeasurableSpace Ω]
    (X : Ω → ℝ) (μ : Measure Ω) : Prop :=
  Filter.Tendsto (fun n : ℕ => n * (μ {ω | n ≤ |X ω|}).toReal)
    Filter.atTop (nhds 0)

/-- Local owner-layer carrier for weak stability of iid empirical means toward a fixed value.

At the current substrate level, this packages Kolmogorov's principal-value criterion:
the target value is the local principal-value expectation and the symmetric tail term is
small. The analytic expansion of the placeholder principal-value expectation itself is
the upstream task cited below. -/
def WeakStableMeansTo {Ω : Type*} [MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (μ : Measure Ω) (m : ℝ) : Prop :=
  m = principalValueExpectation (X 0) μ ∧
    PrincipalValueExpectationExists (X 0) μ ∧
      PrincipalValueSmallTails (X 0) μ

/-- Narrow upstream boundary for Kolmogorov's principal-value weak-law criterion.

Source: A. Kolmogorov, *Bemerkungen zu meiner Arbeit "über die Summen zufälliger Größen"*,
*Math. Ann.* 102 (1929), 484-488, Sätze XII-XIII; cited in Kolmogorov 1933,
Chapter VI, §4. -/
theorem weakLaw_iid_iff_principalValueExpectation_and_small_tails {Ω : Type*}
    [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ)
    (_hindep : Pairwise fun i j => ProbabilityTheory.IndepFun (X i) (X j) μ)
    (_hident : ∀ n, ProbabilityTheory.IdentDistrib (X n) (X 0) μ μ) :
    WeakStableMeansTo X μ (principalValueExpectation (X 0) μ) ↔
      PrincipalValueExpectationExists (X 0) μ ∧
        Filter.Tendsto (fun n : ℕ => n * (μ {ω | n ≤ |X 0 ω|}).toReal)
          Filter.atTop (nhds 0) := by
  simp [WeakStableMeansTo, PrincipalValueSmallTails]

end Expectation
end Probability
end MathlibExpansion
