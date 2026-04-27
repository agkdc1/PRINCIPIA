import Mathlib.Analysis.InnerProductSpace.EuclideanDist

/-!
# Directional flux (HE-07)

Discharges the deferred `HE-07` HVT. Heat flux in a prescribed direction `n`
is the inner product of the Fourier gradient vector with `n`, scaled by the
conductivity constant. We package this as a structural Lean object plus the
expected bilinearity and `n = 0` trivial theorems.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- The Fourier directional flux `q · n = -k ⟪∇u, n⟫`. Encoded at the level
of vectors already known. -/
def directionalFlux (k : ℝ) (gradU n : EuclideanSpace ℝ (Fin 3)) : ℝ :=
  -k * inner gradU n

@[simp] theorem directionalFlux_zero_direction (k : ℝ)
    (gradU : EuclideanSpace ℝ (Fin 3)) :
    directionalFlux k gradU 0 = 0 := by
  simp [directionalFlux]

@[simp] theorem directionalFlux_zero_gradient (k : ℝ)
    (n : EuclideanSpace ℝ (Fin 3)) :
    directionalFlux k 0 n = 0 := by
  simp [directionalFlux]

/-- **HE-07 bilinearity**: directional flux is additive in the gradient argument. -/
theorem directionalFlux_add_gradient (k : ℝ)
    (g₁ g₂ n : EuclideanSpace ℝ (Fin 3)) :
    directionalFlux k (g₁ + g₂) n =
      directionalFlux k g₁ n + directionalFlux k g₂ n := by
  simp [directionalFlux, inner_add_left, mul_add]

/-- **HE-07 bilinearity**: directional flux is additive in the direction argument. -/
theorem directionalFlux_add_direction (k : ℝ)
    (gradU n₁ n₂ : EuclideanSpace ℝ (Fin 3)) :
    directionalFlux k gradU (n₁ + n₂) =
      directionalFlux k gradU n₁ + directionalFlux k gradU n₂ := by
  simp [directionalFlux, inner_add_right, mul_add]

/-- **HE-07 constitutive scaling**: scaling conductivity scales the flux. -/
theorem directionalFlux_const_mul_conductivity (c k : ℝ)
    (gradU n : EuclideanSpace ℝ (Fin 3)) :
    directionalFlux (c * k) gradU n = c * directionalFlux k gradU n := by
  simp [directionalFlux]; ring

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
