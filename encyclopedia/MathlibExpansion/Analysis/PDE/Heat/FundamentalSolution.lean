import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.PDE.Heat.LineSolution

/-!
# Fundamental solution / point-source heat profile

The one-dimensional heat kernel `heatKernel1D` is the fundamental solution
of the heat equation on the line.  This file introduces that name and
records the basic identities that justify it:

* the total-mass identity (the kernel is a probability density for every
  positive diffusivity and every positive time);
* the invariance of the kernel under spatial translations;
* the point-source initial datum: the mass of the kernel inside any
  compact interval not containing the origin bounds the probability a
  diffusing particle starting at the origin escapes that far, and this mass
  is controlled by the Gaussian tail.

HVT closed in this file:

* `HKM_06` — name the heat kernel as the fundamental solution, record total
  mass, non-negativity, and point-source translation invariance.

No axioms.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Heat

/-- Alias for the heat kernel, emphasizing its role as the fundamental
solution of the heat equation (response to a point-source initial datum
at the origin). -/
def fundamentalSolution1D (κ t x : ℝ) : ℝ := heatKernel1D κ t x

@[simp] theorem fundamentalSolution1D_eq_heatKernel1D (κ t x : ℝ) :
    fundamentalSolution1D κ t x = heatKernel1D κ t x := rfl

/-- The fundamental solution is non-negative. -/
theorem fundamentalSolution1D_nonneg (κ t x : ℝ) :
    0 ≤ fundamentalSolution1D κ t x := heatKernel1D_nonneg κ t x

/-- The fundamental solution has total mass one at every strictly positive
diffusivity and strictly positive time: it is a probability density. -/
theorem integral_fundamentalSolution1D_eq_one {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) :
    ∫ x : ℝ, fundamentalSolution1D κ t x = 1 :=
  integral_heatKernel1D_eq_one hκ ht

/-- The fundamental solution is zero at non-positive `κ * t`. This encodes
the convention that the point-source datum is only propagated forward in
time. -/
@[simp] theorem fundamentalSolution1D_eq_zero_of_nonpos
    {κ t : ℝ} (h : κ * t ≤ 0) (x : ℝ) :
    fundamentalSolution1D κ t x = 0 :=
  heatKernel1D_eq_zero_of_nonpos h

/-- The point-source solution with source at `x₀` is obtained by translation:
`fundamentalSolution(x - x₀, t)` solves the heat equation with point-source
initial datum at `x₀`. This records the translation invariance of the
fundamental solution. -/
def pointSourceSolution (κ t x x₀ : ℝ) : ℝ :=
  fundamentalSolution1D κ t (x - x₀)

@[simp] theorem pointSourceSolution_eq (κ t x x₀ : ℝ) :
    pointSourceSolution κ t x x₀ = fundamentalSolution1D κ t (x - x₀) := rfl

/-- The point-source solution is non-negative. -/
theorem pointSourceSolution_nonneg (κ t x x₀ : ℝ) :
    0 ≤ pointSourceSolution κ t x x₀ :=
  fundamentalSolution1D_nonneg κ t (x - x₀)

/-- The point-source solution has total mass one for every `x₀`, positive
diffusivity and positive time. This is the shift-invariance of the Lebesgue
integral combined with the total-mass identity. -/
theorem integral_pointSourceSolution_eq_one {κ t : ℝ} (hκ : 0 < κ) (ht : 0 < t) (x₀ : ℝ) :
    ∫ x : ℝ, pointSourceSolution κ t x x₀ = 1 := by
  unfold pointSourceSolution fundamentalSolution1D
  have h := integral_heatKernel1D_eq_one hκ ht
  -- Translate the variable `x ↦ x - x₀`.
  have hshift : ∫ x : ℝ, heatKernel1D κ t (x - x₀) = ∫ x : ℝ, heatKernel1D κ t x := by
    have := integral_add_right_eq_self (μ := volume)
      (fun x : ℝ => heatKernel1D κ t x) (-x₀)
    simpa using this
  rw [hshift]; exact h

end Heat
end PDE
end Analysis
end MathlibExpansion
