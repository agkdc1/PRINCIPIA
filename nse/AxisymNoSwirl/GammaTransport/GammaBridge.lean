import NavierStokes.AxisymNoSwirl.GammaTransport.ProductRule
import NavierStokes.AxisymNoSwirl.GammaTransport.VorticityEquation

/-!
# NavierStokes.AxisymNoSwirl.GammaTransport.GammaBridge

Steady algebraic bridge from the `ω_θ` equation to the `Γ` equation under the
substitution `ω_θ = rCyl * Γ`.

The first-order product rules are proved in `ProductRule.lean`. The remaining gap in the
live tree is second-order substitution plumbing for the diffusion side, so this file makes
those identities explicit as a kernel-clean hypothesis package.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

namespace NavierStokes.AxisymNoSwirl.GammaTransport

open NavierStokes.Geometry.Cylindrical

/-- Second-order substitution data needed to reduce the `ω_θ` diffusion operator to
`gammaDiffusion`. These are the exact identities still missing from the live cylindrical
calculus surface. -/
structure HasGammaSubstitution (Γ : GammaField) : Prop where
  diff :
    ∀ p : E3, DifferentiableAt ℝ Γ p
  radial_second :
    ∀ p : E3, p ∈ puncturedSpace →
      radialDeriv (radialDeriv (fun q => rCyl q * Γ q)) p
        = rCyl p * radialDeriv (radialDeriv Γ) p + 2 * radialDeriv Γ p
  vertical_second :
    ∀ p : E3, p ∈ puncturedSpace →
      verticalDeriv (verticalDeriv (fun q => rCyl q * Γ q)) p
        = rCyl p * verticalDeriv (verticalDeriv Γ) p

/-- The transport/stretching side collapses to `rCyl * gammaAdvection`. -/
theorem thetaVorticityDrift_rCyl_mul {Γ : GammaField} {u : CylVectorField} {p : E3}
    (hp : p ∈ puncturedSpace) (hΓ : DifferentiableAt ℝ Γ p) :
    thetaVorticityDrift u (fun q => rCyl q * Γ q) p = rCyl p * gammaAdvection u Γ p := by
  have hr : rCyl p ≠ 0 := rCyl_ne_zero_of_mem hp
  unfold thetaVorticityDrift
  rw [gammaAdvection_rCyl_mul hp hΓ]
  field_simp [hr]
  ring

/-- Under the explicit second-order substitution package, the `ω_θ` diffusion operator
collapses to `rCyl * gammaDiffusion`. -/
theorem thetaVorticityDiffusion_rCyl_mul {Γ : GammaField} {p : E3}
    (hΓ : HasGammaSubstitution Γ) (hp : p ∈ puncturedSpace) :
    thetaVorticityDiffusion (fun q => rCyl q * Γ q) p = rCyl p * gammaDiffusion Γ p := by
  have hr : rCyl p ≠ 0 := rCyl_ne_zero_of_mem hp
  unfold thetaVorticityDiffusion gammaDiffusion
  rw [hΓ.radial_second p hp, radialDeriv_rCyl_mul hp (hΓ.diff p), hΓ.vertical_second p hp]
  field_simp [hr]
  ring

/-- The steady `ω_θ` equation for `ω_θ = rCyl * Γ` reduces to the steady `Γ` equation. -/
theorem gammaTransport_of_thetaVorticityEquation
    {Γ : GammaField} {u : CylVectorField} {hdiv : DivergenceFreeCyl u}
    (hΓ : HasGammaSubstitution Γ)
    (hω : IsThetaVorticityEquation (fun q => rCyl q * Γ q) u hdiv) :
    IsGammaTransportSolution Γ u hdiv := by
  refine ⟨?_⟩
  intro p hp
  have hEq : thetaVorticityDrift u (fun q => rCyl q * Γ q) p
      = thetaVorticityDiffusion (fun q => rCyl q * Γ q) p :=
    thetaVorticity_equation hω hp
  rw [thetaVorticityDrift_rCyl_mul hp (hΓ.diff p),
      thetaVorticityDiffusion_rCyl_mul hΓ hp] at hEq
  have hr : rCyl p ≠ 0 := rCyl_ne_zero_of_mem hp
  have hDiv := congrArg (fun x : ℝ => x / rCyl p) hEq
  field_simp [hr] at hDiv
  exact hDiv

end NavierStokes.AxisymNoSwirl.GammaTransport

end
