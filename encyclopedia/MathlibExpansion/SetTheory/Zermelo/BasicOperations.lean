import Mathlib.SetTheory.ZFC.Basic

/-!
# Zermelo basic operations on `ZFSet`

This file packages the item `11`-`12` algebraic laws from Zermelo's `1908`
paper directly on the faithful `ZFSet` carrier.
-/

namespace MathlibExpansion.SetTheory.Zermelo

open ZFSet

theorem zermelo_sUnion_eq_empty_of_all_empty {T : ZFSet}
    (h : ∀ z : ZFSet, z ∈ T → z = ∅) :
    ZFSet.sUnion T = ∅ := by
  apply ZFSet.ext
  intro x
  constructor
  · intro hx
    rcases (ZFSet.mem_sUnion.mp hx) with ⟨z, hzT, hxz⟩
    rw [h z hzT] at hxz
    exact (ZFSet.not_mem_empty x hxz).elim
  · intro hx
    exact (ZFSet.not_mem_empty x hx).elim

theorem zermelo_union_empty_zfset (M : ZFSet) : M ∪ ∅ = M := by
  ext x
  simp

theorem zermelo_union_self_zfset (M : ZFSet) : M ∪ M = M := by
  ext x
  simp

theorem zermelo_union_comm_zfset (M N : ZFSet) : M ∪ N = N ∪ M := by
  ext x
  simp [or_comm]

theorem zermelo_union_assoc_zfset (M N R : ZFSet) :
    M ∪ (N ∪ R) = (M ∪ N) ∪ R := by
  ext x
  simp [or_assoc]

theorem zermelo_union_inter_distrib_right_zfset (M N R : ZFSet) :
    (M ∪ N) ∩ R = (M ∩ R) ∪ (N ∩ R) := by
  apply ZFSet.ext
  intro x
  constructor
  · intro hx
    rcases ZFSet.mem_inter.mp hx with ⟨hxMN, hxR⟩
    rcases ZFSet.mem_union.mp hxMN with hxM | hxN
    · exact ZFSet.mem_union.mpr <| Or.inl <| ZFSet.mem_inter.mpr ⟨hxM, hxR⟩
    · exact ZFSet.mem_union.mpr <| Or.inr <| ZFSet.mem_inter.mpr ⟨hxN, hxR⟩
  · intro hx
    rcases ZFSet.mem_union.mp hx with hxMR | hxNR
    · rcases ZFSet.mem_inter.mp hxMR with ⟨hxM, hxR⟩
      exact ZFSet.mem_inter.mpr ⟨ZFSet.mem_union.mpr (Or.inl hxM), hxR⟩
    · rcases ZFSet.mem_inter.mp hxNR with ⟨hxN, hxR⟩
      exact ZFSet.mem_inter.mpr ⟨ZFSet.mem_union.mpr (Or.inr hxN), hxR⟩

theorem zermelo_inter_union_distrib_right_zfset (M N R : ZFSet) :
    (M ∩ N) ∪ R = (M ∪ R) ∩ (N ∪ R) := by
  apply ZFSet.ext
  intro x
  constructor
  · intro hx
    rcases ZFSet.mem_union.mp hx with hxMN | hxR
    · rcases ZFSet.mem_inter.mp hxMN with ⟨hxM, hxN⟩
      exact ZFSet.mem_inter.mpr ⟨ZFSet.mem_union.mpr (Or.inl hxM),
        ZFSet.mem_union.mpr (Or.inl hxN)⟩
    · exact ZFSet.mem_inter.mpr
        ⟨ZFSet.mem_union.mpr (Or.inr hxR), ZFSet.mem_union.mpr (Or.inr hxR)⟩
  · intro hx
    rcases ZFSet.mem_inter.mp hx with ⟨hxMR, hxNR⟩
    rcases ZFSet.mem_union.mp hxMR with hxM | hxR
    · rcases ZFSet.mem_union.mp hxNR with hxN | hxR'
      · exact ZFSet.mem_union.mpr <| Or.inl <| ZFSet.mem_inter.mpr ⟨hxM, hxN⟩
      · exact ZFSet.mem_union.mpr <| Or.inr hxR'
    · exact ZFSet.mem_union.mpr <| Or.inr hxR

end MathlibExpansion.SetTheory.Zermelo
