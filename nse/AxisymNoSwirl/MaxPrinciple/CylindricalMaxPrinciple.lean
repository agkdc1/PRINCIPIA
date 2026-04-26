import Mathlib
import NavierStokes.AxisymNoSwirl.MaxPrinciple.FiveDHeatMaxPrinciple

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open NavierStokes.Geometry.Cylindrical

namespace NavierStokes.AxisymNoSwirl.MaxPrinciple

open NavierStokes.AxisymNoSwirl.GammaTransport

/-- Time-sliced steady `Γ` transport surface on `[0,T]`. -/
def TimeSlicedGammaTransportSolution
    (u : ℝ → CylVectorField) (Γ : ℝ → GammaField) (T : ℝ) : Prop :=
  ∀ t ∈ Set.Icc 0 T,
    ∃ hdiv : DivergenceFreeCyl (u t), IsGammaTransportSolution (Γ t) (u t) hdiv

/-- Time-sliced B4 radial-Laplacian bridge data on `[0,T]`. -/
def TimeSlicedFiveDRadialBridge
    (Γ : ℝ → GammaField) (T : ℝ) : Prop :=
  ∀ t ∈ Set.Icc 0 T, ∀ p : E3, p ∈ puncturedSpace →
    HasFiveDRadialLaplacianData (Γ t) (gammaLiftTo5D (Γ t)) p

/-- Transfer the lifted 5D exponential envelope back to the cylindrical field. -/
theorem cylindrical_pointwise_exp_bound
    {Γ : ℝ → E3 → ℝ} {M B0 T : ℝ}
    (hinv : ∀ t ∈ Set.Icc 0 T, CylindricalRepresentativeInvariant (Γ t))
    (hlift : LiftedGammaBound Γ M B0 T) :
    ∀ t ∈ Set.Icc 0 T, ∀ p : E3, |Γ t p| ≤ Real.exp (M * t) * B0 := by
  intro t ht p
  exact cylindrical_bound_of_lifted_bound (hinv t ht) (hlift t ht) p

/-- Off-axis specialization of the B4 radial-Laplacian bridge along the B5 canonical lift. -/
theorem pointwise_bridge_on_interval
    {Γ : ℝ → GammaField} {T : ℝ}
    (hbridge : TimeSlicedFiveDRadialBridge Γ T)
    {t : ℝ} (ht : t ∈ Set.Icc 0 T) {p : E3} (hp : p ∈ puncturedSpace) :
    laplacian5 (gammaLiftTo5D (Γ t)) (embedMeridian p) = gammaDiffusion (Γ t) p :=
  gammaLift_laplacian_eq_gammaDiffusion hp (hbridge t ht p hp)

/-- Conditional B5 export: once the lifted 5D lane supplies the exponential envelope, the
original cylindrical field inherits the same bound. The transport and `u_r / r` hypotheses
are carried explicitly so the theorem shape matches the board-approved Phase 2 contract. -/
theorem conditional_max_principle
    (u : ℝ → CylVectorField) (Γ : ℝ → GammaField)
    (T M B0 : ℝ)
    (htr : TimeSlicedGammaTransportSolution u Γ T)
    (hM : 0 ≤ M)
    (hB0 : 0 ≤ B0)
    (hbd : ∀ t ∈ Set.Icc 0 T, ∀ p : E3, |(u t p).1| ≤ M * rCyl p)
    (hbridge : TimeSlicedFiveDRadialBridge Γ T)
    (hinv : ∀ t ∈ Set.Icc 0 T, CylindricalRepresentativeInvariant (Γ t))
    (hlift : LiftedGammaBound Γ M B0 T) :
    ∀ t ∈ Set.Icc 0 T, ∀ p : E3, |Γ t p| ≤ Real.exp (M * t) * B0 := by
  intro t ht p
  have htrSlice := htr t ht
  have hbdSlice := hbd t ht p
  exact cylindrical_pointwise_exp_bound hinv hlift t ht p

theorem conditional_max_principle_initial_data
    (u : ℝ → CylVectorField) (Γ : ℝ → GammaField)
    (T M B0 : ℝ)
    (htr : TimeSlicedGammaTransportSolution u Γ T)
    (hM : 0 ≤ M)
    (hB0 : 0 ≤ B0)
    (hbd : ∀ t ∈ Set.Icc 0 T, ∀ p : E3, |(u t p).1| ≤ M * rCyl p)
    (hbridge : TimeSlicedFiveDRadialBridge Γ T)
    (hinv : ∀ t ∈ Set.Icc 0 T, CylindricalRepresentativeInvariant (Γ t))
    (hlift : LiftedGammaBound Γ M B0 T)
    (hT : 0 ≤ T) :
    GammaInitialDataAdmissible (Γ 0) := by
  apply gammaInitialDataAdmissible_of_bound hB0
  intro p
  have h0 : (0 : ℝ) ∈ Set.Icc 0 T := ⟨le_rfl, hT⟩
  simpa using conditional_max_principle u Γ T M B0 htr hM hB0 hbd hbridge hinv hlift 0 h0 p

end NavierStokes.AxisymNoSwirl.MaxPrinciple

end
