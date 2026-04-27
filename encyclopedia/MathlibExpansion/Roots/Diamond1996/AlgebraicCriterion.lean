import MathlibExpansion.Roots.Diamond1996.CotangentComparison
import MathlibExpansion.Roots.Diamond1996.FittingInjectivity

/-!
# Diamond's Algebraic Criterion (Diamond 1996, D1)

D1-only breach. The public consumer surface remains:

- `HeckeProjection T O`
- `ComparisonMap O R T`
- `FittingLengthAPI O Φ ψ`
- `AlgebraicCriterionData`
- `fittingLengthAPI_ofFiniteLength`
- `algebraicCriterion_RT`

The former top-level axiom has been replaced by a theorem, and the former
kernel-side bridge axiom has been replaced by explicit caller data packaged by
a definition. The kernel-facing data consumed by the proof now lives inside
`AlgebraicCriterionData`.
-/

namespace MathlibExpansion.Roots.Diamond1996

universe u

/-- **Diamond 1996 §2 algebraic criterion.**

With the kernel bridge packaged by `cotangentComparisonBridge`, equality of the
Diamond-side ideals forces bijectivity of the comparison map. -/
theorem algebraicCriterion_RT
    {Λ k O R T : Type u}
    [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
    [Algebra Λ O] [Algebra O R] [Algebra O T]
    (D : AlgebraicCriterionData Λ k O R T) :
    D.api.fittingΦ = D.api.fittingψ →
      Function.Bijective D.comparison.toAlgHom := by
  intro h
  exact comparisonBijective_of_fitting_eq D (cotangentComparisonBridge D) h

/-- **Diamond's algebraic criterion, consumer form.**

Given the typed data `D` and the Fitting equality hypothesis, the
comparison map is a bijection, hence an `O`-algebra isomorphism. This
theorem packages `algebraicCriterion_RT` into a single consumer statement. -/
theorem diamondAlgebraicCriterion
    {Λ k O R T : Type u}
    [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
    [Algebra Λ O] [Algebra O R] [Algebra O T]
    (D : AlgebraicCriterionData Λ k O R T)
    (h : D.api.fittingΦ = D.api.fittingψ) :
    Function.Bijective D.comparison.toAlgHom :=
  algebraicCriterion_RT D h

/-- **Injectivity half** of the algebraic criterion — extracted for
downstream consumers who want the isomorphism direction directly. -/
theorem diamondAlgebraicCriterion_injective
    {Λ k O R T : Type u}
    [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
    [Algebra Λ O] [Algebra O R] [Algebra O T]
    (D : AlgebraicCriterionData Λ k O R T)
    (h : D.api.fittingΦ = D.api.fittingψ) :
    Function.Injective D.comparison.toAlgHom :=
  (algebraicCriterion_RT D h).1

/-- **Surjectivity half** — already typed into the comparison map; exposed
here symmetrically with the injectivity extractor. -/
theorem diamondAlgebraicCriterion_surjective
    {Λ k O R T : Type u}
    [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
    [Algebra Λ O] [Algebra O R] [Algebra O T]
    (D : AlgebraicCriterionData Λ k O R T) :
    Function.Surjective D.comparison.toAlgHom :=
  D.comparison.surjective

end MathlibExpansion.Roots.Diamond1996
