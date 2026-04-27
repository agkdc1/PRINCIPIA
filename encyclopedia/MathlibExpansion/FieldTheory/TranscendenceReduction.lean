import Mathlib.RingTheory.AlgebraicIndependent.Adjoin
import Mathlib.RingTheory.AlgebraicIndependent.TranscendenceBasis

/-!
# Purely transcendental reduction

Mathlib already has the constituent results for the reduction: existence of
transcendence bases, the rational-function model of an algebraically
independent family, and algebraicity over the generated intermediate field.
This module packages them as the single existential wrapper used by the
Steinitz textbook sentence.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 22`-`23`.
-/

noncomputable section

universe u v

namespace MathlibExpansion.FieldTheory

/-- Steinitz reduction wrapper: every extension is algebraic over a
purely transcendental extension of the base, presented as a rational function
field on some transcendence basis.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 22`-`23`. Mathlib supplies the construction through
`exists_isTranscendenceBasis'`, `AlgebraicIndependent.aevalEquivField`, and
`IsTranscendenceBasis.isAlgebraic_field`. -/
theorem exists_transcendenceBasis_reduction
    (F : Type u) (E : Type v) [Field F] [Field E] [Algebra F E] :
    ∃ (ι : Type v) (x : ι -> E),
      IsTranscendenceBasis F x ∧
      Nonempty (FractionRing (MvPolynomial ι F) ≃ₐ[F]
        IntermediateField.adjoin F (Set.range x)) ∧
      Algebra.IsAlgebraic (IntermediateField.adjoin F (Set.range x)) E := by
  obtain ⟨ι, x, hx⟩ :=
    exists_isTranscendenceBasis' F (A := E) (algebraMap F E).injective
  exact ⟨ι, x, hx, ⟨hx.1.aevalEquivField⟩, hx.isAlgebraic_field⟩

end MathlibExpansion.FieldTheory
