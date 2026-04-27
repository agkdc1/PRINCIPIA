import MathlibExpansion.Dynamics.Floquet.Basic

/-!
# Autonomous Floquet shell

For an autonomous periodic orbit, the time-shift direction contributes a zero
characteristic exponent. This file packages that boundary as a reusable
extension of the basic Floquet data.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Floquet

structure AutonomousFloquetData (R : Type*) (τ : Type*) [AddMonoid τ] [Zero R] [DecidableEq R]
    (α : Type*) extends FloquetData R τ α where
  zero_mem : 0 ∈ characteristicExponents

theorem zero_characteristicExponent_of_autonomous_periodic_orbit
    {R τ α : Type*} [AddMonoid τ] [Zero R] [DecidableEq R]
    (data : AutonomousFloquetData R τ α) :
    0 ∈ characteristicExponentSet data.toFloquetData := by
  simpa [characteristicExponentSet] using data.zero_mem

end Floquet
end Dynamics
end MathlibExpansion
