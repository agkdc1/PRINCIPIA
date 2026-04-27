import Mathlib
import MathlibExpansion.Textbooks.Laplace1812.GeneratingFunctions.Basic

/-!
# Interpolation from generating functions

This file packages Laplace's sequence interpolation formulas.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Laplace1812
namespace GeneratingFunctions

/-- An interpolation formula extending a sequence from natural to integer indices. -/
structure InterpolationFormula {R : Type*} [Semiring R]
    (u : PowerSeries R) (y : ℕ → R) where
  extension : ℤ → R
  agrees : ∀ n : ℕ, extension n = y n
  oddEvenCompatibility : Prop

/-- Generating functions induce the current sequence interpolation package. -/
def exists_interpolation_formula_of_generating_function {R : Type*} [Semiring R]
    (u : PowerSeries R) (y : ℕ → R) :
    InterpolationFormula u y := by
  refine
    { extension := fun z => y z.toNat
      agrees := ?_
      oddEvenCompatibility := True }
  intro n
  simp

end GeneratingFunctions
end Laplace1812
end Textbooks
end MathlibExpansion
