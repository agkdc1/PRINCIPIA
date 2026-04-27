import Mathlib.Dynamics.Ergodic.Conservative
import MathlibExpansion.Dynamics.Ergodic.FlowRecurrence

/-!
# Hamiltonian Poincare recurrence on invariant shells

This file packages the standard recurrence bridge used in the Poincare recon:
once a Hamiltonian flow preserves a finite measure and an invariant shell, the
restricted time map is conservative and hence recurrent almost everywhere.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Hamiltonian

open Filter MeasureTheory

structure HamiltonianRecurrenceData (α : Type*) [TopologicalSpace α] [MeasurableSpace α] where
  flow : Flow ℝ α
  measure : Measure α
  shell : Set α
  step : ℝ
  measurePreserving : forall t : ℝ, MeasurePreserving (flow t) measure measure
  restrictedMeasurePreserving :
    forall t : ℝ, MeasurePreserving (flow t) (measure.restrict shell) (measure.restrict shell)
  invariantShell : forall t : ℝ, Set.MapsTo (flow t) shell shell

namespace HamiltonianRecurrenceData

theorem timeMapConservativeOnShell {α : Type*} [TopologicalSpace α] [MeasurableSpace α]
    (data : HamiltonianRecurrenceData α) [IsFiniteMeasure (data.measure.restrict data.shell)] :
    Conservative (data.flow data.step) (data.measure.restrict data.shell) := by
  exact MeasureTheory.MeasurePreserving.conservative (data.restrictedMeasurePreserving data.step)

theorem ae_mem_imp_frequently_timeMap_mem_onShell {α : Type*} [TopologicalSpace α] [MeasurableSpace α]
    (data : HamiltonianRecurrenceData α) [IsFiniteMeasure (data.measure.restrict data.shell)]
    {s : Set α} (hs : NullMeasurableSet s (data.measure.restrict data.shell)) :
    ∀ᵐ x ∂(data.measure.restrict data.shell),
      x ∈ s -> ∃ᶠ n in (atTop : Filter ℕ), (data.flow data.step)^[n] x ∈ s := by
  simpa using (data.timeMapConservativeOnShell).ae_mem_imp_frequently_image_mem hs

theorem ae_mem_imp_frequently_flow_mem_onShell {α : Type*} [TopologicalSpace α] [MeasurableSpace α]
    (data : HamiltonianRecurrenceData α) [IsFiniteMeasure (data.measure.restrict data.shell)]
    {s : Set α} (hs : NullMeasurableSet s (data.measure.restrict data.shell)) :
    ∀ᵐ x ∂(data.measure.restrict data.shell),
      x ∈ s -> ∃ᶠ n in (atTop : Filter ℕ), data.flow (n • data.step) x ∈ s := by
  refine (data.ae_mem_imp_frequently_timeMap_mem_onShell hs).mono ?_
  intro x hx hxmem
  exact (hx hxmem).mono fun (n : ℕ) hn => by
    simpa [MathlibExpansion.Dynamics.Ergodic.iterate_timeMap_apply] using hn

end HamiltonianRecurrenceData

end Hamiltonian
end Dynamics
end MathlibExpansion
