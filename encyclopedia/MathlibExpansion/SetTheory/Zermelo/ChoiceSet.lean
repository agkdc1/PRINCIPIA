import Mathlib.Data.Set.Lattice
import Mathlib.Data.Set.Pairwise.Lattice
import Mathlib.Logic.Equiv.Set
import Mathlib.SetTheory.Cardinal.Basic

/-!
# Zermelo choice sets and family transport

This file packages the executable typed shadows of Zermelo's theorem `28`,
`29vi`, and the additive half of theorem `30`.
-/

universe u

namespace MathlibExpansion.SetTheory.Zermelo

open Cardinal

theorem simultaneous_disjointization_away
    {ι α β : Type u} (s : ι → Set α) (Z : Set β) :
    ∃ t : ι → Set (β ⊕ (ι × α)),
      Pairwise (fun i j => Disjoint (t i) (t j)) ∧
      Disjoint (⋃ i, t i) (Sum.inl '' Z) ∧
      (∀ i, Nonempty (s i ≃ t i)) := by
  let t : ι → Set (β ⊕ (ι × α)) :=
    fun i => Set.range fun x : s i => (Sum.inr (i, (x : α)) : β ⊕ (ι × α))
  refine ⟨t, ?_, ?_, ?_⟩
  · intro i j hij
    refine Set.disjoint_left.2 ?_
    intro x hx hy
    change x ∈ Set.range (fun x : s i => (Sum.inr (i, (x : α)) : β ⊕ (ι × α))) at hx
    change x ∈ Set.range (fun x : s j => (Sum.inr (j, (x : α)) : β ⊕ (ι × α))) at hy
    rcases hx with ⟨u, rfl⟩
    rcases hy with ⟨v, hv⟩
    have hv' : (Sum.inr (j, (v : α)) : β ⊕ (ι × α)) = Sum.inr (i, (u : α)) := by
      simpa using hv
    have hp : (j, (v : α)) = (i, (u : α)) := Sum.inr.inj hv'
    exact hij (Prod.mk.inj_iff.mp hp).1.symm
  · refine Set.disjoint_left.2 ?_
    intro x hx hz
    rw [Set.mem_iUnion] at hx
    rcases hx with ⟨i, hx⟩
    change x ∈ Set.range (fun x : s i => (Sum.inr (i, (x : α)) : β ⊕ (ι × α))) at hx
    rcases hx with ⟨u, rfl⟩
    rcases hz with ⟨z, _hz, hzx⟩
    cases hzx
  · intro i
    refine ⟨Equiv.ofInjective
      (fun x : s i => (Sum.inr (i, (x : α)) : β ⊕ (ι × α))) ?_⟩
    intro x y hxy
    apply Subtype.ext
    have hxy' : (Sum.inr (i, (x : α)) : β ⊕ (ι × α)) = Sum.inr (i, (y : α)) := by
      simpa using hxy
    have hp : (i, (x : α)) = (i, (y : α)) := Sum.inr.inj hxy'
    exact (Prod.mk.inj_iff.mp hp).2

theorem choice_set_of_pairwise_disjoint_nonempty
    {ι α : Type u} {s : ι → Set α}
    (hs : Pairwise fun i j => Disjoint (s i) (s j)) (hne : ∀ i, (s i).Nonempty) :
    ∃ P : Set α, P ⊆ ⋃ i, s i ∧ ∀ i, ∃! x, x ∈ P ∧ x ∈ s i := by
  classical
  choose f hf using hne
  let P : Set α := Set.range f
  refine ⟨P, ?_, ?_⟩
  · intro x hx
    rcases hx with ⟨i, rfl⟩
    exact Set.mem_iUnion.2 ⟨i, hf i⟩
  · intro i
    refine ⟨f i, ⟨⟨i, rfl⟩, hf i⟩, ?_⟩
    intro y hy
    rcases hy with ⟨hyP, hySi⟩
    rcases hyP with ⟨j, hfj⟩
    by_cases hij : j = i
    · simpa [hij] using hfj.symm
    · have hySj : y ∈ s j := by
        simpa [hfj] using hf j
      exact False.elim <| (Set.disjoint_left.mp (hs hij)) hySj hySi

theorem disjoint_sum_transport_same
    {ι α β : Type u} {s : ι → Set α} {t : ι → Set β}
    (hs : Pairwise fun i j => Disjoint (s i) (s j))
    (ht : Pairwise fun i j => Disjoint (t i) (t j))
    (h : ∀ i, Cardinal.mk (s i) = Cardinal.mk (t i)) :
    Cardinal.mk (⋃ i, s i) = Cardinal.mk (⋃ i, t i) := by
  calc
    Cardinal.mk (⋃ i, s i) = Cardinal.sum (fun i => Cardinal.mk (s i)) :=
      Cardinal.mk_iUnion_eq_sum_mk hs
    _ = Cardinal.sum (fun i => Cardinal.mk (t i)) := by
      exact congrArg Cardinal.sum (funext h)
    _ = Cardinal.mk (⋃ i, t i) := (Cardinal.mk_iUnion_eq_sum_mk ht).symm

theorem disjoint_sum_transport
    {ι α β : Type u} {s : ι → Set α} {t : ι → Set β}
    (hs : Pairwise fun i j => Disjoint (s i) (s j))
    (ht : Pairwise fun i j => Disjoint (t i) (t j))
    (h : ∀ i, Cardinal.mk (s i) = Cardinal.mk (t i)) :
    Cardinal.mk (⋃ i, s i) = Cardinal.mk (⋃ i, t i) :=
  disjoint_sum_transport_same hs ht h

end MathlibExpansion.SetTheory.Zermelo
