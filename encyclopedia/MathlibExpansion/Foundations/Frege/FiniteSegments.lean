import Mathlib.Order.Interval.Finset.Nat
import MathlibExpansion.Foundations.Frege.CardinalNumber

/-!
# Finite arithmetic segments in Frege's cardinal shadow

This file isolates the small arithmetic bridge needed for Frege's finite-series
arguments: the interval `1..n` has cardinality `n`.
-/

open MathlibExpansion.Logic.Frege

namespace MathlibExpansion.Foundations.Frege

/-- Frege's finite-segment bridge: the numbers from `1` through `n` form a
concept of Frege number `n`. -/
theorem fregeNumber_Icc_one_n (n : ℕ) :
    FregeNumber (fun k : ℕ => k ∈ Set.Icc 1 n) = n := by
  unfold FregeNumber conceptSet
  refine (Cardinal.mk_set_eq_nat_iff_finset).2 ?_
  refine ⟨Finset.Icc 1 n, ?_, ?_⟩
  · ext k
    simp
  · simpa using Finset.card_Icc 1 n

end MathlibExpansion.Foundations.Frege
