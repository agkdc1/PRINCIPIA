import Mathlib
import MathlibExpansion.DecisionTheory.LogUtility

/-!
# St. Petersburg under log utility

This file records Laplace's log-utility resolution of the St. Petersburg
paradox.
-/

namespace MathlibExpansion
namespace DecisionTheory

/-- The canonical St. Petersburg payoff after `n` tosses. -/
def stPetersburgPayoff (n : ℕ) : ℝ :=
  2 ^ n

/-- The theorem package resolving the St. Petersburg paradox at initial wealth `w`. -/
structure StPetersburgResolution (w : ℝ) where
  entryPrice : ℝ
  wealthPreserving : 0 ≤ entryPrice ∧ entryPrice ≤ w
  finiteMoralExpectation :
    Summable (fun n : ℕ => ((1 / 2 : ℝ) ^ (n + 1)) *
      Real.log (w + stPetersburgPayoff n))

private lemma st_petersburg_geometric_shift_summable :
    Summable (fun n : ℕ => ((1 / 2 : ℝ) ^ (n + 1))) := by
  have h : Summable (fun n : ℕ => ((1 / 2 : ℝ) ^ n)) :=
    summable_geometric_of_lt_one (by norm_num) (by norm_num)
  convert h.mul_left (1 / 2 : ℝ) using 1
  ext n
  rw [pow_succ']

private lemma st_petersburg_linear_geometric_shift_summable :
    Summable (fun n : ℕ => (n : ℝ) * ((1 / 2 : ℝ) ^ (n + 1))) := by
  have h : Summable (fun n : ℕ => (n : ℝ) ^ (1 : ℕ) * ((1 / 2 : ℝ) ^ n)) :=
    summable_pow_mul_geometric_of_norm_lt_one (R := ℝ) 1 (by norm_num)
  convert h.mul_left (1 / 2 : ℝ) using 1
  ext n
  ring_nf

private lemma st_petersburg_log_bound_summable (w : ℝ) :
    Summable (fun n : ℕ =>
      ((1 / 2 : ℝ) ^ (n + 1)) * (Real.log (w + 1) + (n : ℝ) * Real.log 2)) := by
  have hconst : Summable (fun n : ℕ =>
      Real.log (w + 1) * ((1 / 2 : ℝ) ^ (n + 1))) :=
    st_petersburg_geometric_shift_summable.mul_left _
  have hlin : Summable (fun n : ℕ =>
      Real.log 2 * ((n : ℝ) * ((1 / 2 : ℝ) ^ (n + 1)))) :=
    st_petersburg_linear_geometric_shift_summable.mul_left _
  convert hconst.add hlin using 1
  ext n
  ring

private lemma st_petersburg_log_bound (w : ℝ) (hw : 0 < w) (n : ℕ) :
    Real.log (w + (2 : ℝ) ^ n) ≤ Real.log (w + 1) + (n : ℝ) * Real.log 2 := by
  have hp_pos : 0 < (2 : ℝ) ^ n := pow_pos (by norm_num) n
  have hp_one : 1 ≤ (2 : ℝ) ^ n :=
    one_le_pow₀ (show (1 : ℝ) ≤ 2 by norm_num) (n := n)
  have harg_pos : 0 < w + (2 : ℝ) ^ n := add_pos hw hp_pos
  have hmul_nonneg : 0 ≤ w * ((2 : ℝ) ^ n - 1) :=
    mul_nonneg hw.le (sub_nonneg.mpr hp_one)
  have harg_le : w + (2 : ℝ) ^ n ≤ (w + 1) * (2 : ℝ) ^ n := by
    nlinarith
  calc
    Real.log (w + (2 : ℝ) ^ n) ≤ Real.log ((w + 1) * (2 : ℝ) ^ n) :=
      Real.log_le_log harg_pos harg_le
    _ = Real.log (w + 1) + Real.log ((2 : ℝ) ^ n) := by
      rw [Real.log_mul]
      · linarith
      · exact pow_ne_zero n (by norm_num)
    _ = Real.log (w + 1) + (n : ℝ) * Real.log 2 := by
      rw [Real.log_pow]

private lemma st_petersburg_log_utility_series_summable (w : ℝ) (hw : 0 < w) :
    Summable (fun n : ℕ => ((1 / 2 : ℝ) ^ (n + 1)) *
      Real.log (w + (2 : ℝ) ^ n)) := by
  refine Summable.of_nonneg_of_le ?_ ?_ (st_petersburg_log_bound_summable w)
  · intro n
    have hp_one : 1 ≤ (2 : ℝ) ^ n :=
      one_le_pow₀ (show (1 : ℝ) ≤ 2 by norm_num) (n := n)
    exact mul_nonneg (pow_nonneg (by norm_num) _)
      (Real.log_nonneg (by nlinarith [hp_one, hw.le]))
  · intro n
    exact mul_le_mul_of_nonneg_left (st_petersburg_log_bound w hw n)
      (pow_nonneg (by norm_num) _)

private lemma st_petersburg_const_log_hasSum (w : ℝ) :
    HasSum (fun n : ℕ => ((1 / 2 : ℝ) ^ (n + 1)) * Real.log w) (Real.log w) := by
  convert hasSum_geometric_two' (Real.log w) using 1
  ext n
  rw [pow_succ']
  ring_nf

private lemma st_petersburg_log_initial_le_tsum (w : ℝ) (hw : 0 < w) :
    Real.log w ≤
      ∑' n : ℕ, ((1 / 2 : ℝ) ^ (n + 1)) *
        Real.log (w + (2 : ℝ) ^ n) := by
  have hf : Summable (fun n : ℕ => ((1 / 2 : ℝ) ^ (n + 1)) * Real.log w) :=
    (st_petersburg_const_log_hasSum w).summable
  have hg : Summable (fun n : ℕ => ((1 / 2 : ℝ) ^ (n + 1)) *
      Real.log (w + (2 : ℝ) ^ n)) :=
    st_petersburg_log_utility_series_summable w hw
  have hle : ∀ n : ℕ,
      ((1 / 2 : ℝ) ^ (n + 1)) * Real.log w ≤
        ((1 / 2 : ℝ) ^ (n + 1)) * Real.log (w + (2 : ℝ) ^ n) := by
    intro n
    have hp_pos : 0 < (2 : ℝ) ^ n := pow_pos (by norm_num) n
    have hlog_le : Real.log w ≤ Real.log (w + (2 : ℝ) ^ n) :=
      Real.log_le_log hw (by nlinarith [hp_pos.le])
    exact mul_le_mul_of_nonneg_left hlog_le (pow_nonneg (by norm_num) _)
  have htsum := tsum_le_tsum hle hf hg
  rw [(st_petersburg_const_log_hasSum w).tsum_eq] at htsum
  exact htsum

/--
The St. Petersburg game has finite expected log utility at every positive
initial wealth.

This formalizes the logarithmic moral-expectation resolution from Daniel
Bernoulli, "Specimen theoriae novae de mensura sortis" (1738), as reused in
Laplace, Theorie analytique des probabilites (1812), Introduction, moral
expectation discussion.
-/
def st_petersburg_log_utility_finite (w : ℝ) (hw : 0 < w) :
    StPetersburgResolution w where
  entryPrice := 0
  wealthPreserving := ⟨le_rfl, hw.le⟩
  finiteMoralExpectation := by
    simpa [stPetersburgPayoff] using st_petersburg_log_utility_series_summable w hw

/--
The theorem-level series boundary for the St. Petersburg paradox under log
utility.

The proof follows Bernoulli's 1738 log-utility resolution: the weighted log
payoffs are dominated by a linear polynomial times a geometric series, and the
certainty equivalent is `exp` of the resulting sum. See Daniel Bernoulli,
"Specimen theoriae novae de mensura sortis" (1738), St. Petersburg discussion,
and Laplace, Theorie analytique des probabilites (1812), Introduction.
-/
theorem st_petersburg_log_utility_series (w : ℝ) (hw : 0 < w) :
    ∃ c : ℝ,
      0 ≤ c ∧
      Summable (fun n : ℕ => ((1 / 2 : ℝ) ^ (n + 1)) * Real.log (w + (2 : ℝ) ^ n)) ∧
      Real.log (w + c) =
        ∑' n, ((1 / 2 : ℝ) ^ (n + 1)) * Real.log (w + (2 : ℝ) ^ n) := by
  let s : ℝ := ∑' n : ℕ, ((1 / 2 : ℝ) ^ (n + 1)) *
    Real.log (w + (2 : ℝ) ^ n)
  have hs : Summable (fun n : ℕ => ((1 / 2 : ℝ) ^ (n + 1)) *
      Real.log (w + (2 : ℝ) ^ n)) :=
    st_petersburg_log_utility_series_summable w hw
  have hlog_le : Real.log w ≤ s := by
    simpa [s] using st_petersburg_log_initial_le_tsum w hw
  refine ⟨Real.exp s - w, ?_, hs, ?_⟩
  · exact sub_nonneg.mpr (by
      have hexp_le : Real.exp (Real.log w) ≤ Real.exp s := Real.exp_le_exp.mpr hlog_le
      simpa [Real.exp_log hw] using hexp_le)
  · have hsum : w + (Real.exp s - w) = Real.exp s := by ring
    rw [hsum, Real.log_exp]

end DecisionTheory
end MathlibExpansion
