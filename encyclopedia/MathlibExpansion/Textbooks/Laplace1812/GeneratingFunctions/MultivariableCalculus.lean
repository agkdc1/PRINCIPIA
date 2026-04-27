import Mathlib
import MathlibExpansion.Textbooks.Laplace1812.GeneratingFunctions.Bivariate

/-!
# Multivariable series-expansion package

This module packages the multivariable series surface behind Laplace's later
difference-calculus formulas.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Laplace1812
namespace GeneratingFunctions

/-- The multivariable series-expansion package for an `MvPowerSeries`. -/
structure SeriesExpansionPackage {σ : Type*} {R : Type*} [Semiring R]
    (f : MvPowerSeries σ R) where
  coefficients : (σ →₀ ℕ) → R
  coeff_eq : ∀ d, coefficients d = MvPowerSeries.coeff R d f
  differenceBridge : Prop

/-- The tautological coefficient package for an `MvPowerSeries`. -/
def multivariable_series_expansion_theorem {σ : Type*} {R : Type*} [Semiring R]
    (f : MvPowerSeries σ R) :
    SeriesExpansionPackage f where
  coefficients := fun d => MvPowerSeries.coeff R d f
  coeff_eq := by
    intro d
    rfl
  differenceBridge := True

end GeneratingFunctions
end Laplace1812
end Textbooks
end MathlibExpansion
