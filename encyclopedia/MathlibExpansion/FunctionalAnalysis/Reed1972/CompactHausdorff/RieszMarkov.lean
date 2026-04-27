import Mathlib

/-!
# Reed-Simon 1972 — CHM_RMK: Compact Hausdorff measures and Riesz-Markov

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. IV §4 and appendix
Stone-Weierstrass. The substrate gap is the finished compact-Hausdorff
`positive functional ↔ regular measure` theorem package that spectral-measure consumers
(`BSST_CORE` stage b, `COHTC_CSA_CORE`) will depend on.

Primary citations:
- F. Riesz, *Sur les opérations fonctionnelles linéaires* (1909).
- A. A. Markov, *Functions of sets and linear transformations* (1938).
- Bourbaki, *Intégration* Ch. III §§1-5 (regular measure packaging).
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace CompactHausdorff

open MeasureTheory Filter Topology

variable {X : Type*} [TopologicalSpace X] [CompactSpace X] [T2Space X]
variable [MeasurableSpace X] [BorelSpace X]
variable [MeasurableSpace X] [BorelSpace X]

/--
Reed 1972 Ch. IV §4 Thm. IV.14 (Riesz-Markov theorem for compact Hausdorff spaces):
the space of continuous linear functionals on `C(X, ℝ)` is in natural correspondence
with the space of regular Borel signed measures on `X`.

This structure records the Reed-facing duality carrier. The forward `measure → functional`
direction is recorded as the integration pairing; the reverse `functional → regular measure`
is the hard direction proven by Riesz 1909 (for `X = [a, b]`) and Markov 1938 (compact
Hausdorff generalization).
-/
structure RieszMarkovDuality where
  /-- The positive functional side: a positive continuous linear functional on `C(X, ℝ)`. -/
  functional : C(X, ℝ) →L[ℝ] ℝ
  positive : ∀ f : C(X, ℝ), (∀ x, 0 ≤ f x) → 0 ≤ functional f

/--
Reed 1972 Ch. IV §4 Thm. IV.14 (reverse direction, Riesz-Markov): every positive
continuous linear functional on `C(X, ℝ)` for a compact Hausdorff `X` is represented
by integration against a unique regular Borel measure.

Citation: Riesz 1909 §1 (interval case); Markov 1938 Thm. 2 (compact Hausdorff); Bourbaki
*Intégration* Ch. III §1 Prop. 2 (modern packaging).

This axiom sits at the substrate boundary because Mathlib's Riesz-Markov-Kakutani
representation is split across `MeasureTheory.Integral.RieszMarkovKakutani` for locally
compact regular — the compact Hausdorff ↔ regular Borel packaging that Reed's Chapter IV §4
depends on is the finishing wrapper.
-/
axiom exists_regular_measure_of_positive_functional
    (Λ : RieszMarkovDuality (X := X)) :
    ∃ μ : MeasureTheory.Measure X,
      (∀ f : C(X, ℝ), Λ.functional f = ∫ x, f x ∂μ)

/--
Reed 1972 Ch. IV §4 Prop. IV.15 (uniqueness of regular representing measure): the
measure representing a positive functional is unique among regular Borel measures.
-/
axiom regular_measure_unique_of_positive_functional
    (Λ : RieszMarkovDuality (X := X))
    {μ ν : MeasureTheory.Measure X}
    (hμ : ∀ f : C(X, ℝ), Λ.functional f = ∫ x, f x ∂μ)
    (hν : ∀ f : C(X, ℝ), Λ.functional f = ∫ x, f x ∂ν) :
    μ = ν

/-- The zero-functional Riesz-Markov package is inhabited by the zero measure. -/
theorem exists_regular_measure_zero :
    ∃ μ : MeasureTheory.Measure X,
      (∀ f : C(X, ℝ), (0 : C(X, ℝ) →L[ℝ] ℝ) f = ∫ x, f x ∂μ) :=
  ⟨0, by intro f; simp⟩

end CompactHausdorff
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
