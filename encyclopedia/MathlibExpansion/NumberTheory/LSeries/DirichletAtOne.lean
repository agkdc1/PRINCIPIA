import Mathlib.NumberTheory.LSeries.DirichletContinuation

/-!
# Dirichlet series at `s = 1`

This packages the textbook-facing one-sided limit statement deduced from the
analytic continuation of Dirichlet `L`-functions.
-/

open scoped Topology

theorem DirichletCharacter.tendsto_LSeries_at_one_of_ne_one (χ : DirichletCharacter ℂ q)
    [NeZero q] (hχ : χ ≠ 1) :
    Filter.Tendsto (fun x : ℝ ↦ LSeries (χ ·) (x : ℂ)) (𝓝[>] (1 : ℝ))
      (𝓝 (DirichletCharacter.LFunction χ (1 : ℂ))) := by
  have hMap :
      Filter.Tendsto (fun x : ℝ ↦ (x : ℂ)) (𝓝[>] (1 : ℝ))
        (𝓝[{s : ℂ | 1 < s.re}] (1 : ℂ)) :=
    Complex.continuous_ofReal.continuousWithinAt.tendsto_nhdsWithin (fun _ hs ↦ by simpa using hs)
  have hcont :
      Filter.Tendsto (fun s : ℂ ↦ DirichletCharacter.LFunction χ s)
        (𝓝[{s : ℂ | 1 < s.re}] (1 : ℂ))
        (𝓝 (DirichletCharacter.LFunction χ (1 : ℂ))) :=
    (DirichletCharacter.differentiableAt_LFunction χ (1 : ℂ) (Or.inr hχ)).continuousAt.tendsto
      |>.mono_left nhdsWithin_le_nhds
  have hEq :
      (fun s : ℂ ↦ DirichletCharacter.LFunction χ s) =ᶠ[𝓝[{s : ℂ | 1 < s.re}] (1 : ℂ)]
        fun s : ℂ ↦ LSeries (χ ·) s := by
    filter_upwards [self_mem_nhdsWithin] with s hs
    simpa using DirichletCharacter.LFunction_eq_LSeries χ hs
  exact (hcont.congr' hEq).comp hMap
