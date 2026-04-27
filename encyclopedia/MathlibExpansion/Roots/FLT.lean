import Mathlib.NumberTheory.FLT.Four
import Mathlib.NumberTheory.FLT.Three
import MathlibExpansion.Roots.Frey1986.Paper

/-!
# FLT capstone from the clean Frey package

This file is the Phase 1 capstone. It does not route through the quarantined
all-in-one FLT file. Instead it says:

1. for odd prime exponents `p ≥ 5`, a builder that turns any putative Fermat
   counterexample into a `FreyToLevelTwoResidualPackage` yields a contradiction;
2. `p = 3` is already settled by Mathlib;
3. `Mathlib.NumberTheory.FLT.Four.FermatLastTheorem.of_odd_primes` upgrades the
   odd-prime case to the full theorem.

No new axioms are introduced here.
-/

namespace MathlibExpansion
namespace Roots
namespace FLT

open MathlibExpansion.Roots.Frey1986

/-- A capstone-ready builder. It may perform the standard reduction from an
arbitrary nonzero natural-number solution to a primitive integer Frey triple
before returning the contradiction package. -/
abbrev FreyToLevelTwoResidualPackageBuilder :=
  ∀ p : ℕ, Nat.Prime p → 5 ≤ p →
    ∀ a b c : ℕ, a ≠ 0 → b ≠ 0 → c ≠ 0 →
      a ^ p + b ^ p = c ^ p →
      FreyToLevelTwoResidualPackage

/-- Any prime exponent `p ≥ 5` satisfies FLT once the clean Frey package can be
constructed from putative solutions. -/
theorem fermatLastTheoremFor_prime_ge_five_of_builder
    (hbuild : FreyToLevelTwoResidualPackageBuilder)
    {p : ℕ} (hp : Nat.Prime p) (hp5 : 5 ≤ p) :
    FermatLastTheoremFor p := by
  intro a b c ha hb hc habc
  exact (hbuild p hp hp5 a b c ha hb hc habc).contradiction.elim

/-- An odd prime other than `3` is at least `5`. -/
lemma prime_ge_five_of_odd_ne_three
    {p : ℕ} (hp : Nat.Prime p) (hpodd : Odd p) (h3 : p ≠ 3) :
    5 ≤ p := by
  rcases hpodd with ⟨k, hk⟩
  subst hk
  have hp2 : 2 ≤ 2 * k + 1 := hp.two_le
  omega

/-- FLT for odd prime exponents from the clean Frey builder plus Mathlib's
`p = 3` theorem. -/
theorem fermatLastTheoremFor_odd_prime_of_builder
    (hbuild : FreyToLevelTwoResidualPackageBuilder)
    {p : ℕ} (hp : Nat.Prime p) (hpodd : Odd p) :
    FermatLastTheoremFor p := by
  by_cases h3 : p = 3
  · simpa [h3] using fermatLastTheoremThree
  · exact fermatLastTheoremFor_prime_ge_five_of_builder
      hbuild hp (prime_ge_five_of_odd_ne_three hp hpodd h3)

/-- Phase 1 capstone: once odd-prime counterexamples can be pushed all the way
to the clean level-2 package, Mathlib's reduction theorem yields full FLT. -/
theorem fermatLastTheorem_of_builder
    (hbuild : FreyToLevelTwoResidualPackageBuilder) :
    FermatLastTheorem := by
  apply FermatLastTheorem.of_odd_primes
  intro p hp hpodd
  exact fermatLastTheoremFor_odd_prime_of_builder hbuild hp hpodd

/-- Named closure theorem for the Phase 1 capstone route. -/
theorem phase1_close_confirmation
    (hbuild : FreyToLevelTwoResidualPackageBuilder) :
    FermatLastTheorem :=
  fermatLastTheorem_of_builder hbuild

end FLT
end Roots
end MathlibExpansion
