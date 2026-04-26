import NavierStokes.AxisymNoSwirl.BiotSavart.StreamOps
import NavierStokes.AxisymNoSwirl.GammaTransport.Carrier

/-!
# NavierStokes.AxisymNoSwirl.Gamma.Operator

Fresh operator surface for the axisymmetric no-swirl quantity
`Γ = ω_θ / r = thetaCurl / rCyl`.

This file intentionally does not reuse the stream-function operator from B8:
`tildeDeltaGamma` is the `Γ` diffusion operator
`∂²_r + (3/r) ∂_r + ∂²_z`, not the stream-function operator
`∂²_r - (1/r) ∂_r + ∂²_z`.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

namespace NavierStokes.AxisymNoSwirl.Gamma

open NavierStokes.Geometry.Cylindrical
open NavierStokes.AxisymNoSwirl.BiotSavart
open NavierStokes.AxisymNoSwirl.GammaTransport

/-- Off-axis domain `Ω = puncturedSpace`, where `rCyl > 0`. -/
abbrev Ω : Set E3 := puncturedSpace

/-- Fresh `Γ` diffusion operator:
`∂²_r + (3/r) ∂_r + ∂²_z`. -/
def tildeDeltaGamma (f : E3 → ℝ) (p : E3) : ℝ :=
  radialDeriv (radialDeriv f) p
  + (3 / rCyl p) * radialDeriv f p
  + verticalDeriv (verticalDeriv f) p

/-- Off-axis positivity of the cylindrical radius. -/
lemma rCyl_pos_on_Ω {p : E3} (hp : p ∈ Ω) : 0 < rCyl p :=
  rCyl_pos_of_mem hp

/-- Off-axis radial quotient rule for division by `rCyl`. -/
lemma radialDeriv_div_rCyl {f : E3 → ℝ} {p : E3}
    (hp : p ∈ Ω) (hf : DifferentiableAt ℝ f p) :
    radialDeriv (fun q => f q / rCyl q) p
      = radialDeriv f p / rCyl p - f p / rCyl p ^ 2 := by
  have hr : rCyl p ≠ 0 := rCyl_ne_zero_of_mem hp
  have hinv : DifferentiableAt ℝ (fun q : E3 => (rCyl q)⁻¹) p :=
    (differentiableAt_rCyl hp).inv hr
  have hquot : DifferentiableAt ℝ (fun q => f q / rCyl q) p :=
    by simpa [div_eq_mul_inv] using hf.mul hinv
  have hline :
      HasDerivAt (fun t : ℝ => f (radialLine p t) / rCyl (radialLine p t))
        ((radialDeriv f p * rCyl p - f p * 1) / rCyl p ^ 2) 0 := by
    simpa [radialLine_zero] using
      (hasDerivAt_comp_radialLine hf).div (hasDerivAt_rCyl_radialLine hp)
        (by simpa [radialLine_zero] using hr)
  calc
    radialDeriv (fun q => f q / rCyl q) p
        = deriv (fun t : ℝ => f (radialLine p t) / rCyl (radialLine p t)) 0 := by
          symm
          exact deriv_radialLine_eq_radialDeriv (f := fun q => f q / rCyl q) hquot
    _ = (radialDeriv f p * rCyl p - f p * 1) / rCyl p ^ 2 := hline.deriv
    _ = radialDeriv f p / rCyl p - f p / rCyl p ^ 2 := by
          field_simp [hr]
          ring

/-- Off-axis vertical quotient rule for division by `rCyl`. -/
lemma verticalDeriv_div_rCyl {f : E3 → ℝ} {p : E3}
    (hp : p ∈ Ω) (hf : DifferentiableAt ℝ f p) :
    verticalDeriv (fun q => f q / rCyl q) p
      = verticalDeriv f p / rCyl p := by
  have hr : rCyl p ≠ 0 := rCyl_ne_zero_of_mem hp
  have hinv : DifferentiableAt ℝ (fun q : E3 => (rCyl q)⁻¹) p :=
    (differentiableAt_rCyl hp).inv hr
  have hquot : DifferentiableAt ℝ (fun q => f q / rCyl q) p :=
    by simpa [div_eq_mul_inv] using hf.mul hinv
  have hline :
      HasDerivAt (fun t : ℝ => f (verticalLine p t) / rCyl (verticalLine p t))
        ((verticalDeriv f p * rCyl p - f p * 0) / rCyl p ^ 2) 0 := by
    simpa [verticalLine_zero] using
      (hasDerivAt_comp_verticalLine hf).div (hasDerivAt_rCyl_verticalLine p)
        (by simpa [verticalLine_zero] using hr)
  calc
    verticalDeriv (fun q => f q / rCyl q) p
        = deriv (fun t : ℝ => f (verticalLine p t) / rCyl (verticalLine p t)) 0 := by
          symm
          exact deriv_verticalLine_eq_verticalDeriv (f := fun q => f q / rCyl q) hquot
    _ = (verticalDeriv f p * rCyl p - f p * 0) / rCyl p ^ 2 := hline.deriv
    _ = verticalDeriv f p / rCyl p := by
          field_simp [hr]
          ring

/-- The new `Γ` operator agrees definitionally with the existing steady `gammaDiffusion`
surface, but is kept as a fresh declaration to avoid the stream-operator sign confusion. -/
lemma tildeDeltaGamma_eq_gammaDiffusion (f : E3 → ℝ) (p : E3) :
    tildeDeltaGamma f p = gammaDiffusion f p := rfl

end NavierStokes.AxisymNoSwirl.Gamma

end
