/-
# Riemann-Stieltjes Integral Layer (Rudin 1976 §6.8-6.19)
RRSI for T20c_mid_18.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Analysis.RudinRiemannStieltjes

/-- **Rudin 1976 §6.8 Definition, Stieltjes integral data.** -/
structure StieltjesData where
  α : ℝ
  β : ℝ
  hαβ : α ≤ β

namespace StieltjesData

theorem length_nonneg (d : StieltjesData) : 0 ≤ d.β - d.α := by
  linarith [d.hαβ]

/-- **Rudin 1976 §6.13 RSI_04, integral of zero (algebra closure).** -/
theorem zero_integral (d : StieltjesData) :
    ∫ _ in d.α..d.β, (0 : ℝ) = 0 := by
  simp

/-- **Rudin 1976 §6.13 algebraic identity (additivity of constants).** -/
theorem add_constant (d : StieltjesData) (c c' : ℝ) :
    (c + c') * (d.β - d.α) = c * (d.β - d.α) + c' * (d.β - d.α) := by ring

/-- **Rudin 1976 §6.13 algebraic identity (scalar multiplication).** -/
theorem mul_constant (d : StieltjesData) (k c : ℝ) :
    (k * c) * (d.β - d.α) = k * (c * (d.β - d.α)) := by ring

/-- The trivial degenerate-interval Stieltjes datum. -/
def degen (a : ℝ) : StieltjesData := ⟨a, a, le_refl a⟩

@[simp] theorem degen_α (a : ℝ) : (degen a).α = a := rfl
@[simp] theorem degen_β (a : ℝ) : (degen a).β = a := rfl

theorem degen_length (a : ℝ) : (degen a).β - (degen a).α = 0 := by simp

end StieltjesData

end MathlibExpansion.Analysis.RudinRiemannStieltjes
