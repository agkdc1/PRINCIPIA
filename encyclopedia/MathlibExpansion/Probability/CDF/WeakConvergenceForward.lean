import MathlibExpansion.Probability.CDF.WeakConvergence

/-!
# CDF convergence implies weak convergence

This file packages the one-dimensional converse bridge from distribution
functions back to weak convergence of laws.
-/

namespace MathlibExpansion
namespace Probability
namespace CDF

open scoped Topology

open Filter MeasureTheory Set

/--
Open-set liminf form of the real-line CDF convergence theorem.

Exact source boundary: Patrick Billingsley, "Weak Convergence of Measures:
Applications in Probability" (1971), Theorem 2.3, converse direction, which
states that convergence of real distribution functions at all continuity points
of the limit distribution is equivalent to weak convergence.  The target shape
is its upstream-narrow portmanteau component, isolated using Billingsley (1971),
Theorem 2.1(c): `liminf Pₙ(G) ≥ P(G)` for every open set `G`.
-/
axiom le_liminf_measure_open_of_cdf_tendsto_at_continuityPoints {μs : ℕ → ProbabilityMeasure ℝ}
    {μ : ProbabilityMeasure ℝ}
    (h : ∀ x : ℝ, ContinuousAt (ProbabilityTheory.cdf (μ : Measure ℝ)) x →
      Tendsto (fun n ↦ ProbabilityTheory.cdf (μs n : Measure ℝ) x) atTop
        (𝓝 (ProbabilityTheory.cdf (μ : Measure ℝ) x)))
    (G : Set ℝ) (hG : IsOpen G) :
    μ G ≤ atTop.liminf (fun n ↦ μs n G)

/-- Convergence of CDFs at continuity points implies weak convergence of the laws. -/
theorem tendsto_of_cdf_tendsto_at_continuityPoints {μs : ℕ → ProbabilityMeasure ℝ}
    {μ : ProbabilityMeasure ℝ}
    (h : ∀ x : ℝ, ContinuousAt (ProbabilityTheory.cdf (μ : Measure ℝ)) x →
      Tendsto (fun n ↦ ProbabilityTheory.cdf (μs n : Measure ℝ) x) atTop
        (𝓝 (ProbabilityTheory.cdf (μ : Measure ℝ) x))) :
    Tendsto μs atTop (𝓝 μ) := by
  exact MeasureTheory.tendsto_of_forall_isOpen_le_liminf
    (le_liminf_measure_open_of_cdf_tendsto_at_continuityPoints h)

end CDF
end Probability
end MathlibExpansion
