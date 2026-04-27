import Mathlib.Data.Set.Insert
import Mathlib.Data.Set.Lattice
import Mathlib.Logic.Equiv.Set
import Mathlib.SetTheory.Cardinal.Arithmetic
import Mathlib.SetTheory.Cardinal.SchroederBernstein
import Mathlib.SetTheory.ZFC.Basic

/-!
# Zermelo disjoint copies and self-similarity wrappers

This file packages the reusable item `19` disjoint-copy theorem on `ZFSet`
and the typed-set wrappers for items `25`-`26`.
-/

universe u

namespace MathlibExpansion.SetTheory.Zermelo

open Function
open ZFSet

def taggedCopyElement (N x : ZFSet.{u}) : ZFSet.{u} :=
  ({N, ZFSet.pair N x} : ZFSet)

theorem taggedCopyElement_mem_left (N x : ZFSet.{u}) : N ∈ taggedCopyElement N x :=
  ZFSet.mem_pair.mpr <| Or.inl rfl

theorem orderedPair_ne_left (N x : ZFSet.{u}) : ZFSet.pair N x ≠ N := by
  intro h
  have hmem : ({N} : ZFSet.{u}) ∈ N := by
    have : ({N} : ZFSet.{u}) ∈ ZFSet.pair N x := by
      simp [ZFSet.pair, ZFSet.mem_pair]
    simpa [h] using this
  have hnot : N ∉ ({N} : ZFSet.{u}) := ZFSet.mem_asymm hmem
  exact hnot ((ZFSet.mem_singleton (x := N) (y := N)).2 rfl)

theorem taggedCopyElement_injective (N : ZFSet.{u}) :
    Function.Injective (taggedCopyElement N) := by
  intro x y hxy
  have hxmem : ZFSet.pair N x ∈ taggedCopyElement N y := by
    have : ZFSet.pair N x ∈ taggedCopyElement N x := ZFSet.mem_pair.mpr <| Or.inr rfl
    simpa [hxy] using this
  have hpair : ZFSet.pair N x = ZFSet.pair N y := by
    rcases ZFSet.mem_pair.mp hxmem with hN | hEq
    · exact False.elim <| (orderedPair_ne_left N x) hN
    · exact hEq
  exact (ZFSet.pair_inj.mp hpair).2

noncomputable def disjointCopy (M N : ZFSet.{u}) : ZFSet.{u} :=
  ZFSet.range fun x : M.toSet => taggedCopyElement N x.1

theorem exists_disjoint_copy (M N : ZFSet.{u}) :
    ∃ M' : ZFSet.{u}, Disjoint M'.toSet N.toSet ∧ Nonempty (M.toSet ≃ M'.toSet) := by
  refine ⟨disjointCopy M N, ?_, ?_⟩
  · refine Set.disjoint_left.2 ?_
    intro y hyM' hyN
    rcases ZFSet.mem_range.mp hyM' with ⟨x, rfl⟩
    exact (ZFSet.mem_asymm hyN) (taggedCopyElement_mem_left N x.1)
  · refine ⟨?_⟩
    simpa [disjointCopy] using
      (Equiv.ofInjective (fun x : M.toSet => taggedCopyElement N x.1)
        (fun x y hxy => by
          exact Subtype.ext <| taggedCopyElement_injective N hxy))

def embeddingOfSubset {α : Type*} {s t : Set α} (h : s ⊆ t) : s ↪ t :=
  ⟨fun x => ⟨x.1, h x.2⟩, fun _ _ hxy => Subtype.ext <| by
    simpa using congrArg Subtype.val hxy⟩

theorem equiv_of_equiv_subsubset {α : Type*} {s t u : Set α}
    (hts : t ⊆ s) (htu : t ⊆ u) (hus : u ⊆ s) (h : Nonempty (s ≃ t)) :
    Nonempty (s ≃ u) := by
  let e : s ≃ t := h.some
  let estu : s ↪ u :=
    ⟨fun x => ⟨(e x).1, htu (e x).2⟩, fun x y hxy => by
      exact e.injective <| Subtype.ext <| by
        simpa using congrArg Subtype.val hxy⟩
  exact Function.Embedding.antisymm estu (embeddingOfSubset hus)

theorem infinite_of_equiv_proper_subset {α : Type*} {s t : Set α}
    (hts : t ⊂ s) (h : Nonempty (s ≃ t)) : Infinite s := by
  classical
  let e : s ≃ t := h.some
  let f : s → s := fun x => ⟨(e x).1, hts.1 (e x).2⟩
  have hf : Function.Injective f := by
    intro x y hxy
    exact e.injective <| Subtype.ext <| by
      simpa using congrArg Subtype.val hxy
  by_contra hsInf
  haveI : Finite s := not_infinite_iff_finite.mp hsInf
  have hsurj : Function.Surjective f := Finite.surjective_of_injective hf
  rcases Set.exists_of_ssubset hts with ⟨a, haS, haNotT⟩
  rcases hsurj ⟨a, haS⟩ with ⟨x, hx⟩
  have hxval : (e x).1 = a := by simpa [f] using congrArg Subtype.val hx
  have : a ∈ t := by simpa [hxval] using (e x).2
  exact haNotT this

theorem equiv_sdiff_singleton_of_equiv_proper_subset {α : Type*} {s t : Set α} {a : α}
    (hts : t ⊂ s) (h : Nonempty (s ≃ t)) (ha : a ∈ s) :
    Nonempty (↥(s \ ({a} : Set α)) ≃ s) := by
  classical
  by_cases hat : a ∈ t
  · rcases Set.exists_of_ssubset hts with ⟨b, hbS, hbNotT⟩
    let u : Set α := insert b (t \ ({a} : Set α))
    have hsu : u ⊆ s \ ({a} : Set α) := by
      intro x hx
      rcases hx with rfl | hx
      · refine ⟨hbS, ?_⟩
        intro hba
        subst hba
        exact hbNotT hat
      · exact ⟨hts.1 hx.1, hx.2⟩
    have hEqTU : Nonempty (t ≃ u) := by
      exact ⟨Set.BijOn.equiv (Equiv.swap a b) (Equiv.swap_bijOn_exchange hat hbNotT)⟩
    have hEqSU : Nonempty (s ≃ u) := by
      exact ⟨h.some.trans hEqTU.some⟩
    let e : s ↪ ↥(s \ ({a} : Set α)) :=
      ⟨fun x => ⟨(hEqSU.some x).1, hsu (hEqSU.some x).2⟩, fun x y hxy => by
        exact hEqSU.some.injective <| Subtype.ext <| by
          simpa using congrArg Subtype.val hxy⟩
    exact ⟨(Function.Embedding.antisymm e (embeddingOfSubset Set.diff_subset)).some.symm⟩
  · have htu : t ⊆ s \ ({a} : Set α) := by
      intro x hx
      refine ⟨hts.1 hx, ?_⟩
      intro hxa
      subst hxa
      exact hat hx
    let e : s ↪ ↥(s \ ({a} : Set α)) :=
      ⟨fun x => ⟨(h.some x).1, htu (h.some x).2⟩, fun x y hxy => by
        exact h.some.injective <| Subtype.ext <| by
          simpa using congrArg Subtype.val hxy⟩
    exact ⟨(Function.Embedding.antisymm e (embeddingOfSubset Set.diff_subset)).some.symm⟩

theorem equiv_insert_of_equiv_proper_subset {α : Type*} {s t : Set α} {a : α}
    (hts : t ⊂ s) (h : Nonempty (s ≃ t)) (ha : a ∉ s) :
    Nonempty ((insert a s : Set α) ≃ s) := by
  letI : Infinite s := infinite_of_equiv_proper_subset hts h
  have hcard : Cardinal.mk (insert a s : Set α) = Cardinal.mk s := by
    exact (Cardinal.mk_insert (s := s) (a := a) ha).trans (Cardinal.mk_add_one_eq (α := s))
  exact Cardinal.eq.mp hcard

end MathlibExpansion.SetTheory.Zermelo
