import Mathlib.Analysis.Complex.CauchyIntegral
import Mathlib.Topology.Path

/-!
# Composite contour integrals

This file provides a small substrate for contour integrals along paths built from
finitely many `C¹` pieces.  Mathlib 4.17.0 already contains:

- explicit circle integrals;
- rectangle boundary integrals;
- Cauchy integral formulas on circles/annuli.

What is still missing for the valence-formula campaign is an API for *composite*
contours assembled from finitely many smooth pieces.  We keep the abstraction
deliberately lightweight:

- `C1Path z w` is a path `[0,1] → ℂ` with an explicit derivative field;
- `PiecewiseC1 z w` is the free finite closure of `C1Path` under concatenation
  and reversal;
- the contour integral of a composite path is defined recursively as the sum of
  the piece integrals.

This is enough for Chapter A's bookkeeping lemmas and for the small circular
indent estimates needed later in the argument-principle chapter.
-/

open TopologicalSpace Set MeasureTheory intervalIntegral Metric Filter

open scoped Interval Real Topology

noncomputable section

namespace MathlibExpansion.Roots.Valence.CompositeContour

/-- A `C¹` path from `z₀` to `z₁`, encoded by an explicit derivative function on
`ℝ`.  We only integrate over `[0,1]`, but keeping the parameter domain as `ℝ`
lets us use the interval-integral API directly. -/
structure C1Path (z₀ z₁ : ℂ) where
  toFun : ℝ → ℂ
  deriv : ℝ → ℂ
  source' : toFun 0 = z₀
  target' : toFun 1 = z₁
  continuous_toFun : Continuous toFun
  continuous_deriv : Continuous deriv
  hasDerivAt_toFun : ∀ t : ℝ, HasDerivAt toFun (deriv t) t

instance {z₀ z₁ : ℂ} : CoeFun (C1Path z₀ z₁) (fun _ => ℝ → ℂ) :=
  ⟨C1Path.toFun⟩

namespace C1Path

variable {z₀ z₁ z₂ : ℂ}

@[simp]
theorem source (γ : C1Path z₀ z₁) : γ 0 = z₀ :=
  γ.source'

@[simp]
theorem target (γ : C1Path z₀ z₁) : γ 1 = z₁ :=
  γ.target'

/-- Forget a `C¹` path down to a continuous `Path`. -/
def toPath (γ : C1Path z₀ z₁) : Path z₀ z₁ :=
  Path.ofLine γ.continuous_toFun.continuousOn γ.source γ.target

@[simp]
theorem toPath_apply (γ : C1Path z₀ z₁) (t : Set.Icc (0 : ℝ) 1) :
    γ.toPath t = γ t := by
  rfl

/-- Contour integral of `f` along a `C¹` path. -/
def integral (γ : C1Path z₀ z₁) (f : ℂ → ℂ) : ℂ :=
  ∫ t in (0 : ℝ)..1, γ.deriv t * f (γ t)

@[simp]
theorem integral_def (γ : C1Path z₀ z₁) (f : ℂ → ℂ) :
    γ.integral f = ∫ t in (0 : ℝ)..1, γ.deriv t * f (γ t) :=
  rfl

/-- Straight-line segment from `z₀` to `z₁`. -/
def line (z₀ z₁ : ℂ) : C1Path z₀ z₁ where
  toFun := fun t => z₀ + t * (z₁ - z₀)
  deriv := fun _ => z₁ - z₀
  source' := by simp
  target' := by ring_nf; simp
  continuous_toFun := by
    fun_prop
  continuous_deriv := continuous_const
  hasDerivAt_toFun := by
    intro t
    simpa [sub_eq_add_neg, add_assoc, add_comm, add_left_comm, mul_assoc, mul_comm,
      mul_left_comm] using (((Complex.ofRealCLM : ℝ →L[ℝ] ℂ).hasDerivAt (x := t)).mul_const
        (z₁ - z₀)).const_add z₀

/-- Reversal of a `C¹` path. -/
def symm (γ : C1Path z₀ z₁) : C1Path z₁ z₀ where
  toFun := fun t => γ (1 - t)
  deriv := fun t => -γ.deriv (1 - t)
  source' := by simp [γ.target]
  target' := by simp [γ.source]
  continuous_toFun := γ.continuous_toFun.comp (continuous_const.sub continuous_id)
  continuous_deriv := γ.continuous_deriv.comp (continuous_const.sub continuous_id) |>.neg
  hasDerivAt_toFun := by
    intro t
    simpa using (γ.hasDerivAt_toFun (1 - t)).scomp t
      ((hasDerivAt_const t (1 : ℝ)).sub (hasDerivAt_id t))

/-- Arc on the circle `|z - c| = R`, traversed from angle `θ₀` to angle `θ₁`. -/
def arc (c : ℂ) (R θ₀ θ₁ : ℝ) :
    C1Path (circleMap c R θ₀) (circleMap c R θ₁) where
  toFun := fun t => circleMap c R (θ₀ + (θ₁ - θ₀) * t)
  deriv := fun t => ((θ₁ - θ₀ : ℝ) : ℂ) *
      (circleMap 0 R (θ₀ + (θ₁ - θ₀) * t) * Complex.I)
  source' := by simp [circleMap]
  target' := by simp [circleMap]
  continuous_toFun := by
    fun_prop
  continuous_deriv := by
    fun_prop
  hasDerivAt_toFun := by
    intro t
    have hlin : HasDerivAt (fun s : ℝ => θ₀ + (θ₁ - θ₀) * s) (θ₁ - θ₀) t := by
      simpa [sub_eq_add_neg, add_assoc, add_comm, add_left_comm, mul_assoc, mul_comm,
        mul_left_comm] using ((hasDerivAt_id t).const_mul (θ₁ - θ₀)).const_add θ₀
    simpa [mul_assoc, mul_left_comm, mul_comm] using
      (hasDerivAt_circleMap c R (θ₀ + (θ₁ - θ₀) * t)).scomp t hlin

@[simp]
theorem arc_apply (c : ℂ) (R θ₀ θ₁ t : ℝ) :
    arc c R θ₀ θ₁ t = circleMap c R (θ₀ + (θ₁ - θ₀) * t) :=
  rfl

theorem arc_mem_sphere {c : ℂ} {R θ₀ θ₁ t : ℝ} (hR : 0 ≤ R) :
    arc c R θ₀ θ₁ t ∈ sphere c R := by
  simpa [arc_apply] using circleMap_mem_sphere c hR (θ₀ + (θ₁ - θ₀) * t)

theorem intervalIntegrable_integrand (γ : C1Path z₀ z₁) {f : ℂ → ℂ}
    (hf : Continuous fun t : ℝ => f (γ t)) :
    IntervalIntegrable (fun t : ℝ => γ.deriv t * f (γ t)) volume 0 1 :=
  (γ.continuous_deriv.mul hf).intervalIntegrable _ _

theorem integral_add (γ : C1Path z₀ z₁) {f g : ℂ → ℂ}
    (hf : IntervalIntegrable (fun t : ℝ => γ.deriv t * f (γ t)) volume 0 1)
    (hg : IntervalIntegrable (fun t : ℝ => γ.deriv t * g (γ t)) volume 0 1) :
    γ.integral (fun z => f z + g z) = γ.integral f + γ.integral g := by
  unfold integral
  simpa [mul_add] using intervalIntegral.integral_add hf hg

theorem integral_add_of_continuous (γ : C1Path z₀ z₁) {f g : ℂ → ℂ}
    (hf : Continuous fun t : ℝ => f (γ t))
    (hg : Continuous fun t : ℝ => g (γ t)) :
    γ.integral (fun z => f z + g z) = γ.integral f + γ.integral g :=
  γ.integral_add (γ.intervalIntegrable_integrand hf) (γ.intervalIntegrable_integrand hg)

theorem integral_sub (γ : C1Path z₀ z₁) {f g : ℂ → ℂ}
    (hf : IntervalIntegrable (fun t : ℝ => γ.deriv t * f (γ t)) volume 0 1)
    (hg : IntervalIntegrable (fun t : ℝ => γ.deriv t * g (γ t)) volume 0 1) :
    γ.integral (fun z => f z - g z) = γ.integral f - γ.integral g := by
  unfold integral
  simpa [mul_sub] using intervalIntegral.integral_sub hf hg

theorem integral_symm (γ : C1Path z₀ z₁) (f : ℂ → ℂ) :
    (γ.symm.integral f) = -γ.integral f := by
  unfold integral symm
  have hneg :
      (fun t : ℝ => -γ.deriv (1 - t) * f (γ (1 - t))) =
        fun t : ℝ => -(γ.deriv (1 - t) * f (γ (1 - t))) := by
    funext t
    ring
  rw [hneg, intervalIntegral.integral_neg]
  have hcomp :
      ∫ t in (0 : ℝ)..1, γ.deriv (1 - t) * f (γ (1 - t)) =
        ∫ t in (0 : ℝ)..1, γ.deriv t * f (γ t) := by
    simpa using
      (intervalIntegral.integral_comp_sub_left
        (f := fun t : ℝ => γ.deriv t * f (γ t))
        (a := (0 : ℝ)) (b := (1 : ℝ)) (d := (1 : ℝ)))
  simpa using hcomp

/-- A norm bound for arc integrals.  This is the arc analogue of
`circleIntegral.norm_integral_le_of_norm_le_const`. -/
theorem norm_integral_arc_le_of_norm_le_const {c : ℂ} {R θ₀ θ₁ C : ℝ} (hR : 0 ≤ R)
    {f : ℂ → ℂ} (hf : ∀ z ∈ sphere c R, ‖f z‖ ≤ C) :
    ‖(arc c R θ₀ θ₁).integral f‖ ≤ |θ₁ - θ₀| * R * C := by
  unfold integral
  have hbound :
      ∀ t ∈ Ι (0 : ℝ) 1,
        ‖(arc c R θ₀ θ₁).deriv t * f ((arc c R θ₀ θ₁) t)‖ ≤ |θ₁ - θ₀| * R * C := by
    intro t ht
    calc
      ‖(arc c R θ₀ θ₁).deriv t * f ((arc c R θ₀ θ₁) t)‖
          = |θ₁ - θ₀| * ‖circleMap 0 R (θ₀ + (θ₁ - θ₀) * t)‖ *
              ‖f ((arc c R θ₀ θ₁) t)‖ := by
        have hreal : ‖((θ₁ - θ₀ : ℝ) : ℂ)‖ = |θ₁ - θ₀| := by
          simpa using (RCLike.norm_ofReal (θ₁ - θ₀) : ‖((θ₁ - θ₀ : ℝ) : ℂ)‖ = |θ₁ - θ₀|)
        rw [arc, norm_mul, norm_mul, hreal, norm_mul, Complex.norm_I, mul_one]
      _ = |θ₁ - θ₀| * R * ‖f ((arc c R θ₀ θ₁) t)‖ := by
        rw [norm_circleMap_zero, abs_of_nonneg hR, mul_assoc]
      _ ≤ |θ₁ - θ₀| * R * C := by
        refine mul_le_mul_of_nonneg_left ?_ (mul_nonneg (abs_nonneg _) hR)
        exact hf _ (arc_mem_sphere hR)
  simpa using
    (intervalIntegral.norm_integral_le_of_norm_le_const
      (a := (0 : ℝ)) (b := (1 : ℝ))
      (f := fun t : ℝ => (arc c R θ₀ θ₁).deriv t * f ((arc c R θ₀ θ₁) t))
      (C := |θ₁ - θ₀| * R * C) hbound)

/-- Exact evaluation of the singular principal-part integral on a circular arc. -/
theorem integral_sub_center_inv_const_arc {c res : ℂ} {R θ₀ θ₁ : ℝ} (hR : R ≠ 0) :
    (arc c R θ₀ θ₁).integral (fun z => (z - c)⁻¹ * res) =
      (((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * res := by
  calc
    (arc c R θ₀ θ₁).integral (fun z => (z - c)⁻¹ * res)
      = ∫ t in (0 : ℝ)..1, (((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * res := by
        unfold integral
        refine intervalIntegral.integral_congr ?_
        intro t ht
        have hne : circleMap c R (θ₀ + (θ₁ - θ₀) * t) ≠ c :=
          circleMap_ne_center hR
        calc
          (arc c R θ₀ θ₁).deriv t * (((arc c R θ₀ θ₁) t - c)⁻¹ * res)
              = (((θ₁ - θ₀ : ℝ) : ℂ) *
                  (circleMap 0 R (θ₀ + (θ₁ - θ₀) * t) * Complex.I)) *
                  ((circleMap 0 R (θ₀ + (θ₁ - θ₀) * t))⁻¹ * res) := by
            simp [arc, circleMap_sub_center]
          _ = (((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * res := by
            have hne0 : circleMap 0 R (θ₀ + (θ₁ - θ₀) * t) ≠ 0 := by
              simpa [circleMap_sub_center] using sub_ne_zero.2 hne
            calc
              (((θ₁ - θ₀ : ℝ) : ℂ) *
                  (circleMap 0 R (θ₀ + (θ₁ - θ₀) * t) * Complex.I)) *
                  ((circleMap 0 R (θ₀ + (θ₁ - θ₀) * t))⁻¹ * res)
                  = ((((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) *
                      (circleMap 0 R (θ₀ + (θ₁ - θ₀) * t) *
                        (circleMap 0 R (θ₀ + (θ₁ - θ₀) * t))⁻¹)) * res := by
                    ring
              _ = (((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * res := by
                    rw [mul_inv_cancel₀ hne0, mul_one]
    _ = (((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * res := by
      simp

/-- Full-circle small-circle estimate, re-exported under the Chapter A namespace. -/
theorem small_circle_estimate {c : ℂ} {R C : ℝ} (hR : 0 ≤ R) {f : ℂ → ℂ}
    (hf : ∀ z ∈ sphere c R, ‖f z‖ ≤ C) :
    ‖∮ z in C(c, R), f z‖ ≤ 2 * π * R * C :=
  circleIntegral.norm_integral_le_of_norm_le_const hR hf

/-- If `g` is continuous on a closed ball around `c`, then the contribution of the
regular part along a shrinking circular arc tends to `0`. -/
theorem tendsto_integral_arc_of_continuous_zero {c : ℂ} {ρ θ₀ θ₁ : ℝ} (hρ : 0 < ρ)
    {g : ℂ → ℂ} (hg : ContinuousOn g (closedBall c ρ)) :
    Tendsto (fun ε : ℝ => (arc c ε θ₀ θ₁).integral g) (nhdsWithin (0 : ℝ) (Ioi 0)) (𝓝 0) := by
  have hcont : ContinuousAt g c := hg.continuousAt (closedBall_mem_nhds c hρ)
  obtain ⟨δ, hδ0, hδ⟩ := Metric.continuousAt_iff.1 hcont 1 zero_lt_one
  have hbound :
      ∀ᶠ ε : ℝ in nhdsWithin (0 : ℝ) (Ioi 0),
        ‖(arc c ε θ₀ θ₁).integral g‖ ≤ ε * (|θ₁ - θ₀| * (‖g c‖ + 1)) := by
    filter_upwards [Ioo_mem_nhdsGT (show (0 : ℝ) < min ρ δ by positivity)] with ε hε
    have hερ : ε < ρ := lt_of_lt_of_le hε.2 (min_le_left _ _)
    have hεδ : ε < δ := lt_of_lt_of_le hε.2 (min_le_right _ _)
    have hboundg : ∀ z ∈ sphere c ε, ‖g z‖ ≤ ‖g c‖ + 1 := by
      intro z hz
      have hzδ : dist z c < δ := by
        rw [mem_sphere] at hz
        simpa [hz] using hεδ
      have hgz : dist (g z) (g c) < 1 := hδ hzδ
      calc
        ‖g z‖ = ‖(g z - g c) + g c‖ := by ring_nf
        _ ≤ dist (g z) (g c) + ‖g c‖ := by
          simpa [dist_eq_norm] using norm_add_le (g z - g c) (g c)
        _ ≤ ‖g c‖ + 1 := by linarith
    have hnorm :
        ‖(arc c ε θ₀ θ₁).integral g‖ ≤ |θ₁ - θ₀| * ε * (‖g c‖ + 1) :=
      norm_integral_arc_le_of_norm_le_const hε.1.le hboundg
    simpa [mul_assoc, mul_left_comm, mul_comm] using hnorm
  have hε :
      Tendsto (fun ε : ℝ => ε * (|θ₁ - θ₀| * (‖g c‖ + 1)))
        (nhdsWithin (0 : ℝ) (Ioi 0)) (𝓝 0) := by
    have hε0 :
        Tendsto (fun ε : ℝ => ε * (|θ₁ - θ₀| * (‖g c‖ + 1)))
          (𝓝 (0 : ℝ)) (𝓝 0) := by
      simpa using ((continuous_id.mul continuous_const).continuousAt.tendsto
        (x := (0 : ℝ)))
    exact hε0.mono_left nhdsWithin_le_nhds
  exact squeeze_zero_norm' hbound hε

/-- Residue contribution of a shrinking circular indent.  If `f` decomposes as a
principal part `res / (z - c)` plus a continuous remainder on a closed ball
around `c`, then the arc integral tends to the expected angle-weighted residue.

This is the form needed later for indented contours.  The limit
`(((θ₁ - θ₀ : ℝ) : ℂ) * I) * res` is classically equal to
`(2π i) * res * ((θ₁ - θ₀) / 2π)`.
-/
theorem tendsto_integral_indent_arc {c res : ℂ} {ρ θ₀ θ₁ : ℝ} (hρ : 0 < ρ)
    {g : ℂ → ℂ} (hg : ContinuousOn g (closedBall c ρ)) :
    Tendsto
      (fun ε : ℝ => (arc c ε θ₀ θ₁).integral (fun z => (z - c)⁻¹ * res + g z))
      (nhdsWithin (0 : ℝ) (Ioi 0))
      (𝓝 ((((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * res)) := by
  have hprincipal :
      ∀ᶠ ε : ℝ in nhdsWithin (0 : ℝ) (Ioi 0),
        (arc c ε θ₀ θ₁).integral (fun z => (z - c)⁻¹ * res) =
          (((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * res := by
    filter_upwards [self_mem_nhdsWithin] with ε hε
    exact integral_sub_center_inv_const_arc hε.ne'
  have hreg := tendsto_integral_arc_of_continuous_zero (θ₀ := θ₀) (θ₁ := θ₁) hρ hg
  have hsmallρ : Ioo (0 : ℝ) ρ ∈ nhdsWithin (0 : ℝ) (Ioi 0) := Ioo_mem_nhdsGT hρ
  have hsum :
      Tendsto
        (fun ε : ℝ =>
          (arc c ε θ₀ θ₁).integral (fun z => (z - c)⁻¹ * res + g z))
        (nhdsWithin (0 : ℝ) (Ioi 0))
        (𝓝 ((((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * res + 0)) := by
    refine Tendsto.congr' ?_ ((tendsto_const_nhds.add hreg))
    filter_upwards [hprincipal, hsmallρ] with ε hε hsmall
    have hprincipalCont :
        Continuous fun t : ℝ => (((arc c ε θ₀ θ₁) t - c)⁻¹ * res) := by
      have hne : ∀ t : ℝ, (arc c ε θ₀ θ₁) t - c ≠ 0 := by
        intro t
        exact sub_ne_zero.2 (circleMap_ne_center hsmall.1.ne')
      exact (Continuous.inv₀ ((arc c ε θ₀ θ₁).continuous_toFun.sub continuous_const) hne).mul
        continuous_const
    have hmaps : ∀ t : ℝ, arc c ε θ₀ θ₁ t ∈ closedBall c ρ := by
      intro t
      rw [mem_closedBall_iff_norm]
      have hsphere : arc c ε θ₀ θ₁ t ∈ sphere c ε := arc_mem_sphere hsmall.1.le
      rw [mem_sphere, dist_eq_norm] at hsphere
      exact hsphere.le.trans hsmall.2.le
    have hregCont : Continuous fun t : ℝ => g ((arc c ε θ₀ θ₁) t) :=
      hg.comp_continuous (arc c ε θ₀ θ₁).continuous_toFun hmaps
    have hprincipalCont' :
        Continuous fun t : ℝ => (fun z : ℂ => (z - c)⁻¹ * res) ((arc c ε θ₀ θ₁) t) := by
      simpa using hprincipalCont
    calc
      (((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * res + (arc c ε θ₀ θ₁).integral g
        = (arc c ε θ₀ θ₁).integral (fun z : ℂ => (z - c)⁻¹ * res) +
            (arc c ε θ₀ θ₁).integral g := by rw [← hε]
      _ = (arc c ε θ₀ θ₁).integral (fun z => (z - c)⁻¹ * res + g z) := by
            symm
            exact (arc c ε θ₀ θ₁).integral_add_of_continuous
              (f := fun z : ℂ => (z - c)⁻¹ * res) (g := g) hprincipalCont' hregCont
  simpa using hsum

end C1Path

/-- Piecewise-`C¹` paths: finitely many `C¹` pieces, glued by concatenation and
reversal.  The inductive definition makes the finiteness explicit. -/
inductive PiecewiseC1 : ℂ → ℂ → Type
  | ofC1 {z₀ z₁ : ℂ} : C1Path z₀ z₁ → PiecewiseC1 z₀ z₁
  | trans {z₀ z₁ z₂ : ℂ} : PiecewiseC1 z₀ z₁ → PiecewiseC1 z₁ z₂ → PiecewiseC1 z₀ z₂
  | symm {z₀ z₁ : ℂ} : PiecewiseC1 z₀ z₁ → PiecewiseC1 z₁ z₀

namespace PiecewiseC1

variable {z₀ z₁ z₂ : ℂ}

/-- Underlying continuous path. -/
def toPath : PiecewiseC1 z₀ z₁ → Path z₀ z₁
  := by
    intro γ
    induction γ with
    | ofC1 γ => exact γ.toPath
    | trans γ₁ γ₂ h₁ h₂ => exact h₁.trans h₂
    | symm γ h => exact h.symm

/-- Contour integral of a piecewise-`C¹` path, defined by summing the piece
integrals. -/
def integral (γ : PiecewiseC1 z₀ z₁) (f : ℂ → ℂ) : ℂ :=
  by
    induction γ with
    | ofC1 γ => exact γ.integral f
    | trans γ₁ γ₂ h₁ h₂ => exact h₁ + h₂
    | symm γ h => exact -h

@[simp]
theorem integral_ofC1 (γ : C1Path z₀ z₁) (f : ℂ → ℂ) :
    (PiecewiseC1.ofC1 γ).integral f = γ.integral f :=
  rfl

@[simp]
theorem integral_trans (γ₁ : PiecewiseC1 z₀ z₁) (γ₂ : PiecewiseC1 z₁ z₂) (f : ℂ → ℂ) :
    (PiecewiseC1.trans γ₁ γ₂).integral f = γ₁.integral f + γ₂.integral f :=
  rfl

@[simp]
theorem integral_symm (γ : PiecewiseC1 z₀ z₁) (f : ℂ → ℂ) :
    (PiecewiseC1.symm γ).integral f = -γ.integral f :=
  rfl

@[simp]
theorem toPath_trans (γ₁ : PiecewiseC1 z₀ z₁) (γ₂ : PiecewiseC1 z₁ z₂) :
    (PiecewiseC1.trans γ₁ γ₂).toPath = γ₁.toPath.trans γ₂.toPath :=
  rfl

@[simp]
theorem toPath_symm (γ : PiecewiseC1 z₀ z₁) :
    (PiecewiseC1.symm γ).toPath = γ.toPath.symm :=
  rfl

/-- Promote a `C¹` line segment to a piecewise-`C¹` path. -/
def line (z₀ z₁ : ℂ) : PiecewiseC1 z₀ z₁ :=
  .ofC1 (C1Path.line z₀ z₁)

/-- Promote a circular arc to a piecewise-`C¹` path. -/
def arc (c : ℂ) (R θ₀ θ₁ : ℝ) :
    PiecewiseC1 (circleMap c R θ₀) (circleMap c R θ₁) :=
  .ofC1 (C1Path.arc c R θ₀ θ₁)

end PiecewiseC1

end MathlibExpansion.Roots.Valence.CompositeContour
