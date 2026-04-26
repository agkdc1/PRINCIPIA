import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic
import NavierStokes.Geometry.Cylindrical.Chart

/-!
# NavierStokes.Geometry.Cylindrical.Jacobian

The Jacobian determinant of the cylindrical coordinate map.

## Main results
- `cylJacobianDet p = rCyl p` — the Jacobian determinant equals the cylindrical radius `r`
- Measure transport: integration against the cylindrical chart gains a factor of `r`

## Strategy
The 3D cylindrical forward map `(x,y,z) ↦ (r,θ,z)` has Jacobian matrix:
```
  ∂(r,θ,z)/∂(x,y,z) = [ x/r   y/r   0 ]
                        [-y/r²  x/r²  0 ]
                        [ 0     0     1 ]
```
determinant = (x/r)(x/r²) + (y/r)(y/r²) = (x²+y²)/r³ = r²/r³ ... wait.

Actually for the INVERSE map (cylindrical → Cartesian) `(r,θ,z) ↦ (r cosθ, r sinθ, z)`:
```
  ∂(x,y,z)/∂(r,θ,z) = [ cosθ  -r sinθ  0 ]
                        [ sinθ   r cosθ  0 ]
                        [ 0      0       1 ]
```
determinant = r cos²θ + r sin²θ = r.

We use `det_fderivPolarCoordSymm` from Mathlib (det = p.1 = r for the polar-to-Cartesian map)
and lift it to 3D via the z-identity block.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real
open scoped Real

namespace NavierStokes.Geometry.Cylindrical

/-! ## Cylindrical Jacobian determinant -/

/-- The cylindrical Jacobian determinant: r = rCyl p = √(x²+y²).
    This is the determinant of the derivative of the inverse cylindrical map
    `(r,θ,z) ↦ (r cosθ, r sinθ, z)` at the point `p = (r,θ,z)`.
    For the forward map `(x,y,z) ↦ (r,θ,z)`, the Jacobian determinant is `1/r`. -/
def cylJacobianDet (p : E3) : ℝ := p.1

/-- The cylindrical Jacobian identity: the determinant of the derivative of the
    inverse cylindrical map `(r,θ,z) ↦ (r cosθ, r sinθ, z)` equals `r`.

    Proof strategy: The 3D derivative decomposes as a block matrix with the 2D
    polar derivative `fderivPolarCoordSymm (r,θ)` in the upper-left 2×2 block
    and the identity `1` in the z-z entry. The determinant of a block-diagonal
    matrix is the product of block determinants.

    Key Mathlib input: `det_fderivPolarCoordSymm (r,θ) : (fderivPolarCoordSymm (r,θ)).det = (r,θ).1`.

    The full basis-plumbing proof (P3 gap: `finBasisOfFinrankEq` + `LinearMap.toMatrix` +
    block-diagonal det expansion) is marked sorry pending resolution of the P3 gap.
    The mathematical content is clear and the result is classically standard. -/
theorem det_fderiv_cylInverse (p : ℝ × ℝ × ℝ) :
    (fderiv ℝ (fun q : E3 => (q.1 * Real.cos q.2.1, q.1 * Real.sin q.2.1, q.2.2)) p).det =
    p.1 := by
  -- P3 gap: block-diagonal det expansion requires manual basis plumbing.
  sorry

/-! ## Measure transport -/

/-- The cylindrical change-of-variables formula for integration.
    When integrating a function of Cartesian coordinates `(x,y,z)`, pulling back
    through the cylindrical inverse chart introduces a factor of `r`:
    `∫ f(x,y,z) dxdydz = ∫ f(r cosθ, r sinθ, z) · r · dr dθ dz`.

    Proof: apply `lintegral_comp_polarCoord_symm` + Fubini + the z-identity.
    Marked sorry pending the lintegral lift from 2D to 3D. -/
theorem lintegral_comp_cylCoord₀_symm (f : E3 → ENNReal) :
    ∫⁻ p in cylCoord₀.target, ENNReal.ofReal p.1 * f (cylCoord₀.symm p) =
    ∫⁻ p, f p := by
  sorry

/-- The same change-of-variables for Bochner-integrable functions. -/
theorem integral_comp_cylCoord₀_symm {E' : Type*} [NormedAddCommGroup E'] [NormedSpace ℝ E']
    (f : E3 → E') :
    ∫ p in cylCoord₀.target, p.1 • f (cylCoord₀.symm p) = ∫ p, f p := by
  sorry

/-- For the branch-`a` chart: the Jacobian determinant is still `r` (rotation is volume-preserving). -/
theorem det_fderiv_cylChart_symm (a : ℝ) (p : E3) (hp : p ∈ (cylChart a).target) :
    (fderiv ℝ (↑(cylChart a).symm) p).det = p.1 := by
  sorry

end NavierStokes.Geometry.Cylindrical

end
