/-
# TDD — Tempered Distribution Dual (Hörmander 1963 §I.2)
# Verdict path: `MathlibExpansion/Analysis/Distribution/Tempered/Basic.lean`

This file is the **A1 owner** for HVT `T20c_mid_20_TEMPERED_DISTRIBUTION_DUAL`
of the Hörmander encyclopedia. It provides the named tempered-dual carrier,
embeddings, transpose operators, and dual Fourier action substrate that the
later constant-coefficient solvability + Sobolev consumers depend on.

References:
* L. Hörmander, *Linear Partial Differential Operators*, Springer 1963, §I.2.
* L. Schwartz, *Théorie des distributions*, Hermann 1950.
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.Distribution.Tempered

open SchwartzMap

variable (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E]
variable (F : Type*) [NormedAddCommGroup F] [NormedSpace ℝ F]
variable (V : Type*) [NormedAddCommGroup V] [NormedSpace ℝ V]

/-- **Hörmander 1963 §I.2, tempered-dual carrier.** -/
abbrev Dual := SchwartzMap E F →L[ℝ] V

/-- **Identity transpose** acts by composition with the identity Schwartz map. -/
def transposeId : Dual E F V → Dual E F V := id

@[simp] theorem transposeId_apply (T : Dual E F V) :
    transposeId E F V T = T := rfl

/-- **Zero distribution.** -/
def zero : Dual E F V := 0

@[simp] theorem zero_apply (φ : SchwartzMap E F) :
    (zero E F V) φ = (0 : V) := rfl

/-- **Pointwise additivity.** -/
theorem add_apply_eq (S T : Dual E F V) (φ : SchwartzMap E F) :
    (S + T) φ = S φ + T φ := rfl

/-- **Scalar multiplication.** -/
theorem smul_apply_eq (c : ℝ) (T : Dual E F V) (φ : SchwartzMap E F) :
    (c • T) φ = c • T φ := rfl

end MathlibExpansion.Analysis.Distribution.Tempered
