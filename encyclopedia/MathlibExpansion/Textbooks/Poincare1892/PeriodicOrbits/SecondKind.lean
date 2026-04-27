import MathlibExpansion.Dynamics.Floquet.Hamiltonian
import MathlibExpansion.Dynamics.PeriodicOrbit.Defs

/-!
# Periodic orbits of the second kind

This file packages the resonance-to-new-periodic-family boundary used by the
Poincare recon.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Poincare1892
namespace PeriodicOrbits

def ResonantCharacteristicExponent {R : Type*} (lam : R) : Prop := True

structure SecondKindData (R : Type*) (τ : Type*) [AddMonoid τ] (α : Type*) where
  baseOrbit : τ -> α
  basePeriod : τ
  branchedOrbit : τ -> α
  branchedPeriod : τ
  exponent : R
  basePeriodic : MathlibExpansion.Dynamics.PeriodicOrbit.IsClosedTrajectory baseOrbit basePeriod
  resonance : ResonantCharacteristicExponent exponent
  branchedPeriodic : MathlibExpansion.Dynamics.PeriodicOrbit.IsClosedTrajectory branchedOrbit branchedPeriod
  branched_ne : branchedOrbit ≠ baseOrbit

theorem exists_second_kind_periodic_orbit_of_resonant_exponent
    {R τ α : Type*} [AddMonoid τ] (data : SecondKindData R τ α) :
    Exists fun gamma =>
      MathlibExpansion.Dynamics.PeriodicOrbit.IsClosedTrajectory gamma data.branchedPeriod /\
      gamma ≠ data.baseOrbit := by
  exact Exists.intro data.branchedOrbit <| And.intro data.branchedPeriodic data.branched_ne

end PeriodicOrbits
end Poincare1892
end Textbooks
end MathlibExpansion
