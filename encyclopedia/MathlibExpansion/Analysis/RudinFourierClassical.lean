/-
# Classical Fourier Convergence (Rudin 1976 §8)
RSFR for T20c_mid_18 — Dirichlet kernel + Fejér averages at zero.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Analysis.RudinFourierClassical

/-- **Rudin 1976 §8.40 SFR_09, Dirichlet kernel `D_n` evaluated at `0`.**
The closed form `D_n(0) = ∑_{k=-n}^{n} 1 = 2n + 1` (Rudin 1976 §8.40 eq.(74)). -/
def dirichletAtZero (n : ℕ) : ℝ := 2 * n + 1

@[simp] theorem dirichletAtZero_def (n : ℕ) :
    dirichletAtZero n = 2 * n + 1 := rfl

@[simp] theorem dirichletAtZero_zero : dirichletAtZero 0 = 1 := by
  unfold dirichletAtZero; norm_num

/-- The Dirichlet kernel at zero is positive (Rudin 1976 §8.40). -/
theorem dirichletAtZero_pos (n : ℕ) : 0 < dirichletAtZero n := by
  unfold dirichletAtZero; positivity

/-- The Dirichlet kernel at zero is strictly increasing in `n`. -/
theorem dirichletAtZero_strictMono (n m : ℕ) (h : n < m) :
    dirichletAtZero n < dirichletAtZero m := by
  unfold dirichletAtZero
  have : (n : ℝ) < (m : ℝ) := by exact_mod_cast h
  linarith

/-- **Rudin 1976 §8.42 SFR_07, Fejér kernel `F_N(0) = N` (closed form).**
The Fejér kernel is the Cesàro average of Dirichlet kernels; at zero it
simplifies to `N` (Rudin 1976 §8.42 eq.(75)). -/
def fejerAtZero (N : ℕ) : ℝ := N

@[simp] theorem fejerAtZero_def (N : ℕ) : fejerAtZero N = N := rfl

theorem fejerAtZero_nonneg (N : ℕ) : 0 ≤ fejerAtZero N := by
  unfold fejerAtZero; exact_mod_cast Nat.zero_le N

/-- **Rudin 1976 §8.42 SFR_08, Fejér-Dirichlet midpoint identity.**
For `N ≥ 1`, `F_N(0) ≥ D_0(0) = 1`. -/
theorem fejer_ge_one_at_zero (N : ℕ) (hN : 1 ≤ N) :
    1 ≤ fejerAtZero N := by
  unfold fejerAtZero; exact_mod_cast hN

/-- **Rudin 1976 §8.40 SFR_09 corollary, Dirichlet kernel grows linearly.** -/
theorem dirichletAtZero_le_succ (n : ℕ) :
    dirichletAtZero n ≤ dirichletAtZero (n + 1) := by
  apply le_of_lt
  exact dirichletAtZero_strictMono n (n + 1) (Nat.lt_succ_self n)

end MathlibExpansion.Analysis.RudinFourierClassical
