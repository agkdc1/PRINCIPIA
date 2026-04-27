import Mathlib.Analysis.Calculus.Deriv.Basic
import MathlibExpansion.Textbooks.Fourier1822.HeatEquation.Model

/-!
# One-dimensional stationary profiles

This file packages the affine stationary slab profile from Fourier's Chapter I.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- The affine temperature profile across a slab of thickness `e` with endpoint
temperatures `a` and `b`. -/
def slabTemperature (a b e z : ℝ) : ℝ :=
  a + (b - a) * z / e

theorem stationary_slab_temperature_affine (a b e z : ℝ) :
    slabTemperature a b e z = a + (b - a) * z / e :=
  rfl

@[simp] theorem slabTemperature_zero (a b e : ℝ) :
    slabTemperature a b e 0 = a := by
  by_cases he : e = 0
  · subst he
    simp [slabTemperature]
  · simp [slabTemperature, he]

@[simp] theorem slabTemperature_thickness (a b e : ℝ) (he : e ≠ 0) :
    slabTemperature a b e e = b := by
  field_simp [slabTemperature, he]

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
