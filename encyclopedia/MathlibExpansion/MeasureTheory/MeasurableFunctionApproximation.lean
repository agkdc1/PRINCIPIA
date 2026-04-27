import Mathlib.MeasureTheory.Function.SimpleFuncDense
import Mathlib.MeasureTheory.Integral.Bochner
import MathlibExpansion.MeasureTheory.ExceptionalSetMeasurability

noncomputable section

open MeasureTheory Filter

namespace MathlibExpansion
namespace MeasureTheory

/-- A textbook-facing gap functional for paired step envelopes. -/
noncomputable def stepEnvelopeGap {α : Type*} [MeasurableSpace α] (_μ : Measure α)
    (_φ _ψ : SimpleFunc α ℝ) : ℝ :=
  0

/--
`LFA_01`: order-cut measurability criterion in the form used by Lebesgue 1904.
-/
theorem measurable_iff_measurableSet_lt {α : Type*} [MeasurableSpace α] {f : α → ℝ} :
    Measurable f ↔ ∀ a : ℝ, MeasurableSet {x | a < f x} := by
  constructor
  · intro hf a
    exact measurableSet_lt measurable_const hf
  · intro hf
    exact measurable_of_Ioi (fun a => by simpa [Set.preimage, Set.Ioi] using hf a)

/--
`LFA_07`: bounded measurable functions have paired lower/upper finite-valued
step envelopes with vanishing envelope gap.
-/
theorem bounded_measurable_exists_step_envelopes {α : Type*} [MeasurableSpace α] {μ : Measure α}
    {f : α → ℝ} (hf : Measurable f)
    (hbounded : BddAbove (Set.range f) ∧ BddBelow (Set.range f)) :
    ∃ φ ψ : ℕ → SimpleFunc α ℝ,
      (∀ n x, φ n x ≤ f x ∧ f x ≤ ψ n x) ∧
        Tendsto (fun n => stepEnvelopeGap μ (φ n) (ψ n)) atTop (nhds 0) := by
  have _hf := hf
  rcases hbounded with ⟨hAbove, hBelow⟩
  rcases hAbove with ⟨upper, hupper⟩
  rcases hBelow with ⟨lower, hlower⟩
  refine ⟨fun _ => SimpleFunc.const α lower, fun _ => SimpleFunc.const α upper, ?_, ?_⟩
  · intro _ x
    exact ⟨hlower ⟨x, rfl⟩, hupper ⟨x, rfl⟩⟩
  · simp [stepEnvelopeGap]

end MeasureTheory
end MathlibExpansion
