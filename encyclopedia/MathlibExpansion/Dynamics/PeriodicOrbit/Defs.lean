import Mathlib.Dynamics.Flow

/-!
# Periodic-orbit definitions

This file provides a small, reusable notion of an orbit and a closed trajectory
for an additive-time family.  It is intentionally lightweight: the point is to
give later Poincare-section and Floquet files a common vocabulary without
pretending that Mathlib already contains the full classical mechanics stack.
-/

namespace MathlibExpansion
namespace Dynamics
namespace PeriodicOrbit

section

variable {τ α : Type*} [AddMonoid τ]

/-- A trajectory `γ` follows the family `φ` if time-addition along the orbit agrees with `φ`. -/
def IsOrbit (φ : τ → α → α) (γ : τ → α) : Prop :=
  ∀ s t, γ (s + t) = φ s (γ t)

/-- A trajectory is closed with period `T` if it repeats after time-shift by `T`. -/
def IsClosedTrajectory (γ : τ → α) (T : τ) : Prop :=
  ∀ t, γ (t + T) = γ t

/-- A periodic orbit is an orbit that is also a closed trajectory. -/
def IsPeriodicOrbit (φ : τ → α → α) (γ : τ → α) (T : τ) : Prop :=
  IsOrbit φ γ ∧ IsClosedTrajectory γ T

theorem returns_to_basepoint {φ : τ → α → α} {γ : τ → α} {T : τ}
    (h : IsPeriodicOrbit φ γ T) :
    φ T (γ 0) = γ 0 := by
  rcases h with ⟨horbit, hclosed⟩
  calc
    φ T (γ 0) = γ (T + 0) := by simpa using (horbit T 0).symm
    _ = γ (0 + T) := by simp
    _ = γ 0 := by simpa using hclosed 0

theorem closedTrajectory_nsmul {γ : τ → α} {T : τ} (h : IsClosedTrajectory γ T) :
    ∀ n : ℕ, ∀ t : τ, γ (t + n • T) = γ t
  | 0, t => by simp
  | n + 1, t => by
      calc
        γ (t + (n + 1) • T) = γ ((t + n • T) + T) := by simp [add_assoc, succ_nsmul]
        _ = γ (t + n • T) := h (t + n • T)
        _ = γ t := closedTrajectory_nsmul (h := h) n t

end

end PeriodicOrbit
end Dynamics
end MathlibExpansion
