import Mathlib
import MathlibExpansion.Textbooks.Laplace1812.GeneratingFunctions.LinearRecurrence

/-!
# Inhomogeneous constant-coefficient recurrences

This module extends the homogeneous recurrence bridge to Laplace's
inhomogeneous finite-difference equations.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Laplace1812
namespace GeneratingFunctions

/-- Inhomogeneous version of `LinearRecurrence.IsSolution`. -/
def InhomogeneousSolution {R : Type*} [CommSemiring R]
    (E : LinearRecurrence R) (f u : ℕ → R) : Prop :=
  ∀ n, u (n + E.order) = (∑ i, E.coeffs i * u (n + i)) + f n

/-- The theorem package for an inhomogeneous recurrence and its generating function. -/
structure InhomogeneousRecurrenceBridge {R : Type*} [CommSemiring R]
    (E : LinearRecurrence R) (f : ℕ → R) where
  solution : ℕ → R
  solves : InhomogeneousSolution E f solution
  generatingFunction : PowerSeries R
  encodes : IsGeneratingFunction generatingFunction solution

/-- The zero-initialized solution of an inhomogeneous constant-coefficient recurrence. -/
def mkInhomogeneousSolution {R : Type*} [CommSemiring R]
    (E : LinearRecurrence R) (f : ℕ → R) : ℕ → R
  | n =>
    if _ : n < E.order then
      0
    else
      (∑ k : Fin E.order,
        have _ : n - E.order + k < n := by omega
        E.coeffs k * mkInhomogeneousSolution E f (n - E.order + k)) + f (n - E.order)

/-- `mkInhomogeneousSolution` satisfies the inhomogeneous recurrence relation. -/
theorem mkInhomogeneousSolution_solves {R : Type*} [CommSemiring R]
    (E : LinearRecurrence R) (f : ℕ → R) :
    InhomogeneousSolution E f (mkInhomogeneousSolution E f) := by
  intro n
  rw [mkInhomogeneousSolution]
  simp

/-- Inhomogeneous constant-coefficient recurrences have generating-function solutions. -/
def exists_solution_of_linear_difference_inhomogeneous {R : Type*} [CommSemiring R]
    (E : LinearRecurrence R) (f : ℕ → R) :
    InhomogeneousRecurrenceBridge E f := by
  refine
    { solution := mkInhomogeneousSolution E f
      solves := mkInhomogeneousSolution_solves E f
      generatingFunction := PowerSeries.mk (mkInhomogeneousSolution E f)
      encodes := ?_ }
  intro n
  simp [IsGeneratingFunction]

end GeneratingFunctions
end Laplace1812
end Textbooks
end MathlibExpansion
