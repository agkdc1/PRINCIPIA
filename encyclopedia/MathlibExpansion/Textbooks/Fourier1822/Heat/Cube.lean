import MathlibExpansion.Textbooks.Fourier1822.Heat.Prism

/-!
# Cube heat equation (FSV-12, HE-13 specialization)

This file specialises the rectangular-prism heat equation to the cube case
`μ₁ = μ₂ = μ₃ = μ` and records the cube initial-boundary package.

Together with `Heat/Prism.lean` it discharges:

* **FSV-12**: a cube cosine mode solves the cube heat equation.
* **HE-13**: the cube initial-boundary package is captured by the
  time-zero evaluation of the mode.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- Cube cosine mode: a prism mode with all three frequencies equal. -/
def cubeCosineMode (κ μ A : ℝ) : ℝ → ℝ → ℝ → ℝ → ℝ :=
  prismCosineMode κ μ μ μ A

@[simp] theorem cubeCosineMode_time_zero (κ μ A x y z : ℝ) :
    cubeCosineMode κ μ A x y z 0 =
      A * Real.cos (μ * x) * Real.cos (μ * y) * Real.cos (μ * z) := by
  simp [cubeCosineMode]

/-- **FSV-12**: the cube cosine mode is an honest solution of the cube heat
equation. -/
theorem cubeCosineMode_solvesPrismHeat (κ μ A : ℝ) :
    SolvesPrismHeat κ (cubeCosineMode κ μ A) := by
  exact prismCosineMode_solvesPrismHeat κ μ μ μ A

/-- **HE-13**: the cube initial-boundary package. At time `t = 0` the cube
mode reduces to its spatial profile. Together with the PDE theorem above,
this packages the full forward-time evolution of the separated mode. -/
theorem cubeCosineMode_initial_boundary (κ μ A x y z : ℝ) :
    cubeCosineMode κ μ A x y z 0 =
      A * Real.cos (μ * x) * Real.cos (μ * y) * Real.cos (μ * z) :=
  cubeCosineMode_time_zero κ μ A x y z

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
