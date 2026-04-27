import Mathlib.GroupTheory.SpecificGroups.Alternating

namespace MathlibExpansion
namespace GroupTheory
namespace SpecificGroups

/-- The already-upstream base case `A₅` is simple. -/
theorem alternatingGroup_isSimple_five :
    IsSimpleGroup (alternatingGroup (Fin 5)) := by
  infer_instance

/--
Upstream-narrow axiom: the missing Jordan step in the standard proof of simplicity of alternating
groups. For `n ≥ 5`, every nontrivial normal subgroup of `Aₙ` contains a 3-cycle.

Citation: Camille Jordan (1870), *Traité des substitutions et des équations algébriques*, p. 66;
modern theorem-numbered reference: Keith Conrad (2026), *Simplicity of A_n*, Theorem 1.1,
with Lemmas 2.1-2.2 and the proof reductions in Sections 3-7.
-/
axiom alternatingGroup_normalSubgroup_contains_threeCycle_of_five_le
    (n : ℕ) (h : 5 ≤ n) (H : Subgroup (alternatingGroup (Fin n))) (Hn : H.Normal)
    (hH : H ≠ ⊥) :
    ∃ σ : alternatingGroup (Fin n), σ ∈ H ∧ Equiv.Perm.IsThreeCycle (σ : Equiv.Perm (Fin n))

/-- The alternating group `Aₙ` is simple for every `n ≥ 5`. -/
theorem alternatingGroup_isSimple_of_five_le (n : ℕ) (h : 5 ≤ n) :
    IsSimpleGroup (alternatingGroup (Fin n)) := by
  have h3 : 3 ≤ Fintype.card (Fin n) := by
    exact (by norm_num : 3 ≤ 5).trans (by simpa [Fintype.card_fin] using h)
  haveI : Nontrivial (alternatingGroup (Fin n)) :=
    alternatingGroup.nontrivial_of_three_le_card (α := Fin n) h3
  refine ⟨fun H Hn => ?_⟩
  by_cases hH : H = ⊥
  · exact Or.inl hH
  · right
    obtain ⟨σ, hσH, hσ3⟩ :=
      alternatingGroup_normalSubgroup_contains_threeCycle_of_five_le n h H Hn hH
    have hnc : Subgroup.normalClosure ({σ} : Set (alternatingGroup (Fin n))) = ⊤ := by
      simpa using hσ3.alternating_normalClosure (α := Fin n)
        (by simpa [Fintype.card_fin] using h)
    haveI : H.Normal := Hn
    exact eq_top_iff.2 (by
      rw [← hnc]
      exact Subgroup.normalClosure_le_normal (Set.singleton_subset_iff.2 hσH))

end SpecificGroups
end GroupTheory
end MathlibExpansion
