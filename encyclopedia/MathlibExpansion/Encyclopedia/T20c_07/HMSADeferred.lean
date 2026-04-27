import Mathlib.Topology.MetricSpace.Basic

namespace MathlibExpansion
namespace Encyclopedia
namespace T20c_07

/--
Historical defer ledger for the metric-space opening in Hausdorff 1914,
*Grundzuege der Mengenlehre*, Kap. VII, § 1, pp. 211-214: open
metric sets are exactly the sets containing a positive-radius ball around
each of their points.  This is the standard Mathlib theorem
`Metric.isOpen_iff`.
-/
theorem metric_isOpen_iff_ball_historical
    {α : Type*} [PseudoMetricSpace α] {s : Set α} :
    IsOpen s ↔ ∀ x ∈ s, ∃ ε > 0, Metric.ball x ε ⊆ s :=
  Metric.isOpen_iff

end T20c_07
end Encyclopedia
end MathlibExpansion
