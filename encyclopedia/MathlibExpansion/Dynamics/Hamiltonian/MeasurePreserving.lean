import Mathlib.Dynamics.Ergodic.Conservative
import MathlibExpansion.Dynamics.Hamiltonian.Basic

/-!
# Hamiltonian measure-preserving shell

This file packages the invariant-measure boundary needed for recurrence: a
Hamiltonian flow together with a measure known to be preserved by every time
map.
-/

namespace MathlibExpansion
namespace Dynamics
namespace Hamiltonian

open MeasureTheory

structure HamiltonianMeasureData (τ : Type*) (α : Type*) [MeasurableSpace α] where
  flow : τ -> α -> α
  measure : Measure α
  measurePreserving : forall t : τ, MeasurePreserving (flow t) measure measure

theorem hamiltonianFlow_measurePreserving {τ α : Type*} [MeasurableSpace α]
    (data : HamiltonianMeasureData τ α) (t : τ) :
    MeasurePreserving (data.flow t) data.measure data.measure :=
  data.measurePreserving t

theorem conservative_timeMap {τ α : Type*} [MeasurableSpace α]
    (data : HamiltonianMeasureData τ α) [IsFiniteMeasure data.measure] (t : τ) :
    Conservative (data.flow t) data.measure :=
  MeasureTheory.MeasurePreserving.conservative (data.measurePreserving t)

end Hamiltonian
end Dynamics
end MathlibExpansion
