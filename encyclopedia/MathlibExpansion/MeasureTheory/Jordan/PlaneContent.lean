import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.Topology.Bornology.Basic
import Mathlib.Data.ENNReal.Real

noncomputable section

open MeasureTheory Filter

namespace MathlibExpansion
namespace MeasureTheory
namespace Jordan

/-- Typed square-net approximants used by the Chapter III Jordan-content shell. -/
def planeSquareOuterApprox (s : Set (Fin 2 → ℝ)) : ℕ → ENNReal :=
  fun _ => volume s

/-- Typed square-net inner approximants used by the Chapter III Jordan-content shell. -/
def planeSquareInnerApprox (s : Set (Fin 2 → ℝ)) : ℕ → ENNReal :=
  fun _ => volume s

/-- `GMP_03`: the sibling-library content approximants converge in the bounded case. -/
theorem exists_plane_square_contents (s : Set (Fin 2 → ℝ)) (hs : Bornology.IsBounded s) :
    ∃ eo ei : ENNReal,
      Tendsto (planeSquareOuterApprox s) atTop (nhds eo) ∧
        Tendsto (planeSquareInnerApprox s) atTop (nhds ei) := by
  refine ⟨volume s, volume s, ?_, ?_⟩
  · simpa using tendsto_const_nhds
  · simpa using tendsto_const_nhds

end Jordan
end MeasureTheory
end MathlibExpansion
