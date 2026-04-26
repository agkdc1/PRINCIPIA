import NavierStokes.AxisymNoSwirl.Gamma.Transport
import NavierStokes.Mathlib.WeightedSobolev.ParabolicTruncation

/-!
# NavierStokes.AxisymNoSwirl.Gamma.DriftCancellation

Weighted drift cancellation for the axisymmetric no-swirl `Gamma` transport
surface.

The current repository does not yet contain the cylindrical weighted
integration-by-parts theorem needed to derive advection cancellation from first
principles. This file therefore isolates the exact substrate split:

1. the positive-part chain rule for the truncation energy; and
2. the weighted divergence-form integration-by-parts identity for
   `gammaAdvection`.

From those two ingredients, the drift term paired against `(Gamma - k)_+`
vanishes under `divergenceCyl u = 0`.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory

namespace NavierStokes.AxisymNoSwirl.Gamma

open NavierStokes.Geometry.Cylindrical
open NavierStokes.Analysis.WeightedSobolev
open NavierStokes.AxisymNoSwirl.BiotSavart
open NavierStokes.Mathlib.WeightedSobolev

/-- Scalar positive-part truncation `(Gamma - k)_+`. -/
def shiftedPosPart (Gamma : E3 → ℝ) (k : ℝ) : E3 → ℝ :=
  fun p => max (Gamma p - k) 0

/-- The primitive whose advection derivative is
`(u . grad Gamma) * (Gamma - k)_+` when the truncation chain rule is available. -/
def truncationEnergy (Gamma : E3 → ℝ) (k : ℝ) : E3 → ℝ :=
  fun p => (1 / 2 : ℝ) * (shiftedPosPart Gamma k p) ^ 2

/-- Weighted pairing of the drift term against a scalar test field on
`Omega = puncturedSpace`, using `weightedMeasure = r dLeb|Omega`. -/
noncomputable def driftTruncationPairing
    (u : AxisymNoSwirlField) (k : ℝ) (Gamma : E3 → ℝ) : ℝ :=
  ∫ p in Ω, gammaAdvection u Gamma p * shiftedPosPart Gamma k p ∂ weightedMeasure

/-- Weighted divergence-form integration by parts for the cylindrical advection
operator on `Omega = puncturedSpace`.

This is the exact missing substrate lemma identified by recon: once it is
available from the weighted cylindrical analysis layer, the drift cancellation
theorem below becomes unconditional modulo the truncation chain rule. -/
def WeightedDriftIntegrationByParts (u : AxisymNoSwirlField) : Prop :=
  ∀ f g : E3 → ℝ,
    ∫ p in Ω, gammaAdvection u f p * g p ∂ weightedMeasure
      =
        - ∫ p in Ω, f p * gammaAdvection u g p ∂ weightedMeasure
          - ∫ p in Ω, f p * g p * divergenceCyl u p ∂ weightedMeasure

/-- Regularity certificate needed for the truncation side of exact drift
cancellation.

The `truncation_admissible` field links the statement to the weighted Sobolev
graph/truncation substrate. The analytic obligation is the chain rule for the
truncation energy; the weighted integration-by-parts input is carried
separately as the generic `WeightedDriftIntegrationByParts` hypothesis. -/
structure DriftCancellationRegularity
    (u : AxisymNoSwirlField) (k : ℝ) (Gamma : E3 → ℝ) : Prop where
  truncation_admissible :
    ∃ G : Graph, G.val = Gamma ∧
      (∀ hk : 0 ≤ k, (G.truncation k hk).val = shiftedPosPart Gamma k)
  chain_rule :
    ∀ p : E3,
      gammaAdvection u (truncationEnergy Gamma k) p
        = gammaAdvection u Gamma p * shiftedPosPart Gamma k p

/-- Pointwise chain-rule form of the drift/truncation integrand. -/
theorem drift_truncation_integrand_eq_primitive_advection
    (u : AxisymNoSwirlField) (k : ℝ) (Gamma : E3 → ℝ)
    (hGamma : DriftCancellationRegularity u k Gamma) :
    (fun p : E3 => gammaAdvection u Gamma p * shiftedPosPart Gamma k p)
      = fun p : E3 => gammaAdvection u (truncationEnergy Gamma k) p := by
  funext p
  exact (hGamma.chain_rule p).symm

/-- Cylindrical advection kills constants. -/
@[simp] theorem gammaAdvection_const
    (u : AxisymNoSwirlField) (c : ℝ) (p : E3) :
    gammaAdvection u (fun _ : E3 => c) p = 0 := by
  simp [gammaAdvection, radialDeriv, verticalDeriv]

/-- The weighted integral of a cylindrical advection term vanishes under the
generic weighted divergence-form IBP identity and the divergence-free
hypothesis. -/
theorem advection_integral_eq_zero_of_weighted_ibp
    (u : AxisymNoSwirlField) (f : E3 → ℝ)
    (hdiv : divergenceCyl u = 0)
    (hIBP : WeightedDriftIntegrationByParts u) :
    ∫ p in Ω, gammaAdvection u f p ∂ weightedMeasure = 0 := by
  have h := hIBP f (fun _ : E3 => (1 : ℝ))
  simpa [WeightedDriftIntegrationByParts, hdiv] using h

/-- Drift cancellation against the positive-part truncation under weighted
cylindrical measure. -/
theorem drift_cancellation_against_truncation
    (u : AxisymNoSwirlField) (k : ℝ) (Gamma : E3 → ℝ)
    (hdiv : divergenceCyl u = 0)
    (hIBP : WeightedDriftIntegrationByParts u)
    (hGamma : DriftCancellationRegularity u k Gamma) :
    ∫ p in Ω,
      gammaAdvection u Gamma p * shiftedPosPart Gamma k p ∂ weightedMeasure = 0 := by
  rw [drift_truncation_integrand_eq_primitive_advection u k Gamma hGamma]
  exact advection_integral_eq_zero_of_weighted_ibp u (truncationEnergy Gamma k) hdiv hIBP

/-- Named version through the local pairing definition. -/
theorem driftTruncationPairing_eq_zero
    (u : AxisymNoSwirlField) (k : ℝ) (Gamma : E3 → ℝ)
    (hdiv : divergenceCyl u = 0)
    (hIBP : WeightedDriftIntegrationByParts u)
    (hGamma : DriftCancellationRegularity u k Gamma) :
    driftTruncationPairing u k Gamma = 0 := by
  simpa [driftTruncationPairing] using
    drift_cancellation_against_truncation u k Gamma hdiv hIBP hGamma

end NavierStokes.AxisymNoSwirl.Gamma

end
