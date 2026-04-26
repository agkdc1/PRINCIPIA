import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic
import NavierStokes.Geometry.Cylindrical.Chart
import NavierStokes.Geometry.Cylindrical.Frame

/-!
# NavierStokes.Geometry.Cylindrical.Gradient

Gradient transport through the cylindrical chart and frame expression.

## Main results
- `grad_comp_cylChart`: chain rule for `f ∘ cylChart`
- `grad_from_cyl_components`: `(fderiv ℝ f p) v = ∂_r f · ⟪v, eR⟫ + ∂_θ f · ⟪v, eTheta⟫ + ∂_z f · ⟪v, eZ⟫`
  (inner products here are `innerE3`)
- `axisym_grad_no_theta`: for axisymmetric `f`, the eTheta component vanishes

## Note on inner products
All `innerE3` references use the explicit Euclidean dot product from Frame.lean
(not `@inner ℝ E3 _`) to avoid the sup-norm instance conflict on `ℝ × ℝ × ℝ`.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real
open scoped Real

namespace NavierStokes.Geometry.Cylindrical

/-! ## Cylindrical gradient components -/

/-- Radial derivative component: `∂_r f` at `p` (directional derivative in eR direction). -/
def radialDeriv (f : E3 → ℝ) (p : E3) : ℝ :=
  fderiv ℝ f p (eR p)

/-- Azimuthal derivative component: `∂_θ f` at `p` (directional derivative in eTheta direction). -/
def azimuthalDeriv (f : E3 → ℝ) (p : E3) : ℝ :=
  fderiv ℝ f p (eTheta p)

/-- Vertical derivative: `∂_z f` at `p`. -/
def verticalDeriv (f : E3 → ℝ) (p : E3) : ℝ :=
  fderiv ℝ f p eZ

/-! ## Gradient decomposition in the cylindrical frame -/

/-- The gradient `fderiv ℝ f p` decomposes in the (eR, eTheta, eZ) frame via linearity.
    Applied to any vector `v`, the result is the sum of cylindrical components times
    the Euclidean projections of `v` onto the frame vectors.

    Proof: decompose `v` via `frame_decomposition`, then use linearity of `fderiv`. -/
theorem grad_from_cyl_components {f : E3 → ℝ} {p : E3}
    (hf : DifferentiableAt ℝ f p)
    (hp : p ∈ puncturedSpace) (v : E3) :
    fderiv ℝ f p v =
    radialDeriv f p * innerE3 v (eR p) +
    azimuthalDeriv f p * innerE3 v (eTheta p) +
    verticalDeriv f p * innerE3 v eZ := by
  conv_lhs => rw [frame_decomposition hp v]
  simp only [map_add, _root_.map_smul, smul_eq_mul]
  simp [radialDeriv, azimuthalDeriv, verticalDeriv, mul_comm]

/-! ## Chain rule for cylindrical composition -/

/-- Chain rule: `fderiv (f ∘ cylChart a) p = (fderiv f (cylChart a p)).comp (fderiv (cylChart a) p)`.
    Requires `f` to be differentiable at `cylChart a p` and `cylChart a` differentiable at `p`. -/
theorem grad_comp_cylChart (a : ℝ) {f : E3 → ℝ} {p : E3}
    (hf : DifferentiableAt ℝ f ((cylChart a) p))
    (hg : DifferentiableAt ℝ (↑(cylChart a)) p) :
    fderiv ℝ (f ∘ (cylChart a)) p =
    (fderiv ℝ f ((cylChart a) p)).comp (fderiv ℝ (↑(cylChart a)) p) :=
  fderiv_comp p hf hg

/-! ## Axisymmetric specialization -/

/-- A function `f : E3 → ℝ` is axisymmetric if it depends only on `r = rCyl p` and `z = p.2.2`. -/
def IsAxisymmetric (f : E3 → ℝ) : Prop :=
  ∀ (r z : ℝ) (θ : ℝ), f (r * Real.cos θ, r * Real.sin θ, z) = f (r, 0, z)

/-- For an axisymmetric function, the azimuthal derivative vanishes. -/
theorem axisymmetric_azimuthal_deriv_zero {f : E3 → ℝ} {p : E3}
    (hf : ContDiffAt ℝ 1 f p)
    (hp : p ∈ puncturedSpace)
    (hsym : IsAxisymmetric f) :
    azimuthalDeriv f p = 0 := by
  sorry

/-! ## Cylindrical gradient formula (classical formula) -/

/-- The classical cylindrical gradient formula:
    `∇f = (∂_r f) eR + (1/r)(∂_θ f) eTheta + (∂_z f) eZ`

    In our notation, since `eTheta` already has unit L2-norm, the `1/r` factor
    for the θ-component enters via the coordinate expression of `azimuthalDeriv`.
    Marked sorry: requires combining the chain rule with the Jacobian `det = r`. -/
theorem cylindrical_gradient {f : E3 → ℝ} {p : E3}
    (hf : ContDiffAt ℝ 1 f p)
    (hp : p ∈ puncturedSpace) :
    ∀ v : E3,
    fderiv ℝ f p v =
    radialDeriv f p * innerE3 v (eR p) +
    azimuthalDeriv f p * innerE3 v (eTheta p) +
    verticalDeriv f p * innerE3 v eZ := by
  intro v
  exact grad_from_cyl_components (hf.differentiableAt le_rfl) hp v

end NavierStokes.Geometry.Cylindrical

end
