import Mathlib.Analysis.Complex.CauchyIntegral
import Mathlib.Topology.Path

/-!
# Piecewise contour integrals

This file stages a small contour API intended for eventual upstreaming to
`Mathlib/Analysis/Complex/PiecewiseContour.lean`.

Mathlib already provides contour integrals for circles and rectangle boundaries.
The missing reusable layer for the valence-formula campaign is an API for
contours assembled from finitely many `C¹` pieces.  We keep the abstraction
deliberately light:

- `C1Path z₀ z₁` is a `C¹` parametrized path from `z₀` to `z₁`;
- `PiecewiseC1 z₀ z₁` is the finite closure of `C1Path` under concatenation and
  reversal;
- contour integrals are recursive sums of interval integrals over the pieces.

The companion file `PiecewiseContourIndent.lean` packages the local arc
estimates needed for indented contours.
-/

open MeasureTheory Set intervalIntegral Metric

open scoped Interval Real Topology

noncomputable section

namespace Mathlib.Analysis.Complex.PiecewiseContour

/-- A `C¹` path from `z₀` to `z₁`, encoded by an explicit derivative on `ℝ`.
We only integrate over `[0,1]`, but keeping the parameter domain as `ℝ` lets us
reuse the interval-integral API directly. -/
structure C1Path (z₀ z₁ : ℂ) where
  toFun : ℝ → ℂ
  deriv : ℝ → ℂ
  source_eq : toFun 0 = z₀
  target_eq : toFun 1 = z₁
  continuous_toFun : Continuous toFun
  continuous_deriv : Continuous deriv
  hasDerivAt_toFun : ∀ t : ℝ, HasDerivAt toFun (deriv t) t

instance {z₀ z₁ : ℂ} : CoeFun (C1Path z₀ z₁) (fun _ => ℝ → ℂ) :=
  ⟨C1Path.toFun⟩

namespace C1Path

variable {z₀ z₁ z₂ : ℂ}

@[simp]
theorem source (γ : C1Path z₀ z₁) : γ 0 = z₀ :=
  γ.source_eq

@[simp]
theorem target (γ : C1Path z₀ z₁) : γ 1 = z₁ :=
  γ.target_eq

/-- Restrict a `C¹` path to the unit interval, forgetting the derivative data. -/
def to_path (γ : C1Path z₀ z₁) : Path z₀ z₁ :=
  Path.ofLine γ.continuous_toFun.continuousOn γ.source γ.target

@[simp]
theorem to_path_apply (γ : C1Path z₀ z₁) (t : Set.Icc (0 : ℝ) 1) :
    γ.to_path t = γ t := by
  rfl

/-- The scalar contour integral of `f` along a `C¹` path. -/
def integral (γ : C1Path z₀ z₁) (f : ℂ → ℂ) : ℂ :=
  ∫ t in (0 : ℝ)..1, γ.deriv t * f (γ t)

@[simp]
theorem integral_def (γ : C1Path z₀ z₁) (f : ℂ → ℂ) :
    γ.integral f = ∫ t in (0 : ℝ)..1, γ.deriv t * f (γ t) :=
  rfl

/-- The straight-line segment from `z₀` to `z₁`. -/
def line (z₀ z₁ : ℂ) : C1Path z₀ z₁ where
  toFun := fun t => z₀ + t * (z₁ - z₀)
  deriv := fun _ => z₁ - z₀
  source_eq := by simp
  target_eq := by ring_nf; simp
  continuous_toFun := by
    fun_prop
  continuous_deriv := continuous_const
  hasDerivAt_toFun := by
    intro t
    simpa [sub_eq_add_neg, add_assoc, add_comm, add_left_comm, mul_assoc, mul_comm,
      mul_left_comm] using (((Complex.ofRealCLM : ℝ →L[ℝ] ℂ).hasDerivAt (x := t)).mul_const
        (z₁ - z₀)).const_add z₀

@[simp]
theorem line_apply (z₀ z₁ : ℂ) (t : ℝ) :
    line z₀ z₁ t = z₀ + t * (z₁ - z₀) :=
  rfl

@[simp]
theorem line_deriv (z₀ z₁ : ℂ) (t : ℝ) :
    (line z₀ z₁).deriv t = z₁ - z₀ :=
  rfl

/-- The constant path at `z`, realized as a degenerate line segment. -/
def refl (z : ℂ) : C1Path z z :=
  line z z

@[simp]
theorem refl_apply (z : ℂ) (t : ℝ) : refl z t = z := by
  simp [refl, line]

@[simp]
theorem refl_deriv (z : ℂ) (t : ℝ) : (refl z).deriv t = 0 := by
  simp [refl, line]

/-- Reversal of a `C¹` path. -/
def symm (γ : C1Path z₀ z₁) : C1Path z₁ z₀ where
  toFun := fun t => γ (1 - t)
  deriv := fun t => -γ.deriv (1 - t)
  source_eq := by simp [γ.target]
  target_eq := by simp [γ.source]
  continuous_toFun := γ.continuous_toFun.comp (continuous_const.sub continuous_id)
  continuous_deriv := γ.continuous_deriv.comp (continuous_const.sub continuous_id) |>.neg
  hasDerivAt_toFun := by
    intro t
    simpa using (γ.hasDerivAt_toFun (1 - t)).scomp t
      ((hasDerivAt_const t (1 : ℝ)).sub (hasDerivAt_id t))

@[simp]
theorem symm_apply (γ : C1Path z₀ z₁) (t : ℝ) :
    γ.symm t = γ (1 - t) :=
  rfl

@[simp]
theorem symm_deriv (γ : C1Path z₀ z₁) (t : ℝ) :
    γ.symm.deriv t = -γ.deriv (1 - t) :=
  rfl

/-- The circular arc on `|z - c| = R` from angle `θ₀` to angle `θ₁`. -/
def arc (c : ℂ) (R θ₀ θ₁ : ℝ) :
    C1Path (circleMap c R θ₀) (circleMap c R θ₁) where
  toFun := fun t => circleMap c R (θ₀ + (θ₁ - θ₀) * t)
  deriv := fun t => ((θ₁ - θ₀ : ℝ) : ℂ) *
      (circleMap 0 R (θ₀ + (θ₁ - θ₀) * t) * Complex.I)
  source_eq := by simp [circleMap]
  target_eq := by simp [circleMap]
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

/-- Continuous integrands along a `C¹` contour are interval-integrable. -/
theorem interval_integrable_integrand (γ : C1Path z₀ z₁) {f : ℂ → ℂ}
    (hf : Continuous fun t : ℝ => f (γ t)) :
    IntervalIntegrable (fun t : ℝ => γ.deriv t * f (γ t)) volume 0 1 :=
  (γ.continuous_deriv.mul hf).intervalIntegrable _ _

@[simp]
theorem integral_zero (γ : C1Path z₀ z₁) :
    γ.integral (fun _ => (0 : ℂ)) = 0 := by
  unfold integral
  simp

theorem integral_congr (γ : C1Path z₀ z₁) {f g : ℂ → ℂ} (hfg : ∀ z, f z = g z) :
    γ.integral f = γ.integral g := by
  unfold integral
  refine intervalIntegral.integral_congr ?_
  intro t ht
  simp [hfg]

theorem integral_const_mul (γ : C1Path z₀ z₁) (c : ℂ) (f : ℂ → ℂ) :
    γ.integral (fun z => c * f z) = c * γ.integral f := by
  unfold integral
  calc
    ∫ t in (0 : ℝ)..1, γ.deriv t * (c * f (γ t))
      = ∫ t in (0 : ℝ)..1, c * (γ.deriv t * f (γ t)) := by
          refine intervalIntegral.integral_congr ?_
          intro t ht
          ring
    _ = c * ∫ t in (0 : ℝ)..1, γ.deriv t * f (γ t) := by
          exact
            (intervalIntegral.integral_const_mul (a := (0 : ℝ)) (b := (1 : ℝ)) c
              (fun t : ℝ => γ.deriv t * f (γ t)))

theorem integral_mul_const (γ : C1Path z₀ z₁) (f : ℂ → ℂ) (c : ℂ) :
    γ.integral (fun z => f z * c) = γ.integral f * c := by
  unfold integral
  calc
    ∫ t in (0 : ℝ)..1, γ.deriv t * (f (γ t) * c)
      = ∫ t in (0 : ℝ)..1, (γ.deriv t * f (γ t)) * c := by
          refine intervalIntegral.integral_congr ?_
          intro t ht
          ring
    _ = (∫ t in (0 : ℝ)..1, γ.deriv t * f (γ t)) * c := by
          exact
            (intervalIntegral.integral_mul_const (a := (0 : ℝ)) (b := (1 : ℝ)) c
              (fun t : ℝ => γ.deriv t * f (γ t)))

theorem integral_neg (γ : C1Path z₀ z₁) (f : ℂ → ℂ) :
    γ.integral (fun z => -f z) = -γ.integral f := by
  unfold integral
  calc
    ∫ t in (0 : ℝ)..1, γ.deriv t * (-f (γ t))
      = ∫ t in (0 : ℝ)..1, -(γ.deriv t * f (γ t)) := by
          refine intervalIntegral.integral_congr ?_
          intro t ht
          ring
    _ = -∫ t in (0 : ℝ)..1, γ.deriv t * f (γ t) := by
          exact
            (intervalIntegral.integral_neg
              (f := fun t : ℝ => γ.deriv t * f (γ t)) (a := (0 : ℝ)) (b := (1 : ℝ)))

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
  γ.integral_add (γ.interval_integrable_integrand hf) (γ.interval_integrable_integrand hg)

theorem integral_sub (γ : C1Path z₀ z₁) {f g : ℂ → ℂ}
    (hf : IntervalIntegrable (fun t : ℝ => γ.deriv t * f (γ t)) volume 0 1)
    (hg : IntervalIntegrable (fun t : ℝ => γ.deriv t * g (γ t)) volume 0 1) :
    γ.integral (fun z => f z - g z) = γ.integral f - γ.integral g := by
  unfold integral
  simpa [mul_sub] using intervalIntegral.integral_sub hf hg

theorem integral_sub_of_continuous (γ : C1Path z₀ z₁) {f g : ℂ → ℂ}
    (hf : Continuous fun t : ℝ => f (γ t))
    (hg : Continuous fun t : ℝ => g (γ t)) :
    γ.integral (fun z => f z - g z) = γ.integral f - γ.integral g :=
  γ.integral_sub (γ.interval_integrable_integrand hf) (γ.interval_integrable_integrand hg)

@[simp]
theorem refl_integral (z : ℂ) (f : ℂ → ℂ) :
    (refl z).integral f = 0 := by
  simp [refl, integral, line]

theorem integral_symm (γ : C1Path z₀ z₁) (f : ℂ → ℂ) :
    γ.symm.integral f = -γ.integral f := by
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

end C1Path

/-- Piecewise-`C¹` contours are the finite closure of `C1Path` under
concatenation and reversal. -/
inductive PiecewiseC1 : ℂ → ℂ → Type
  | of_c1 {z₀ z₁ : ℂ} : C1Path z₀ z₁ → PiecewiseC1 z₀ z₁
  | trans {z₀ z₁ z₂ : ℂ} : PiecewiseC1 z₀ z₁ → PiecewiseC1 z₁ z₂ → PiecewiseC1 z₀ z₂
  | symm {z₀ z₁ : ℂ} : PiecewiseC1 z₀ z₁ → PiecewiseC1 z₁ z₀

namespace PiecewiseC1

variable {z₀ z₁ z₂ : ℂ}

/-- Forget the derivative data and retain only the underlying continuous path. -/
def to_path : {z₀ z₁ : ℂ} → PiecewiseC1 z₀ z₁ → Path z₀ z₁
  | _, _, .of_c1 γ => γ.to_path
  | _, _, .trans γ₁ γ₂ => (to_path γ₁).trans (to_path γ₂)
  | _, _, .symm γ => (to_path γ).symm

/-- Contour integral along a piecewise-`C¹` contour. -/
def integral : {z₀ z₁ : ℂ} → PiecewiseC1 z₀ z₁ → (ℂ → ℂ) → ℂ
  | _, _, .of_c1 γ, f => γ.integral f
  | _, _, .trans γ₁ γ₂, f => integral γ₁ f + integral γ₂ f
  | _, _, .symm γ, f => -integral γ f

@[simp]
theorem integral_of_c1 (γ : C1Path z₀ z₁) (f : ℂ → ℂ) :
    (PiecewiseC1.of_c1 γ).integral f = γ.integral f :=
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
theorem to_path_of_c1 (γ : C1Path z₀ z₁) :
    (PiecewiseC1.of_c1 γ).to_path = γ.to_path :=
  rfl

@[simp]
theorem to_path_trans (γ₁ : PiecewiseC1 z₀ z₁) (γ₂ : PiecewiseC1 z₁ z₂) :
    (PiecewiseC1.trans γ₁ γ₂).to_path = γ₁.to_path.trans γ₂.to_path :=
  rfl

@[simp]
theorem to_path_symm (γ : PiecewiseC1 z₀ z₁) :
    (PiecewiseC1.symm γ).to_path = γ.to_path.symm :=
  rfl

@[simp]
theorem integral_zero (γ : PiecewiseC1 z₀ z₁) :
    γ.integral (fun _ => (0 : ℂ)) = 0 := by
  induction γ with
  | of_c1 γ =>
      exact γ.integral_zero
  | trans γ₁ γ₂ ih₁ ih₂ =>
      simp [PiecewiseC1.integral, ih₁, ih₂]
  | symm γ ih =>
      simp [PiecewiseC1.integral, ih]

theorem integral_congr (γ : PiecewiseC1 z₀ z₁) {f g : ℂ → ℂ} (hfg : ∀ z, f z = g z) :
    γ.integral f = γ.integral g := by
  induction γ with
  | of_c1 γ =>
      exact γ.integral_congr hfg
  | trans γ₁ γ₂ ih₁ ih₂ =>
      simp [PiecewiseC1.integral, ih₁, ih₂]
  | symm γ ih =>
      simp [PiecewiseC1.integral, ih]

theorem integral_const_mul (γ : PiecewiseC1 z₀ z₁) (c : ℂ) (f : ℂ → ℂ) :
    γ.integral (fun z => c * f z) = c * γ.integral f := by
  induction γ with
  | of_c1 γ =>
      exact γ.integral_const_mul c f
  | trans γ₁ γ₂ ih₁ ih₂ =>
      simp [PiecewiseC1.integral, ih₁, ih₂, mul_add]
  | symm γ ih =>
      simp [PiecewiseC1.integral, ih, mul_comm, mul_left_comm, mul_assoc]

/-- Promote a `C¹` line segment to a piecewise-`C¹` contour. -/
def line (z₀ z₁ : ℂ) : PiecewiseC1 z₀ z₁ :=
  .of_c1 (C1Path.line z₀ z₁)

/-- The constant piecewise-`C¹` contour at `z`. -/
def refl (z : ℂ) : PiecewiseC1 z z :=
  line z z

/-- Promote a circular arc to a piecewise-`C¹` contour. -/
def arc (c : ℂ) (R θ₀ θ₁ : ℝ) :
    PiecewiseC1 (circleMap c R θ₀) (circleMap c R θ₁) :=
  .of_c1 (C1Path.arc c R θ₀ θ₁)

/-- The positively oriented axis-aligned rectangle boundary with opposite
corners `z` and `w`. -/
def rectangle_boundary (z w : ℂ) : PiecewiseC1 z z :=
  let z_right : ℂ := ⟨w.re, z.im⟩
  let z_top : ℂ := ⟨z.re, w.im⟩
  .trans (line z z_right)
    (.trans (line z_right w)
      (.trans (line w z_top) (line z_top z)))

@[simp]
theorem refl_integral (z : ℂ) (f : ℂ → ℂ) :
    (refl z).integral f = 0 := by
  simp [refl, line]

end PiecewiseC1

end Mathlib.Analysis.Complex.PiecewiseContour
