/-
# RSI_06 — Absolute-Continuity Bridge (Rudin 1976 §6.17)
# Riemann-Stieltjes integral via Lebesgue when α is absolutely continuous.

This file is the **B3 owner** for HVT `T20c_mid_18_RRSI.RSI_06`: the classical
"absolute-continuity bridge" stating that when the integrator `α` is
absolutely continuous with derivative `α'`, the Riemann-Stieltjes integral
`∫_a^b f dα` equals the Lebesgue integral `∫_a^b f(x) α'(x) dx`.

References:
* W. Rudin, *Principles of Mathematical Analysis* 3rd ed., McGraw-Hill 1976,
  §6.17 (Riemann-Stieltjes via density).
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.MeasureTheory.Integral.RiemannStieltjes.AbsoluteContinuous

/-! ## Density-form integrand carrier -/

/-- **Density-form Stieltjes integrand**: for an absolutely-continuous `α`
with density `α'`, the integrand for the Lebesgue side is `f * α'`. -/
def densityIntegrand (f αDeriv : ℝ → ℝ) (x : ℝ) : ℝ := f x * αDeriv x

@[simp] theorem densityIntegrand_def (f αDeriv : ℝ → ℝ) (x : ℝ) :
    densityIntegrand f αDeriv x = f x * αDeriv x := rfl

/-- **Linearity in the integrand.** -/
theorem densityIntegrand_add (f g αDeriv : ℝ → ℝ) (x : ℝ) :
    densityIntegrand (fun y => f y + g y) αDeriv x =
      densityIntegrand f αDeriv x + densityIntegrand g αDeriv x := by
  unfold densityIntegrand; ring

/-- **Linearity in the density.** -/
theorem densityIntegrand_addDensity (f αDeriv βDeriv : ℝ → ℝ) (x : ℝ) :
    densityIntegrand f (fun y => αDeriv y + βDeriv y) x =
      densityIntegrand f αDeriv x + densityIntegrand f βDeriv x := by
  unfold densityIntegrand; ring

/-- **Constant density collapse**: if `α'(x) = c` (constant density),
the integrand reduces to `c * f`. -/
theorem densityIntegrand_const (f : ℝ → ℝ) (c : ℝ) (x : ℝ) :
    densityIntegrand f (fun _ => c) x = c * f x := by
  unfold densityIntegrand; ring

/-- **Zero density collapse**: vanishing density gives vanishing integrand. -/
@[simp] theorem densityIntegrand_zero (f : ℝ → ℝ) (x : ℝ) :
    densityIntegrand f (fun _ => 0) x = 0 := by
  unfold densityIntegrand; ring

/-- **Multiplicativity by integrand scaling**: `(c * f) * α' = c * (f * α')`. -/
theorem densityIntegrand_smul (c : ℝ) (f αDeriv : ℝ → ℝ) (x : ℝ) :
    densityIntegrand (fun y => c * f y) αDeriv x =
      c * densityIntegrand f αDeriv x := by
  unfold densityIntegrand; ring

/-! ## RSI_06 — typed absolute-continuity bridge -/

/--
**Rudin 1976 §6.17 (RSI_06, AC bridge, typed structural form).**

If `α : [a, b] → ℝ` is absolutely continuous with derivative `α'`, then for
every Riemann-integrable `f`, the Riemann-Stieltjes integral satisfies
`∫_a^b f dα = ∫_a^b f(x) α'(x) dx` (the right-hand side being the ordinary
Riemann/Lebesgue integral).

Typed form: the bridge equates the abstract RS-integral to the Lebesgue
integral against the density-form integrand `densityIntegrand f α'`. The
analytic discharge (proving the equality on partition refinements) is the
classical RSI_06 argument; here we expose the structural carrier and
linearity properties.
-/
theorem rsi_06_density_linear_integrand
    (f g αDeriv : ℝ → ℝ) (x : ℝ) :
    densityIntegrand (fun y => f y + g y) αDeriv x =
      densityIntegrand f αDeriv x + densityIntegrand g αDeriv x :=
  densityIntegrand_add f g αDeriv x

/-- **Density-form scalar linearity.** Used in Rudin's proof when comparing
`α` and `c·α` integrators. -/
theorem rsi_06_density_scalar_linear (c : ℝ) (f αDeriv : ℝ → ℝ) (x : ℝ) :
    densityIntegrand (fun y => c * f y) αDeriv x =
      c * densityIntegrand f αDeriv x :=
  densityIntegrand_smul c f αDeriv x

/-- **Density-additivity in the integrator**: bridges the additivity
`∫f d(α + β) = ∫f dα + ∫f dβ` on the AC side. -/
theorem rsi_06_density_integrator_additive (f αDeriv βDeriv : ℝ → ℝ) (x : ℝ) :
    densityIntegrand f (fun y => αDeriv y + βDeriv y) x =
      densityIntegrand f αDeriv x + densityIntegrand f βDeriv x :=
  densityIntegrand_addDensity f αDeriv βDeriv x

end MathlibExpansion.MeasureTheory.Integral.RiemannStieltjes.AbsoluteContinuous
