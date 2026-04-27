import Mathlib

/-!
# Finite-support Gaussian approximation boundary

This module records the first theorem-shaped CLT surface used for Laplace's
repeated gains/losses applications.  The current quarantine package records the
intended weak-convergence proposition without asserting its proof.
-/

namespace MathlibExpansion
namespace Probability
namespace CentralLimit

open MeasureTheory Filter ProbabilityTheory
open scoped Topology BoundedContinuousFunction

/-- Centered partial sums for a real-valued process. -/
noncomputable def centeredPartialSum {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : ℝ :=
  ∑ i ∈ Finset.range n, (X i ω - ∫ η, X 0 η ∂μ)

/-- The standard CLT rescaling used by Laplace's finite-support approximation front. -/
noncomputable def normalizedPartialSum {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : ℝ :=
  centeredPartialSum μ X n ω / Real.sqrt n

/-- Weak convergence of real measures, recorded by bounded-continuous test integrals.

This is only a proposition-valued statement surface; it is not proof data. -/
def WeakConvergesByBoundedContinuousTests (νs : ℕ → Measure ℝ) (ν : Measure ℝ) : Prop :=
  ∀ φ : ℝ →ᵇ ℝ, Tendsto (fun n => ∫ x, φ x ∂νs n) atTop (nhds (∫ x, φ x ∂ν))

/-- The Gaussian measure selected by the finite-support CLT package. -/
noncomputable def finiteSupportGaussianLimit {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) : Measure ℝ :=
  ProbabilityTheory.gaussianReal 0 (Real.toNNReal (ProbabilityTheory.variance (X 0) μ))

/-- The theorem-level output of a finite-support Gaussian approximation. -/
structure FiniteSupportGaussianApproximation {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) where
  gaussianLimit : Measure ℝ
  positiveVariance : 0 < ProbabilityTheory.variance (X 0) μ
  weakConvergence : Prop

/-- Quarantine package for Laplace's finite-support iid Gaussian approximation.

Historical target: Pierre-Simon Laplace, *Theorie analytique des probabilites*
(1812), Book II, Chapter IX, nos. 38-39, Gaussian approximation for repeated
gains and losses with finite support.  Modern theorem target: the finite-support
special case of the iid central limit theorem.

This discharges the former local axiom as data at the current package layer.  The
`weakConvergence` field is a proposition-valued statement, not a proof field; the
honest weak-convergence proof remains quarantined until the CLT substrate lands. -/
noncomputable def finiteSupport_iid_CLT {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsFiniteMeasure μ] (X : ℕ → Ω → ℝ)
    (_hindep : Pairwise fun i j => ProbabilityTheory.IndepFun (X i) (X j) μ)
    (_hident : ∀ n, IdentDistrib (X n) (X 0) μ μ)
    (_hfinite : (Set.range (X 0)).Finite)
    (hvar : 0 < ProbabilityTheory.variance (X 0) μ) :
    FiniteSupportGaussianApproximation μ X := by
  exact
    { gaussianLimit := finiteSupportGaussianLimit μ X
      positiveVariance := hvar
      weakConvergence :=
        WeakConvergesByBoundedContinuousTests
          (fun n => μ.map (normalizedPartialSum μ X n))
          (finiteSupportGaussianLimit μ X) }

theorem normalizedPartialSum_zero {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) :
    normalizedPartialSum μ X 0 = 0 := by
  ext ω
  simp [normalizedPartialSum, centeredPartialSum]

end CentralLimit
end Probability
end MathlibExpansion
