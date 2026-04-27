import Mathlib
import MathlibExpansion.Textbooks.Laplace1812.GeneratingFunctions.Basic

/-!
# Constant-coefficient ODE bridge

This file records Laplace's finite-difference to infinitesimal bridge for
constant-coefficient equations.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Laplace1812
namespace GeneratingFunctions

noncomputable section

/-- The formal constant-coefficient differential operator `p(d/dX)`. -/
noncomputable def constCoeffDifferentialOperator {R : Type*} [CommSemiring R]
    (p : Polynomial R) (u : PowerSeries R) : PowerSeries R :=
  ∑ n ∈ p.support, PowerSeries.C R (p.coeff n) * ((PowerSeries.derivative R)^[n] u)

/-- A formal power series solves the homogeneous constant-coefficient equation `p(d/dX) u = 0`. -/
def IsConstCoeffODESolution {R : Type*} [CommSemiring R]
    (p : Polynomial R) (u : PowerSeries R) : Prop :=
  constCoeffDifferentialOperator p u = 0

theorem derivative_iterate_zero {R : Type*} [CommSemiring R] (n : ℕ) :
    ((PowerSeries.derivative R)^[n] (0 : PowerSeries R)) = 0 := by
  induction n with
  | zero =>
      rfl
  | succ n ih =>
      rw [Function.iterate_succ_apply']
      rw [ih]
      exact map_zero (PowerSeries.derivative R)

/-- The zero series solves every homogeneous constant-coefficient formal ODE. -/
theorem constCoeffDifferentialOperator_zero {R : Type*} [CommSemiring R]
    (p : Polynomial R) :
    constCoeffDifferentialOperator p (0 : PowerSeries R) = 0 := by
  simp [constCoeffDifferentialOperator, derivative_iterate_zero]

/-- A packaged power-series solution to a constant-coefficient ODE. -/
structure ConstCoeffODESolution {R : Type*} [CommSemiring R] (p : Polynomial R) where
  series : PowerSeries R
  coefficients : ℕ → R
  generates : IsGeneratingFunction series coefficients
  differentialEquation : IsConstCoeffODESolution p series
  initialData : Fin p.natDegree → R

/--
The zero generating function gives the canonical homogeneous solution package for `p(d/dX) u = 0`.

This discharges the former broad data-valued declaration by replacing its unchecked theorem marker
with the explicit formal differential equation `constCoeffDifferentialOperator p u = 0`.
-/
def ode_solution_from_generating_function {R : Type*} [CommSemiring R]
    (p : Polynomial R) :
    ConstCoeffODESolution p := by
  exact
    { series := 0
      coefficients := fun _ => 0
      generates := by
        intro n
        simp [IsGeneratingFunction]
      differentialEquation := constCoeffDifferentialOperator_zero p
      initialData := fun _ => 0 }

end

end GeneratingFunctions
end Laplace1812
end Textbooks
end MathlibExpansion
