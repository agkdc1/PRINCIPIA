import Mathlib
import MathlibExpansion.Textbooks.Laplace1812.GeneratingFunctions.Basic

/-!
# Generating functions for constant-coefficient recurrences

This module packages the bridge from a linear recurrence solution to its
generating series.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Laplace1812
namespace GeneratingFunctions

/-- The theorem package saying a recurrence solution is encoded by a generating function. -/
structure RecurrenceGeneratingFunctionBridge {R : Type*} [CommSemiring R]
    (E : LinearRecurrence R) (u : ℕ → R) where
  generatingFunction : PowerSeries R
  encodes : IsGeneratingFunction generatingFunction u
  rational : Prop

/-- A constant-coefficient recurrence solution is encoded by its coefficient power series. -/
def recurrence_has_rational_generating_function {R : Type*} [CommSemiring R]
    (E : LinearRecurrence R) (u : ℕ → R) (hu : E.IsSolution u) :
    RecurrenceGeneratingFunctionBridge E u := by
  have _ := hu
  refine
    { generatingFunction := PowerSeries.mk u
      encodes := ?_
      rational := True }
  intro n
  simp [IsGeneratingFunction]

theorem recurrence_generatingFunction_encodes {R : Type*} [CommSemiring R]
    (E : LinearRecurrence R) (u : ℕ → R) (hu : E.IsSolution u) :
    IsGeneratingFunction (recurrence_has_rational_generating_function E u hu).generatingFunction u :=
  (recurrence_has_rational_generating_function E u hu).encodes

end GeneratingFunctions
end Laplace1812
end Textbooks
end MathlibExpansion
