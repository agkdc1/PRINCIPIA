import MathlibExpansion.Logic.HilbertAckermann.Propositional.Axioms

/-!
# Hilbert-Ackermann propositional substitution
-/

open MathlibExpansion.Textbooks.Boole1854

namespace MathlibExpansion.Logic.HilbertAckermann.Propositional

open HAPropFormula

section

variable {ν μ : Type*} [Fintype ν] [DecidableEq ν] [Fintype μ] [DecidableEq μ]

def subst (σ : ν → HAPropFormula μ) (φ : HAPropFormula ν) : HAPropFormula μ :=
  Finset.univ.filter fun τ : Assignment μ =>
    (fun i => MathlibExpansion.Textbooks.Boole1854.truthValue (σ i) τ) ∈ φ

@[simp] theorem mem_subst_iff (σ : ν → HAPropFormula μ) (φ : HAPropFormula ν)
    (τ : Assignment μ) :
    τ ∈ subst σ φ ↔
      (fun i => MathlibExpansion.Textbooks.Boole1854.truthValue (σ i) τ) ∈ φ := by
  simp [subst]

theorem subst_preserves_valid (σ : ν → HAPropFormula μ) {φ : HAPropFormula ν}
    (hφ : Valid φ) : Valid (subst σ φ) := by
  intro τ
  simpa [mem_subst_iff] using
    hφ (fun i => MathlibExpansion.Textbooks.Boole1854.truthValue (σ i) τ)

end

end MathlibExpansion.Logic.HilbertAckermann.Propositional
