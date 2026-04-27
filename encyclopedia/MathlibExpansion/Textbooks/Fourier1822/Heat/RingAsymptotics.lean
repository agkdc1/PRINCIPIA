import MathlibExpansion.Textbooks.Fourier1822.Heat.RingSingleMode
import Mathlib.Analysis.SpecialFunctions.Exp

/-!
# Ring asymptotics (FSV-04)

Discharges the deferred `FSV-04` HVT. Each cosine mode of the ring heat
equation is bounded in absolute value by an exponentially decaying
envelope.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- **FSV-04 pointwise amplitude bound**: every ring cosine mode is
bounded in absolute value by `|A| · exp(-κμ² t)`. -/
theorem abs_ringCosineMode_le (κ μ A x t : ℝ) :
    |ringCosineMode κ μ A x t| ≤ |A| * Real.exp (-(κ * μ ^ 2) * t) := by
  unfold ringCosineMode
  have hcos : |Real.cos (μ * x)| ≤ 1 := Real.abs_cos_le_one _
  have hexp_nonneg : 0 ≤ Real.exp (-(κ * μ ^ 2) * t) := (Real.exp_pos _).le
  rw [abs_mul, abs_mul]
  rw [abs_of_nonneg hexp_nonneg]
  have hA : |A| * |Real.cos (μ * x)| ≤ |A| * 1 :=
    mul_le_mul_of_nonneg_left hcos (abs_nonneg A)
  calc
    |A| * |Real.cos (μ * x)| * Real.exp (-(κ * μ ^ 2) * t)
        ≤ |A| * 1 * Real.exp (-(κ * μ ^ 2) * t) :=
          mul_le_mul_of_nonneg_right hA hexp_nonneg
    _ = |A| * Real.exp (-(κ * μ ^ 2) * t) := by ring

/-- **FSV-04 (non-growth)**: for `κ ≥ 0` and `t ≥ 0`, the amplitude
envelope is bounded by `|A|`. -/
theorem abs_ringCosineMode_le_amplitude
    {κ t : ℝ} (μ A x : ℝ) (hκ : 0 ≤ κ) (ht : 0 ≤ t) :
    |ringCosineMode κ μ A x t| ≤ |A| := by
  have h1 := abs_ringCosineMode_le κ μ A x t
  have hkappamu : 0 ≤ κ * μ ^ 2 := mul_nonneg hκ (sq_nonneg _)
  have hnonpos : -(κ * μ ^ 2) * t ≤ 0 := by
    have : 0 ≤ κ * μ ^ 2 * t := mul_nonneg hkappamu ht
    linarith
  have hexp_le_one : Real.exp (-(κ * μ ^ 2) * t) ≤ 1 :=
    Real.exp_le_one_iff.mpr hnonpos
  have h2 : |A| * Real.exp (-(κ * μ ^ 2) * t) ≤ |A| * 1 :=
    mul_le_mul_of_nonneg_left hexp_le_one (abs_nonneg A)
  linarith

/-- **FSV-04 (time-zero value)**: the mode equals `A · cos(μ x)` at `t = 0`. -/
theorem ringCosineMode_amplitude_at_zero (κ μ A x : ℝ) :
    ringCosineMode κ μ A x 0 = A * Real.cos (μ * x) := by
  simp [ringCosineMode]

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
