import MathlibExpansion.Dynamics.PeriodicOrbit.Defs

/-!
# Hill-problem periodic-family shell

This file packages the coordinate-level Hill-family boundary used by the
Poincare three-body recon.
-/

namespace MathlibExpansion
namespace Dynamics
namespace ThreeBody

structure HillState (R : Type*) where
  position : Fin 2 -> R
  velocity : Fin 2 -> R

def IsHillPeriodicOrbit {R τ : Type*} [AddMonoid τ] (gamma : τ -> HillState R) (T : τ) : Prop :=
  PeriodicOrbit.IsClosedTrajectory gamma T

structure HillPeriodicFamilyData (R : Type*) (τ : Type*) [AddMonoid τ] where
  period : τ
  orbit : τ -> HillState R
  symmetric : Prop
  periodic : IsHillPeriodicOrbit orbit period
  symmetric_ok : symmetric

theorem hill_problem_exists_symmetric_periodic_family
    {R τ : Type*} [AddMonoid τ] (data : HillPeriodicFamilyData R τ) :
    Exists fun gamma : τ -> HillState R => IsHillPeriodicOrbit gamma data.period /\ data.symmetric := by
  exact Exists.intro data.orbit <| And.intro data.periodic data.symmetric_ok

end ThreeBody
end Dynamics
end MathlibExpansion
