import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.PDE.Heat.LineSolution

/-!
# Method of images for the heat equation on the half-line

The method of images constructs the Dirichlet and Neumann heat kernels on the
half-line `(0, ∞)` by reflecting the whole-line kernel about the origin.
The Dirichlet kernel vanishes at `x = 0`; the Neumann kernel doubles at
`x = 0`.

HVT closed in this file:

* `HKM_04` — the Dirichlet image kernel vanishes at the reflecting boundary
  `x = 0`, together with the matching Neumann doubling identity and the
  symmetry lemmas.

No axioms.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Heat

/-- The one-dimensional heat kernel is an even function of the spatial
coordinate: `K(-x, t) = K(x, t)`. This is the Gaussian's reflection
symmetry. -/
theorem heatKernel1D_neg (κ t x : ℝ) :
    heatKernel1D κ t (-x) = heatKernel1D κ t x := by
  unfold heatKernel1D
  by_cases h : 0 < κ * t
  · simp [h, gaussianPDFReal]
  · simp [h]

/-- The Dirichlet image heat kernel on the half-line:
`K_D(x, y, t) = K(x - y, t) - K(x + y, t)`. -/
def dirichletImageKernel (κ t x y : ℝ) : ℝ :=
  heatKernel1D κ t (x - y) - heatKernel1D κ t (x + y)

/-- The Neumann image heat kernel on the half-line:
`K_N(x, y, t) = K(x - y, t) + K(x + y, t)`. -/
def neumannImageKernel (κ t x y : ℝ) : ℝ :=
  heatKernel1D κ t (x - y) + heatKernel1D κ t (x + y)

/-- At the reflecting boundary `x = 0`, the Dirichlet image kernel vanishes
identically in `y` and `t`, for every `y : ℝ` and every `t`. -/
@[simp] theorem dirichletImageKernel_zero (κ t y : ℝ) :
    dirichletImageKernel κ t 0 y = 0 := by
  unfold dirichletImageKernel
  have h1 : heatKernel1D κ t (0 - y) = heatKernel1D κ t y := by
    rw [zero_sub]; exact heatKernel1D_neg κ t y
  have h2 : heatKernel1D κ t (0 + y) = heatKernel1D κ t y := by
    rw [zero_add]
  rw [h1, h2]
  ring

/-- The Neumann image kernel at the reflecting boundary `x = 0` is twice the
whole-line kernel evaluated at `y`: `K_N(0, y, t) = 2 K(y, t)`. -/
theorem neumannImageKernel_zero (κ t y : ℝ) :
    neumannImageKernel κ t 0 y = 2 * heatKernel1D κ t y := by
  unfold neumannImageKernel
  have h1 : heatKernel1D κ t (0 - y) = heatKernel1D κ t y := by
    rw [zero_sub]; exact heatKernel1D_neg κ t y
  have h2 : heatKernel1D κ t (0 + y) = heatKernel1D κ t y := by
    rw [zero_add]
  rw [h1, h2]; ring

/-- The Dirichlet image kernel is odd under reflection `x → -x`. -/
theorem dirichletImageKernel_odd (κ t x y : ℝ) :
    dirichletImageKernel κ t (-x) y = - dirichletImageKernel κ t x y := by
  unfold dirichletImageKernel
  have h1 : heatKernel1D κ t (-x - y) = heatKernel1D κ t (x + y) := by
    have : -x - y = -(x + y) := by ring
    rw [this, heatKernel1D_neg]
  have h2 : heatKernel1D κ t (-x + y) = heatKernel1D κ t (x - y) := by
    have : -x + y = -(x - y) := by ring
    rw [this, heatKernel1D_neg]
  rw [h1, h2]; ring

/-- The Neumann image kernel is even under reflection `x → -x`. -/
theorem neumannImageKernel_even (κ t x y : ℝ) :
    neumannImageKernel κ t (-x) y = neumannImageKernel κ t x y := by
  unfold neumannImageKernel
  have h1 : heatKernel1D κ t (-x - y) = heatKernel1D κ t (x + y) := by
    have : -x - y = -(x + y) := by ring
    rw [this, heatKernel1D_neg]
  have h2 : heatKernel1D κ t (-x + y) = heatKernel1D κ t (x - y) := by
    have : -x + y = -(x - y) := by ring
    rw [this, heatKernel1D_neg]
  rw [h1, h2]; ring

/-- The half-line Dirichlet solution operator: integrate the initial datum
against the Dirichlet image kernel over the positive half-line. -/
def halfLineDirichletSolution (κ t : ℝ) (f : ℝ → ℝ) : ℝ → ℝ :=
  fun x => ∫ y in Set.Ioi (0 : ℝ), dirichletImageKernel κ t x y * f y

/-- The half-line Neumann solution operator. -/
def halfLineNeumannSolution (κ t : ℝ) (f : ℝ → ℝ) : ℝ → ℝ :=
  fun x => ∫ y in Set.Ioi (0 : ℝ), neumannImageKernel κ t x y * f y

/-- At the reflecting boundary `x = 0`, the half-line Dirichlet solution
vanishes identically on every initial datum and at every time. -/
@[simp] theorem halfLineDirichletSolution_boundary (κ t : ℝ) (f : ℝ → ℝ) :
    halfLineDirichletSolution κ t f 0 = 0 := by
  unfold halfLineDirichletSolution
  simp [dirichletImageKernel_zero]

end Heat
end PDE
end Analysis
end MathlibExpansion
