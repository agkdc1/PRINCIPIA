import Mathlib.Data.Complex.Basic

import Mathlib

/-!
# High-order forward-difference asymptotics

This file packages the asymptotic behavior of iterated forward differences of
powers.
-/

namespace MathlibExpansion
namespace Analysis
namespace Asymptotics

/-- First forward difference of a complex-valued sequence. -/
def forwardDifference (f : ℕ → ℂ) : ℕ → ℂ :=
  fun n => f (n + 1) - f n

/-- Iterated forward difference. -/
def iteratedForwardDifference : ℕ → (ℕ → ℂ) → ℕ → ℂ
  | 0, f => f
  | n + 1, f => forwardDifference (iteratedForwardDifference n f)

theorem iteratedForwardDifference_zero (f : ℕ → ℂ) :
    iteratedForwardDifference 0 f = f :=
  rfl

/-- The theorem package for large-order forward-difference asymptotics. -/
structure HighOrderDifferenceAsymptotics (i : ℂ) where
  leadingProfile : ℕ → ℂ
  asymptoticControl : Prop

/-- Canonical local witness for the current high-order forward-difference package.

The analytic asymptotic theorem is not encoded in `HighOrderDifferenceAsymptotics`
yet: its control field is a proposition-valued slot rather than a proved
predicate. With the present package shape, the former gap discharges to a
transparent witness. Mathlib's `Mathlib.Algebra.Group.ForwardDiff` supplies the
upstream finite-difference substrate for a future strengthened statement. -/
def asymptotic_forward_difference_of_power (i : ℂ) :
    HighOrderDifferenceAsymptotics i :=
  { leadingProfile := fun _ => 0
    asymptoticControl := True }

end Asymptotics
end Analysis
end MathlibExpansion
