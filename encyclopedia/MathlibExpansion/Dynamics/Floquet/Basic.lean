import Mathlib.Data.Finset.Basic
import MathlibExpansion.Dynamics.PeriodicOrbit.Defs

/-!
# Coordinate-level Floquet data

The current namespace does not yet contain a full variational-equation or
monodromy construction. This file therefore isolates the executable core: a
closed trajectory together with a finite carrier for its characteristic
exponents.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Floquet

structure FloquetData (R : Type*) (τ : Type*) [AddMonoid τ] (α : Type*) where
  orbit : τ -> α
  period : τ
  periodic : PeriodicOrbit.IsClosedTrajectory orbit period
  characteristicExponents : Finset R

def characteristicExponentSet {R τ α : Type*} [AddMonoid τ]
    (data : FloquetData R τ α) : Set R :=
  data.characteristicExponents.toSet

@[simp] theorem mem_characteristicExponentSet {R τ α : Type*} [AddMonoid τ]
    (data : FloquetData R τ α) (lam : R) :
    lam ∈ characteristicExponentSet data ↔ lam ∈ data.characteristicExponents := Iff.rfl

theorem finite_characteristicExponentSet {R τ α : Type*} [AddMonoid τ]
    (data : FloquetData R τ α) :
    Set.Finite (characteristicExponentSet data) := by
  classical
  simpa [characteristicExponentSet] using data.characteristicExponents.finite_toSet

end Floquet
end Dynamics
end MathlibExpansion
