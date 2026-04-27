import MathlibExpansion.Dynamics.StableUnstable.PeriodicOrbit

/-!
# Homoclinic section intersections

This file packages the coordinate-level homoclinic boundary used in the breach:
an explicit point lying on both the stable and unstable section traces of the
same periodic orbit, away from the orbit basepoint.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Homoclinic

structure HomoclinicIntersectionData (τ : Type*) (α : Type*) [AddMonoid τ] where
  package : StableUnstable.StableUnstablePackage τ α
  point : α
  point_ne_base : point ≠ package.orbit 0
  mem_stable : point ∈ package.stableSurface
  mem_unstable : point ∈ package.unstableSurface

theorem asymptotic_surfaces_same_periodic_orbit_intersect
    {τ α : Type*} [AddMonoid τ] (data : HomoclinicIntersectionData τ α) :
    Exists fun x =>
      x ≠ data.package.orbit 0 /\ x ∈ data.package.stableSurface /\ x ∈ data.package.unstableSurface := by
  exact Exists.intro data.point <|
    And.intro data.point_ne_base <| And.intro data.mem_stable data.mem_unstable

end Homoclinic
end Dynamics
end MathlibExpansion
