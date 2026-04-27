import MathlibExpansion.Logic.HilbertAckermann.Propositional.Derivability

/-!
# Hilbert-Ackermann propositional consistency boundary
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Propositional

open HAPropFormula

section

variable {ν : Type*} [Fintype ν] [DecidableEq ν]

theorem contradictoryPair_not_derivable :
    ¬ ∃ φ : HAPropFormula ν, Valid φ ∧ Valid (not φ) := by
  rintro ⟨φ, hφ, hnotφ⟩
  let σ : Assignment ν := fun _ => false
  exact (mem_not φ σ).1 (hnotφ σ) (hφ σ)

theorem axiom_sound {φ : HAPropFormula ν} (h : HAAxiom φ) : Valid φ :=
  h.valid

theorem propositional_consistent : ¬ Valid (⊥ : HAPropFormula ν) :=
  HAPropFormula.not_valid_bot

end

end MathlibExpansion.Logic.HilbertAckermann.Propositional
