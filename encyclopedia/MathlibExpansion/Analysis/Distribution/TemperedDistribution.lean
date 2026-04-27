/-
# STD — Schwartz Dual and Tempered-Distribution Boundary
# (Stein 1970 *Singular Integrals* I §2; Schwartz 1950)

This file is the **B0 root owner** for HVT `T20c_mid_19_STD` of the Stein
encyclopedia. It ships the load-bearing tempered-distribution boundary that
gates the singular-integral, Riesz-transform, multiplier, and potential
corridors.

Owner surface (STD_01-STD_09 from Step 5 verdict):
* `TemperedDistribution`: linear continuous functional from Schwartz functions
  to a target space — typed Schwartz dual.
* `transpose`: pre-composition action via a fixed Schwartz endomorphism.
* `zero`, `add`, `scalarMul`: linear-algebra structure.

References:
* E. M. Stein, *Singular Integrals and Differentiability Properties of
  Functions*, Princeton 1970, §I.2.
* L. Schwartz, *Théorie des distributions* (1950), Hermann, Paris.
* Mathlib v4.17 `SchwartzMap` (`Mathlib.Analysis.Distribution.SchwartzSpace`).
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.Distribution.TemperedDistribution

open SchwartzMap

variable (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E]
variable (F : Type*) [NormedAddCommGroup F] [NormedSpace ℝ F]
variable (V : Type*) [NormedAddCommGroup V] [NormedSpace ℝ V]

/-! ## STD_01-STD_03 — typed Schwartz dual -/

/--
**Stein 1970 §I.2, Schwartz dual / tempered distribution (STD_01).**

A *tempered distribution* on `E → F` valued in `V` is a continuous ℝ-linear
map from the Schwartz space `𝓢(E, F)` to `V`. We define this as the
Mathlib-native `SchwartzMap E F →L[ℝ] V`.
-/
abbrev TemperedDistribution := SchwartzMap E F →L[ℝ] V

/-! ## STD_04 — pre-composition by a Schwartz endomorphism -/

/--
**Stein 1970 §I.2, Transpose of tempered distribution (STD_04).**

For a tempered distribution `T` and a continuous linear endomorphism `Φ` of
Schwartz space, the *transpose* distribution is `T ∘ Φ`.
-/
def transpose
    (Φ : SchwartzMap E F →L[ℝ] SchwartzMap E F)
    (T : TemperedDistribution E F V) :
    TemperedDistribution E F V :=
  T.comp Φ

@[simp] theorem transpose_apply
    (Φ : SchwartzMap E F →L[ℝ] SchwartzMap E F)
    (T : TemperedDistribution E F V)
    (φ : SchwartzMap E F) :
    transpose E F V Φ T φ = T (Φ φ) := rfl

/-- **Identity transpose collapse.** -/
@[simp] theorem transpose_id
    (T : TemperedDistribution E F V) :
    transpose E F V (ContinuousLinearMap.id ℝ _) T = T := by
  ext φ; simp [transpose]

/-- **Transpose composes contravariantly.** -/
theorem transpose_comp
    (Φ Ψ : SchwartzMap E F →L[ℝ] SchwartzMap E F)
    (T : TemperedDistribution E F V) :
    transpose E F V (Φ.comp Ψ) T =
      transpose E F V Ψ (transpose E F V Φ T) := by
  ext φ; simp [transpose]

/-! ## STD_05-STD_09 — linear algebra on the dual -/

/-- Constant-zero distribution. -/
def zero : TemperedDistribution E F V := 0

@[simp] theorem zero_apply (φ : SchwartzMap E F) :
    (zero E F V) φ = (0 : V) := rfl

/-- Pointwise addition of tempered distributions. -/
def add (S T : TemperedDistribution E F V) :
    TemperedDistribution E F V := S + T

@[simp] theorem add_apply (S T : TemperedDistribution E F V)
    (φ : SchwartzMap E F) :
    (add E F V S T) φ = S φ + T φ := rfl

/-- Scalar multiplication. -/
def scalarMul (c : ℝ) (T : TemperedDistribution E F V) :
    TemperedDistribution E F V := c • T

@[simp] theorem scalarMul_apply (c : ℝ) (T : TemperedDistribution E F V)
    (φ : SchwartzMap E F) :
    (scalarMul E F V c T) φ = c • T φ := rfl

end MathlibExpansion.Analysis.Distribution.TemperedDistribution
