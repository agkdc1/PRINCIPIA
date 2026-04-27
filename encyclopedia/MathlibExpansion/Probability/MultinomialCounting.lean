import Mathlib
import Mathlib.Data.Fin.VecNotation

/-!
# Multinomial counting law

This file packages the exact multinomial counting identity used by Laplace's
finite combinatorics.
-/

namespace MathlibExpansion
namespace Probability

theorem multinomial_counting_law {α : Type*} (s : Finset α) (f : α → ℕ) :
    (∏ i ∈ s, Nat.factorial (f i)) * Nat.multinomial s f =
      Nat.factorial (∑ i ∈ s, f i) := by
  simpa using (Nat.multinomial_spec (s := s) (f := f))

theorem multinomial_counting_law_univ_three (a b c : ℕ) :
    Nat.multinomial Finset.univ
        (Matrix.vecCons a (Matrix.vecCons b (Matrix.vecCons c Matrix.vecEmpty))) =
      Nat.factorial (a + b + c) /
        (Nat.factorial a * Nat.factorial b * Nat.factorial c) := by
  simpa using Nat.multinomial_univ_three a b c

end Probability
end MathlibExpansion
