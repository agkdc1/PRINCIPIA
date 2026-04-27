import MathlibExpansion.Logic.HilbertAckermann.Propositional.NormalForms

/-!
# Hilbert-Ackermann propositional duality
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Propositional

section

variable {ν : Type*} [Fintype ν] [DecidableEq ν]

/-- The extensional Boolean dual: evaluate the original formula on the
pointwise-complemented assignment and negate the resulting truth value.

This is the truth-table form of the duality operation from Hilbert and
Ackermann, *Grundzüge der theoretischen Logik* (1928), Chapter I, §5. -/
def dualize (φ : HAPropFormula ν) : HAPropFormula ν :=
  Finset.univ.filter fun σ : Assignment ν => (fun i => !σ i) ∉ φ

/-- Hilbert-Ackermann propositional duality principle.

For the extensional Boolean-formula carrier used here, logical equivalence is
equality of truth tables, so dualization is immediately congruent. This is the
truth-table version of Hilbert and Ackermann, *Grundzüge der theoretischen
Logik* (1928), Chapter I, §5. -/
theorem ha_duality_principle (φ ψ : HAPropFormula ν) :
    HAPropFormula.Equivalent φ ψ →
      HAPropFormula.Equivalent (dualize φ) (dualize ψ) := by
  intro h
  simpa [HAPropFormula.Equivalent] using congrArg dualize h

end

end MathlibExpansion.Logic.HilbertAckermann.Propositional
