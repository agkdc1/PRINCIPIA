import Mathlib

/-!
# Polynomial asymptotics near zero

This module records a narrow but reusable first-nonzero-term sign theorem for
polynomial models written in the factored form
`x^n * (a + x * q(x))`.
-/

open Filter

namespace MathlibExpansion
namespace Textbooks
namespace Cauchy1821

/-- If the first nonzero term has even order and positive coefficient, then the
factored polynomial model is eventually nonnegative near `0`. -/
theorem eventually_nonneg_model_of_even_positive {n : ℕ} {a : ℝ} {q : Polynomial ℝ}
    (ha : 0 < a) (hn : Even n) :
    ∀ᶠ x : ℝ in nhds 0, 0 ≤ x ^ n * (a + x * q.eval x) := by
  have hfactor : Tendsto (fun x : ℝ => a + x * q.eval x) (nhds 0) (nhds a) := by
    simpa using
      ((continuous_const.add (continuous_id.mul q.continuous)).continuousAt :
        ContinuousAt (fun x : ℝ => a + x * q.eval x) 0).tendsto
  have hfactor_pos : ∀ᶠ x : ℝ in nhds 0, 0 < a + x * q.eval x :=
    hfactor.eventually (Ioi_mem_nhds ha)
  rcases hn with ⟨m, rfl⟩
  filter_upwards [hfactor_pos] with x hx
  have hpow : 0 ≤ x ^ (m + m) := by
    simpa [pow_add] using mul_self_nonneg (x ^ m)
  exact mul_nonneg hpow hx.le

/-- If the first nonzero term has even order and negative coefficient, then the
factored polynomial model is eventually nonpositive near `0`. -/
theorem eventually_nonpos_model_of_even_negative {n : ℕ} {a : ℝ} {q : Polynomial ℝ}
    (ha : a < 0) (hn : Even n) :
    ∀ᶠ x : ℝ in nhds 0, x ^ n * (a + x * q.eval x) ≤ 0 := by
  have hfactor : Tendsto (fun x : ℝ => a + x * q.eval x) (nhds 0) (nhds a) := by
    simpa using
      ((continuous_const.add (continuous_id.mul q.continuous)).continuousAt :
        ContinuousAt (fun x : ℝ => a + x * q.eval x) 0).tendsto
  have hfactor_neg : ∀ᶠ x : ℝ in nhds 0, a + x * q.eval x < 0 :=
    hfactor.eventually (Iio_mem_nhds ha)
  rcases hn with ⟨m, rfl⟩
  filter_upwards [hfactor_neg] with x hx
  have hpow : 0 ≤ x ^ (m + m) := by
    simpa [pow_add] using mul_self_nonneg (x ^ m)
  exact mul_nonpos_of_nonneg_of_nonpos hpow hx.le

end Cauchy1821
end Textbooks
end MathlibExpansion
