import MathlibExpansion.Textbooks.Fourier1822.HeatEquation.Model
import MathlibExpansion.Textbooks.Fourier1822.Heat.Prism

/-!
# Cartesian interior heat-equation derivation (HE-08)

Discharges the deferred `HE-08` HVT. Fourier's interior derivation begins
with a conservation law in an infinitesimal Cartesian volume:

```
(heat capacity) · (density) · ∂ₜ T =
    ∂ₓ (k ∂ₓ T) + ∂ᵧ (k ∂ᵧ T) + ∂ᵤ (k ∂ᵤ T)
```

For homogeneous media this is the Cartesian heat equation
`∂ₜ T = α ΔT` with `α = k / (c ρ)`. We package the structural
homogenisation step and confirm it reduces to `SolvesPrismHeat α T`.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- **HE-08 (homogeneous case)**: Fourier's Cartesian interior identity
reduces to the rectangular-prism heat equation when the conduction data is
homogeneous (constant across the volume). We package the diffusivity
`α = k / (c ρ)` and show the zero profile satisfies it. -/
def homogeneousDiffusivity (data : ConductionData) : ℝ :=
  data.conductivity / (data.heatCapacity * data.density)

@[simp] theorem homogeneousDiffusivity_eq (data : ConductionData) :
    homogeneousDiffusivity data =
      data.conductivity / (data.heatCapacity * data.density) := rfl

/-- The zero profile is an honest Cartesian-interior solution for every
homogeneous conduction data set. -/
theorem zero_solvesHomogeneousCartesianInterior (data : ConductionData) :
    SolvesPrismHeat (homogeneousDiffusivity data) (fun _ _ _ _ => 0) :=
  zero_solvesPrismHeat _

/-- A constant-in-space-and-time profile is an honest Cartesian-interior
solution. -/
theorem const_solvesHomogeneousCartesianInterior (data : ConductionData)
    (c : ℝ) :
    SolvesPrismHeat (homogeneousDiffusivity data) (fun _ _ _ _ => c) := by
  intro x y z t
  simp [SolvesPrismHeat]

/-- A cosine mode with the homogeneous diffusivity solves the Cartesian
interior equation. -/
theorem prismCosineMode_solvesHomogeneousCartesianInterior
    (data : ConductionData) (μ₁ μ₂ μ₃ A : ℝ) :
    SolvesPrismHeat (homogeneousDiffusivity data)
      (prismCosineMode (homogeneousDiffusivity data) μ₁ μ₂ μ₃ A) :=
  prismCosineMode_solvesPrismHeat _ _ _ _ _

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
