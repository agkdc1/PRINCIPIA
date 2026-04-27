import Mathlib.Data.Fintype.Card
import Mathlib.Data.Nat.Totient
import Mathlib.Data.ZMod.Units
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.GroupTheory.SpecificGroups.Cyclic

/-!
# Primitive-root boundary for odd prime powers

This file keeps the odd-prime-power unit-group layer honest.  The genuinely hard
arithmetic input is exposed as an explicit upstream axiom, while the reusable
cyclicity and root-count consequences are proved from it.
-/

namespace MathlibExpansion.NumberTheory.ModularArithmetic

open Finset Nat

section PrimePower

/-- Upstream boundary: odd prime powers have a generator of the full unit
group.

Citation: Carl Friedrich Gauss, *Disquisitiones Arithmeticae* (1801),
Section III, Article 89, where Gauss states that for a prime-power modulus
`p^n` with `p ≠ 2`, primitive roots exist and have exponent
`p^(n-1) * (p - 1) = Nat.totient (p^n)`. -/
axiom exists_primitiveRoot_zmod_prime_pow {p n : ℕ} (hp : p.Prime) (hp2 : p ≠ 2) (hn : 1 ≤ n) :
    ∃ u : (ZMod (p ^ n))ˣ, orderOf u = Nat.totient (p ^ n)

theorem isCyclic_units_zmod_prime_pow {p n : ℕ} (hp : p.Prime) (hp2 : p ≠ 2) (hn : 1 ≤ n) :
    IsCyclic (ZMod (p ^ n))ˣ := by
  have hpow_pos : 0 < p ^ n := pow_pos hp.pos _
  haveI : NeZero (p ^ n) := ⟨Nat.ne_of_gt hpow_pos⟩
  obtain ⟨u, hu⟩ := exists_primitiveRoot_zmod_prime_pow hp hp2 hn
  apply isCyclic_of_orderOf_eq_card u
  rw [Nat.card_eq_fintype_card, hu, ZMod.card_units_eq_totient]

private theorem card_pow_eq_one_of_isCyclic {G : Type*} [Group G] [Fintype G] [DecidableEq G]
    [IsCyclic G] (t : ℕ) :
    Fintype.card {x : G // x ^ t = 1} = Nat.gcd t (Fintype.card G) := by
  classical
  rw [Fintype.card_subtype]
  let d := Nat.gcd t (Fintype.card G)
  have hfilter :
      (univ.filter fun x : G => x ^ t = 1) =
        (univ.filter fun x : G => x ^ d = 1) := by
    ext x
    simp [d, (pow_gcd_card_eq_one_iff (G := G) (x := x) (n := t))]
  rw [hfilter]
  have hcard_pos : 0 < Fintype.card G := Fintype.card_pos_iff.2 ⟨1⟩
  have hd_ne : d ≠ 0 := (Nat.gcd_pos_of_pos_right t hcard_pos).ne'
  rw [← sum_card_orderOf_eq_card_pow_eq_one (G := G) (n := d) hd_ne]
  calc
    (∑ m ∈ Nat.divisors d, #{x : G | orderOf x = m}) =
        ∑ m ∈ Nat.divisors d, Nat.totient m := by
      refine sum_congr rfl fun m hm => ?_
      have hmd : m ∣ d := (Nat.mem_divisors.mp hm).1
      have hmc : m ∣ Fintype.card G := hmd.trans (Nat.gcd_dvd_right t (Fintype.card G))
      exact IsCyclic.card_orderOf_eq_totient (α := G) hmc
    _ = d := Nat.sum_totient d

/-- Consequence of the primitive-root boundary: once the unit group is cyclic, the roots
of `x^t = 1` in the unit group modulo an odd prime power are counted by the
expected gcd formula.

Citation: Carl Friedrich Gauss, *Disquisitiones Arithmeticae* (1801),
Section III, Article 85, gives the formula for roots of
`x^t ≡ 1 (mod p^n)`, and Article 89 supplies the primitive-root/cyclicity
input used here. -/
theorem card_roots_pow_eq_one_units_zmod_prime_pow_aux {p n t : ℕ} [NeZero (p ^ n)]
    (hp : p.Prime) (hp2 : p ≠ 2) (hn : 1 ≤ n) :
    Fintype.card {u : (ZMod (p ^ n))ˣ // u ^ t = 1} = Nat.gcd t (Nat.totient (p ^ n)) := by
  classical
  have hcyc : IsCyclic (ZMod (p ^ n))ˣ := isCyclic_units_zmod_prime_pow hp hp2 hn
  letI : IsCyclic (ZMod (p ^ n))ˣ := hcyc
  simpa [ZMod.card_units_eq_totient] using
    (card_pow_eq_one_of_isCyclic (G := (ZMod (p ^ n))ˣ) t)

theorem card_roots_pow_eq_one_units_zmod_prime_pow {p n t : ℕ} [NeZero (p ^ n)]
    (hp : p.Prime) (hp2 : p ≠ 2) (hn : 1 ≤ n) :
    Fintype.card {u : (ZMod (p ^ n))ˣ // u ^ t = 1} = Nat.gcd t (Nat.totient (p ^ n)) := by
  exact card_roots_pow_eq_one_units_zmod_prime_pow_aux hp hp2 hn

end PrimePower

end MathlibExpansion.NumberTheory.ModularArithmetic
