import Mathlib.SetTheory.ZFC.Basic

/-!
# Zermelo's Russell subset wrapper

This file isolates the narrow executable theorem from Zermelo's theorem `10`
without deduplicating it against the stronger modern `mem_irrefl` endpoint.
-/

namespace MathlibExpansion.SetTheory.Zermelo

open ZFSet

theorem russellSubset_mem_iff {M x : ZFSet} :
    x ∈ ZFSet.sep (fun y => y ∉ y) M ↔ x ∈ M ∧ x ∉ x :=
  ZFSet.mem_sep

theorem russellSubset_not_mem (M : ZFSet) :
    ZFSet.sep (fun y => y ∉ y) M ∉ M := by
  let R : ZFSet := ZFSet.sep (fun y => y ∉ y) M
  intro hRM
  have hRnot : R ∉ R := by
    intro hRR
    exact (ZFSet.mem_sep.mp hRR).2 hRR
  have hRR : R ∈ R := by
    exact ZFSet.mem_sep.mpr ⟨hRM, hRnot⟩
  exact hRnot hRR

end MathlibExpansion.SetTheory.Zermelo
