import Mathlib

/-!
# Two-variable generating functions

This is the typed coefficient-extraction API for Laplace's bivariate
generating-series surface.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Laplace1812
namespace GeneratingFunctions

/-- A bivariate series `u` generates the coefficient table `y`. -/
def IsBivariateGeneratingFunction {R : Type*} [Semiring R]
    (u : MvPowerSeries (Fin 2) R) (y : ℕ → ℕ → R) : Prop :=
  ∀ m n, MvPowerSeries.coeff R (Finsupp.single 0 m + Finsupp.single 1 n) u = y m n

theorem coeff_eq_of_IsBivariateGeneratingFunction {R : Type*} [Semiring R]
    {u : MvPowerSeries (Fin 2) R} {y : ℕ → ℕ → R}
    (h : IsBivariateGeneratingFunction u y) (m n : ℕ) :
    MvPowerSeries.coeff R (Finsupp.single 0 m + Finsupp.single 1 n) u = y m n :=
  h m n

end GeneratingFunctions
end Laplace1812
end Textbooks
end MathlibExpansion
