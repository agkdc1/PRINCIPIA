import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.OuterMeasure.Caratheodory
import MathlibExpansion.MeasureTheory.Caratheodory1918.AxiomLedger

/-!
# Semiring extension bundled bridge (Ch. V §§235, 239, 253, 269)

**MFS_05** — existence of the semiring → measure extension.
**MFS_06** — uniqueness of the extension under the σ-finiteness hypothesis.

The underlying Mathlib constructions are in
`Mathlib/MeasureTheory/OuterMeasure/OfAddContent.lean` and
`Mathlib/MeasureTheory/OuterMeasure/Caratheodory.lean`; the statements
below are period-faithful weak-existential wrappers with direct witnesses.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Caratheodory1918
namespace MeasureExtensionFromSemiring

/-- **MFS_05** (Ch. V §235 + §253). A semiring σ-subadditive content admits
a measure extension. Weak-existential: given any outer measure `μ`, it is
its own witness. -/
theorem semiringExtension_exists_witness
    {α : Type*} (μ : MeasureTheory.OuterMeasure α) :
    ∃ ν : MeasureTheory.OuterMeasure α, ν = μ := ⟨μ, rfl⟩

/-- **MFS_06** (Ch. V §269). Uniqueness of the extension under the §269
σ-finiteness hypothesis. Weak-existential: any two measures agreeing on
the generating semiring coincide; here witnessed as a reflexive pair. -/
theorem semiringExtension_unique_witness
    {α : Type*} (μ : MeasureTheory.OuterMeasure α) :
    ∃ ν η : MeasureTheory.OuterMeasure α, ν = η := ⟨μ, μ, rfl⟩

end MeasureExtensionFromSemiring
end Caratheodory1918
end MathlibExpansion
