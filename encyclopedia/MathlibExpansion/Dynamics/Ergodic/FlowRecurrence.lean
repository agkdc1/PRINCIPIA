import Mathlib.Dynamics.Ergodic.Conservative
import Mathlib.Dynamics.Flow
import Mathlib.Tactic
import MathlibExpansion.Dynamics.Hamiltonian.MeasurePreserving

/-!
# Recurrence for measure-preserving flows along a fixed step

Mathlib already proves Poincare recurrence for a conservative self-map. This
file packages the reusable bridge for a flow by applying that theorem to one
chosen time map.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Ergodic

open Filter MeasureTheory

theorem iterate_timeMap_apply {α : Type*} [TopologicalSpace α] (flow : Flow ℝ α) (t : ℝ) :
    forall n : ℕ, forall x : α, (flow t)^[n] x = flow (n • t) x
  | 0, x => by simpa using flow.map_zero_apply x
  | n + 1, x => by
      rw [Function.iterate_succ_apply', iterate_timeMap_apply flow t n]
      calc
        flow t (flow (n • t) x) = flow (t + n • t) x := by
          simpa using (flow.map_add t (n • t) x).symm
        _ = flow ((n + 1) • t) x := by
          change flow.toFun (t + n • t) x = flow.toFun ((n + 1) • t) x
          have htime : t + (n : ℝ) * t = ((n : ℝ) + 1) * t := by
            ring
          simpa [nsmul_eq_mul] using congrArg (fun s => flow s x) htime

structure FlowRecurrenceData (α : Type*) [TopologicalSpace α] [MeasurableSpace α] where
  flow : Flow ℝ α
  measure : Measure α
  step : ℝ
  measurePreserving : forall t : ℝ, MeasurePreserving (flow t) measure measure

namespace FlowRecurrenceData

theorem timeMapConservative {α : Type*} [TopologicalSpace α] [MeasurableSpace α]
    (data : FlowRecurrenceData α) [IsFiniteMeasure data.measure] :
    Conservative (data.flow data.step) data.measure :=
  MeasureTheory.MeasurePreserving.conservative (data.measurePreserving data.step)

theorem ae_mem_imp_frequently_timeMap_mem {α : Type*} [TopologicalSpace α] [MeasurableSpace α]
    (data : FlowRecurrenceData α) [IsFiniteMeasure data.measure] {s : Set α}
    (hs : NullMeasurableSet s data.measure) :
    ∀ᵐ x ∂data.measure, x ∈ s -> ∃ᶠ n in (atTop : Filter ℕ), (data.flow data.step)^[n] x ∈ s := by
  simpa using (data.timeMapConservative).ae_mem_imp_frequently_image_mem hs

theorem ae_mem_imp_frequently_flow_mem {α : Type*} [TopologicalSpace α] [MeasurableSpace α]
    (data : FlowRecurrenceData α) [IsFiniteMeasure data.measure] {s : Set α}
    (hs : NullMeasurableSet s data.measure) :
    ∀ᵐ x ∂data.measure, x ∈ s -> ∃ᶠ n in (atTop : Filter ℕ), data.flow (n • data.step) x ∈ s := by
  refine (data.ae_mem_imp_frequently_timeMap_mem hs).mono ?_
  intro x hx hxmem
  exact (hx hxmem).mono fun (n : ℕ) hn => by
    simpa [iterate_timeMap_apply] using hn

end FlowRecurrenceData

end Ergodic
end Dynamics
end MathlibExpansion
