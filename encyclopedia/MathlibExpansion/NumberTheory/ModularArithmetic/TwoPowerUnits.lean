import Mathlib.Data.Fintype.Card
import Mathlib.Data.ZMod.Units
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.GroupTheory.SpecificGroups.Cyclic
import Mathlib.Tactic

/-!
# Units modulo powers of two

This file isolates the reusable Section III surface at powers of two.  It proves
explicitly that the unit group modulo `2^n`, for `n ≥ 3`, has three distinct
involutions and contains the classical unit `5` of order `2^(n-2)`.
-/

namespace MathlibExpansion.NumberTheory.ModularArithmetic

open scoped Classical

namespace TwoPowerUnits

private theorem zmod_natCast_ne_of_lt {m a b : ℕ} (ha : a < m) (hb : b < m) (hab : a ≠ b) :
    (a : ZMod m) ≠ b := by
  intro h
  have hmod : a ≡ b [MOD m] := (ZMod.eq_iff_modEq_nat m).mp h
  have hEq := Nat.mod_eq_of_modEq hmod hb
  rw [Nat.mod_eq_of_lt ha] at hEq
  exact hab hEq

private theorem two_mul_two_pow_pred {n : ℕ} (hn : 1 ≤ n) :
    2 * 2 ^ (n - 1) = 2 ^ n := by
  calc
    2 * 2 ^ (n - 1) = 2 ^ (n - 1) * 2 := by rw [mul_comm]
    _ = 2 ^ ((n - 1) + 1) := by rw [pow_succ]
    _ = 2 ^ n := by rw [Nat.sub_add_cancel hn]

private theorem two_pow_pred_square_zero {n : ℕ} (hn : 2 ≤ n) :
    ((2 ^ (n - 1) : ℕ) : ZMod (2 ^ n)) ^ 2 = 0 := by
  rw [← Nat.cast_pow, ZMod.natCast_zmod_eq_zero_iff_dvd]
  rw [← pow_mul]
  exact pow_dvd_pow 2 (by omega : n ≤ (n - 1) * 2)

private theorem two_mul_two_pow_pred_zero {n : ℕ} (hn : 1 ≤ n) :
    ((2 : ZMod (2 ^ n)) * (2 ^ (n - 1) : ℕ) : ZMod (2 ^ n)) = 0 := by
  change (((2 : ℕ) : ZMod (2 ^ n)) * ((2 ^ (n - 1) : ℕ) : ZMod (2 ^ n)) = 0)
  rw [← Nat.cast_mul, ZMod.natCast_zmod_eq_zero_iff_dvd]
  rw [two_mul_two_pow_pred hn]

private theorem square_two_pow_pred_add_one {n : ℕ} (hn : 2 ≤ n) :
    ((2 ^ (n - 1) + 1 : ℕ) : ZMod (2 ^ n)) ^ 2 = 1 := by
  let a : ZMod (2 ^ n) := (2 ^ (n - 1) : ℕ)
  have hcast : ((2 ^ (n - 1) + 1 : ℕ) : ZMod (2 ^ n)) = a + 1 := by
    simp [a]
  have ha2 : a ^ 2 = 0 := two_pow_pred_square_zero hn
  have h2a : (2 : ZMod (2 ^ n)) * a = 0 := two_mul_two_pow_pred_zero (by omega : 1 ≤ n)
  have ha2' : a * 2 = 0 := by simpa [mul_comm] using h2a
  rw [hcast]
  ring_nf
  rw [ha2, ha2']
  ring

private theorem square_two_pow_pred_sub_one {n : ℕ} (hn : 2 ≤ n) :
    ((2 ^ (n - 1) - 1 : ℕ) : ZMod (2 ^ n)) ^ 2 = 1 := by
  let a : ZMod (2 ^ n) := (2 ^ (n - 1) : ℕ)
  have hge : 1 ≤ 2 ^ (n - 1) := one_le_pow₀ (by omega : 0 < 2)
  have hcast : ((2 ^ (n - 1) - 1 : ℕ) : ZMod (2 ^ n)) = a - 1 := by
    rw [Nat.cast_sub hge]
    simp [a]
  have ha2 : a ^ 2 = 0 := two_pow_pred_square_zero hn
  have h2a : (2 : ZMod (2 ^ n)) * a = 0 := two_mul_two_pow_pred_zero (by omega : 1 ≤ n)
  have ha2' : a * 2 = 0 := by simpa [mul_comm] using h2a
  rw [hcast]
  ring_nf
  rw [ha2', ha2]
  ring

/-- For `n ≥ 3`, the unit group modulo `2^n` contains three distinct
involutions. -/
theorem exists_three_distinct_square_roots_one_units_zmod_two_pow {n : ℕ} (hn : 3 ≤ n) :
    ∃ u₁ u₂ u₃ : (ZMod (2 ^ n))ˣ,
      u₁ ^ 2 = 1 ∧ u₂ ^ 2 = 1 ∧ u₃ ^ 2 = 1 ∧ u₁ ≠ u₂ ∧ u₁ ≠ u₃ ∧ u₂ ≠ u₃ := by
  let a := 2 ^ (n - 1)
  have hn1 : 1 ≤ n := by omega
  have hn2 : 2 ≤ n := by omega
  have hpred_ne : n - 1 ≠ 0 := by omega
  have ha_ge4 : 4 ≤ a := by
    have hle : 2 ^ 2 ≤ 2 ^ (n - 1) := Nat.pow_le_pow_right (by decide : 0 < 2) (by omega)
    norm_num at hle
    exact hle
  have ha_even : Even a := by
    rw [even_iff_two_dvd]
    exact dvd_pow_self 2 hpred_ne
  have hcop₁ : Nat.Coprime 1 (2 ^ n) := by simp
  have hcop₂ : Nat.Coprime (a + 1) (2 ^ n) := by
    exact Nat.prime_two.coprime_pow_of_not_dvd ha_even.add_one.not_two_dvd_nat
  have hodd₃ : Odd (a - 1) := by
    rw [Nat.odd_sub' (by omega : 1 ≤ a)]
    exact iff_of_true odd_one ha_even
  have hcop₃ : Nat.Coprime (a - 1) (2 ^ n) := by
    exact Nat.prime_two.coprime_pow_of_not_dvd hodd₃.not_two_dvd_nat
  let u₁ : (ZMod (2 ^ n))ˣ := ZMod.unitOfCoprime 1 hcop₁
  let u₂ : (ZMod (2 ^ n))ˣ := ZMod.unitOfCoprime (a + 1) hcop₂
  let u₃ : (ZMod (2 ^ n))ˣ := ZMod.unitOfCoprime (a - 1) hcop₃
  have h1lt : 1 < 2 ^ n := by
    rw [← two_mul_two_pow_pred hn1]
    omega
  have hplus_lt : a + 1 < 2 ^ n := by
    rw [← two_mul_two_pow_pred hn1]
    omega
  have hminus_lt : a - 1 < 2 ^ n := by
    rw [← two_mul_two_pow_pred hn1]
    omega
  refine ⟨u₁, u₂, u₃, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · ext
    simp [u₁]
  · ext
    simpa [u₂, a] using square_two_pow_pred_add_one (n := n) hn2
  · ext
    simpa [u₃, a] using square_two_pow_pred_sub_one (n := n) hn2
  · intro h
    exact (zmod_natCast_ne_of_lt h1lt hplus_lt (by omega : 1 ≠ a + 1)) (by
      simpa [u₁, u₂] using congrArg ((↑) : (ZMod (2 ^ n))ˣ → ZMod (2 ^ n)) h)
  · intro h
    exact (zmod_natCast_ne_of_lt h1lt hminus_lt (by omega : 1 ≠ a - 1)) (by
      simpa [u₁, u₃] using congrArg ((↑) : (ZMod (2 ^ n))ˣ → ZMod (2 ^ n)) h)
  · intro h
    exact (zmod_natCast_ne_of_lt hplus_lt hminus_lt (by omega : a + 1 ≠ a - 1)) (by
      simpa [u₂, u₃] using congrArg ((↑) : (ZMod (2 ^ n))ˣ → ZMod (2 ^ n)) h)

/-- Genuine consequence of the three-involution boundary: `(ZMod (2^n))ˣ` is
not cyclic once `n ≥ 3`. -/
theorem not_isCyclic_units_zmod_two_pow {n : ℕ} (hn : 3 ≤ n) :
    ¬ IsCyclic (ZMod (2 ^ n))ˣ := by
  intro hcyc
  classical
  have hpow_pos : 0 < 2 ^ n := pow_pos (by decide) _
  haveI : NeZero (2 ^ n) := ⟨Nat.ne_of_gt hpow_pos⟩
  obtain ⟨u₁, u₂, u₃, hu₁, hu₂, hu₃, hu₁₂, hu₁₃, hu₂₃⟩ :=
    exists_three_distinct_square_roots_one_units_zmod_two_pow hn
  have hthree : 3 ≤ Fintype.card {u : (ZMod (2 ^ n))ˣ // u ^ 2 = 1} := by
    let v₁ : {u : (ZMod (2 ^ n))ˣ // u ^ 2 = 1} := ⟨u₁, hu₁⟩
    let v₂ : {u : (ZMod (2 ^ n))ˣ // u ^ 2 = 1} := ⟨u₂, hu₂⟩
    let v₃ : {u : (ZMod (2 ^ n))ˣ // u ^ 2 = 1} := ⟨u₃, hu₃⟩
    let s : Finset {u : (ZMod (2 ^ n))ˣ // u ^ 2 = 1} := {v₁, v₂, v₃}
    have hs_card : s.card = 3 := by
      have hv₁₂ : v₁ ≠ v₂ := by
        intro h
        exact hu₁₂ (congrArg Subtype.val h)
      have hv₁₃ : v₁ ≠ v₃ := by
        intro h
        exact hu₁₃ (congrArg Subtype.val h)
      have hv₂₃ : v₂ ≠ v₃ := by
        intro h
        exact hu₂₃ (congrArg Subtype.val h)
      simp [s, hv₁₂, hv₁₃, hv₂₃]
    calc
      3 = s.card := hs_card.symm
      _ ≤ Fintype.card {u : (ZMod (2 ^ n))ˣ // u ^ 2 = 1} := Finset.card_le_univ s
  haveI : IsCyclic (ZMod (2 ^ n))ˣ := hcyc
  have hbound : Fintype.card {u : (ZMod (2 ^ n))ˣ // u ^ 2 = 1} ≤ 2 := by
    rw [Fintype.card_subtype]
    simpa using (IsCyclic.card_pow_eq_one_le (α := (ZMod (2 ^ n))ˣ) (n := 2) (by decide : 0 < 2))
  exact (by decide : ¬ 3 ≤ 2) (le_trans hthree hbound)

private theorem five_pow_two_pow_eq_one_add {k : ℕ} :
    ∃ c : ℕ, Odd c ∧ 5 ^ (2 ^ k) = 1 + 2 ^ (k + 2) * c := by
  induction k with
  | zero =>
      exact ⟨1, by norm_num, by norm_num⟩
  | succ k ih =>
      rcases ih with ⟨c, hcodd, hc⟩
      refine ⟨c + 2 ^ (k + 1) * c ^ 2, ?_, ?_⟩
      · have heven : Even (2 ^ (k + 1) * c ^ 2) := by
          rw [even_iff_two_dvd]
          exact dvd_mul_of_dvd_left (dvd_pow_self 2 (by omega : k + 1 ≠ 0)) _
        exact hcodd.add_even heven
      · have hpow : 5 ^ (2 ^ (k + 1)) = (5 ^ (2 ^ k)) ^ 2 := by
          rw [pow_succ, pow_mul]
        rw [hpow, hc]
        ring_nf

private theorem five_pow_two_pow_eq_one_zmod {k : ℕ} :
    ((5 : ZMod (2 ^ (k + 2))) ^ (2 ^ k)) = 1 := by
  obtain ⟨c, -, hc⟩ := five_pow_two_pow_eq_one_add (k := k)
  rw [show (5 : ZMod (2 ^ (k + 2))) = ((5 : ℕ) : ZMod (2 ^ (k + 2))) by norm_num]
  rw [← Nat.cast_pow]
  rw [hc, Nat.cast_add, Nat.cast_one]
  have hzero : (((2 ^ (k + 2) * c : ℕ) : ZMod (2 ^ (k + 2))) = 0) := by
    rw [ZMod.natCast_zmod_eq_zero_iff_dvd]
    exact dvd_mul_right _ _
  simp [hzero]

private theorem five_pow_two_pow_ne_one_zmod {k : ℕ} :
    ((5 : ZMod (2 ^ (k + 3))) ^ (2 ^ k)) ≠ 1 := by
  obtain ⟨c, hcodd, hc⟩ := five_pow_two_pow_eq_one_add (k := k)
  intro h
  have hcast : (((1 + 2 ^ (k + 2) * c : ℕ) : ZMod (2 ^ (k + 3))) = 1) := by
    rw [show (5 : ZMod (2 ^ (k + 3))) = ((5 : ℕ) : ZMod (2 ^ (k + 3))) by norm_num] at h
    rw [← Nat.cast_pow] at h
    simpa [← hc] using h
  have hzero : (((2 ^ (k + 2) * c : ℕ) : ZMod (2 ^ (k + 3))) = 0) := by
    rw [Nat.cast_add, Nat.cast_one] at hcast
    simpa using hcast
  have hdvd : 2 ^ (k + 3) ∣ 2 ^ (k + 2) * c := by
    exact (ZMod.natCast_zmod_eq_zero_iff_dvd _ _).mp hzero
  have hfactor : 2 ^ (k + 3) = 2 ^ (k + 2) * 2 := by
    rw [show k + 3 = k + 2 + 1 by omega, pow_succ]
  have h2dvd : 2 ∣ c := by
    rw [hfactor] at hdvd
    exact (Nat.mul_dvd_mul_iff_left (pow_pos (by decide : 0 < 2) (k + 2))).mp hdvd
  exact hcodd.not_two_dvd_nat h2dvd

private theorem five_pow_two_pow_succ_eq_one_zmod {k : ℕ} :
    ((5 : ZMod (2 ^ (k + 3))) ^ (2 ^ (k + 1))) = 1 := by
  have h := five_pow_two_pow_eq_one_zmod (k := k + 1)
  simpa [Nat.add_assoc] using h

/-- The unit `5` has order `2^(n-2)` modulo `2^n` for `n ≥ 3`. -/
theorem exists_unit_of_order_two_pow_sub_two {n : ℕ} (hn : 3 ≤ n) :
    ∃ u : (ZMod (2 ^ n))ˣ, orderOf u = 2 ^ (n - 2) := by
  rcases (show ∃ k, n = k + 3 from ⟨n - 3, by omega⟩) with ⟨k, rfl⟩
  have hcop : Nat.Coprime 5 (2 ^ (k + 3)) := by
    exact Nat.prime_two.coprime_pow_of_not_dvd (by norm_num : ¬2 ∣ 5)
  let u : (ZMod (2 ^ (k + 3)))ˣ := ZMod.unitOfCoprime 5 hcop
  have hnot : ¬u ^ (2 ^ k) = 1 := by
    intro h
    exact five_pow_two_pow_ne_one_zmod (k := k) (by
      simpa [u] using congrArg ((↑) : (ZMod (2 ^ (k + 3)))ˣ → ZMod (2 ^ (k + 3))) h)
  have hfin : u ^ (2 ^ (k + 1)) = 1 := by
    ext
    simpa [u] using five_pow_two_pow_succ_eq_one_zmod (k := k)
  haveI : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
  refine ⟨u, ?_⟩
  calc
    orderOf u = 2 ^ (k + 1) := orderOf_eq_prime_pow (p := 2) (n := k) hnot hfin
    _ = 2 ^ (k + 3 - 2) := by
      rw [show k + 3 - 2 = k + 1 by omega]

end TwoPowerUnits

end MathlibExpansion.NumberTheory.ModularArithmetic
