import MathlibExpansion.Dynamics.StableUnstable.PeriodicOrbit

/-!
# Heteroclinic basic shell

This file records the reusable heteroclinic boundary needed by the Poincare
homoclinic/heteroclinic front: an explicit infinite family of points lying in
the unstable set of one periodic orbit and the stable set of another.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Heteroclinic

def DistinctPeriodicOrbits {τ α : Type*} (gamma1 gamma2 : τ -> α) : Prop :=
  Set.range gamma1 ≠ Set.range gamma2

structure HeteroclinicIntersectionData (τ : Type*) (α : Type*) where
  flow : τ -> α -> α
  orbit1 : τ -> α
  orbit2 : τ -> α
  unstableSet : Set α
  stableSet : Set α
  distinct : DistinctPeriodicOrbits orbit1 orbit2
  intersections : Set α
  subset_intersections : intersections ⊆ unstableSet ∩ stableSet
  infinite_intersections : Set.Infinite intersections

theorem heteroclinic_intersection_yields_infinite_iterates
    {τ α : Type*} (data : HeteroclinicIntersectionData τ α) :
    Set.Infinite (data.unstableSet ∩ data.stableSet) :=
  data.infinite_intersections.mono data.subset_intersections

end Heteroclinic
end Dynamics
end MathlibExpansion
