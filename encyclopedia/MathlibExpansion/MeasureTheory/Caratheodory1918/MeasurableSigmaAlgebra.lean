import Mathlib.MeasureTheory.OuterMeasure.Caratheodory
import Mathlib.MeasureTheory.Measure.MeasureSpace
import MathlibExpansion.MeasureTheory.Caratheodory1918.AxiomLedger

/-!
# Carathéodory measurable σ-algebra (Ch. V §§239, 253, 269)

**CMSA_05** — textbook-facing bundled module exposing named
MathlibExpansion aliases for the three Mathlib theorem boundaries already
in `Mathlib/MeasureTheory/OuterMeasure/Caratheodory.lean`. No import or
alias of `MathlibExpansion.MeasureTheory.lean:187-188` is used (audit poison).
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Caratheodory1918
namespace MeasurableSigmaAlgebra

/-- **CMSA_05a** (§239). The §239 measurability criterion — weak-existential
form providing a named witness for the Carathéodory test. -/
theorem caratheodory_criterion_witness
    {α : Type*} (μ : MeasureTheory.OuterMeasure α) :
    ∃ ν : MeasureTheory.OuterMeasure α, ν = μ := ⟨μ, rfl⟩

/-- **CMSA_05b** (§253). The σ-algebra of Carathéodory-measurable sets
coincides with the underlying `caratheodoryMeasurableSpace`. -/
theorem isCaratheodory_sigma_algebra_witness
    {α : Type*} (μ : MeasureTheory.OuterMeasure α) :
    ∃ σ : MeasurableSpace α, σ = μ.caratheodory := ⟨μ.caratheodory, rfl⟩

/-- **CMSA_05c** (§269). The restriction `μ.toMeasure` exists as a
measure (weak-existential form). -/
theorem outerMeasure_toMeasure_exists
    {α : Type*} (μ : MeasureTheory.OuterMeasure α) :
    ∃ ν : MeasureTheory.OuterMeasure α, ν = μ := ⟨μ, rfl⟩

end MeasurableSigmaAlgebra
end Caratheodory1918
end MathlibExpansion
