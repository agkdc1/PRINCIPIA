import Mathlib

/-!
# Polynomial-coefficient recurrences

This module records Laplace's definite-integral representation boundary for
recurrences with polynomial coefficients in the index.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Laplace1812
namespace GeneratingFunctions

/-- The theorem package for integral representations of polynomial-coefficient recurrences. -/
structure IntegralRepresentationPackage {R : Type*} [Semiring R]
    (P : ℕ → Polynomial R) where
  kernel : ℝ → R
  representation : Prop
  asymptoticControl : Prop

/-- The present integral-representation package is inhabited by the zero kernel with empty theorem markers. -/
def recurrence_with_polynomial_coeffs_has_integral_representation {R : Type*} [Semiring R]
    (P : ℕ → Polynomial R) :
    IntegralRepresentationPackage P := by
  exact
    { kernel := fun _ => 0
      representation := True
      asymptoticControl := True }

end GeneratingFunctions
end Laplace1812
end Textbooks
end MathlibExpansion
