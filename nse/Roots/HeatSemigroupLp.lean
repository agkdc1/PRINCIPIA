import Mathlib

/-!
# Heat semigroup on `L^p(R^3)`

NS-R3 attempt 2 records the operator-theoretic target for the heat flow on
`L^p(R^3)`, `1 <= p < infinity`.

The concrete, Mathlib-available part fixes the domain, `Lp` carriers, Gaussian
kernel formula, and raw integral representative
`x |-> integral y, K_t (x - y) * f y`.  The unavailable analytic bridge is kept
as typed primitive data: Mathlib v4.17.0 does not package a heat-kernel
`C0Semigroup` on `Lp(R^3)`, nor the Young/approximate-identity/smoothing
theorems needed to construct it from the explicit kernel.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory
open scoped ENNReal NNReal

namespace NavierStokes
namespace Roots
namespace HeatSemigroupLp

/-- The spatial domain `R^3`, represented as functions on `Fin 3`. -/
abbrev R3 : Type := Fin 3 → ℝ

/-- Scalar-valued spatial `L^p(R^3)`. -/
abbrev HeatLpSpace (p : ℝ≥0∞) [Fact (1 ≤ p)] : Type :=
  Lp ℝ p (volume : Measure R3)

/-- Finite-exponent side condition for `1 <= p < infinity`. -/
def FiniteLpExponent (p : ℝ≥0∞) : Prop :=
  p ≠ ∞

/-- Local strongly continuous semigroup record for this root. -/
structure C₀Semigroup (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] where
  T : ℝ≥0 → E →L[ℝ] E
  map_zero : T 0 = ContinuousLinearMap.id ℝ E
  map_add : ∀ s t : ℝ≥0, T (s + t) = (T s).comp (T t)
  strongly_continuous_at_zero : ∀ u : E, ContinuousAt (fun t : ℝ≥0 => T t u) 0

/-- Gaussian heat kernel on `R^3` for positive time; set to zero at `t = 0`. -/
def heatKernel (t : ℝ≥0) (x : R3) : ℝ :=
  if t = 0 then
    0
  else
    (4 * Real.pi * (t : ℝ)) ^ (-(3 / 2 : ℝ)) *
      Real.exp (-(‖x‖ ^ 2) / (4 * (t : ℝ)))

/-- Raw representative-level Gaussian convolution formula. -/
def heatKernelConvolution (t : ℝ≥0) (f : R3 → ℝ) (x : R3) : ℝ :=
  ∫ y : R3, heatKernel t (x - y) * f y

/-- The Navier-Stokes/Fujita-Kato `Lp -> Lq` heat-smoothing time scale. -/
def heatLpLqScale (p q : ℝ≥0∞) (t : ℝ≥0) : ℝ :=
  (t : ℝ) ^ (-(3 / 2 : ℝ) * (p.toReal⁻¹ - q.toReal⁻¹))

/-- Machine-readable list of Mathlib gaps used by the typed wall. -/
inductive MathlibGap where
  | heatKernelConvolutionOnLpR3
  | gaussianKernelMemL1AndMassOne
  | youngConvolutionInequalityLp
  | heatKernelApproximateIdentityStrongContinuity
  | heatKernelLpLqSmoothing
  | packagedC0SemigroupApiForHeatKernel
  | heatKernelContinuousLinearMapSemigroup
  | heatKernelContractionOperatorNorm
  | heatKernelStrongContinuityAtZeroOnLp
deriving DecidableEq, Repr

/-- Typed primitive for the missing explicit-kernel-to-operator bridge on `Lp(R^3)`. -/
class HasHeatSemigroupLpOperatorAPI
    (p : ℝ≥0∞) [Fact (1 ≤ p)] where
  operator : ℝ≥0 → HeatLpSpace p →L[ℝ] HeatLpSpace p
  convolution_formula :
    ∀ t : ℝ≥0, t ≠ 0 → Prop
  contraction :
    ∀ t : ℝ≥0, ‖operator t‖ ≤ 1
  map_zero :
    operator 0 = ContinuousLinearMap.id ℝ (HeatLpSpace p)
  map_add :
    ∀ s t : ℝ≥0, operator (s + t) = (operator s).comp (operator t)
  strongly_continuous_at_zero :
    ∀ u : HeatLpSpace p, ContinuousAt (fun t : ℝ≥0 => operator t u) 0

/-- Typed primitive for the missing `Lp -> Lq` smoothing operator estimate. -/
class HasHeatSemigroupLpLqSmoothingAPI
    (p q : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)] where
  operator : ℝ≥0 → HeatLpSpace p →L[ℝ] HeatLpSpace q
  constant : ℝ
  constant_nonnegative : 0 ≤ constant
  estimate :
    ∀ (t : ℝ≥0), t ≠ 0 →
      ∀ u : HeatLpSpace p,
        ‖operator t u‖ ≤ constant * heatLpLqScale p q t * ‖u‖

/-- Conditional heat semigroup on `L^p(R^3)`, once the missing Mathlib API exists. -/
def heatSemigroupLp
    (p : ℝ≥0∞) [Fact (1 ≤ p)] (_hp_finite : FiniteLpExponent p)
    [api : HasHeatSemigroupLpOperatorAPI p] :
    C₀Semigroup (HeatLpSpace p) where
  T := api.operator
  map_zero := api.map_zero
  map_add := api.map_add
  strongly_continuous_at_zero := api.strongly_continuous_at_zero

/-- `e^{tΔ}` as a continuous linear operator on `L^p`, conditionally supplied by the wall. -/
def heatOperatorLp
    (p : ℝ≥0∞) [Fact (1 ≤ p)] [api : HasHeatSemigroupLpOperatorAPI p]
    (t : ℝ≥0) :
    HeatLpSpace p →L[ℝ] HeatLpSpace p :=
  api.operator t

/-- The operator agrees with the Gaussian convolution representative; honest-wall statement. -/
def heatKernelConvolutionDefinition
    (p : ℝ≥0∞) [Fact (1 ≤ p)] [api : HasHeatSemigroupLpOperatorAPI p]
    (t : ℝ≥0) (ht : t ≠ 0) :
    Prop :=
  api.convolution_formula t ht

/-- Heat flow is an `L^p -> L^p` contraction, once the missing API is supplied. -/
theorem heatContractionEstimate
    (p : ℝ≥0∞) [Fact (1 ≤ p)] [api : HasHeatSemigroupLpOperatorAPI p]
    (t : ℝ≥0) :
    ‖heatOperatorLp p t‖ ≤ 1 :=
  api.contraction t

/-- Heat flow satisfies the standard `L^p -> L^q` smoothing estimate. -/
theorem heatSmoothingEstimate
    (p q : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [api : HasHeatSemigroupLpLqSmoothingAPI p q]
    (hpq : p ≤ q) (t : ℝ≥0) (ht : t ≠ 0) (u : HeatLpSpace p) :
    ‖api.operator t u‖ ≤ api.constant * heatLpLqScale p q t * ‖u‖ := by
  exact api.estimate t ht u

/-- Attempt-2 wall: the named Mathlib v4.17.0 gaps blocking a closed proof. -/
def heatSemigroupLpAttempt2Wall : List MathlibGap :=
  [ MathlibGap.heatKernelConvolutionOnLpR3
  , MathlibGap.gaussianKernelMemL1AndMassOne
  , MathlibGap.youngConvolutionInequalityLp
  , MathlibGap.heatKernelApproximateIdentityStrongContinuity
  , MathlibGap.heatKernelLpLqSmoothing
  , MathlibGap.packagedC0SemigroupApiForHeatKernel
  , MathlibGap.heatKernelContinuousLinearMapSemigroup
  , MathlibGap.heatKernelContractionOperatorNorm
  , MathlibGap.heatKernelStrongContinuityAtZeroOnLp
  ]

/-- Upstream names expected to close the attempt-2 wall. -/
def heatSemigroupLpAttempt2WallNames : List String :=
  [ "Mathlib.Analysis.EvolutionEquations.HeatSemigroupLp"
  , "Mathlib.Analysis.Semigroup.C0Semigroup"
  , "MeasureTheory.YoungConvolutionInequality"
  , "MeasureTheory.GaussianHeatKernel.integral_eq_one"
  , "MeasureTheory.GaussianHeatKernel.memLp"
  , "MeasureTheory.GaussianHeatKernel.approximateIdentity"
  , "MeasureTheory.GaussianHeatKernel.toContinuousLinearMapLp"
  , "MeasureTheory.GaussianHeatKernel.convolution_formula_ae"
  , "MeasureTheory.GaussianHeatKernel.semigroup_convolution"
  , "MeasureTheory.GaussianHeatKernel.mass_one"
  , "MeasureTheory.GaussianHeatKernel.young_contraction_Lp"
  , "MeasureTheory.GaussianHeatKernel.approximate_identity_tendsto_Lp"
  , "MeasureTheory.GaussianHeatKernel.smoothing_Lp_Lq_operator_norm"
  ]

end HeatSemigroupLp
end Roots
end NavierStokes
