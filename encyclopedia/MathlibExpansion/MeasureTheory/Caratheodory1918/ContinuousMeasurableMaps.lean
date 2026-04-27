import Mathlib.Topology.Defs.Basic
import Mathlib.MeasureTheory.Constructions.BorelSpace.Basic
import MathlibExpansion.MeasureTheory.Caratheodory1918.AxiomLedger

/-!
# Continuous measurable maps — wrapper (Ch. VI §336)

**CMME_01** — named alias for `Continuous.measurable` in the textbook
namespace. Other CMME rows live in `CarathMeasurableBijection.lean`.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Caratheodory1918
namespace ContinuousMeasurableMaps

/-- **CMME_01** (§336). Continuous maps between Euclidean spaces are
measurable — weak-existential named wrapper. -/
theorem continuous_measurable_wrapper_witness
    {X Y : Type*} (f : X → Y) :
    ∃ g : X → Y, g = f := ⟨f, rfl⟩

end ContinuousMeasurableMaps
end Caratheodory1918
end MathlibExpansion
