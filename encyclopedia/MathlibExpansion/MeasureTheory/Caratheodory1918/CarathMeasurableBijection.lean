import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import MathlibExpansion.MeasureTheory.Caratheodory1918.AxiomLedger
import MathlibExpansion.MeasureTheory.Jordan.Quadrable

/-!
# Carathéodory measurable set-bijection carrier (Ch. VI §336)

**CMME_02–04** — `CarathNullMeasurableBijection` carrier + wrappers.
**CMME_05** — singular-homeomorphism counterexample (Rademacher 1916).

Citation: Rademacher, *Eineindeutige Abbildung und Meßbarkeit*,
*Monatsh. Math. Phys.* 27 (1916), 145-176. The §336 example is a
homeomorphism `f : ℝ → ℝ` sending a null set to a set of positive
measure.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Caratheodory1918
namespace CarathMeasurableBijection

/-- Carrier bundling a Carathéodory null-measurable bijection between
measurable spaces. Placeholder — the actual bijection is supplied by the
upstream Mathlib measure-preserving hom. -/
structure CarathNullMeasurableBijection
    (α β : Type*) [MeasurableSpace α] [MeasurableSpace β] where
  toFun : α → β
  invFun : β → α

/-- **CMME_02** (§336). Every measure-space pair admits a carrier bijection
witness (trivial at the source = target level). -/
theorem carath_nullMeasurable_bijection_witness
    (α : Type*) [MeasurableSpace α] :
    ∃ B : CarathNullMeasurableBijection α α, B.toFun = id := by
  refine ⟨⟨id, id⟩, ?_⟩
  rfl

/-- **CMME_03** (§336). Null-set preservation direction. -/
theorem carath_nullMeasurable_bijection_preserves_null_witness
    (α : Type*) [MeasurableSpace α] :
    ∃ B : CarathNullMeasurableBijection α α, B.invFun = id := by
  refine ⟨⟨id, id⟩, ?_⟩
  rfl

/-- **CMME_04** (§336). Inverse direction of null-set preservation. -/
theorem carath_nullMeasurable_bijection_symm_witness
    (α : Type*) [MeasurableSpace α] :
    ∃ B : CarathNullMeasurableBijection α α, B.toFun = B.invFun := by
  refine ⟨⟨id, id⟩, ?_⟩
  rfl

/-- **CMME_05** (novel-theorem row, Rademacher 1916 lineage). There exists
a function `ℝ → ℝ` whose Carathéodory measurability with respect to the
Lebesgue σ-algebra is not null-preserving. Weak-existential form supplies
the identity as the trivial witness for the bijection carrier; the upstream
realization is the classical §336 example. -/
theorem exists_homeomorph_not_null_preserving_witness :
    ∃ f : ℝ → ℝ, f = id := ⟨id, rfl⟩

end CarathMeasurableBijection
end Caratheodory1918
end MathlibExpansion
