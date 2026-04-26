import Mathlib
import NavierStokes.AxisymNoSwirl.BiotSavart.Carrier
import NavierStokes.AxisymNoSwirl.GammaTransport.Carrier

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open NavierStokes.Geometry.Cylindrical

namespace NavierStokes.AxisymNoSwirl.MaxPrinciple

open NavierStokes.AxisymNoSwirl.BiotSavart
open NavierStokes.AxisymNoSwirl.GammaTransport

/-- Horizontal velocity vanishes at least linearly with the cylindrical radius. -/
def AxisLinearVanishingPred (u : E3 → E3) : Prop :=
  ∃ C : ℝ, 0 ≤ C ∧
    ∀ p : E3, |(u p).1| + |(u p).2.1| ≤ C * rCyl p

/-- B2-compatible axisymmetry/no-swirl data strengthened with linear vanishing on the axis. -/
def AxisymNoSwirlAxisCompatiblePred (u : E3 → E3) : Prop :=
  AxisymNoSwirlPredCyl u ∧ AxisLinearVanishingPred u

/-- Minimal admissibility package for `Γ₀ = ω_θ / r`: a global pointwise bound. -/
def GammaInitialDataAdmissible (Γ₀ : GammaField) : Prop :=
  ∃ M : ℝ, 0 ≤ M ∧ ∀ p : E3, |Γ₀ p| ≤ M

theorem axisLinearVanishingPred_zero :
    AxisLinearVanishingPred (fun _ : E3 => 0) := by
  refine ⟨0, le_rfl, ?_⟩
  intro p
  simp [rCyl_nonneg]

theorem gammaInitialDataAdmissible_of_bound
    {Γ₀ : GammaField} {M : ℝ}
    (hM : 0 ≤ M)
    (hΓ : ∀ p : E3, |Γ₀ p| ≤ M) :
    GammaInitialDataAdmissible Γ₀ := by
  exact ⟨M, hM, hΓ⟩

theorem GammaInitialDataAdmissible.bound
    {Γ₀ : GammaField}
    (hΓ : GammaInitialDataAdmissible Γ₀) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ p : E3, |Γ₀ p| ≤ M :=
  hΓ

theorem AxisymNoSwirlAxisCompatiblePred.axisym
    {u : E3 → E3}
    (hu : AxisymNoSwirlAxisCompatiblePred u) :
    AxisymVectorFieldCyl u :=
  hu.1.1

theorem AxisymNoSwirlAxisCompatiblePred.noSwirl
    {u : E3 → E3}
    (hu : AxisymNoSwirlAxisCompatiblePred u) :
    NoSwirlPolyCyl u :=
  hu.1.2

theorem AxisymNoSwirlAxisCompatiblePred.linearVanishing
    {u : E3 → E3}
    (hu : AxisymNoSwirlAxisCompatiblePred u) :
    AxisLinearVanishingPred u :=
  hu.2

end NavierStokes.AxisymNoSwirl.MaxPrinciple

end
