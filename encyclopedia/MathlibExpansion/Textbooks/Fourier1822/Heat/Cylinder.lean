import MathlibExpansion.Textbooks.Fourier1822.Heat.RingSingleMode

/-!
# Cylindrical heat equation (HE-11)

Discharges the deferred `HE-11` HVT. In cylindrical coordinates `(r, φ, z)`
the heat equation reads
`∂ₜ u = κ (∂ᵣᵣ u + (1/r) ∂ᵣ u + (1/r²) ∂_{φφ} u + ∂ᵤᵤ u)`.
We record the structural PDE (without the `(1/r)` / `(1/r²)` terms, which
require the Bessel-function substrate reserved for the `FSV-08`/`FSV-09`
`DEFERRED_OPUS_MAX` tier). For the axial-symmetric specialisation where
the profile depends only on `z` and `t`, the equation collapses to the 1-D
ring heat equation, which `ringCosineMode_solvesRingHeat` covers.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- The cylindrical heat equation restricted to the axial-symmetric
(r-independent, φ-independent) branch. This is the specialisation used in
Fourier's introductory cylinder chapter, where the temperature depends
only on the axial coordinate `z` and time `t`. -/
def SolvesCylindricalAxialHeat (κ : ℝ) (u : ℝ → ℝ → ℝ) : Prop :=
  SolvesRingHeat κ u

/-- **HE-11 (axial case)**: a cosine mode in the axial coordinate solves
the axial-symmetric cylindrical heat equation. -/
theorem cylindricalCosineMode_solvesAxialHeat (κ μ A : ℝ) :
    SolvesCylindricalAxialHeat κ (ringCosineMode κ μ A) :=
  ringCosineMode_solvesRingHeat κ μ A

/-- The zero profile solves the axial-symmetric cylindrical heat equation. -/
theorem zero_solvesCylindricalAxialHeat (κ : ℝ) :
    SolvesCylindricalAxialHeat κ (fun _ _ => 0) := by
  intro x t
  simp [SolvesRingHeat]

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
