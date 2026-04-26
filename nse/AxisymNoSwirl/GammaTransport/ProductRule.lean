import NavierStokes.AxisymNoSwirl.GammaTransport.Carrier

/-!
# NavierStokes.AxisymNoSwirl.GammaTransport.ProductRule

Off-axis Leibniz rules for the substitution `ω_θ = rCyl * Γ`.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

namespace NavierStokes.AxisymNoSwirl.GammaTransport

open NavierStokes.Geometry.Cylindrical

/-- Off-axis radial product rule for `rCyl * Γ`. -/
lemma radialDeriv_rCyl_mul {Γ : GammaField} {p : E3}
    (hp : p ∈ puncturedSpace) (hΓ : DifferentiableAt ℝ Γ p) :
    radialDeriv (fun q => rCyl q * Γ q) p = rCyl p * radialDeriv Γ p + Γ p := by
  have hprod : DifferentiableAt ℝ (fun q => rCyl q * Γ q) p :=
    (differentiableAt_rCyl hp).mul hΓ
  have hline :
      HasDerivAt (fun t : ℝ => rCyl (radialLine p t) * Γ (radialLine p t))
        (1 * Γ p + rCyl p * radialDeriv Γ p) 0 := by
    simpa [radialLine_zero] using
      (hasDerivAt_rCyl_radialLine hp).mul (hasDerivAt_comp_radialLine hΓ)
  calc
    radialDeriv (fun q => rCyl q * Γ q) p
        = deriv (fun t : ℝ => rCyl (radialLine p t) * Γ (radialLine p t)) 0 := by
          symm
          simpa [radialLine] using
            deriv_radialLine_eq_radialDeriv (f := fun q => rCyl q * Γ q) hprod
    _ = 1 * Γ p + rCyl p * radialDeriv Γ p := hline.deriv
    _ = rCyl p * radialDeriv Γ p + Γ p := by ring

/-- Off-axis vertical product rule for `rCyl * Γ`. -/
lemma verticalDeriv_rCyl_mul {Γ : GammaField} {p : E3}
    (hp : p ∈ puncturedSpace) (hΓ : DifferentiableAt ℝ Γ p) :
    verticalDeriv (fun q => rCyl q * Γ q) p = rCyl p * verticalDeriv Γ p := by
  have hprod : DifferentiableAt ℝ (fun q => rCyl q * Γ q) p :=
    (differentiableAt_rCyl hp).mul hΓ
  have hline :
      HasDerivAt (fun t : ℝ => rCyl (verticalLine p t) * Γ (verticalLine p t))
        (0 * Γ p + rCyl p * verticalDeriv Γ p) 0 := by
    simpa [verticalLine_zero] using
      (hasDerivAt_rCyl_verticalLine p).mul (hasDerivAt_comp_verticalLine hΓ)
  calc
    verticalDeriv (fun q => rCyl q * Γ q) p
        = deriv (fun t : ℝ => rCyl (verticalLine p t) * Γ (verticalLine p t)) 0 := by
          symm
          simpa [verticalLine] using
            deriv_verticalLine_eq_verticalDeriv (f := fun q => rCyl q * Γ q) hprod
    _ = 0 * Γ p + rCyl p * verticalDeriv Γ p := hline.deriv
    _ = rCyl p * verticalDeriv Γ p := by ring

/-- Pointwise off-axis product rule
`(u_r ∂_r + u_z ∂_z)(rCyl * Γ) = rCyl * (u_r ∂_r + u_z ∂_z) Γ + u_r * Γ`. -/
theorem gammaAdvection_rCyl_mul {Γ : GammaField} {u : CylVectorField} {p : E3}
    (hp : p ∈ puncturedSpace) (hΓ : DifferentiableAt ℝ Γ p) :
    gammaAdvection u (fun q => rCyl q * Γ q) p
      = rCyl p * gammaAdvection u Γ p + (u p).1 * Γ p := by
  rw [gammaAdvection, radialDeriv_rCyl_mul hp hΓ, verticalDeriv_rCyl_mul hp hΓ, gammaAdvection]
  ring

end NavierStokes.AxisymNoSwirl.GammaTransport

end
