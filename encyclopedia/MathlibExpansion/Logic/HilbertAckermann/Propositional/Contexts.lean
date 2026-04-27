import MathlibExpansion.Logic.HilbertAckermann.Propositional.Substitution

/-!
# Hilbert-Ackermann one-hole propositional contexts
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Propositional

structure HAContext (ν : Type*) where
  fill : HAPropFormula ν → HAPropFormula ν
  congr :
    ∀ {φ ψ : HAPropFormula ν}, HAPropFormula.Equivalent φ ψ →
      HAPropFormula.Equivalent (fill φ) (fill ψ)

theorem replace_equiv_in_context {ν : Type*} (C : HAContext ν)
    {A B : HAPropFormula ν} :
    HAPropFormula.Equivalent A B →
      HAPropFormula.Equivalent (C.fill A) (C.fill B) :=
  C.congr

end MathlibExpansion.Logic.HilbertAckermann.Propositional
