import Mathlib.Topology.MetricSpace.Pseudo.Basic
import Mathlib.Topology.Sequences

namespace MathlibExpansion
namespace Topology
namespace Hausdorff

open Filter Set

/--
Hausdorff's convergent-set predicate in the local metric compactness lane:
the set is totally bounded and has `x` as its unique closure point.

Source anchor: Felix Hausdorff, *Grundzuege der Mengenlehre* (1914),
Kap. VIII, Section 8, pp. 311--317, compactness and total-boundedness
criteria.
-/
def HausdorffConvergentSet {α : Type*} [PseudoMetricSpace α] (A : Set α) (x : α) : Prop :=
  TotallyBounded A ∧ x ∈ closure A ∧ ∀ y, y ∈ closure A → y = x

/--
Hausdorff's convergent-set package, in the current local carrier, is exactly
total boundedness plus uniqueness of the closure point.

Source anchor: Felix Hausdorff, *Grundzuege der Mengenlehre* (1914),
Kap. VIII, Section 8, pp. 311--317, compactness and total-boundedness
criteria.
-/
theorem hausdorffConvergentSet_iff_totallyBounded_uniqueCluster
    {α : Type*} [PseudoMetricSpace α] [T2Space α] {A : Set α} :
    (∃ x, HausdorffConvergentSet A x) ↔
      TotallyBounded A ∧ ∃! x, x ∈ closure A := by
  constructor
  · rintro ⟨x, hxconv⟩
    rcases hxconv with ⟨hA, hx, huniq⟩
    exact ⟨hA, ⟨x, hx, fun y hy => huniq y hy⟩⟩
  · rintro ⟨hA, x, hx, huniq⟩
    exact ⟨x, hA, hx, fun y hy => huniq y hy⟩

end Hausdorff
end Topology
end MathlibExpansion
