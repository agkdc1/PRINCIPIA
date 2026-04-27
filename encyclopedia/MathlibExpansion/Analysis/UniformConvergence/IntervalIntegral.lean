import Mathlib.Data.Real.Basic

import Mathlib

/-!
# Uniform convergence and interval integrals

This file packages the textbook-facing interval-integral wrapper used in the
Weierstrass uniform-convergence lane.
-/

noncomputable section

open Filter MeasureTheory
open scoped Topology

namespace MathlibExpansion
namespace Analysis
namespace UniformConvergence

/-- If `f n` converges uniformly to `g` on `[a, b]` and the approximants are
eventually continuous there, then their interval integrals converge to the
interval integral of `g`.

The interval-orientation hypothesis `a ≤ b` is explicit: without it, a theorem
stated on `Set.Icc a b` would say nothing about the actual integration domain
`uIcc a b`. -/
theorem tendsto_intervalIntegral_of_tendstoUniformlyOn
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    {f : ℕ → ℝ → E} {g : ℝ → E} {a b : ℝ}
    (hab : a ≤ b)
    (hfg : TendstoUniformlyOn f g atTop (Set.Icc a b))
    (hcont : ∀ᶠ n in atTop, ContinuousOn (f n) (Set.Icc a b)) :
    Tendsto (fun n => ∫ x in a..b, f n x) atTop (𝓝 (∫ x in a..b, g x)) := by
  have hgcont : ContinuousOn g (Set.Icc a b) := hfg.continuousOn hcont
  have hgInt : IntervalIntegrable g volume a b := hgcont.intervalIntegrable_of_Icc hab
  refine Metric.tendsto_atTop.2 ?_
  intro ε hε
  let C : ℝ := ε / (|b - a| + 1)
  have hCpos : 0 < C := by
    dsimp [C]
    positivity
  rcases Filter.eventually_atTop.mp ((Metric.tendstoUniformlyOn_iff.mp hfg) C hCpos) with
    ⟨N₁, hN₁⟩
  rcases Filter.eventually_atTop.mp hcont with ⟨N₂, hN₂⟩
  refine ⟨max N₁ N₂, fun n hn => ?_⟩
  have hfncont : ContinuousOn (f n) (Set.Icc a b) := hN₂ n (le_trans (le_max_right _ _) hn)
  have hfnInt : IntervalIntegrable (f n) volume a b := hfncont.intervalIntegrable_of_Icc hab
  have hbound : ∀ x ∈ Ι a b, ‖f n x - g x‖ ≤ C := by
    intro x hx
    have hx' : x ∈ Set.Icc a b := by
      have hxIoc : x ∈ Set.Ioc a b := by
        simpa [Set.uIoc_of_le hab] using hx
      exact Set.Ioc_subset_Icc_self hxIoc
    have hlt : dist (g x) (f n x) < C := hN₁ n (le_trans (le_max_left _ _) hn) x hx'
    exact le_of_lt (by simpa [dist_eq_norm, norm_sub_rev] using hlt)
  have hnorm :
      ‖∫ x in a..b, (f n x - g x)‖ ≤ C * |b - a| :=
    intervalIntegral.norm_integral_le_of_norm_le_const hbound
  have hCmul : C * |b - a| < ε := by
    have hlt : |b - a| < |b - a| + 1 := lt_add_of_pos_right _ zero_lt_one
    have hmul_lt : C * |b - a| < C * (|b - a| + 1) := by
      exact mul_lt_mul_of_pos_left hlt hCpos
    have hden : |b - a| + 1 ≠ 0 := by positivity
    have hCeq : C * (|b - a| + 1) = ε := by
      dsimp [C]
      field_simp [hden]
    simpa [hCeq] using hmul_lt
  calc
    dist (∫ x in a..b, f n x) (∫ x in a..b, g x)
        = ‖∫ x in a..b, f n x - g x‖ := by
            rw [dist_eq_norm, ← intervalIntegral.integral_sub hfnInt hgInt]
    _ ≤ C * |b - a| := hnorm
    _ < ε := hCmul

end UniformConvergence
end Analysis
end MathlibExpansion
