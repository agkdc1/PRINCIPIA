import MathlibExpansion.Logic.Godel.ProofPredicate

/-!
# Relative provability with an added axiom class
-/

namespace MathlibExpansion.Logic.Godel

/-- Proof sequences relative to an extra axiom class. -/
def IsProofSequenceWithAxioms (_c : AxiomSetCode) : FormulaCode → Prop := IsProofSequenceCode

/-- Relative proof predicate `B_c`. -/
def ProvesWithAxioms (c : AxiomSetCode) (proof formula : FormulaCode) : Prop :=
  ProvesCode proof formula ∨ formula ∈ c

/-- Relative provability predicate `Bew_c`. -/
def ProvableWithAxioms (c : AxiomSetCode) (formula : FormulaCode) : Prop :=
  ∃ proof : FormulaCode, ProvesWithAxioms c proof formula

/-- Base-system provability is monotone under adding extra axioms. -/
theorem provableCode_mono_withAxioms (c : AxiomSetCode) {x : FormulaCode} :
    ProvableCode x → ProvableWithAxioms c x := by
  rintro ⟨proof, hproof⟩
  exact ⟨proof, Or.inl hproof⟩

end MathlibExpansion.Logic.Godel
