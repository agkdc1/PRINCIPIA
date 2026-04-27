import Mathlib
set_option maxHeartbeats 800000

/-!
# Riemann 1859 Mellin integral

This file exposes the classical Bose-Einstein kernel identity
`Γ(s) ζ(s) = ∫ x^(s-1)/(e^x - 1) dx` as the historical-facing boundary for the
1859 zeta campaign.
-/

noncomputable section

open MeasureTheory Set Complex
open scoped BigOperators

namespace MathlibExpansion
namespace Textbooks
namespace Riemann1859

/-- The Bose-Einstein kernel used in Riemann's Mellin integral formula. -/
def boseEinsteinKernel (s : ℂ) (x : ℝ) : ℂ :=
  ((x : ℂ) ^ (s - 1)) / (_root_.Complex.exp x - 1)

private lemma hasSum_boseEinsteinKernel_series (t : ℝ) (ht : t ∈ Set.Ioi (0 : ℝ)) :
    HasSum (fun n : ℕ ↦ (1 : ℂ) * Real.exp (-(((n + 1 : ℕ) : ℝ)) * t))
      (1 / (Complex.exp (t : ℂ) - 1)) := by
  have ht' : 0 < t := ht
  let q : ℂ := Complex.exp (-(t : ℂ))
  have hqnorm : ‖q‖ < 1 := by
    change ‖Complex.exp (-(t : ℂ))‖ < 1
    rw [Complex.norm_exp]
    simp [ht']
  have hq : HasSum (fun n : ℕ ↦ q ^ (n + 1)) (q * (1 - q)⁻¹) := by
    simpa [pow_succ'] using (hasSum_geometric_of_norm_lt_one hqnorm).mul_left q
  convert hq using 1
  · ext n
    dsimp [q]
    rw [Complex.ofReal_exp]
    rw [show (↑((-(((n + 1 : ℕ) : ℝ)) * t)) : ℂ) = (n + 1 : ℂ) * (-(t : ℂ)) by
      norm_num
      ring]
    simpa using (Complex.exp_nat_mul (-(t : ℂ)) (n + 1))
  · dsimp [q]
    rw [Complex.exp_neg]
    field_simp [Complex.exp_ne_zero (t : ℂ)]

private lemma summable_boseEinsteinKernel_coeff {s : ℂ} (hs : 1 < s.re) :
    Summable fun n : ℕ ↦ ‖(1 : ℂ)‖ / (((n + 1 : ℕ) : ℝ) ^ s.re) := by
  simpa using (summable_nat_add_iff 1).mpr (Real.summable_one_div_nat_rpow.mpr hs)

/-- The classical Mellin integral formula for the Riemann zeta function:
`Γ(s) ζ(s) = ∫₀^∞ x^(s-1)/(e^x - 1) dx`.

This is the Mellin-transform form of Riemann's 1859 memoir, section I, equation
following the expansion `1/(e^x - 1) = ∑ₙ e^{-(n+1)x}`; the proof here uses
Mathlib's `hasSum_mellin` Dirichlet-series theorem and
`zeta_eq_tsum_one_div_nat_add_one_cpow`. -/
theorem riemannZeta_mul_Gamma_eq_integral
    {s : ℂ} (hs : 1 < s.re) :
    _root_.Complex.Gamma s * riemannZeta s =
      ∫ x : ℝ in Set.Ioi 0, boseEinsteinKernel s x := by
  let F : ℝ → ℂ := fun t ↦ 1 / (Complex.exp (t : ℂ) - 1)
  have hs_pos : 0 < s.re := lt_trans zero_lt_one hs
  have hp : ∀ n : ℕ, (1 : ℂ) = 0 ∨ 0 < (((n + 1 : ℕ) : ℝ)) := by
    intro n
    exact Or.inr (by positivity)
  have hF : ∀ t ∈ Ioi (0 : ℝ),
      HasSum (fun n : ℕ ↦ (1 : ℂ) * Real.exp (-(((n + 1 : ℕ) : ℝ)) * t)) (F t) := by
    intro t ht
    exact hasSum_boseEinsteinKernel_series t ht
  have hsum : Summable fun n : ℕ ↦ ‖(1 : ℂ)‖ / (((n + 1 : ℕ) : ℝ) ^ s.re) :=
    summable_boseEinsteinKernel_coeff (s := s) hs
  have hmellin : HasSum
      (fun n : ℕ ↦ Complex.Gamma s * (1 : ℂ) / (((n + 1 : ℕ) : ℝ) : ℂ) ^ s)
      (mellin F s) := by
    exact hasSum_mellin (ι := ℕ) (a := fun _ ↦ (1 : ℂ))
      (p := fun n ↦ (((n + 1 : ℕ) : ℝ))) (F := F) hp hs_pos hF hsum
  calc
    Complex.Gamma s * riemannZeta s
        = Complex.Gamma s * (∑' n : ℕ, 1 / ((n : ℂ) + 1) ^ s) := by
            rw [zeta_eq_tsum_one_div_nat_add_one_cpow hs]
    _ = ∑' n : ℕ, Complex.Gamma s * (1 / ((n : ℂ) + 1) ^ s) := by
            rw [tsum_mul_left]
    _ = ∑' n : ℕ, Complex.Gamma s * (1 : ℂ) / (((n + 1 : ℕ) : ℝ) : ℂ) ^ s := by
            congr 1 with n
            rw [show (n : ℂ) + 1 = (((n + 1 : ℕ) : ℝ) : ℂ) by norm_num]
            ring
    _ = mellin F s := hmellin.tsum_eq
    _ = ∫ x : ℝ in Set.Ioi 0, boseEinsteinKernel s x := by
            simp [mellin, F, boseEinsteinKernel, div_eq_mul_inv, smul_eq_mul]

end Riemann1859
end Textbooks
end MathlibExpansion
