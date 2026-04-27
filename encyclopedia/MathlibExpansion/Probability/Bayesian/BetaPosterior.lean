import Mathlib

/-!
# Beta posterior boundary for Laplace 1812

This module lands the first theorem-shaped interface for the uniform-prior
Bernoulli posterior used throughout Laplace's inverse-probability chapter.

The definitional surface is explicit:

- the unnormalized kernel `x^s * (1 - x)^f`
- the supported density on `[0, 1]`
- the parameter update `(s, f) ↦ (s + 1, f + 1)`

The normalization constant is constructed as the reciprocal of the positive
integral of the polynomial kernel on `[0, 1]`.
-/

namespace MathlibExpansion
namespace Probability
namespace Bayesian

open MeasureTheory

/-- The support interval for the Laplace/Beta posterior. -/
def unitInterval : Set ℝ := Set.Icc 0 1

/-- The unnormalized Bernoulli posterior kernel under the uniform prior. -/
def bernoulliPosteriorKernel (s f : ℕ) (x : ℝ) : ℝ :=
  x ^ s * (1 - x) ^ f

/-- The normalized posterior density, once a normalization constant is supplied. -/
noncomputable def betaPosteriorDensity (s f : ℕ) (C : ℝ) (x : ℝ) : ℝ :=
  if x ∈ Set.Icc (0 : ℝ) 1 then C * bernoulliPosteriorKernel s f x else 0

/-- A density is normalized when its mass on `[0, 1]` is exactly `1`. -/
def NormalizedOnUnitInterval (g : ℝ → ℝ) : Prop :=
  ∫ x in unitInterval, g x = 1

/-- The theorem package behind Laplace's Beta posterior update. -/
structure BernoulliPosteriorUpdate (s f : ℕ) where
  normalizationConstant : ℝ
  positive_normalization : 0 < normalizationConstant
  normalizes : NormalizedOnUnitInterval (betaPosteriorDensity s f normalizationConstant)

/-- Laplace's 1812 beta posterior normalization for a uniform-prior Bernoulli model.

The cited analytic statement is the beta integral in Pierre-Simon Laplace,
*Theorie analytique des probabilites* (1812), Livre II, where the posterior
kernel is proportional to `x^s * (1 - x)^f`.  Here the required normalizing
constant is constructed directly as the reciprocal of the positive integral of
that continuous nonnegative kernel on `[0,1]`. -/
noncomputable def bernoulliPosteriorUpdate (s f : ℕ) : BernoulliPosteriorUpdate s f := by
  let I : ℝ := ∫ x in unitInterval, bernoulliPosteriorKernel s f x
  have hIpos : 0 < I := by
    have hset_interval :
        (∫ x in unitInterval, bernoulliPosteriorKernel s f x) =
          ∫ x in (0 : ℝ)..1, bernoulliPosteriorKernel s f x := by
      rw [unitInterval, intervalIntegral.integral_of_le zero_le_one,
        MeasureTheory.integral_Icc_eq_integral_Ioc]
    have hinterval : 0 < ∫ x in (0 : ℝ)..1, bernoulliPosteriorKernel s f x := by
      refine intervalIntegral.integral_pos zero_lt_one ?_ ?_ ?_
      · exact ((continuous_id.pow s).mul ((continuous_const.sub continuous_id).pow f)).continuousOn
      · intro x hx
        exact mul_nonneg (pow_nonneg hx.1.le s) (pow_nonneg (sub_nonneg.mpr hx.2) f)
      · refine ⟨(1 / 2 : ℝ), by norm_num, ?_⟩
        have hleft : 0 < (1 / 2 : ℝ) := by norm_num
        have hright : 0 < 1 - (1 / 2 : ℝ) := by norm_num
        exact mul_pos (pow_pos hleft s) (pow_pos hright f)
    show 0 < ∫ x in unitInterval, bernoulliPosteriorKernel s f x
    rw [hset_interval]
    exact hinterval
  refine
    { normalizationConstant := I⁻¹
      positive_normalization := inv_pos.mpr hIpos
      normalizes := ?_ }
  unfold NormalizedOnUnitInterval
  calc
    ∫ x in unitInterval, betaPosteriorDensity s f I⁻¹ x =
        ∫ x in unitInterval, I⁻¹ * bernoulliPosteriorKernel s f x := by
      refine setIntegral_congr_fun (by simp [unitInterval]) fun x hx => ?_
      have hx' : x ∈ Set.Icc (0 : ℝ) 1 := by
        simpa [unitInterval] using hx
      simp [betaPosteriorDensity, hx']
    _ = I⁻¹ * ∫ x in unitInterval, bernoulliPosteriorKernel s f x := by
      rw [integral_mul_left]
    _ = 1 := by
      rw [show (∫ x in unitInterval, bernoulliPosteriorKernel s f x) = I from rfl]
      exact inv_mul_cancel₀ hIpos.ne'

/-- Posterior parameters for a uniform-prior Bernoulli model. -/
def posteriorParameters (s f : ℕ) : ℕ × ℕ :=
  (s + 1, f + 1)

theorem posterior_parameters_update (s f : ℕ) :
    posteriorParameters s f = (Nat.succ s, Nat.succ f) :=
  rfl

theorem posterior_density_on_unitInterval (s f : ℕ) (C x : ℝ) (hx : x ∈ unitInterval) :
    betaPosteriorDensity s f C x = C * bernoulliPosteriorKernel s f x := by
  have hx' : x ∈ Set.Icc (0 : ℝ) 1 := by
    simpa [unitInterval] using hx
  simp [betaPosteriorDensity, hx']

theorem posterior_density_off_unitInterval (s f : ℕ) (C x : ℝ) (hx : x ∉ unitInterval) :
    betaPosteriorDensity s f C x = 0 := by
  have hx' : x ∉ Set.Icc (0 : ℝ) 1 := by
    simpa [unitInterval] using hx
  simp [betaPosteriorDensity, hx']

/-- Laplace's uniform-prior Bernoulli posterior density package. -/
theorem posterior_density_bernoulli_uniform (s f : ℕ) :
    ∃ C : ℝ, 0 < C ∧ NormalizedOnUnitInterval (betaPosteriorDensity s f C) := by
  refine ⟨(bernoulliPosteriorUpdate s f).normalizationConstant,
    (bernoulliPosteriorUpdate s f).positive_normalization,
    (bernoulliPosteriorUpdate s f).normalizes⟩

end Bayesian
end Probability
end MathlibExpansion
