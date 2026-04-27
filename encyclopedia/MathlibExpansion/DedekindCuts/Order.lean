import MathlibExpansion.DedekindCuts.Basic

/-!
# Order on Dedekind cuts

This file orders cuts by inclusion of their lower classes.
-/

namespace MathlibExpansion
namespace DedekindCuts

open Set

namespace DedekindCut

instance : LT DedekindCut where
  lt A B := A.lower ⊂ B.lower

@[simp] theorem lt_def {A B : DedekindCut} : A < B ↔ A.lower ⊂ B.lower := Iff.rfl

theorem lower_total (A B : DedekindCut) : A.lower ⊆ B.lower ∨ B.lower ⊆ A.lower := by
  classical
  by_cases hAB : A.lower ⊆ B.lower
  · exact Or.inl hAB
  · exact Or.inr <| by
      intro q hqB
      by_contra hqA
      rcases not_subset.mp hAB with ⟨p, hpA, hpB⟩
      rcases lt_trichotomy p q with hpq | rfl | hqp
      · exact hpB (B.downward_closed hqB hpq)
      · exact hqA hpA
      · exact hqA (A.downward_closed hpA hqp)

theorem cut_compare_trichotomy (A B : DedekindCut) : A = B ∨ A < B ∨ B < A := by
  rcases lower_total A B with hAB | hBA
  · by_cases hEq : A.lower = B.lower
    · exact Or.inl (DedekindCut.ext hEq)
    · exact Or.inr (Or.inl ⟨hAB, by
        intro hBA'
        exact hEq (Subset.antisymm hAB hBA')⟩)
  · by_cases hEq : B.lower = A.lower
    · exact Or.inl (DedekindCut.ext hEq.symm)
    · exact Or.inr (Or.inr ⟨hBA, by
        intro hAB'
        exact hEq (Subset.antisymm hBA hAB')⟩)

end DedekindCut

end DedekindCuts
end MathlibExpansion
