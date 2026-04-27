import Mathlib.Data.Real.Basic

import Mathlib.Analysis.Fourier.FourierTransform
import Mathlib.Analysis.Fourier.Inversion

/-!
# Sinc function and indicator-recovery (Fourier 1822, FPU_04)

Fourier used the rectangular "porte" function
```
  f(x) = 1  for  |x| < 1,
  f(x) = 0  for  |x| > 1,
```
whose Fourier integral is `2 · sinc(ω) = 2 sin(ω) / ω`, and recovered the
original indicator from its sinc Fourier transform via the inversion
formula. This computation appears repeatedly in the treatise and gives the
FPU_04 "sinc/indicator recovery" surface.

Source: J.-B.-J. Fourier, *Théorie analytique de la chaleur* (1822),
§§ 345–348 (Livre IV, Ch. II), sometimes rediscovered under the name
"Dirichlet integral" — it reappears in Dirichlet (1829) and Poisson (1823).

This file lands the closed-form sinc function and files the final inversion
identity as an upstream-narrow axiom.
-/

noncomputable section

open Real

namespace MathlibExpansion.Analysis.Fourier

/-- The continuous `sinc` function: `sinc 0 = 1` and `sinc x = sin x / x`
otherwise. -/
def sinc (x : ℝ) : ℝ :=
  if x = 0 then 1 else Real.sin x / x

@[simp] theorem sinc_zero : sinc 0 = 1 := by
  simp [sinc]

theorem sinc_of_ne_zero {x : ℝ} (hx : x ≠ 0) :
    sinc x = Real.sin x / x := by
  simp [sinc, hx]

/-- The value of the sinc function at `π` is `0`. -/
theorem sinc_pi : sinc Real.pi = 0 := by
  have hp : Real.pi ≠ 0 := Real.pi_ne_zero
  rw [sinc_of_ne_zero hp, Real.sin_pi, zero_div]

/--
FPU_04 upstream-narrow axiom: indicator-recovery via sinc Fourier inversion.

Source: Fourier 1822 §§ 345–348; Poisson 1823. For the porte function
`𝟙_[-1, 1]`, its Fourier integral is `2 · sinc(ω)`, and the inversion
`(2/π) ∫₀^∞ sinc(ω) cos(ω x) dω = 𝟙_{|x| < 1}(x) + ½ · 𝟙_{|x| = 1}(x)`
holds pointwise, returning the midpoint at the jump discontinuities.

## Diagnostic

Mathlib has `MeasureTheory.Integrable.fourier_inversion`
(`Mathlib.Analysis.Fourier.Inversion`), which covers full-line Fourier
inversion for integrable continuous functions. The indicator
`𝟙_[-1, 1]` is integrable but has jump discontinuities, so the Mathlib
statement does not directly apply; the midpoint convergence at the
discontinuity requires the symmetric-partial-integral treatment not yet
exposed in Mathlib.

The improper integral `∫₀^∞ sinc(ω) cos(ω x) dω` is conditionally convergent
(not absolutely), which is the classical obstruction Dirichlet addressed.
-/
axiom sincFourierInversion_indicator
    {x : ℝ} (_hx : |x| ≠ 1) :
    Filter.Tendsto
      (fun R => (2 / Real.pi) *
        ∫ ω in (0 : ℝ)..R, sinc ω * Real.cos (ω * x))
      Filter.atTop
      (nhds (if |x| < 1 then (1 : ℝ) else 0))

end MathlibExpansion.Analysis.Fourier
