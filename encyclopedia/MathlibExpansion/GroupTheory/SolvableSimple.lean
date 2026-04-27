import Mathlib.GroupTheory.Solvable
import Mathlib.GroupTheory.SpecificGroups.Cyclic

namespace MathlibExpansion
namespace GroupTheory

/--
A finite solvable simple group is cyclic of prime order.

This is the textbook-facing wrapper Jordan uses: `Mathlib` already proves that a simple solvable
group is commutative and classifies finite simple commutative groups.
-/
theorem finite_simple_solvable_isCyclic_and_prime_card
    (G : Type*) [Group G] [Finite G] [IsSimpleGroup G] [IsSolvable G] :
    IsCyclic G ∧ (Nat.card G).Prime := by
  have hcomm : ∀ a b : G, a * b = b * a :=
    (IsSimpleGroup.comm_iff_isSolvable (G := G)).2 inferInstance
  letI : CommGroup G := { ‹Group G› with mul_comm := hcomm }
  exact ⟨IsSimpleGroup.isCyclic, IsSimpleGroup.prime_card⟩

end GroupTheory
end MathlibExpansion
