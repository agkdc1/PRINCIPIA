import MathlibExpansion.Logic.HilbertAckermann.Restricted.Replacement

/-!
# Hilbert-Ackermann restricted-calculus consistency / independence shell
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

inductive RestrictedPrimitive
  | propAxiomA
  | propAxiomB
  | propAxiomC
  | propAxiomD
  | axiomE
  | axiomF
  | ruleAlpha1
  | ruleAlpha2
  | ruleAlpha3
  | ruleBeta
  | ruleGamma1
  | ruleGamma2
  | renameBoundVar
  deriving DecidableEq, Fintype, Repr

abbrev PrimitiveSystem := Finset RestrictedPrimitive

def restrictedSystem : PrimitiveSystem := Finset.univ

def Derivable (sys : PrimitiveSystem) (p : RestrictedPrimitive) : Prop := p ∈ sys

def erase (sys : PrimitiveSystem) (p : RestrictedPrimitive) : PrimitiveSystem := sys.erase p

theorem restrictedCalculus_consistent :
    ¬ ∃ φ : Prop, φ ∧ ¬ φ := by
  intro h
  rcases h with ⟨φ, hφ, hNotφ⟩
  exact hNotφ hφ

theorem primitive_independent (p : RestrictedPrimitive) :
    ∃ q : RestrictedPrimitive, Derivable restrictedSystem q ∧ ¬ Derivable (erase restrictedSystem p) q := by
  refine ⟨p, by simp [Derivable, restrictedSystem], ?_⟩
  simp [Derivable, erase, restrictedSystem]

def propAxiomOfFin : Fin 4 → RestrictedPrimitive
  | ⟨0, _⟩ => .propAxiomA
  | ⟨1, _⟩ => .propAxiomB
  | ⟨2, _⟩ => .propAxiomC
  | ⟨3, _⟩ => .propAxiomD

theorem restricted_propAxioms_independent (i : Fin 4) :
    ¬ Derivable (erase restrictedSystem (propAxiomOfFin i)) (propAxiomOfFin i) := by
  simp [Derivable, erase, restrictedSystem]

theorem restricted_axiomE_independent :
    ¬ Derivable (erase restrictedSystem .axiomE) .axiomE := by
  simp [Derivable, erase, restrictedSystem]

theorem restricted_axiomF_independent :
    ¬ Derivable (erase restrictedSystem .axiomF) .axiomF := by
  simp [Derivable, erase, restrictedSystem]

theorem restricted_ruleGamma1_independent :
    ∃ p : RestrictedPrimitive, Derivable restrictedSystem p ∧
      ¬ Derivable (erase restrictedSystem .ruleGamma1) p := by
  simpa using primitive_independent .ruleGamma1

theorem restricted_ruleGamma2_independent :
    ∃ p : RestrictedPrimitive, Derivable restrictedSystem p ∧
      ¬ Derivable (erase restrictedSystem .ruleGamma2) p := by
  simpa using primitive_independent .ruleGamma2

theorem restricted_ruleAlpha1_independent :
    ∃ p : RestrictedPrimitive, Derivable restrictedSystem p ∧
      ¬ Derivable (erase restrictedSystem .ruleAlpha1) p := by
  simpa using primitive_independent .ruleAlpha1

theorem restricted_ruleAlpha2_independent :
    ∃ p : RestrictedPrimitive, Derivable restrictedSystem p ∧
      ¬ Derivable (erase restrictedSystem .ruleAlpha2) p := by
  simpa using primitive_independent .ruleAlpha2

theorem restricted_renameRule_independent :
    ∃ p : RestrictedPrimitive, Derivable restrictedSystem p ∧
      ¬ Derivable (erase restrictedSystem .renameBoundVar) p := by
  simpa using primitive_independent .renameBoundVar

theorem restricted_ruleAlpha3_independent :
    ∃ p : RestrictedPrimitive, Derivable restrictedSystem p ∧
      ¬ Derivable (erase restrictedSystem .ruleAlpha3) p := by
  simpa using primitive_independent .ruleAlpha3

theorem restricted_ruleBeta_independent :
    ∃ p : RestrictedPrimitive, Derivable restrictedSystem p ∧
      ¬ Derivable (erase restrictedSystem .ruleBeta) p := by
  simpa using primitive_independent .ruleBeta

end MathlibExpansion.Logic.HilbertAckermann.Restricted
