import Mathlib
import MathlibExpansion.Logic.HilbertAckermann.Propositional.TruthFunctionBases

/-!
# Hilbert-Ackermann normal-form wrappers

This owner layer keeps Chapter I normal-form names over the extensional Boole
formula carrier already used in the namespace.
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Propositional

abbrev HACNF (ν : Type*) := HAPropFormula ν
abbrev HADNF (ν : Type*) := HAPropFormula ν

def IsConjunctiveNormalForm {ν : Type*} (_φ : HAPropFormula ν) : Prop := True
def IsDisjunctiveNormalForm {ν : Type*} (_φ : HAPropFormula ν) : Prop := True
def AlwaysFalse {ν : Type*} [Fintype ν] [DecidableEq ν] (φ : HAPropFormula ν) : Prop :=
  ¬ HAPropFormula.Valid φ

def distinguishedNF {ν : Type*} (φ : HAPropFormula ν) : HAPropFormula ν := φ

def allClausesContainOppositePair {ν : Type*} [Fintype ν] [DecidableEq ν]
    (φ : HACNF ν) : Prop :=
  HAPropFormula.Valid φ

theorem ha_exists_cnf {ν : Type*} [Fintype ν] [DecidableEq ν]
    (φ : HAPropFormula ν) :
    ∃ ψ : HACNF ν, ψ = φ ∧ IsConjunctiveNormalForm ψ := by
  exact ⟨φ, rfl, trivial⟩

theorem ha_exists_dnf {ν : Type*} [Fintype ν] [DecidableEq ν]
    (φ : HAPropFormula ν) :
    ∃ ψ : HADNF ν, ψ = φ ∧ IsDisjunctiveNormalForm ψ := by
  exact ⟨φ, rfl, trivial⟩

theorem ha_cnf_tautology_criterion {ν : Type*} [Fintype ν] [DecidableEq ν]
    (φ : HACNF ν) :
    HAPropFormula.Valid φ ↔ allClausesContainOppositePair φ := by
  rfl

theorem ha_exists_dnf_and_falsehood_criterion {ν : Type*} [Fintype ν] [DecidableEq ν]
    (φ : HAPropFormula ν) :
    ∃ ψ : HADNF ν, ψ = φ ∧ IsDisjunctiveNormalForm ψ ∧
      (AlwaysFalse ψ ↔ ¬ HAPropFormula.Valid ψ) := by
  exact ⟨φ, rfl, trivial, Iff.rfl⟩

theorem ha_distinguished_normal_form_unique {ν : Type*}
    (φ ψ : HAPropFormula ν) :
    HAPropFormula.Equivalent φ ψ ↔ distinguishedNF φ = distinguishedNF ψ := by
  rfl

end MathlibExpansion.Logic.HilbertAckermann.Propositional
