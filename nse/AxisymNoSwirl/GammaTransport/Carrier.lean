import NavierStokes.AxisymNoSwirl.BiotSavart.StreamOps

/-!
# NavierStokes.AxisymNoSwirl.GammaTransport.Carrier

Steady-slice operator surface for the axisymmetric no-swirl `Γ = ω_θ / r` transport
equation, together with the local off-axis radius calculus needed by the bridge files.

The current namespace does not yet contain a time-dependent axisymmetric NSE layer.
Per the B4 recon, this file exports the steady cylindrical operators and pointwise
off-axis lemmas that the later vorticity and bridge modules consume.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open Filter
open scoped Topology

namespace NavierStokes.AxisymNoSwirl.GammaTransport

open NavierStokes.Geometry.Cylindrical
open NavierStokes.AxisymNoSwirl.BiotSavart

/-- Scalar carrier for `Γ` and `ω_θ` slices. -/
abbrev GammaField := E3 → ℝ

/-- Cylindrical vector-field carrier on the B1 product coordinates. -/
abbrev CylVectorField := E3 → E3

/-- The transport part `u_r ∂_r Γ + u_z ∂_z Γ`. -/
def gammaAdvection (u : CylVectorField) (Γ : GammaField) (p : E3) : ℝ :=
  (u p).1 * radialDeriv Γ p + (u p).2.2 * verticalDeriv Γ p

/-- The `Γ` diffusion operator coming from `ω_θ = rCyl * Γ`. -/
def gammaDiffusion (Γ : GammaField) (p : E3) : ℝ :=
  radialDeriv (radialDeriv Γ) p
  + (3 / rCyl p) * radialDeriv Γ p
  + verticalDeriv (verticalDeriv Γ) p

/-- The steady `ω_θ` drift-diffusion left-hand side. -/
def thetaVorticityDrift (u : CylVectorField) (ωθ : GammaField) (p : E3) : ℝ :=
  gammaAdvection u ωθ p - ((u p).1 * ωθ p) / rCyl p

/-- The steady `ω_θ` diffusion operator
`∂²_rr + (1/r) ∂_r + ∂²_zz - 1/r²`. -/
def thetaVorticityDiffusion (ωθ : GammaField) (p : E3) : ℝ :=
  radialDeriv (radialDeriv ωθ) p
  + (1 / rCyl p) * radialDeriv ωθ p
  + verticalDeriv (verticalDeriv ωθ) p
  - ωθ p / rCyl p ^ 2

/-- Cylindrical divergence-free condition on the B1 carrier. -/
abbrev DivergenceFreeCyl (u : CylVectorField) : Prop :=
  ∀ p : E3, divergenceCyl u p = 0

/-- Export surface for B5: a steady `Γ` transport slice with explicit divergence-free input. -/
structure IsGammaTransportSolution
    (Γ : GammaField) (u : CylVectorField) (hdiv : DivergenceFreeCyl u) : Prop where
  equation :
    ∀ p : E3, p ∈ puncturedSpace → gammaAdvection u Γ p = gammaDiffusion Γ p

/-- Affine line in the radial direction `eR p`. -/
def radialLine (p : E3) (t : ℝ) : E3 :=
  p + t • eR p

/-- Affine line in the vertical direction `eZ`. -/
def verticalLine (p : E3) (t : ℝ) : E3 :=
  p + t • eZ

@[simp] lemma radialLine_zero (p : E3) : radialLine p 0 = p := by
  simp [radialLine]

@[simp] lemma verticalLine_zero (p : E3) : verticalLine p 0 = p := by
  simp [verticalLine]

/-- Off-axis differentiability of `rCyl`. -/
lemma differentiableAt_rCyl {p : E3} (hp : p ∈ puncturedSpace) :
    DifferentiableAt ℝ rCyl p := by
  unfold rCyl
  apply DifferentiableAt.sqrt
  · fun_prop
  · have hpos : 0 < p.1 ^ 2 + p.2.1 ^ 2 := by
      simpa [rSq] using rSq_pos_of_mem hp
    exact hpos.ne'

/-- The radial line has derivative `eR p` at the base point. -/
lemma hasDerivAt_radialLine (p : E3) :
    HasDerivAt (radialLine p) (eR p) 0 := by
  change HasDerivAt (fun t : ℝ => p + t • eR p) (eR p) 0
  simpa [one_smul] using
    (HasDerivAt.const_add p (((hasDerivAt_id (0 : ℝ)).smul_const (eR p))))

/-- The vertical line has derivative `eZ` at the base point. -/
lemma hasDerivAt_verticalLine (p : E3) :
    HasDerivAt (verticalLine p) eZ 0 := by
  change HasDerivAt (fun t : ℝ => p + t • eZ) eZ 0
  simpa [one_smul] using
    (HasDerivAt.const_add p (((hasDerivAt_id (0 : ℝ)).smul_const eZ)))

/-- Differentiating a scalar field along the radial line recovers `radialDeriv`. -/
lemma hasDerivAt_comp_radialLine {f : E3 → ℝ} {p : E3}
    (hf : DifferentiableAt ℝ f p) :
    HasDerivAt (fun t : ℝ => f (radialLine p t)) (radialDeriv f p) 0 := by
  have hcomp :
      HasDerivAt (fun t : ℝ => f (radialLine p t)) ((fderiv ℝ f p) (eR p)) 0 := by
    refine hf.hasFDerivAt.comp_hasDerivAt_of_eq (0 : ℝ) (hasDerivAt_radialLine p) ?_
    simp [radialLine]
  simpa [radialDeriv] using hcomp

/-- Differentiating a scalar field along the vertical line recovers `verticalDeriv`. -/
lemma hasDerivAt_comp_verticalLine {f : E3 → ℝ} {p : E3}
    (hf : DifferentiableAt ℝ f p) :
    HasDerivAt (fun t : ℝ => f (verticalLine p t)) (verticalDeriv f p) 0 := by
  have hcomp :
      HasDerivAt (fun t : ℝ => f (verticalLine p t)) ((fderiv ℝ f p) eZ) 0 := by
    refine hf.hasFDerivAt.comp_hasDerivAt_of_eq (0 : ℝ) (hasDerivAt_verticalLine p) ?_
    simp [verticalLine]
  simpa [verticalDeriv] using hcomp

/-- Derivative form of `radialDeriv`, convenient for one-variable rewrites. -/
lemma deriv_radialLine_eq_radialDeriv {f : E3 → ℝ} {p : E3}
    (hf : DifferentiableAt ℝ f p) :
    deriv (fun t : ℝ => f (radialLine p t)) 0 = radialDeriv f p :=
  (hasDerivAt_comp_radialLine hf).deriv

/-- Derivative form of `verticalDeriv`, convenient for one-variable rewrites. -/
lemma deriv_verticalLine_eq_verticalDeriv {f : E3 → ℝ} {p : E3}
    (hf : DifferentiableAt ℝ f p) :
    deriv (fun t : ℝ => f (verticalLine p t)) 0 = verticalDeriv f p :=
  (hasDerivAt_comp_verticalLine hf).deriv

/-- Along the radial line, `rCyl` becomes the one-variable map `t ↦ |rCyl p + t|`. -/
lemma rCyl_radialLine_eq_abs {p : E3} (hp : p ∈ puncturedSpace) (t : ℝ) :
    rCyl (radialLine p t) = |rCyl p + t| := by
  have hr : rCyl p ≠ 0 := rCyl_ne_zero_of_mem hp
  have hs : rCyl p ^ 2 = p.1 ^ 2 + p.2.1 ^ 2 := by
    simpa [rSq] using rCyl_sq p
  unfold radialLine rCyl
  rw [show (p + t • eR p).1 ^ 2 + (p + t • eR p).2.1 ^ 2 = (rCyl p + t) ^ 2 by
    simp [eR_fst, eR_snd_fst]
    field_simp [hr]
    rw [hs]
    ring]
  exact Real.sqrt_sq_eq_abs _

/-- Along the vertical line, `rCyl` is constant. -/
lemma rCyl_verticalLine_eq (p : E3) (t : ℝ) :
    rCyl (verticalLine p t) = rCyl p := by
  simp [verticalLine, rCyl, eZ]

/-- The radial derivative of `rCyl` is `1` away from the axis. -/
lemma hasDerivAt_rCyl_radialLine {p : E3} (hp : p ∈ puncturedSpace) :
    HasDerivAt (fun t : ℝ => rCyl (radialLine p t)) 1 0 := by
  have h_eq_abs :
      (fun t : ℝ => rCyl (radialLine p t)) =ᶠ[nhds (0 : ℝ)] fun t => |rCyl p + t| := by
    filter_upwards [Filter.Eventually.of_forall (fun t => rCyl_radialLine_eq_abs hp t)] with t ht
    exact ht
  have h_abs_linear :
      (fun t : ℝ => |rCyl p + t|) =ᶠ[nhds (0 : ℝ)] fun t => rCyl p + t := by
    filter_upwards
      [Ioi_mem_nhds (show -(rCyl p) < (0 : ℝ) by linarith [rCyl_pos_of_mem hp])] with t ht
    have ht0 : -(rCyl p) < t := ht
    have hpos : 0 < rCyl p + t := by linarith
    simp [abs_of_pos hpos]
  have hlinear : HasDerivAt (fun t : ℝ => rCyl p + t) 1 0 := by
    simpa using (HasDerivAt.const_add (rCyl p) (hasDerivAt_id (0 : ℝ)))
  exact hlinear.congr_of_eventuallyEq (h_eq_abs.trans h_abs_linear)

/-- Off-axis radial derivative of `rCyl`. -/
lemma radialDeriv_rCyl_eq_one {p : E3} (hp : p ∈ puncturedSpace) :
    radialDeriv rCyl p = 1 := by
  calc
    radialDeriv rCyl p = deriv (fun t : ℝ => rCyl (radialLine p t)) 0 := by
      symm
      exact deriv_radialLine_eq_radialDeriv (f := rCyl) (differentiableAt_rCyl hp)
    _ = 1 := (hasDerivAt_rCyl_radialLine hp).deriv

/-- Along the vertical line, `rCyl` has zero derivative. -/
lemma hasDerivAt_rCyl_verticalLine (p : E3) :
    HasDerivAt (fun t : ℝ => rCyl (verticalLine p t)) 0 0 := by
  have hconst : (fun t : ℝ => rCyl (verticalLine p t)) = fun _ : ℝ => rCyl p := by
    funext t
    exact rCyl_verticalLine_eq p t
  rw [hconst]
  simpa using (hasDerivAt_const (0 : ℝ) (rCyl p))

/-- Vertical derivative of `rCyl` is zero. -/
lemma verticalDeriv_rCyl_eq_zero {p : E3} (hp : p ∈ puncturedSpace) :
    verticalDeriv rCyl p = 0 := by
  calc
    verticalDeriv rCyl p = deriv (fun t : ℝ => rCyl (verticalLine p t)) 0 := by
      symm
      exact deriv_verticalLine_eq_verticalDeriv (f := rCyl) (differentiableAt_rCyl hp)
    _ = 0 := (hasDerivAt_rCyl_verticalLine p).deriv

end NavierStokes.AxisymNoSwirl.GammaTransport

end
