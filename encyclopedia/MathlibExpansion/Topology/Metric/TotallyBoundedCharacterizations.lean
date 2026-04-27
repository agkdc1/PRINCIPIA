import Mathlib.Topology.MetricSpace.Pseudo.Basic
import Mathlib.Topology.Sequences

namespace MathlibExpansion
namespace Topology
namespace Metric

open Set
open scoped Classical

/--
Hausdorff's infinite-subset characterization of total boundedness.

This is the metric-space form of Hausdorff, *Mengenlehre*, 3rd ed. (1935),
Chapter VII, §8, Satz VI: a metric set is totally bounded iff every infinite
subset contains two distinct points at arbitrarily small distance.
-/
theorem totallyBounded_iff_forall_infinite_subset_exists_dist_lt
    {α : Type*} [PseudoMetricSpace α] {s : Set α} :
    TotallyBounded s ↔
      ∀ t ⊆ s, t.Infinite → ∀ ε > 0,
        ∃ x ∈ t, ∃ y ∈ t, x ≠ y ∧ dist x y < ε := by
  constructor
  · intro hs t hts ht ε hε
    rcases (_root_.Metric.totallyBounded_iff.1 hs (ε / 2) (half_pos hε)) with
      ⟨c, hcfin, hcover⟩
    choose center hcenter_mem hcenter_ball using
      fun x : t => mem_iUnion₂.1 (hcover (hts x.property))
    have hcenter_maps : MapsTo center (univ : Set t) c := fun x _ => hcenter_mem x
    haveI : Infinite t := ht.to_subtype
    rcases (infinite_univ : (univ : Set t).Infinite).exists_ne_map_eq_of_mapsTo hcenter_maps hcfin with
      ⟨x, _hx, y, _hy, hxy, hcenter⟩
    refine ⟨x, x.property, y, y.property, ?_, ?_⟩
    · exact fun h => hxy (Subtype.ext h)
    · have hxball := hcenter_ball x
      have hyball : (y : α) ∈ _root_.Metric.ball (center x) (ε / 2) := by
        simpa [hcenter] using hcenter_ball y
      calc
        dist (x : α) (y : α) ≤ dist (x : α) (center x) + dist (y : α) (center x) :=
          dist_triangle_right _ _ _
        _ < ε / 2 + ε / 2 := add_lt_add hxball hyball
        _ = ε := by ring
  · intro h
    refine _root_.Metric.totallyBounded_iff.2 fun ε hε => ?_
    by_contra hcover
    have hnext : ∀ t : Set α, t.Finite →
        ∃ x, x ∈ s ∧ ∀ y ∈ t, x ∉ _root_.Metric.ball y ε := by
      intro t ht
      by_contra! hbad
      exact hcover ⟨t, ht, fun x hx => by
        rcases hbad x hx with ⟨y, hy, hxy⟩
        exact mem_iUnion₂.2 ⟨y, hy, hxy⟩⟩
    obtain ⟨u, hu⟩ := seq_of_forall_finite_exists hnext
    have hu_mem : ∀ n, u n ∈ s := fun n => (hu n).1
    have hnot_close_of_lt : ∀ {m n : ℕ}, m < n → ¬ dist (u n) (u m) < ε := by
      intro m n hmn hdist
      exact (hu n).2 (u m) ⟨m, hmn, rfl⟩ hdist
    have hnot_close_of_ne : ∀ {m n : ℕ}, m ≠ n → ¬ dist (u m) (u n) < ε := by
      intro m n hmn hdist
      rcases lt_or_gt_of_ne hmn with hlt | hgt
      · exact hnot_close_of_lt hlt (by simpa [dist_comm] using hdist)
      · exact hnot_close_of_lt hgt hdist
    have hu_inj : Function.Injective u := by
      intro m n hmn
      by_contra hne
      exact hnot_close_of_ne hne (by simpa [hmn] using hε)
    have hrange_inf : (range u).Infinite := by
      simpa using infinite_range_of_injective hu_inj
    rcases h (range u) (by rintro x ⟨n, rfl⟩; exact hu_mem n) hrange_inf ε hε with
      ⟨x, hx, y, hy, hxy, hxyε⟩
    rcases hx with ⟨m, rfl⟩
    rcases hy with ⟨n, rfl⟩
    exact hnot_close_of_ne (by intro hmn; exact hxy (by simp [hmn])) hxyε

end Metric
end Topology
end MathlibExpansion
