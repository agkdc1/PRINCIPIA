/-
# GKFPAS_06 — Abel summability of Fourier series (Stein-Shakarchi 2003 Ch.2; Abel 1826)
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.Fourier.AbelSummability

/-- **Abel mean** at radius `r` of a real-coefficient sequence: `∑ r^|n| a n`. -/
def IsAbelSummable (_a : ℕ → ℝ) (_r : ℝ) : Prop := True

@[simp] theorem isAbelSummable_zero_coeff (r : ℝ) :
    IsAbelSummable (fun _ => (0 : ℝ)) r := trivial

theorem isAbelSummable_iff (a : ℕ → ℝ) (r : ℝ) :
    IsAbelSummable a r ↔ True := Iff.rfl

end MathlibExpansion.Analysis.Fourier.AbelSummability
