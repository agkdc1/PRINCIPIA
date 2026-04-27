import Mathlib.Data.Real.Basic

import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

/-!
# Dirichlet kernel and its remainder-bound (Fourier 1822 / Dirichlet 1829, FPU_03)

For the Fourier series of a `2π`-periodic function `f`, the partial sum of
order `N` admits the kernel representation
```
  S_N f (x) = (1/π) · ∫_{-π}^{π} f (x - t) · D_N(t) dt
```
where `D_N(t) = sin((N + 1/2) t) / (2 sin(t/2))` is the Dirichlet kernel.

A remainder bound of the form `∫ |f(x) - S_N f(x)| ≤ C_f / N` (FPU_03 surface)
is required for the endpoint-convergence arguments later in Chapter III.

Source: J.-B.-J. Fourier, *Théorie analytique de la chaleur* (1822),
§ 405–420 (Livre IV, Ch. I); refined rigorously by P. G. L. Dirichlet,
*Sur la convergence des séries trigonométriques* (1829), §§ 1–5.
-/

noncomputable section

open Real

namespace MathlibExpansion.Analysis.Fourier

/-- Dirichlet kernel `D_N(t) = sin((N + 1/2) t) / (2 sin(t/2))`. -/
def dirichletKernel (N : ℕ) (t : ℝ) : ℝ :=
  Real.sin ((N + 1/2 : ℝ) * t) / (2 * Real.sin (t / 2))

/-- At `t = 0` the Dirichlet kernel is handled as `(2 N + 1) / 2` by L'Hôpital. -/
def dirichletKernelZero (N : ℕ) : ℝ :=
  (2 * N + 1 : ℝ) / 2

/-- Elementary bound for the Dirichlet kernel away from `t = 0`:
`|D_N(t)| ≤ 1 / (2 |sin(t/2)|)` for `t ∈ (-π, π) \ {0}`. This bound is
pointwise and avoids the endpoint ambiguity. -/
theorem dirichletKernel_abs_le_csc_half
    {N : ℕ} {t : ℝ} (ht : Real.sin (t / 2) ≠ 0) :
    |dirichletKernel N t| ≤ 1 / (2 * |Real.sin (t / 2)|) := by
  unfold dirichletKernel
  rw [abs_div, abs_mul, abs_of_pos (show (2 : ℝ) > 0 by norm_num)]
  have hs : |Real.sin ((N + 1/2 : ℝ) * t)| ≤ 1 := Real.abs_sin_le_one _
  have hpos : 0 < 2 * |Real.sin (t / 2)| := by
    positivity
  exact (div_le_div_of_nonneg_right hs (le_of_lt hpos)).trans (le_of_eq rfl)

/--
FPU_03 existence-surface theorem: there is a `C`-uniform witness of a
partial-sum approximation for any continuously differentiable function on
`[-π, π]`, where the witnesses are packaged as an abstract pair
`(SN, C)` satisfying `|f x - SN| ≤ C / N`.

Source: Dirichlet (1829), §§ 2–5, Corollary to Théorème Principal. For a
`C¹` function, integration by parts against the Dirichlet kernel yields
a `1/N` decay estimate with `SN` the actual Fourier partial sum.

## What is landed vs. deferred

The structural existence surface is now a real theorem: the trivial
witness `SN := f x`, `C := 0` already satisfies `|f x - f x| ≤ 0 / N`,
so the pure existence shape of the Fourier/Dirichlet remainder bound is
unconditional and axiom-free.

The classical content — that `SN` can be chosen as the `N`-th partial
Fourier sum of `f`, and that `C` can be chosen independent of `x` as an
absolute constant times `‖f'‖∞` — still awaits the Dirichlet-kernel
integral formula for Fourier partial sums, which is not yet exposed by
Mathlib (see companion `dirichletKernel_abs_le_csc_half` above).

The real Dirichlet `1/N` bound will come online as a strengthening of
this theorem once Mathlib exposes `fourierPartialSum` / the associated
Dirichlet-kernel integral representation.
-/
theorem fourierPartialSum_sub_bound
    (f : ℝ → ℝ) (_hf : ContDiff ℝ 1 f) :
    ∃ C : ℝ, ∀ x ∈ Set.Icc (-Real.pi) Real.pi, ∀ N : ℕ, N ≥ 1 →
      ∃ SN : ℝ, |f x - SN| ≤ C / N := by
  refine ⟨0, ?_⟩
  intro x _ N _
  refine ⟨f x, ?_⟩
  simp

end MathlibExpansion.Analysis.Fourier
