import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import Mathlib.Analysis.Calculus.LogDeriv
import Mathlib.Analysis.Meromorphic.Order
import Mathlib.Analysis.SpecialFunctions.Complex.LogDeriv
import MathlibExpansion.Roots.Valence.PiecewiseContourIndent

/-!
# Piecewise contour branch-log lemmas

This file stages the strongest honest part of the argument-principle story that
is currently available in this checkout:

- endpoint antiderivative formulas for the staged `C1Path` / `PiecewiseC1`
  contour API;
- closed-contour vanishing of `∮ f'/f` when `f` admits a global branch of
  `Complex.log` along the contour image;
- normalized sector-angle identities for shrinking indentation arcs.

The full meromorphic argument principle on piecewise-`C¹` Jordan boundaries is
still blocked on this pin by missing winding-number, Jordan-boundary, and
residue infrastructure.  Those blockers are recorded in the companion breach
report `MATHLIB_C1B_ARGUMENT_PRINCIPLE_BREACH_REPORT.md`.
-/

open TopologicalSpace Set MeasureTheory intervalIntegral Metric Filter

open scoped Interval Real Topology

noncomputable section

namespace MathlibExpansion.Analysis.Meromorphic.ArgumentPrinciple

open Mathlib.Analysis.Complex.PiecewiseContour

theorem AnalyticAt.continuousAt_logDeriv {g : ℂ → ℂ} {c : ℂ}
    (hg : AnalyticAt ℂ g c) (hgc : g c ≠ 0) :
    ContinuousAt (logDeriv g) c := by
  have hderiv : ContinuousAt (deriv g) c := hg.deriv.continuousAt
  have hgcont : ContinuousAt g c := hg.continuousAt
  have hinv : ContinuousAt (fun z : ℂ => (g z)⁻¹) c := ContinuousAt.inv₀ hgcont hgc
  simpa [logDeriv, Pi.div_apply, div_eq_mul_inv] using hderiv.mul hinv

theorem continuous_logDeriv_of_hasDerivAt_slit {f f' : ℂ → ℂ}
    (hf : ∀ z, HasDerivAt f (f' z) z) (hf' : Continuous f')
    (hslit : ∀ z, f z ∈ Complex.slitPlane) :
    Continuous (logDeriv f) := by
  have hderiv : deriv f = f' := by
    funext z
    exact (hf z).deriv
  have hcontf : Continuous f := continuous_iff_continuousAt.mpr fun z => (hf z).continuousAt
  have hinv : Continuous fun z : ℂ => (f z)⁻¹ := by
    refine Continuous.inv₀ hcontf ?_
    intro z
    exact Complex.slitPlane_ne_zero (hslit z)
  simpa [logDeriv, Pi.div_apply, hderiv, div_eq_mul_inv] using hf'.mul hinv

namespace C1Path

variable {z₀ z₁ : ℂ}

theorem integral_eq_sub_of_hasDerivAt (γ : C1Path z₀ z₁) {F H : ℂ → ℂ}
    (hH : ∀ z, HasDerivAt H (F z) z) (hcontF : Continuous F) :
    γ.integral F = H z₁ - H z₀ := by
  let G : ℝ → ℂ := fun t => H (γ t)
  have hderivAt : ∀ t : ℝ, HasDerivAt G (γ.deriv t * F (γ t)) t := by
    intro t
    simpa [G, Function.comp_apply, smul_eq_mul] using
      (hH (γ t)).scomp t (γ.hasDerivAt_toFun t)
  have hderiv : deriv G = fun t : ℝ => γ.deriv t * F (γ t) := by
    funext t
    exact (hderivAt t).deriv
  have hdiff : ∀ t ∈ Set.uIcc (0 : ℝ) 1, DifferentiableAt ℝ G t := by
    intro t ht
    exact (hderivAt t).differentiableAt
  have hcont : ContinuousOn (fun t : ℝ => γ.deriv t * F (γ t)) (Set.uIcc (0 : ℝ) 1) := by
    exact (γ.continuous_deriv.mul (hcontF.comp γ.continuous_toFun)).continuousOn
  simpa [C1Path.integral, G, γ.source, γ.target] using
    (intervalIntegral.integral_deriv_eq_sub' G hderiv hdiff hcont)

theorem integral_logDeriv_eq_log_sub (γ : C1Path z₀ z₁) {f f' : ℂ → ℂ}
    (hf : ∀ z, HasDerivAt f (f' z) z) (hf' : Continuous f')
    (hslit : ∀ z, f z ∈ Complex.slitPlane) :
    γ.integral (logDeriv f) = Complex.log (f z₁) - Complex.log (f z₀) := by
  refine integral_eq_sub_of_hasDerivAt (γ := γ) (F := logDeriv f)
    (H := fun z => Complex.log (f z)) ?_ ?_
  · intro z
    simpa [Function.comp_apply, logDeriv, Pi.div_apply, (hf z).deriv] using
      (hf z).clog (hslit z)
  · exact continuous_logDeriv_of_hasDerivAt_slit hf hf' hslit

private lemma normalized_arc_weight_eq {θ₀ θ₁ : ℝ} {n : ℤ} :
    ((2 * (Real.pi : ℂ) * Complex.I)⁻¹) *
        ((((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * (n : ℂ)) =
      ((((θ₁ - θ₀) / (2 * Real.pi) : ℝ) : ℂ) * (n : ℂ)) := by
  have htwo : (2 : ℂ) ≠ 0 := by norm_num
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hpi2 : (2 * (Real.pi : ℂ)) ≠ 0 := mul_ne_zero htwo hpi
  have hden : (2 * (Real.pi : ℂ) * Complex.I) ≠ 0 := mul_ne_zero hpi2 Complex.I_ne_zero
  field_simp [hden, hpi2, hpi, Complex.I_ne_zero]
  ring

theorem normalized_integral_sub_center_inv_int_arc {c : ℂ} {R θ₀ θ₁ : ℝ} {n : ℤ} (hR : R ≠ 0) :
    ((2 * (Real.pi : ℂ) * Complex.I)⁻¹) *
        (Mathlib.Analysis.Complex.PiecewiseContour.C1Path.arc c R θ₀ θ₁).integral
          (fun z => (z - c)⁻¹ * (n : ℂ)) =
      ((((θ₁ - θ₀) / (2 * Real.pi) : ℝ) : ℂ) * (n : ℂ)) := by
  rw [Mathlib.Analysis.Complex.PiecewiseContour.C1Path.integral_sub_center_inv_const_arc
    (res := (n : ℂ)) hR]
  simpa using normalized_arc_weight_eq (θ₀ := θ₀) (θ₁ := θ₁) (n := n)

theorem tendsto_normalized_integral_indent_arc_int {c : ℂ} {ρ θ₀ θ₁ : ℝ} {n : ℤ} (hρ : 0 < ρ)
    {g : ℂ → ℂ} (hg : ContinuousOn g (closedBall c ρ)) :
    Tendsto
      (fun ε : ℝ =>
        ((2 * (Real.pi : ℂ) * Complex.I)⁻¹) *
          (Mathlib.Analysis.Complex.PiecewiseContour.C1Path.arc c ε θ₀ θ₁).integral
            (fun z => (z - c)⁻¹ * (n : ℂ) + g z))
      (nhdsWithin (0 : ℝ) (Ioi 0))
      (𝓝
        (((2 * (Real.pi : ℂ) * Complex.I)⁻¹) *
          ((((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * (n : ℂ)))) := by
  have h :=
    Mathlib.Analysis.Complex.PiecewiseContour.C1Path.tendsto_integral_indent_arc
      (c := c) (res := (n : ℂ)) (ρ := ρ) (θ₀ := θ₀) (θ₁ := θ₁) hρ hg
  have hscale :
      Tendsto (fun _ : ℝ => (((2 * (Real.pi : ℂ) * Complex.I)⁻¹ : ℂ)))
        (nhdsWithin (0 : ℝ) (Ioi 0)) (𝓝 (((2 * (Real.pi : ℂ) * Complex.I)⁻¹ : ℂ))) :=
    tendsto_const_nhds
  simpa [C1Path.integral, div_eq_mul_inv, mul_assoc, mul_left_comm, mul_comm] using hscale.mul h

theorem normalized_full_turn_integral_sub_center_inv_int_arc
    {c : ℂ} {R θ : ℝ} {n : ℤ} (hR : R ≠ 0) :
    ((2 * (Real.pi : ℂ) * Complex.I)⁻¹) *
        (Mathlib.Analysis.Complex.PiecewiseContour.C1Path.arc c R θ (θ + 2 * Real.pi)).integral
          (fun z => (z - c)⁻¹ * (n : ℂ)) =
      (n : ℂ) := by
  have h := normalized_integral_sub_center_inv_int_arc
    (c := c) (R := R) (θ₀ := θ) (θ₁ := θ + 2 * Real.pi) (n := n) hR
  simpa [sub_eq_add_neg, add_assoc, neg_add_cancel, div_self, Real.pi_ne_zero, two_ne_zero] using h

end C1Path

namespace PiecewiseC1

variable {z₀ z₁ z₂ : ℂ}

theorem integral_eq_sub_of_hasDerivAt (γ : PiecewiseC1 z₀ z₁) {F H : ℂ → ℂ}
    (hH : ∀ z, HasDerivAt H (F z) z) (hcontF : Continuous F) :
    γ.integral F = H z₁ - H z₀ := by
  induction γ with
  | of_c1 γ =>
      simpa using
        MathlibExpansion.Analysis.Meromorphic.ArgumentPrinciple.C1Path.integral_eq_sub_of_hasDerivAt
          (γ := γ) hH hcontF
  | trans γ₁ γ₂ ih₁ ih₂ =>
      simp [ih₁, ih₂]
  | symm γ ih =>
      simp [ih]

theorem integral_eq_zero_of_hasDerivAt {z : ℂ} (γ : PiecewiseC1 z z) {F H : ℂ → ℂ}
    (hH : ∀ w, HasDerivAt H (F w) w) (hcontF : Continuous F) :
    γ.integral F = 0 := by
  simpa using integral_eq_sub_of_hasDerivAt (γ := γ) hH hcontF

theorem integral_logDeriv_eq_log_sub (γ : PiecewiseC1 z₀ z₁) {f f' : ℂ → ℂ}
    (hf : ∀ z, HasDerivAt f (f' z) z) (hf' : Continuous f')
    (hslit : ∀ z, f z ∈ Complex.slitPlane) :
    γ.integral (logDeriv f) = Complex.log (f z₁) - Complex.log (f z₀) := by
  refine integral_eq_sub_of_hasDerivAt (γ := γ) (F := logDeriv f)
    (H := fun z => Complex.log (f z)) ?_ ?_
  · intro z
    simpa [Function.comp_apply, logDeriv, Pi.div_apply, (hf z).deriv] using
      (hf z).clog (hslit z)
  · exact continuous_logDeriv_of_hasDerivAt_slit hf hf' hslit

theorem integral_logDeriv_eq_zero_of_closed {z : ℂ} (γ : PiecewiseC1 z z) {f f' : ℂ → ℂ}
    (hf : ∀ w, HasDerivAt f (f' w) w) (hf' : Continuous f')
    (hslit : ∀ w, f w ∈ Complex.slitPlane) :
    γ.integral (logDeriv f) = 0 := by
  simpa using integral_logDeriv_eq_log_sub (γ := γ) hf hf' hslit

@[simp]
theorem integral_logDeriv_rectangle_boundary_eq_zero (z w : ℂ) {f f' : ℂ → ℂ}
    (hf : ∀ u, HasDerivAt f (f' u) u) (hf' : Continuous f')
    (hslit : ∀ u, f u ∈ Complex.slitPlane) :
    (Mathlib.Analysis.Complex.PiecewiseContour.PiecewiseC1.rectangle_boundary z w).integral
      (logDeriv f) = 0 :=
  integral_logDeriv_eq_zero_of_closed
    (γ := Mathlib.Analysis.Complex.PiecewiseContour.PiecewiseC1.rectangle_boundary z w)
    hf hf' hslit

end PiecewiseC1

end MathlibExpansion.Analysis.Meromorphic.ArgumentPrinciple
