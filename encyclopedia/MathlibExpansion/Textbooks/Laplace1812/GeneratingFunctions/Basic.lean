import Mathlib

/-!
# Basic one-variable generating functions

This is the sequence-facing coefficient-extraction API for Laplace's Livre I.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Laplace1812
namespace GeneratingFunctions

/-- A power series `u` generates the sequence `y` when its coefficients are exactly `y`. -/
def IsGeneratingFunction {R : Type*} [Semiring R] (u : PowerSeries R) (y : ℕ → R) : Prop :=
  ∀ n, PowerSeries.coeff R n u = y n

/-- The coefficient sequence attached to a power series. -/
noncomputable def coefficientSequence {R : Type*} [Semiring R] (u : PowerSeries R) : ℕ → R :=
  fun n => PowerSeries.coeff R n u

theorem coeff_eq_of_IsGeneratingFunction {R : Type*} [Semiring R]
    {u : PowerSeries R} {y : ℕ → R} (h : IsGeneratingFunction u y) (n : ℕ) :
    PowerSeries.coeff R n u = y n :=
  h n

theorem coefficientSequence_isGeneratingFunction {R : Type*} [Semiring R] (u : PowerSeries R) :
    IsGeneratingFunction u (coefficientSequence u) := by
  intro n
  rfl

end GeneratingFunctions
end Laplace1812
end Textbooks
end MathlibExpansion
