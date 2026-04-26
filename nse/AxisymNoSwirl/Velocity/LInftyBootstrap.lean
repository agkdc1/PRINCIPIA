import NavierStokes.AxisymNoSwirl.Gamma.MaxPrinciple
import NavierStokes.AxisymNoSwirl.BiotSavart.StreamOps
import NavierStokes.Roots.HeatSemigroupLp

/-!
# NavierStokes.AxisymNoSwirl.Velocity.LInftyBootstrap

Conditional `L^∞_t L^∞_x` bootstrap for axisymmetric no-swirl velocity.

This file packages the B7 surface approved by the board:

- B5 supplies the propagated `Γ` `L^∞` control on `[0, T]`
- NS-R3 supplies the heat-semigroup smoothing substrate
- the Duhamel / parabolic bootstrap / Gronwall closure is still an honest wall
- B8 supplies the Biot-Savart reconstruction lane tying the scalar control back
  to the velocity field

The missing analytic closure is recorded as one narrow certificate axiom rather
than hidden behind `sorry` or fake definitional equalities.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

open MeasureTheory Set
open scoped ENNReal NNReal

namespace NavierStokes.AxisymNoSwirl.Velocity

open NavierStokes.Geometry.Cylindrical
open NavierStokes.AxisymNoSwirl.BiotSavart
open NavierStokes.AxisymNoSwirl.Gamma
open NavierStokes.Roots.HeatSemigroupLp

/-- Scalar `L^∞` envelope on a set, recorded as a pointwise `sSup` in `ℝ≥0∞`. -/
def scalarLInftyOn (f : E3 → ℝ) (s : Set E3) : ℝ≥0∞ :=
  sSup ((fun p : E3 => ENNReal.ofReal |f p|) '' s)

/-- Vector-field `L^∞` envelope on a set, recorded as a pointwise `sSup` in `ℝ≥0∞`. -/
def vectorLInftyOn (u : E3 → E3) (s : Set E3) : ℝ≥0∞ :=
  sSup ((fun p : E3 => ENNReal.ofReal ‖u p‖) '' s)

/-- Axisymmetric no-swirl `Γ` sup-envelope on the punctured domain `Ω`. -/
abbrev gammaLInftyNorm (Γ : E3 → ℝ) : ℝ≥0∞ :=
  scalarLInftyOn Γ NavierStokes.AxisymNoSwirl.BiotSavart.Ω

/-- Axisymmetric no-swirl velocity sup-envelope on the punctured domain `Ω`. -/
abbrev velocityLInftyNorm (u : AxisymNoSwirlField) : ℝ≥0∞ :=
  vectorLInftyOn u NavierStokes.AxisymNoSwirl.BiotSavart.Ω

/--
Certificate for the B7 bootstrap closure.

The four provenance fields mark which analytic ingredients were consumed by the
external argument supplying the bound. The only computational content used below
is the uniform real-valued majorant on `velocityLInftyNorm`.
-/
structure VelocityBootstrapCertificate
    (U : ℝ → AxisymNoSwirlField) (Γ : ℝ → E3 → ℝ) (T : ℝ) where
  bound : ℝ
  bound_nonneg : 0 ≤ bound
  stampacchia_input : Prop
  heat_semigroup_smoothing : Prop
  gronwall_closure : Prop
  biot_savart_reconstruction : Prop
  uniform_bound :
    ∀ t ∈ Set.Icc 0 T, (velocityLInftyNorm (U t)).toReal ≤ bound

/--
Narrow B7 honest wall.

Given:
- a time interval `[0, T]`
- the divergence-free `Γ` transport shell for `U`
- identification of the external `Γ` family with the namespace `Γ(U t)` field
- a finite initial `Γ` `L^∞` envelope
- propagation of that `Γ` envelope on `[0, T]`

the parabolic-bootstrap / Gronwall / Biot-Savart lane returns a uniform real
majorant for the velocity `L^∞` envelope on the same interval.
-/
axiom axisymNoSwirl_velocity_bootstrap_certificate
    (U : ℝ → AxisymNoSwirlField) (Γ : ℝ → E3 → ℝ) (T : ℝ)
    (hT : 0 < T)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hΓ_agrees : ∀ t, Γ t = NavierStokes.AxisymNoSwirl.Gamma.Γ (U t))
    (hΓ_init : gammaLInftyNorm (Γ 0) < ⊤)
    (hΓ_bound :
      ∀ t ∈ Set.Icc 0 T, gammaLInftyNorm (Γ t) ≤ gammaLInftyNorm (Γ 0)) :
    VelocityBootstrapCertificate U Γ T

/--
`L^∞_t L^∞_x` bootstrap for axisymmetric no-swirl velocity on `[0, T]`.

The commander sketch states the scalar lane using textbook `‖·‖_{L^∞(Ω)}`. In
the current repo, the formal surface is the real-valued envelope
`(velocityLInftyNorm (U t)).toReal`, obtained from the `ℝ≥0∞` `sSup`
definition above.
-/
theorem linfty_velocity_bootstrap
    (U : ℝ → AxisymNoSwirlField) (Γ : ℝ → E3 → ℝ) (T : ℝ) (hT : 0 < T)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hΓ_agrees : ∀ t, Γ t = NavierStokes.AxisymNoSwirl.Gamma.Γ (U t))
    (hΓ_init : gammaLInftyNorm (Γ 0) < ⊤)
    (hΓ_bound :
      ∀ t ∈ Set.Icc 0 T, gammaLInftyNorm (Γ t) ≤ gammaLInftyNorm (Γ 0)) :
    ∃ M : ℝ, 0 ≤ M ∧
      ∀ t ∈ Set.Icc 0 T, (velocityLInftyNorm (U t)).toReal ≤ M := by
  let cert :=
    axisymNoSwirl_velocity_bootstrap_certificate
      U Γ T hT hdiv hsolves hΓ_agrees hΓ_init hΓ_bound
  exact ⟨cert.bound, cert.bound_nonneg, cert.uniform_bound⟩

end NavierStokes.AxisymNoSwirl.Velocity

end
