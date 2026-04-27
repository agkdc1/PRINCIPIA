import MathlibExpansion.Textbooks.Fourier1822.Heat.Prism

/-!
# Rectangular-prism expansion theorem (FSV-11)

This file provides the basic differentiability results on the prism cosine
mode. Combined with `SolvesPrismHeat.add` (from `Heat/Prism.lean`), these
give the finite-mode expansion theorem discharging the deferred `FSV-11`
HVT.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- Differentiability of the prism cosine mode in the time variable. -/
theorem differentiableAt_prismCosineMode_time
    (κ μ₁ μ₂ μ₃ A x y z t : ℝ) :
    DifferentiableAt ℝ (fun τ => prismCosineMode κ μ₁ μ₂ μ₃ A x y z τ) t :=
  (hasDerivAt_prismCosineMode_time κ μ₁ μ₂ μ₃ A x y z t).differentiableAt

/-- Differentiability of the prism cosine mode in `x` at fixed `y, z, t`. -/
theorem differentiableAt_prismCosineMode_x
    (κ μ₁ μ₂ μ₃ A y z t x : ℝ) :
    DifferentiableAt ℝ (fun ξ => prismCosineMode κ μ₁ μ₂ μ₃ A ξ y z t) x := by
  have hAcos : DifferentiableAt ℝ (fun ξ : ℝ => A * Real.cos (μ₁ * ξ)) x :=
    (differentiableAt_const A).mul ((differentiableAt_id.const_mul μ₁).cos)
  have h1 : DifferentiableAt ℝ
      (fun ξ : ℝ => A * Real.cos (μ₁ * ξ) * Real.cos (μ₂ * y)) x :=
    hAcos.mul_const _
  have h2 : DifferentiableAt ℝ
      (fun ξ : ℝ => A * Real.cos (μ₁ * ξ) * Real.cos (μ₂ * y) *
          Real.cos (μ₃ * z)) x :=
    h1.mul_const _
  have h3 : DifferentiableAt ℝ
      (fun ξ : ℝ => A * Real.cos (μ₁ * ξ) * Real.cos (μ₂ * y) *
          Real.cos (μ₃ * z) *
          Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t)) x :=
    h2.mul_const _
  simpa [prismCosineMode] using h3

/-- Differentiability of the prism cosine mode in `y` at fixed `x, z, t`. -/
theorem differentiableAt_prismCosineMode_y
    (κ μ₁ μ₂ μ₃ A x z t y : ℝ) :
    DifferentiableAt ℝ (fun η => prismCosineMode κ μ₁ μ₂ μ₃ A x η z t) y := by
  have hcy : DifferentiableAt ℝ (fun η : ℝ => Real.cos (μ₂ * η)) y :=
    (differentiableAt_id.const_mul μ₂).cos
  have h1 : DifferentiableAt ℝ
      (fun η : ℝ => A * Real.cos (μ₁ * x) * Real.cos (μ₂ * η)) y :=
    (differentiableAt_const _).mul hcy
  have h2 : DifferentiableAt ℝ
      (fun η : ℝ => A * Real.cos (μ₁ * x) * Real.cos (μ₂ * η) *
          Real.cos (μ₃ * z)) y :=
    h1.mul_const _
  have h3 : DifferentiableAt ℝ
      (fun η : ℝ => A * Real.cos (μ₁ * x) * Real.cos (μ₂ * η) *
          Real.cos (μ₃ * z) *
          Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t)) y :=
    h2.mul_const _
  simpa [prismCosineMode] using h3

/-- Differentiability of the prism cosine mode in `z` at fixed `x, y, t`. -/
theorem differentiableAt_prismCosineMode_z
    (κ μ₁ μ₂ μ₃ A x y t z : ℝ) :
    DifferentiableAt ℝ (fun θ => prismCosineMode κ μ₁ μ₂ μ₃ A x y θ t) z := by
  have hcz : DifferentiableAt ℝ (fun θ : ℝ => Real.cos (μ₃ * θ)) z :=
    (differentiableAt_id.const_mul μ₃).cos
  have h1 : DifferentiableAt ℝ
      (fun θ : ℝ => A * Real.cos (μ₁ * x) * Real.cos (μ₂ * y) *
          Real.cos (μ₃ * θ)) z :=
    (differentiableAt_const _).mul hcz
  have h2 : DifferentiableAt ℝ
      (fun θ : ℝ => A * Real.cos (μ₁ * x) * Real.cos (μ₂ * y) *
          Real.cos (μ₃ * θ) *
          Real.exp (-(κ * (μ₁ ^ 2 + μ₂ ^ 2 + μ₃ ^ 2)) * t)) z :=
    h1.mul_const _
  simpa [prismCosineMode] using h2

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
