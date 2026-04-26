import Mathlib
import NavierStokes.AxisymNoSwirl.MaxPrinciple.FiveDLift

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open NavierStokes.Geometry.Cylindrical

namespace NavierStokes.AxisymNoSwirl.MaxPrinciple

open NavierStokes.AxisymNoSwirl.GammaTransport

/-- Named output of the 5D heat-equation lane: a pointwise exponential envelope on `[0,T]`. -/
def FiveDExponentialBound
    (F : ℝ → E5 → ℝ) (M B0 T : ℝ) : Prop :=
  ∀ t ∈ Set.Icc 0 T, ∀ x : E5, |F t x| ≤ Real.exp (M * t) * B0

/-- Specialization of `FiveDExponentialBound` to the lifted `Γ` field. -/
def LiftedGammaBound
    (Γ : ℝ → E3 → ℝ) (M B0 T : ℝ) : Prop :=
  FiveDExponentialBound (fun t => gammaLiftTo5D (Γ t)) M B0 T

theorem FiveDExponentialBound.apply
    {F : ℝ → E5 → ℝ} {M B0 T : ℝ}
    (hF : FiveDExponentialBound F M B0 T)
    {t : ℝ} (ht : t ∈ Set.Icc 0 T) :
    ∀ x : E5, |F t x| ≤ Real.exp (M * t) * B0 :=
  hF t ht

theorem LiftedGammaBound.apply
    {Γ : ℝ → E3 → ℝ} {M B0 T : ℝ}
    (hΓ : LiftedGammaBound Γ M B0 T)
    {t : ℝ} (ht : t ∈ Set.Icc 0 T) :
    ∀ x : E5, |gammaLiftTo5D (Γ t) x| ≤ Real.exp (M * t) * B0 :=
  hΓ t ht

theorem LiftedGammaBound.onMeridian
    {Γ : ℝ → E3 → ℝ} {M B0 T : ℝ}
    (hΓ : LiftedGammaBound Γ M B0 T)
    {t : ℝ} (ht : t ∈ Set.Icc 0 T) (p : E3) :
    |gammaLiftTo5D (Γ t) (embedMeridian p)| ≤ Real.exp (M * t) * B0 :=
  hΓ t ht (embedMeridian p)

end NavierStokes.AxisymNoSwirl.MaxPrinciple

end
