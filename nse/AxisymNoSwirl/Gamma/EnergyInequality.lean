import NavierStokes.AxisymNoSwirl.Gamma.DriftCancellation
import NavierStokes.AxisymNoSwirl.Gamma.Coercivity
import NavierStokes.Mathlib.WeightedSobolev.Steklov

/-!
# NavierStokes.AxisymNoSwirl.Gamma.EnergyInequality

Route W time-local energy inequality for the positive truncation `(Γ - k)_+`.

The current namespace still lacks the fully analytic bridge from the weak
transport statement to the parabolic energy identity. As in W1 and W2, this
file keeps that seam explicit:

1. W1 supplies pointwise drift cancellation against the truncation test.
2. W2 supplies pointwise diffusion coercivity on the truncated graph carrier.
3. the Steklov-regularized time differentiation step is packaged as a
   certificate on the interval `[0, T]`.

No new axioms.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real intervalIntegral
open scoped ENNReal NNReal

namespace NavierStokes.AxisymNoSwirl.Gamma

open NavierStokes.Geometry.Cylindrical
open NavierStokes.Analysis.WeightedSobolev
open NavierStokes.AxisymNoSwirl.BiotSavart
open NavierStokes.Mathlib.WeightedSobolev

/-- Instantaneous truncation energy
`(1/2) ∫_Ω ((Γ(U t) - k)_+)^2 dν`. -/
noncomputable def truncationEnergyAt
    (U : ℝ → AxisymNoSwirlField) (k : ℝ) (t : ℝ) : ℝ :=
  (1 / 2 : ℝ) *
    ∫ p in Ω, (shiftedPosPart (Γ (U t)) k p) ^ 2 ∂ weightedMeasure

/-- Time profile of the drift pairing against the truncation test. -/
noncomputable def driftPairingProfile
    (U : ℝ → AxisymNoSwirlField) (k : ℝ) (t : ℝ) : ℝ :=
  driftTruncationPairing (U t) k (Γ (U t))

/-- Time profile of the weighted diffusion pairing against the truncation test. -/
noncomputable def diffusionPairingProfile
    (U : ℝ → AxisymNoSwirlField) (k : ℝ) (t : ℝ) : ℝ :=
  diffusionTruncationPairing (Γ (U t)) k

/-- W4 certificate tying the Steklov time-regularization step to the landed W1
and W2 spatial surfaces.

`coercivityConst` and `dissipation` are the time profiles that appear in the
final energy inequality. On `[0, T]` they are required to agree with the W2
coercive constant and the W2 truncation Dirichlet energy. The actual passage
from the weak transport formulation to the scalar energy balance is carried by
`steklov_energy_balance`.
-/
structure EnergyInequalityCertificate
    (U : ℝ → AxisymNoSwirlField) (k T : ℝ)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv) where
  coercivityConst : ℝ → ℝ
  dissipation : ℝ → ℝ
  drift_ibp :
    ∀ t, ∀ ht : t ∈ Set.Icc 0 T, WeightedDriftIntegrationByParts (U t)
  drift_regularity :
    ∀ t, ∀ ht : t ∈ Set.Icc 0 T, DriftCancellationRegularity (U t) k (Γ (U t))
  coercivity :
    ∀ t, ∀ ht : t ∈ Set.Icc 0 T, TruncationCoercivityCertificate (Γ (U t)) k
  coercivityConst_agrees :
    ∀ t, ∀ ht : t ∈ Set.Icc 0 T,
      coercivityConst t =
        Classical.choose
          (diffusion_coercivity_on_truncation
            (k := k) (Γ := Γ (U t)) (hΓ := coercivity t ht))
  dissipation_agrees :
    ∀ t, ∀ ht : t ∈ Set.Icc 0 T,
      dissipation t =
        truncationDirichletEnergy (coercivity t ht).graph k
  /-- Output of the Steklov regularization step applied to the weak transport
  identity. -/
  steklov_energy_balance :
    ∀ t, ∀ ht : t ∈ Set.Icc 0 T,
      truncationEnergyAt U k t - truncationEnergyAt U k 0 ≤
        (∫ s in (0 : ℝ)..t, diffusionPairingProfile U k s)
          - (∫ s in (0 : ℝ)..t, driftPairingProfile U k s)
  /-- Time-integrated drift cancellation after transporting the W1 pointwise
  identity through the Steklov argument. -/
  drift_zero_on_interval :
    ∀ t, ∀ ht : t ∈ Set.Icc 0 T,
      ∫ s in (0 : ℝ)..t, driftPairingProfile U k s = 0
  /-- Time-integrated coercive control after transporting the W2 pointwise
  estimate through the Steklov argument. -/
  diffusion_le_neg_dissipation_on_interval :
    ∀ t, ∀ ht : t ∈ Set.Icc 0 T,
      ∫ s in (0 : ℝ)..t, diffusionPairingProfile U k s ≤
        - ∫ s in (0 : ℝ)..t, coercivityConst s * dissipation s

/-- W1 cancellation applied to the instantaneous drift profile. -/
theorem driftPairingProfile_eq_zero
    (U : ℝ → AxisymNoSwirlField) (k T : ℝ)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U k T hdiv hsolves)
    (t : ℝ) (ht : t ∈ Set.Icc 0 T) :
    driftPairingProfile U k t = 0 := by
  simpa [driftPairingProfile] using
    driftTruncationPairing_eq_zero
      (u := U t) (k := k) (Gamma := Γ (U t))
      (hdiv := hdiv t)
      (hIBP := hEnergy.drift_ibp t ht)
      (hGamma := hEnergy.drift_regularity t ht)

/-- Positivity of the coercive constant selected from W2. -/
theorem coercivityConst_pos
    (U : ℝ → AxisymNoSwirlField) (k T : ℝ)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U k T hdiv hsolves)
    (t : ℝ) (ht : t ∈ Set.Icc 0 T) :
    0 < hEnergy.coercivityConst t := by
  rw [hEnergy.coercivityConst_agrees t ht]
  exact
    (Classical.choose_spec
      (diffusion_coercivity_on_truncation
        (k := k) (Γ := Γ (U t)) (hΓ := hEnergy.coercivity t ht))).1

/-- W2 coercivity applied to the instantaneous diffusion profile. -/
theorem diffusionPairingProfile_le_neg_dissipation
    (U : ℝ → AxisymNoSwirlField) (k T : ℝ)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U k T hdiv hsolves)
    (t : ℝ) (ht : t ∈ Set.Icc 0 T) :
    diffusionPairingProfile U k t ≤
      - hEnergy.coercivityConst t * hEnergy.dissipation t := by
  let hcoer :=
    diffusion_coercivity_on_truncation
      (k := k) (Γ := Γ (U t)) (hΓ := hEnergy.coercivity t ht)
  have hspec := Classical.choose_spec hcoer
  calc
    diffusionPairingProfile U k t
        ≤ -(Classical.choose hcoer) *
            truncationDirichletEnergy (hEnergy.coercivity t ht).graph k := by
          simpa [diffusionPairingProfile] using hspec.2
    _ = - hEnergy.coercivityConst t * hEnergy.dissipation t := by
          rw [hEnergy.coercivityConst_agrees t ht, hEnergy.dissipation_agrees t ht]

/-- Time-local truncation energy inequality on `[0, T]`.

The time differentiation step itself is carried by the Steklov certificate, so
the proof here is the final scalar assembly:

`time balance + drift cancellation + coercive diffusion <= initial energy`.
-/
theorem energy_inequality_truncation
    (U : ℝ → AxisymNoSwirlField) (k T : ℝ)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U k T hdiv hsolves) :
    ∀ t ∈ Set.Icc 0 T,
      truncationEnergyAt U k t
        + (∫ s in (0 : ℝ)..t, hEnergy.coercivityConst s * hEnergy.dissipation s)
          ≤ truncationEnergyAt U k 0 := by
  intro t ht
  have hstep := hEnergy.steklov_energy_balance t ht
  have hdrift := hEnergy.drift_zero_on_interval t ht
  have hdiff := hEnergy.diffusion_le_neg_dissipation_on_interval t ht
  have hmain :
      truncationEnergyAt U k t - truncationEnergyAt U k 0 ≤
        - (∫ s in (0 : ℝ)..t, hEnergy.coercivityConst s * hEnergy.dissipation s) := by
    have hstep' :
        truncationEnergyAt U k t - truncationEnergyAt U k 0 ≤
          ∫ s in (0 : ℝ)..t, diffusionPairingProfile U k s := by
      simpa [hdrift] using hstep
    exact le_trans hstep' hdiff
  linarith

end NavierStokes.AxisymNoSwirl.Gamma

end
