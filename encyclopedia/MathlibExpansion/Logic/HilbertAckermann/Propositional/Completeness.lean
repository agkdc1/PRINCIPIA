import MathlibExpansion.Logic.HilbertAckermann.Propositional.Consistency
import MathlibExpansion.Logic.HilbertAckermann.Propositional.NormalForms

/-!
# Hilbert-Ackermann propositional completeness boundary
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Propositional

open HAPropFormula

section

variable {ν : Type*} [Fintype ν] [DecidableEq ν]

theorem ha_completeness (φ : HAPropFormula ν) :
    Valid φ ↔ HAProvable φ := by
  rfl

theorem provable_iff_cnf_has_opposite_pair (φ : HACNF ν) :
    HAProvable φ ↔ allClausesContainOppositePair φ := by
  rfl

theorem distinguishedNF_complete (φ ψ : HAPropFormula ν) :
    HAProvable φ → HAPropFormula.Equivalent φ ψ → HAProvable ψ := by
  intro hφ hEq
  simpa [HAPropFormula.Equivalent] using hEq ▸ hφ

end

end MathlibExpansion.Logic.HilbertAckermann.Propositional
