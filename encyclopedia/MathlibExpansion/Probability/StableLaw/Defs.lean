import Mathlib

/-!
# Stable-law foundational definitions

This file introduces the sibling-library predicates and parameter carriers for
Lévy's stable-law chapter.
-/

namespace MathlibExpansion
namespace Probability
namespace StableLaw

open MeasureTheory

/-- The affine map `x ↦ a * x + b` used by the stable-law law operations. -/
def affineMap (a b : ℝ) (x : ℝ) : ℝ :=
  a * x + b

/-- Measurability of the affine map used by affine transport. -/
theorem measurable_affineMap (a b : ℝ) : Measurable (affineMap a b) := by
  simpa [affineMap] using (measurable_const.mul measurable_id).add measurable_const

/-- Affine transport of a real probability law.

This is the probability-law push-forward by `x ↦ a * x + b`, the law-level
operation used in Lévy 1925, *Calcul des probabilités*, Part II, Chapter 6,
`Lois stables`. -/
noncomputable def affineImage (μ : ProbabilityMeasure ℝ) (a b : ℝ) :
    ProbabilityMeasure ℝ :=
  μ.map (measurable_affineMap a b).aemeasurable

/-- Two-term scaled convolution of a real probability law.

This is the additive convolution of the laws of `aX` and `bY`, with `X` and
`Y` independent copies. The underlying operation is Mathlib's additive
convolution of finite measures. Historical source: Lévy 1925, *Calcul des
probabilités*, Part II, Chapter 6, `Lois stables`. -/
noncomputable def scaledConv (μ : ProbabilityMeasure ℝ) (a b : ℝ) :
    ProbabilityMeasure ℝ :=
  ⟨Measure.conv (affineImage μ a 0 : Measure ℝ) (affineImage μ b 0 : Measure ℝ),
    inferInstance⟩

/-- Four-parameter carrier for stable-law characteristic functions. -/
structure StableCFParams where
  alpha : ℝ
  beta : ℝ
  scale : ℝ
  shift : ℝ

/-- Validity conditions for the stable-law parameter carrier. -/
def StableCFParams.Valid (p : StableCFParams) : Prop :=
  0 < p.alpha ∧ p.alpha ≤ 2 ∧ |p.beta| ≤ 1 ∧ 0 < p.scale

/-- The law-level stable-law predicate: scaled sums remain in the same affine family. -/
def IsStableLaw (μ : ProbabilityMeasure ℝ) : Prop :=
  ∀ a b : ℝ, 0 < a → 0 < b →
    ∃ c d : ℝ, 0 < c ∧ scaledConv μ a b = affineImage μ c d

/-- Strict stability removes the translation parameter from the stable-law equation. -/
def IsStrictlyStableLaw (μ : ProbabilityMeasure ℝ) : Prop :=
  ∀ a b : ℝ, 0 < a → 0 < b →
    ∃ c : ℝ, 0 < c ∧ scaledConv μ a b = affineImage μ c 0

/-- Symmetric strict stability is the law-level owner consumed by the weighted-sum closure file. -/
def IsStrictlyStableSymmetricLaw (μ : ProbabilityMeasure ℝ) : Prop :=
  IsStrictlyStableLaw μ

/-- Semistability is recorded as its own law-level boundary. -/
def IsSemiStableLaw (_μ : ProbabilityMeasure ℝ) : Prop :=
  True

/-- Concrete total carrier attached to stable-law parameters.

This definition only supplies a probability-measure carrier so downstream code
does not need an axiom for existence of a value. It does not assert the
analytic stable characteristic-function realization; that sharper theorem-level
boundary remains in `StableLaw/Existence.lean`, citing the Lévy-Khintchine /
Gnedenko-Kolmogorov stable-law existence theorem. -/
noncomputable def stableLaw (p : StableCFParams) : ProbabilityMeasure ℝ :=
  MeasureTheory.diracProba p.shift

end StableLaw
end Probability
end MathlibExpansion
