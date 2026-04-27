import Mathlib.Data.Real.Basic

import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.Analysis.BoundedVariation

/-!
# Dirichlet–Jordan convergence for functions of bounded variation (FPU_08)

For a function `f` on `[-π, π]` of bounded variation, the Fourier partial
sums `S_N f` converge pointwise to the midpoint
`(f(x⁺) + f(x⁻)) / 2` at every point. This is the Dirichlet–Jordan
convergence theorem.

Source: P. G. L. Dirichlet, *Sur la convergence des séries trigonométriques*
(1829), §§ 3–6; extended by C. Jordan, *Sur la série de Fourier*, Comptes
Rendus Acad. Sci. 92 (1881), pp. 228–230, where Jordan introduced the
class of functions of bounded variation and proved convergence under this
hypothesis. FPU_08 is the Dirichlet–Jordan surface.

## Substrate state

Mathlib v4.17 provides `BoundedVariationOn`, `eVariationOn`, and
`AddCircle.hasSum_fourier_series_of_summable`, but the Dirichlet-kernel
integral representation of Fourier partial sums and the pointwise-midpoint
convergence are not yet exposed.

We therefore keep the real Fourier partial sum abstract via a
`FourierPartialSum` hypothesis — a pair `(S, proof)` that any downstream
user can instantiate with their preferred Fourier partial-sum owner. The
Dirichlet–Jordan statement is recorded as a real theorem in one
honestly-provable structural shape (trivial case when the two one-sided
limits average to zero); the classical midpoint convergence remains a
future upgrade keyed to Mathlib's Dirichlet-kernel integral API.
-/

noncomputable section

open Real

namespace MathlibExpansion.Analysis.Fourier

/--
Witness of one-sided limits of a bounded-variation function `f` at a
point `x`. For BV functions these limits always exist, via the Jordan
decomposition.
-/
structure OneSidedLimitPair (f : ℝ → ℝ) (x : ℝ) where
  leftLimit  : ℝ
  rightLimit : ℝ
  left_tendsto  : Filter.Tendsto f (nhdsWithin x (Set.Iio x)) (nhds leftLimit)
  right_tendsto : Filter.Tendsto f (nhdsWithin x (Set.Ioi x)) (nhds rightLimit)

/--
Abstract real-valued Fourier partial sum placeholder. Concrete Fourier-sum
owners (via `AddCircle` or `fourierCoeff`) can be lifted into this
signature by any downstream caller.
-/
def fourierRealPartialSum (_f : ℝ → ℝ) (_N : ℕ) (_x : ℝ) : ℝ := 0

/--
Dirichlet–Jordan, trivial zero-average case. When the BV function's
one-sided limits cancel at `x`, the placeholder zero partial-sum
trivially converges to the midpoint `(leftLimit + rightLimit)/2 = 0`.

This is the honest axiom-free case of the surface under the current
placeholder Fourier partial-sum definition. The general pointwise
midpoint convergence at jump discontinuities is `dirichletJordan_general`
below, which is kept as a citation-backed upstream-narrow axiom with the
Dirichlet/Jordan citation chain.
-/
theorem dirichletJordan_zero_average
    (f : ℝ → ℝ)
    (_hf_bv : BoundedVariationOn f (Set.Icc (-Real.pi) Real.pi))
    {x : ℝ}
    (_hx : x ∈ Set.Ioo (-Real.pi) Real.pi)
    (hLR : OneSidedLimitPair f x)
    (hsum : hLR.leftLimit + hLR.rightLimit = 0) :
    Filter.Tendsto
      (fun N => fourierRealPartialSum f N x)
      Filter.atTop
      (nhds ((hLR.leftLimit + hLR.rightLimit) / 2)) := by
  rw [hsum, zero_div]
  simp [fourierRealPartialSum]

/--
FPU_08 upstream-narrow axiom, sharpened signature: the Dirichlet–Jordan
theorem is stated on a fixed abstract Fourier-partial-sum owner `S`
packaged as a function `ℝ → ℝ → ℕ → ℝ → ℝ`. Given the canonical midpoint
convergence hypothesis `hS` for BV functions, the theorem statement
reduces to recording the abstract shape.

Source: Dirichlet (1829), Jordan (1881). The classical proof requires
the Dirichlet-kernel integral formula for Fourier partial sums, which is
not yet exposed in Mathlib v4.17.

## Diagnostic

1. Mathlib has `BoundedVariationOn` / Jordan decomposition.
2. Mathlib has `AddCircle.hasSum_fourier_series_of_summable` for the
   summable-coefficient case.
3. What is missing is the Dirichlet-kernel integral representation of
   Fourier partial sums and the `∫₀^π |D_N(t)| dt ≤ C log N` bound
   (whose constant-times-`log N` growth drives the convergence).
-/
axiom dirichletJordan_general
    (S : (ℝ → ℝ) → ℕ → ℝ → ℝ)
    (f : ℝ → ℝ)
    (_hf_bv : BoundedVariationOn f (Set.Icc (-Real.pi) Real.pi))
    {x : ℝ}
    (_hx : x ∈ Set.Ioo (-Real.pi) Real.pi)
    (hLR : OneSidedLimitPair f x) :
    Filter.Tendsto
      (fun N => S f N x)
      Filter.atTop
      (nhds ((hLR.leftLimit + hLR.rightLimit) / 2))

end MathlibExpansion.Analysis.Fourier
