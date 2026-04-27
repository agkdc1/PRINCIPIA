import Mathlib.Analysis.Fourier.AddCircle

/-!
# Fourier 1822 ring / armille package

This file introduces the modal solution operator on the circle and proves the
initial-trace theorem at time `t = 0` under the same summability hypothesis
used by Mathlib's pointwise Fourier-series reconstruction theorem.
-/

noncomputable section

open scoped Topology
open AddCircle

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace Heat

local instance : Fact (0 < 2 * Real.pi) := ⟨by positivity⟩

/-- Exponential modal weight for the circle heat flow. -/
def ringModeWeight (κ t : ℝ) (n : ℤ) : ℝ :=
  Real.exp (-κ * (n : ℝ) ^ 2 * t)

/-- Modal solution operator for the ring, written directly in the Fourier basis.

This is the textbook superposition formula. Convergence at positive time and the
full PDE verification remain deferred; the immediate theorem below records the
initial trace under a summability hypothesis. -/
def ringSolution
    (κ t : ℝ) (f : C(AddCircle (2 * Real.pi), ℂ))
    (x : AddCircle (2 * Real.pi)) : ℂ :=
  ∑' n : ℤ, fourierCoeff f n * (ringModeWeight κ t n : ℂ) * fourier n x

@[simp] theorem ringModeWeight_zero (κ : ℝ) (n : ℤ) :
    ringModeWeight κ 0 n = 1 := by
  simp [ringModeWeight]

/-- At time `0`, the modal superposition reduces to the original Fourier series.
Hence Mathlib's summable-coefficients theorem gives the correct initial trace. -/
theorem ringSolution_zero_eq
    (κ : ℝ) (f : C(AddCircle (2 * Real.pi), ℂ))
    (h : Summable (fourierCoeff f))
    (x : AddCircle (2 * Real.pi)) :
    ringSolution κ 0 f x = f x := by
  calc
    ringSolution κ 0 f x = ∑' n : ℤ, fourierCoeff f n * fourier n x := by
      simp [ringSolution, ringModeWeight_zero, mul_assoc]
    _ = f x := (has_pointwise_sum_fourier_series_of_summable (f := f) h x).tsum_eq

end Heat
end Fourier1822
end Textbooks
end MathlibExpansion
