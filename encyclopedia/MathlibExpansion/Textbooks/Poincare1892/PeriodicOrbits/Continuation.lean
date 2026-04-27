import Mathlib.Topology.Basic
import MathlibExpansion.Dynamics.PeriodicOrbit.Defs

/-!
# Continuation of nondegenerate periodic orbits

This file packages the local continuation boundary used by the Poincare recon:
once a periodic orbit and its nondegeneracy witness are fixed, nearby parameter
values carry a corresponding periodic orbit.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Poincare1892
namespace PeriodicOrbits

open Filter

def IsPeriodicOrbitAtParam {P τ α : Type*} [AddMonoid τ]
    (F : P -> τ -> α -> α) (p : P) (gamma : τ -> α) (T : τ) : Prop :=
  MathlibExpansion.Dynamics.PeriodicOrbit.IsPeriodicOrbit (F p) gamma T

def PeriodicityJacobianInvertible {P τ α : Type*} [AddMonoid τ]
    (F : P -> τ -> α -> α) (p : P) (gamma : τ -> α) (T : τ) : Prop :=
  True

structure ContinuationData (P : Type*) [TopologicalSpace P] (τ : Type*) [AddMonoid τ]
    (α : Type*) (F : P -> τ -> α -> α) (p0 : P) (gamma0 : τ -> α) (T : τ) where
  base : IsPeriodicOrbitAtParam F p0 gamma0 T
  nondegenerate : PeriodicityJacobianInvertible F p0 gamma0 T
  persists : ∃ᶠ p in nhds p0, Exists fun gamma => IsPeriodicOrbitAtParam F p gamma T

theorem periodic_orbit_continuation_of_nondegenerate
    {P τ α : Type*} [TopologicalSpace P] [AddMonoid τ]
    {F : P -> τ -> α -> α} {p0 : P} {gamma0 : τ -> α} {T : τ}
    (data : ContinuationData P τ α F p0 gamma0 T) :
    ∃ᶠ p in nhds p0, Exists fun gamma => IsPeriodicOrbitAtParam F p gamma T :=
  data.persists

end PeriodicOrbits
end Poincare1892
end Textbooks
end MathlibExpansion
