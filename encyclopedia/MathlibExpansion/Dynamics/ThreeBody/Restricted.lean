import Mathlib.Algebra.Ring.Basic
import Mathlib.Data.Fintype.BigOperators

/-!
# Restricted three-body coordinate shell

This file gives a minimal state-space and Jacobi-integral package for the
planar restricted three-body problem.  It is intentionally a coordinate-level
boundary: enough to state invariant-energy claims and to support later Hill and
recurrence consumers without claiming the full Newtonian derivation.
-/

open scoped BigOperators

namespace MathlibExpansion
namespace Dynamics
namespace ThreeBody

/-- A planar state in rotating coordinates. -/
structure RestrictedState (R : Type*) where
  position : Fin 2 → R
  velocity : Fin 2 → R

/-- A simple Jacobi-style energy carrier for the restricted problem shell. -/
def jacobiIntegral {R : Type*} [Semiring R] (μ : R) (x : RestrictedState R) : R :=
  μ + ∑ i : Fin 2, x.velocity i * x.velocity i

/-- A trajectory equipped with an explicit Jacobi invariant. -/
structure RestrictedTrajectoryData (R : Type*) [Semiring R] (τ : Type*) where
  parameter : R
  trajectory : τ → RestrictedState R
  jacobiConstant : R
  jacobi_invariant : ∀ t, jacobiIntegral parameter (trajectory t) = jacobiConstant

theorem jacobi_integral_constant {R : Type*} [Semiring R] {τ : Type*}
    (data : RestrictedTrajectoryData R τ) (t : τ) :
    jacobiIntegral data.parameter (data.trajectory t) = data.jacobiConstant :=
  data.jacobi_invariant t

end ThreeBody
end Dynamics
end MathlibExpansion
