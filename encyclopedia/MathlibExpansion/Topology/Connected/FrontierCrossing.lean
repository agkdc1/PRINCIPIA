import Mathlib.Topology.Connected.Basic

namespace MathlibExpansion
namespace Topology
namespace Connected

open Set

variable {α : Type*} [TopologicalSpace α]

/--
If a connected set meets both `A` and `Aᶜ`, then it also meets the frontier of
`A`.
-/
theorem IsConnected.inter_frontier_nonempty {s A : Set α} (hs : IsConnected s)
    (hA : (s ∩ A).Nonempty) (hAc : (s ∩ Aᶜ).Nonempty) :
    (s ∩ frontier A).Nonempty := by
  by_contra hfront
  have hsuv : s ⊆ interior A ∪ interior Aᶜ := by
    intro x hx
    have hx' : x ∈ (frontier A)ᶜ := by
      simp only [Set.mem_compl_iff]
      intro hx_front
      exact hfront ⟨x, hx, hx_front⟩
    simpa [compl_frontier_eq_union_interior] using hx'
  have hsu : (s ∩ interior A).Nonempty := by
    rcases hA with ⟨x, hx_s, hx_A⟩
    refine ⟨x, hx_s, ?_⟩
    rw [← self_diff_frontier]
    exact ⟨hx_A, fun hx_front ↦ hfront ⟨x, hx_s, hx_front⟩⟩
  have huv : Disjoint (interior A) (interior Aᶜ) :=
    disjoint_compl_right.mono interior_subset interior_subset
  have hsA : s ⊆ interior A :=
    hs.isPreconnected.subset_left_of_subset_union isOpen_interior isOpen_interior huv hsuv hsu
  rcases hAc with ⟨x, hx_s, hx_Ac⟩
  exact hx_Ac (interior_subset (hsA hx_s))

end Connected
end Topology
end MathlibExpansion
