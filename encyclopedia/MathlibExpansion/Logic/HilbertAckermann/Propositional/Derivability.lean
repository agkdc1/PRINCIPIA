import MathlibExpansion.Logic.HilbertAckermann.Propositional.DerivedRules

/-!
# Hilbert-Ackermann propositional derivability
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Propositional

open HAPropFormula

section

variable {ν : Type*} [Fintype ν] [DecidableEq ν]

theorem axiom_provable {φ : HAPropFormula ν} (h : HAAxiom φ) : HAProvable φ :=
  HAAxiom.valid h

theorem subst_preserves_provable (σ : ν → HAPropFormula ν) {φ : HAPropFormula ν} :
    HAProvable φ → HAProvable (subst σ φ) :=
  subst_preserves_valid σ

theorem provable_or_iff (φ ψ : HAPropFormula ν) :
    HAProvable (or φ ψ) ↔ ∀ σ, σ ∈ φ ∨ σ ∈ ψ := by
  constructor
  · intro h σ
    exact (mem_or φ ψ σ).1 (h σ)
  · intro h σ
    exact (mem_or φ ψ σ).2 (h σ)

end

end MathlibExpansion.Logic.HilbertAckermann.Propositional
