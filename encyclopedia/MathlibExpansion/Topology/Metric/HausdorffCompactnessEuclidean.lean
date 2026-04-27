import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Topology.MetricSpace.Bounded

namespace MathlibExpansion
namespace Topology
namespace Metric

open Set

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]

/--
In finite-dimensional real normed spaces, compactness is equivalent to being
closed and bounded.
-/
theorem isCompact_iff_isClosed_bounded {s : Set E} :
    IsCompact s ↔ IsClosed s ∧ Bornology.IsBounded s := by
  letI : ProperSpace E := FiniteDimensional.proper ℝ E
  constructor
  · intro hs
    exact ⟨hs.isClosed, hs.isBounded⟩
  · rintro ⟨hClosed, hBounded⟩
    exact Metric.isCompact_of_isClosed_isBounded hClosed hBounded

end Metric
end Topology
end MathlibExpansion
