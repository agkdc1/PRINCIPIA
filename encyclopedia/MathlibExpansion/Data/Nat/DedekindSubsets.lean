import Mathlib.Data.Set.Finite.Lattice
import Mathlib.Logic.Denumerable
import MathlibExpansion.Foundations.Dedekind.SimplyInfinite

/-!
# Dedekind's dichotomy for subsets of `ℕ`

Finite subsets of `ℕ` are exactly the bounded-above ones; unbounded subsets carry
the structure of a simply infinite system.
-/

namespace MathlibExpansion
namespace Data
namespace Nat

open Foundations.Dedekind

theorem nat_subset_finite_iff_bddAbove (s : Set ℕ) : s.Finite ↔ BddAbove s := by
  constructor
  · exact Set.Finite.bddAbove
  · rintro ⟨n, hn⟩
    exact (Set.finite_le_nat n).subset hn

theorem simplyInfinite_of_not_bddAbove (s : Set ℕ) [DecidablePred (· ∈ s)]
    (hs : ¬ BddAbove s) : Nonempty (SimplyInfiniteSystem s) := by
  letI : Infinite s := (Set.infinite_of_not_bddAbove hs).to_subtype
  letI := Nat.Subtype.denumerable s
  exact ⟨SimplyInfiniteSystem.ofNatEquiv (Denumerable.eqv s)⟩

theorem finite_or_simplyInfinite (s : Set ℕ) [DecidablePred (· ∈ s)] :
    s.Finite ∨ Nonempty (SimplyInfiniteSystem s) := by
  by_cases hs : BddAbove s
  · exact Or.inl ((nat_subset_finite_iff_bddAbove s).2 hs)
  · exact Or.inr (simplyInfinite_of_not_bddAbove s hs)

end Nat
end Data
end MathlibExpansion
