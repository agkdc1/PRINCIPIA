import MathlibExpansion.Logic.HilbertAckermann.Propositional.Duality

/-!
# Hilbert-Ackermann Chapter I axiom schemata
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Propositional

open HAPropFormula

section

variable {ν : Type*} [Fintype ν] [DecidableEq ν]

inductive HAAxiom : HAPropFormula ν → Prop
  | ax_a (X : HAPropFormula ν) :
      HAAxiom (imp (or X X) X)
  | ax_b (X Y : HAPropFormula ν) :
      HAAxiom (imp X (or X Y))
  | ax_c (X Y : HAPropFormula ν) :
      HAAxiom (imp (or X Y) (or Y X))
  | ax_d (X Y Z : HAPropFormula ν) :
      HAAxiom (imp (imp X Y) (imp (or Z X) (or Z Y)))

theorem HAAxiom.valid {φ : HAPropFormula ν} (h : HAAxiom φ) : Valid φ := by
  classical
  intro σ
  cases h with
  | ax_a X =>
      simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not]
  | ax_b X Y =>
      by_cases hX : σ ∈ X
      · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hX]
      · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hX]
  | ax_c X Y =>
      by_cases hX : σ ∈ X
      · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hX]
      · by_cases hY : σ ∈ Y
        · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hX, hY]
        · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hX, hY]
  | ax_d X Y Z =>
      by_cases hZ : σ ∈ Z
      · by_cases hY : σ ∈ Y
        · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hZ, hY]
        · by_cases hX : σ ∈ X
          · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hZ, hY, hX]
          · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hZ, hY, hX]
      · by_cases hY : σ ∈ Y
        · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hZ, hY]
        · by_cases hX : σ ∈ X
          · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hZ, hY, hX]
          · simp [HAPropFormula.imp, HAPropFormula.or, HAPropFormula.and, HAPropFormula.not, hZ, hY, hX]

end

end MathlibExpansion.Logic.HilbertAckermann.Propositional
