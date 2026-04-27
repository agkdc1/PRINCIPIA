import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.PDE.Heat.LineSolution

/-!
# Heat semigroup interface

This file names the semigroup operator attached to the line heat kernel and
records the elementary semigroup identities that follow directly from the
Gaussian-convolution definition.

HVT closed in this file:

* `HKM_10` — the line heat semigroup vanishes on the zero initial datum,
  is equal to the Gaussian-convolution solution at every positive time,
  and collapses to the trivial zero operator at non-positive time.

No axioms.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Heat

/-- The heat semigroup on the line at time `t`. -/
def heatSemigroup (κ t : ℝ) (f : ℝ → ℝ) : ℝ → ℝ :=
  lineSolution κ t f

@[simp] theorem heatSemigroup_eq_lineSolution (κ t : ℝ) (f : ℝ → ℝ) :
    heatSemigroup κ t f = lineSolution κ t f :=
  rfl

@[simp] theorem heatSemigroup_zero (κ t : ℝ) :
    heatSemigroup κ t (0 : ℝ → ℝ) = 0 := by
  ext x
  simp [heatSemigroup]

/-- At non-positive `κ * t` the heat-kernel is identically zero, so the
semigroup operator sends every initial datum to zero. This captures the
definitional initial-time boundary of the Gaussian-convolution model. -/
theorem heatSemigroup_eq_zero_of_nonpos (κ t : ℝ) (f : ℝ → ℝ) (h : κ * t ≤ 0) :
    heatSemigroup κ t f = 0 := by
  ext x
  simp [heatSemigroup, lineSolution, heatKernel1D_eq_zero_of_nonpos h]

/-- The semigroup operator is linear in its initial datum (additive component). -/
theorem heatSemigroup_add (κ t : ℝ) (f g : ℝ → ℝ)
    (hf : ∀ x : ℝ, MeasureTheory.Integrable (fun y : ℝ => heatKernel1D κ t y * f (x - y)))
    (hg : ∀ x : ℝ, MeasureTheory.Integrable (fun y : ℝ => heatKernel1D κ t y * g (x - y))) :
    heatSemigroup κ t (fun x => f x + g x) =
      fun x => heatSemigroup κ t f x + heatSemigroup κ t g x := by
  ext x
  simp only [heatSemigroup, lineSolution]
  have : (fun y : ℝ => heatKernel1D κ t y * (f (x - y) + g (x - y)))
      = (fun y : ℝ => heatKernel1D κ t y * f (x - y)
          + heatKernel1D κ t y * g (x - y)) := by
    funext y; ring
  rw [this]
  rw [MeasureTheory.integral_add (hf x) (hg x)]

/-- The semigroup operator is homogeneous in its initial datum. -/
theorem heatSemigroup_smul (κ t c : ℝ) (f : ℝ → ℝ) :
    heatSemigroup κ t (fun x => c * f x) = fun x => c * heatSemigroup κ t f x := by
  ext x
  simp only [heatSemigroup, lineSolution]
  have : (fun y : ℝ => heatKernel1D κ t y * (c * f (x - y)))
      = (fun y : ℝ => c * (heatKernel1D κ t y * f (x - y))) := by
    funext y; ring
  rw [this, MeasureTheory.integral_mul_left]

/-- Pointwise unfolding of the semigroup operator at a single space point. -/
theorem heatSemigroup_apply (κ t : ℝ) (f : ℝ → ℝ) (x : ℝ) :
    heatSemigroup κ t f x = ∫ y : ℝ, heatKernel1D κ t y * f (x - y) := by
  simp [heatSemigroup, lineSolution]

/-- The heat semigroup applied to a constant initial datum returns that
constant: this is the conservation-of-constants identity, and is exactly
the mass-conservation identity for the heat kernel applied to the constant
function. This is the cleanest non-trivial semigroup identity that the
Gaussian-convolution definition immediately yields. -/
theorem heatSemigroup_const {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) (c : ℝ) :
    heatSemigroup κ t (fun _ : ℝ => c) = fun _ : ℝ => c := by
  ext x
  rw [heatSemigroup_apply]
  have hsplit :
      (fun y : ℝ => heatKernel1D κ t y * c)
        = fun y : ℝ => c * heatKernel1D κ t y := by
    funext y; ring
  rw [hsplit, MeasureTheory.integral_mul_left, integral_heatKernel1D_eq_one hκ ht]
  ring

/-- The heat semigroup at zero diffusivity sends every initial datum to
zero (degenerate diffusivity boundary). -/
@[simp] theorem heatSemigroup_zero_diffusivity (t : ℝ) (f : ℝ → ℝ) :
    heatSemigroup 0 t f = 0 := by
  apply heatSemigroup_eq_zero_of_nonpos
  simp

/-- The heat semigroup at zero time sends every initial datum to zero
(degenerate-time boundary, matching the Gaussian-convolution definition). -/
@[simp] theorem heatSemigroup_zero_time (κ : ℝ) (f : ℝ → ℝ) :
    heatSemigroup κ 0 f = 0 := by
  apply heatSemigroup_eq_zero_of_nonpos
  simp

end Heat
end PDE
end Analysis
end MathlibExpansion
