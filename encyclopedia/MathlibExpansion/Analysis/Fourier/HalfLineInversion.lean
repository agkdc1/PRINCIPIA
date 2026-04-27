import Mathlib.Data.Real.Basic

import Mathlib.Analysis.Fourier.FourierTransform
import Mathlib.Analysis.Fourier.Inversion
import Mathlib.MeasureTheory.Integral.IntervalIntegral

/-!
# Fourier half-line inversion (Fourier 1822, FPU_05)

The cosine and sine Fourier transforms on the half-line `[0, ∞)` with their
associated inversion formulas
```
  f̃_c(ω) = ∫₀^∞ f(x) · cos(ω x) dx,
  f(x)   = (2/π) · ∫₀^∞ f̃_c(ω) · cos(ω x) dω,
```
appear throughout Fourier's treatise; they are derived by extending `f` to
an even function on all of `ℝ` and invoking the full-line inversion.

Source: J.-B.-J. Fourier, *Théorie analytique de la chaleur* (1822),
§§ 398–420 (Livre IV, Ch. I–II), following the substitution formulas
and culminating in §§ 417–420.
-/

noncomputable section

open Real MeasureTheory

namespace MathlibExpansion.Analysis.Fourier

/-- The (real) Fourier cosine transform of a function `f` on `[0, ∞)`, taken
as a Lebesgue integral over the half-line. -/
def fourierCosineTransform (f : ℝ → ℝ) (ω : ℝ) : ℝ :=
  ∫ x in Set.Ici (0 : ℝ), f x * Real.cos (ω * x)

/-- The (real) Fourier sine transform of a function `f` on `[0, ∞)`, taken
as a Lebesgue integral over the half-line. -/
def fourierSineTransform (f : ℝ → ℝ) (ω : ℝ) : ℝ :=
  ∫ x in Set.Ici (0 : ℝ), f x * Real.sin (ω * x)

/--
FPU_05 upstream-narrow axiom: Fourier cosine inversion on `[0, ∞)`.

Source: Fourier 1822 §§ 417–420. For `f : [0, ∞) → ℝ` integrable and
continuous with integrable cosine transform `f̃_c`, the pointwise identity
```
  f(x) = (2/π) · ∫₀^∞ f̃_c(ω) · cos(ω x) dω
```
holds for `x > 0`.

## Diagnostic

Mathlib has `MeasureTheory.Integrable.fourier_inversion` for the full line.
The half-line version follows by even extension, but Mathlib does not yet
expose:
1. An "even extension" API `evenExtend : (ℝ → ℝ) → (ℝ → ℝ)` with support
   lemmas connecting `fourierCosineTransform f` to the full-line Fourier
   transform of the even extension.
2. The `(2/π)` normalization bridge between Fourier's classical normalization
   and Mathlib's unitary `(2π)^{-1/2}` convention.

Either of these ingredients would discharge the axiom. The structural gap is
normalization-and-API, not deep analysis.
-/
axiom fourierCosineInversion
    (f : ℝ → ℝ)
    (_hf_integrable : MeasureTheory.Integrable f)
    (_hf_cont : ContinuousOn f (Set.Ici (0 : ℝ)))
    (_h_ft : MeasureTheory.Integrable (fourierCosineTransform f))
    {x : ℝ} (_hx : 0 < x) :
    f x = (2 / Real.pi) *
      ∫ ω in Set.Ici (0 : ℝ),
        fourierCosineTransform f ω * Real.cos (ω * x)

end MathlibExpansion.Analysis.Fourier
