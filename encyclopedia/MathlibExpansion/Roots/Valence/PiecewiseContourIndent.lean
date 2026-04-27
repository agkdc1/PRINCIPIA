import MathlibExpansion.Roots.Valence.PiecewiseContour

/-!
# Local estimates for piecewise contour indents

This file stages the local arc computations that naturally sit on top of the
piecewise contour core:

- a norm bound for contour integrals on circular arcs;
- the exact arc integral of `(z - c)⁻¹`;
- a shrinking-indent limit for a principal part plus a continuous remainder.

These lemmas are the contour-specific part of the eventual argument-principle
story, but they do not require winding numbers, residues, or Jordan-curve
machinery.
-/

open MeasureTheory Set intervalIntegral Metric Filter

open scoped Interval Real Topology

noncomputable section

namespace Mathlib.Analysis.Complex.PiecewiseContour

namespace C1Path

/-- An arcwise analogue of
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

/-- Re-export the standard full-circle estimate under the piecewise contour
namespace. -/
theorem small_circle_estimate {c : ℂ} {R C : ℝ} (hR : 0 ≤ R) {f : ℂ → ℂ}
    (hf : ∀ z ∈ sphere c R, ‖f z‖ ≤ C) :
    ‖∮ z in C(c, R), f z‖ ≤ 2 * π * R * C :=
  circleIntegral.norm_integral_le_of_norm_le_const hR hf

/-- The contribution of a continuous remainder along a shrinking circular arc
tends to `0`. -/
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
      simpa using ((continuous_id.mul continuous_const).continuousAt.tendsto (x := (0 : ℝ)))
    exact hε0.mono_left nhdsWithin_le_nhds
  exact squeeze_zero_norm' hbound hε

/-- Residue contribution of a shrinking circular indent.  If `f` decomposes as
`res / (z - c)` plus a continuous remainder on a closed ball around `c`, then
the arc integral tends to the expected angle-weighted residue. -/
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
    refine Tendsto.congr' ?_ (tendsto_const_nhds.add hreg)
    filter_upwards [hprincipal, hsmallρ] with ε hε hsmall
    have hprincipal_cont :
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
    have hreg_cont : Continuous fun t : ℝ => g ((arc c ε θ₀ θ₁) t) :=
      hg.comp_continuous (arc c ε θ₀ θ₁).continuous_toFun hmaps
    have hprincipal_cont' :
        Continuous fun t : ℝ => (fun z : ℂ => (z - c)⁻¹ * res) ((arc c ε θ₀ θ₁) t) := by
      simpa using hprincipal_cont
    calc
      (((θ₁ - θ₀ : ℝ) : ℂ) * Complex.I) * res + (arc c ε θ₀ θ₁).integral g
          = (arc c ε θ₀ θ₁).integral (fun z : ℂ => (z - c)⁻¹ * res) +
              (arc c ε θ₀ θ₁).integral g := by
                rw [← hε]
      _ = (arc c ε θ₀ θ₁).integral (fun z => (z - c)⁻¹ * res + g z) := by
            symm
            exact (arc c ε θ₀ θ₁).integral_add_of_continuous
              (f := fun z : ℂ => (z - c)⁻¹ * res) (g := g) hprincipal_cont' hreg_cont
  simpa using hsum

end C1Path

end Mathlib.Analysis.Complex.PiecewiseContour
