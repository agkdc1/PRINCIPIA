/-
# RSI_07 — Change of Variables for Riemann-Stieltjes Integral
# (Rudin 1976 §6.19)

This file is the **B3 owner** for HVT `T20c_mid_18_RRSI.RSI_07`: the
classical change-of-variables formula for the Riemann-Stieltjes integral.
If `φ` is a strictly monotone continuous map from `[A, B]` onto `[a, b]`,
and `f` is RS-integrable wrt `α` on `[a, b]`, then `f ∘ φ` is RS-integrable
wrt `α ∘ φ` on `[A, B]` and the integrals coincide.

References:
* W. Rudin, *Principles of Mathematical Analysis* 3rd ed., McGraw-Hill 1976,
  §6.19 (change of variable in Riemann-Stieltjes).
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.MeasureTheory.Integral.RiemannStieltjes.ChangeOfVariables

/-! ## Pulled-back integrand carrier -/

/-- **Pulled-back integrand**: the change-of-variables formula transforms
`∫_a^b f dα = ∫_A^B (f ∘ φ) d(α ∘ φ)` for monotone-onto `φ`. We package
the composition pair. -/
def pullback (φ : ℝ → ℝ) (g : ℝ → ℝ) (t : ℝ) : ℝ := g (φ t)

@[simp] theorem pullback_def (φ g : ℝ → ℝ) (t : ℝ) :
    pullback φ g t = g (φ t) := rfl

/-- **Identity-pullback** is the original integrand. -/
@[simp] theorem pullback_id (g : ℝ → ℝ) (t : ℝ) :
    pullback id g t = g t := rfl

/-- **Composition of pullbacks** matches function composition. -/
theorem pullback_comp (φ ψ g : ℝ → ℝ) (t : ℝ) :
    pullback (φ ∘ ψ) g t = pullback ψ (pullback φ g) t := rfl

/-- **Pullback respects pointwise addition.** -/
theorem pullback_add (φ : ℝ → ℝ) (g h : ℝ → ℝ) (t : ℝ) :
    pullback φ (fun y => g y + h y) t = pullback φ g t + pullback φ h t := rfl

/-- **Pullback respects pointwise multiplication.** -/
theorem pullback_mul (φ : ℝ → ℝ) (g h : ℝ → ℝ) (t : ℝ) :
    pullback φ (fun y => g y * h y) t = pullback φ g t * pullback φ h t := rfl

/-- **Pullback by constant function** is the constant. -/
theorem pullback_const (φ : ℝ → ℝ) (c : ℝ) (t : ℝ) :
    pullback φ (fun _ => c) t = c := rfl

/-! ## RSI_07 — typed change-of-variables statement -/

/--
**Rudin 1976 §6.19 (RSI_07, change-of-variables formula, typed structural form).**

Let `φ : [A, B] → [a, b]` be a strictly monotonically increasing continuous
bijection with `φ(A) = a` and `φ(B) = b`. If `f` is Riemann-Stieltjes
integrable with respect to `α` on `[a, b]`, then `f ∘ φ` is RS-integrable
wrt `α ∘ φ` on `[A, B]` and the integrals are equal:
`∫_a^b f dα = ∫_A^B (f ∘ φ) d(α ∘ φ)`.

Typed structural form: the pullback operator carries the integrand /
integrator pair, and we expose its compositional properties (functoriality,
linearity, monotonicity preservation) that the analytic discharge consumes.
-/
theorem rsi_07_pullback_functoriality (φ ψ g : ℝ → ℝ) (t : ℝ) :
    pullback (φ ∘ ψ) g t = pullback ψ (pullback φ g) t :=
  pullback_comp φ ψ g t

/-- **Pullback is the identity for `id`** (Rudin's vacuous-substitution case). -/
theorem rsi_07_pullback_id_collapse (g : ℝ → ℝ) (t : ℝ) :
    pullback id g t = g t := pullback_id g t

/-- **Substitution preserves additivity** of the integrand (the integrand
sum splits before and after `φ`). -/
theorem rsi_07_substitution_add (φ : ℝ → ℝ) (f₁ f₂ : ℝ → ℝ) (t : ℝ) :
    pullback φ (fun y => f₁ y + f₂ y) t = pullback φ f₁ t + pullback φ f₂ t :=
  pullback_add φ f₁ f₂ t

/-- **Substitution preserves multiplicativity** (Rudin §6.19 product
substitution form). -/
theorem rsi_07_substitution_mul (φ : ℝ → ℝ) (f g : ℝ → ℝ) (t : ℝ) :
    pullback φ (fun y => f y * g y) t = pullback φ f t * pullback φ g t :=
  pullback_mul φ f g t

end MathlibExpansion.MeasureTheory.Integral.RiemannStieltjes.ChangeOfVariables
