import Mathlib.Data.Int.GCD
import Mathlib.Data.Int.ModEq
import Mathlib.RingTheory.Int.Basic

/-!
# Square-congruence factor extraction

This file packages the clean Section VI factorization lemmas that do not depend
on Gauss composition or the binary-form corridor.
-/

namespace MathlibExpansion.NumberTheory.Factorization

open Int

/-- A congruence of squares modulo `n` yields a divisibility relation on the
usual difference-of-squares factorization. -/
theorem dvd_mul_sub_add_of_sq_modEq_sq {n x y : ℤ} (hxy : x ^ 2 ≡ y ^ 2 [ZMOD n]) :
    n ∣ (x + y) * (x - y) := by
  rw [Int.modEq_iff_dvd] at hxy
  have hneg : n ∣ -((x + y) * (x - y)) := by
    convert hxy using 1
    ring_nf
  simpa using Int.dvd_neg.mp hneg

/-- A nontrivial square congruence modulo `n` yields a proper nontrivial factor
via `gcd (x - y) n`. -/
theorem factor_of_square_congruence {n x y : ℤ} (hn : 1 < n) (hxy : x ^ 2 ≡ y ^ 2 [ZMOD n])
    (hne₁ : ¬ x ≡ y [ZMOD n]) (hne₂ : ¬ x ≡ -y [ZMOD n]) :
    1 < Int.gcd (x - y) n ∧ (Int.gcd (x - y) n : ℤ) < n := by
  let g : ℕ := Int.gcd (x - y) n
  have hn_pos : 0 < n := lt_trans Int.zero_lt_one hn
  have hn_nonneg : 0 ≤ n := le_of_lt hn_pos
  have hn0 : n ≠ 0 := ne_of_gt hn_pos
  have hg_pos : 0 < g := by
    simpa [g] using Int.gcd_pos_of_ne_zero_right (x - y) hn0
  have hprod : n ∣ (x + y) * (x - y) := dvd_mul_sub_add_of_sq_modEq_sq hxy
  have hg_ne_one : g ≠ 1 := by
    intro hg1
    have hsum : n ∣ x + y := by
      apply Int.dvd_of_dvd_mul_left_of_gcd_one
      · exact hprod
      · simpa [g, Int.gcd_comm] using hg1
    have hneg_sum : n ∣ -y - x := by
      simpa [sub_eq_add_neg, add_assoc, add_left_comm, add_comm] using Int.dvd_neg.mpr hsum
    have hmod : x ≡ -y [ZMOD n] := by
      exact Int.modEq_iff_dvd.mpr hneg_sum
    exact hne₂ hmod
  have hg_dvd_left_natAbs : g ∣ (x - y).natAbs := by
    simpa [g, Int.gcd] using Nat.gcd_dvd_left (x - y).natAbs n.natAbs
  have hg_dvd_natAbs : g ∣ n.natAbs := by
    simpa [g, Int.gcd] using Nat.gcd_dvd_right (x - y).natAbs n.natAbs
  have hn_natAbs_pos : 0 < n.natAbs := Int.natAbs_pos.mpr hn0
  have hg_le_natAbs : g ≤ n.natAbs := Nat.le_of_dvd hn_natAbs_pos hg_dvd_natAbs
  have hg_ne_natAbs : g ≠ n.natAbs := by
    intro h
    have hdiv_nat : n.natAbs ∣ (x - y).natAbs := by
      simpa [h] using hg_dvd_left_natAbs
    have hdiv : n ∣ x - y := by
      rwa [← Int.natAbs_dvd_natAbs]
    have hneg_diff : n ∣ y - x := by
      simpa [sub_eq_add_neg, add_comm] using Int.dvd_neg.mpr hdiv
    have hmod : x ≡ y [ZMOD n] := Int.modEq_iff_dvd.mpr hneg_diff
    exact hne₁ hmod
  have hg_lt_natAbs : g < n.natAbs := lt_of_le_of_ne hg_le_natAbs hg_ne_natAbs
  constructor
  · exact Nat.one_lt_iff_ne_zero_and_ne_one.mpr ⟨Nat.ne_of_gt hg_pos, hg_ne_one⟩
  · calc
      (g : ℤ) < n.natAbs := by exact_mod_cast hg_lt_natAbs
      _ = n := by simp [Int.natAbs_of_nonneg hn_nonneg]

/-- A nontrivial square root of `1` modulo `n` is a special case of a
nontrivial square congruence, hence also yields a proper factor. -/
theorem factor_of_nontrivial_sqrt_one {n u : ℤ} (hn : 1 < n) (hu : u ^ 2 ≡ 1 [ZMOD n])
    (hne₁ : ¬ u ≡ 1 [ZMOD n]) (hne₂ : ¬ u ≡ -1 [ZMOD n]) :
    1 < Int.gcd (u - 1) n ∧ (Int.gcd (u - 1) n : ℤ) < n := by
  have hsq : u ^ 2 ≡ (1 : ℤ) ^ 2 [ZMOD n] := by simpa using hu
  simpa using factor_of_square_congruence (n := n) (x := u) (y := 1) hn hsq hne₁ hne₂

end MathlibExpansion.NumberTheory.Factorization
