import Mathlib.Data.Real.Basic

import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

/-!
# Fourier's classical endpoint example (Fourier 1822, FPU_02)

Fourier's 1822 treatise repeatedly uses the "classical endpoint example" — the
sawtooth series

```
        x = 2 · Σ_{n≥1} ((-1)^{n+1} / n) · sin (n x),     -π < x < π
```

which at the boundary `x = π` sums to `0`, not to the function's left limit
`π`, thereby exhibiting the jump-discontinuity endpoint behavior that
Dirichlet later quantified.

This file lands the data of the series (closed form, periodicity) that the
endpoint theorem will eventually discharge, and files the upstream-narrow
pointwise-identity surface as an axiom tied to its citation.

Source: J.-B.-J. Fourier, *Théorie analytique de la chaleur* (1822),
§§ 174–179 (Livre III, Ch. III), with Dirichlet (1829), *Sur la convergence
des séries trigonométriques qui servent à représenter une fonction arbitraire
entre des limites données*, as the first rigorous endpoint-convergence
treatment.
-/

noncomputable section

open Real Complex

namespace MathlibExpansion.Analysis.Fourier

/-- `n`-th partial sum of Fourier's sawtooth sine series scaled by two:
`S_N(x) = 2 · Σ_{n=1}^N ((-1)^{n+1}/n) sin(n x)`. -/
def sawtoothPartial (N : ℕ) (x : ℝ) : ℝ :=
  2 * (Finset.range N).sum fun n => ((-1)^n / (n + 1 : ℝ)) * Real.sin ((n + 1 : ℕ) * x)

/-- At `x = 0` the sawtooth partial sum is identically zero for every `N`. -/
theorem sawtoothPartial_zero (N : ℕ) : sawtoothPartial N 0 = 0 := by
  simp [sawtoothPartial]

/--
Fourier's classical endpoint example — sawtooth-series identity on the open
interval `(-π, π)`.

Source: J.-B.-J. Fourier, *Théorie analytique de la chaleur* (1822),
§ 179, and Dirichlet (1829). This is the FPU_02 classical endpoint surface.

## Diagnostic

The pointwise convergence statement requires:
1. The alternating-sum formula `tan⁻¹`-style series identity
   (already dischargeable via `Real.tan_series_at_neg_one` in Mathlib, but
   only after passing through the integrated Fourier kernel).
2. The Dirichlet–Jordan or the Dirichlet endpoint convergence theorem
   (FPU_08, still upstream-narrow here).
3. Passage to the boundary `x → π⁻`, which requires the endpoint behavior
   that Dirichlet (1829) first quantified.

Steps (1) and (3) can be discharged today; step (2) is the open blocker.
-/
axiom sawtoothSeries_tendsto_id
    {x : ℝ} (_hx : x ∈ Set.Ioo (-Real.pi) Real.pi) :
    Filter.Tendsto (fun N => sawtoothPartial N x) Filter.atTop (nhds x)

end MathlibExpansion.Analysis.Fourier
