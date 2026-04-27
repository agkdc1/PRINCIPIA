import MathlibExpansion.Logic.HilbertAckermann.Propositional.Contexts

/-!
# Hilbert-Ackermann derived propositional rules
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Propositional

open HAPropFormula

section

variable {ν : Type*} [Fintype ν] [DecidableEq ν]

abbrev HAProvable (φ : HAPropFormula ν) : Prop := Valid φ

theorem modus_ponens {φ ψ : HAPropFormula ν} :
    HAProvable φ → HAProvable (imp φ ψ) → HAProvable ψ := by
  intro hφ hImp σ
  rcases (mem_imp φ ψ σ).1 (hImp σ) with hNot | hψ
  · exact False.elim (hNot (hφ σ))
  · exact hψ

theorem derived_rules_I_to_IV (A B C : HAPropFormula ν) :
    (HAProvable (or A A) → HAProvable A) ∧
      (HAProvable A → HAProvable (or A B)) ∧
      (HAProvable (or A B) → HAProvable (or B A)) ∧
      (HAProvable (imp A B) → HAProvable (imp (or C A) (or C B))) := by
  constructor
  · intro hAA σ
    simpa using hAA σ
  constructor
  · intro hA σ
    exact (mem_or A B σ).2 (Or.inl (hA σ))
  constructor
  · intro hAB σ
    rcases (mem_or A B σ).1 (hAB σ) with hA | hB
    · exact (mem_or B A σ).2 (Or.inr hA)
    · exact (mem_or B A σ).2 (Or.inl hB)
  · intro hAB σ
    rcases (mem_imp A B σ).1 (hAB σ) with hNotA | hB
    · by_cases hC : σ ∈ C
      · exact (mem_imp (or C A) (or C B) σ).2 <|
          Or.inr <| (mem_or C B σ).2 (Or.inl hC)
      · exact (mem_imp (or C A) (or C B) σ).2 <| Or.inl <| by
          intro hCA
          rcases (mem_or C A σ).1 hCA with hC' | hA
          · exact hC hC'
          · exact hNotA hA
    · exact (mem_imp (or C A) (or C B) σ).2 <| Or.inr <|
        (mem_or C B σ).2 (Or.inr hB)

theorem implication_transitivity {A B C : HAPropFormula ν} :
    HAProvable (imp A B) →
      HAProvable (imp B C) →
      HAProvable (imp A C) := by
  intro hAB hBC σ
  rcases (mem_imp A B σ).1 (hAB σ) with hNotA | hB
  · exact (mem_imp A C σ).2 (Or.inl hNotA)
  · rcases (mem_imp B C σ).1 (hBC σ) with hNotB | hC
    · exact False.elim (hNotB hB)
    · exact (mem_imp A C σ).2 (Or.inr hC)

theorem conjunction_package (A B C : HAPropFormula ν) :
    HAProvable (imp (and A B) (and B A)) ∧
      HAProvable (imp (and A B) A) ∧
      HAProvable (imp (and A B) B) ∧
      HAProvable (imp A (imp B (and A B))) ∧
      HAProvable (imp (and A (and B C)) (and (and A B) C)) ∧
      HAProvable (imp (and (and A B) C) (and A (and B C))) := by
  classical
  repeat' constructor
  all_goals
    intro σ
    by_cases hA : σ ∈ A
    · by_cases hB : σ ∈ B
      · by_cases hC : σ ∈ C
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.not, hA, hB, hC]
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.not, hA, hB, hC]
      · by_cases hC : σ ∈ C
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.not, hA, hB, hC]
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.not, hA, hB, hC]
    · by_cases hB : σ ∈ B
      · by_cases hC : σ ∈ C
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.not, hA, hB, hC]
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.not, hA, hB, hC]
      · by_cases hC : σ ∈ C
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.not, hA, hB, hC]
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.not, hA, hB, hC]

theorem distributivity_package (A B C : HAPropFormula ν) :
    HAProvable (imp (or A (and B C)) (and (or A B) (or A C))) ∧
      HAProvable (imp (and (or A B) (or A C)) (or A (and B C))) := by
  classical
  constructor
  all_goals
    intro σ
    by_cases hA : σ ∈ A
    · by_cases hB : σ ∈ B
      · by_cases hC : σ ∈ C
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.or, HAPropFormula.not, hA, hB, hC]
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.or, HAPropFormula.not, hA, hB, hC]
      · by_cases hC : σ ∈ C
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.or, HAPropFormula.not, hA, hB, hC]
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.or, HAPropFormula.not, hA, hB, hC]
    · by_cases hB : σ ∈ B
      · by_cases hC : σ ∈ C
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.or, HAPropFormula.not, hA, hB, hC]
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.or, HAPropFormula.not, hA, hB, hC]
      · by_cases hC : σ ∈ C
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.or, HAPropFormula.not, hA, hB, hC]
        · simp [HAPropFormula.imp, HAPropFormula.and, HAPropFormula.or, HAPropFormula.not, hA, hB, hC]

end

end MathlibExpansion.Logic.HilbertAckermann.Propositional
