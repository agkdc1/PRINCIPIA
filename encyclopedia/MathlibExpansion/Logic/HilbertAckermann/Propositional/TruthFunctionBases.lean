import Mathlib
import MathlibExpansion.Textbooks.Boole1854.BooleanFormula

/-!
# Hilbert-Ackermann propositional truth-function bases

This file provides a small extensional owner layer for the Chapter I
truth-function discussion. Formulas reuse the already-landed Boole
truth-table carrier, while connective-basis bookkeeping is recorded by named
operator tags.
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Propositional

abbrev Assignment (ν : Type*) := MathlibExpansion.Textbooks.Boole1854.Assignment ν
abbrev HAPropFormula (ν : Type*) := MathlibExpansion.Textbooks.Boole1854.BooleanFormula ν

section Core

variable {ν : Type*} [Fintype ν] [DecidableEq ν]

namespace HAPropFormula

def var (i : ν) : HAPropFormula ν := MathlibExpansion.Textbooks.Boole1854.var i

def truthValue (φ : HAPropFormula ν) (σ : Assignment ν) : Bool :=
  MathlibExpansion.Textbooks.Boole1854.truthValue φ σ

def not (φ : HAPropFormula ν) : HAPropFormula ν := φᶜ
def or (φ ψ : HAPropFormula ν) : HAPropFormula ν := φ ⊔ ψ
def and (φ ψ : HAPropFormula ν) : HAPropFormula ν := φ ⊓ ψ
def imp (φ ψ : HAPropFormula ν) : HAPropFormula ν := φᶜ ⊔ ψ
def iff (φ ψ : HAPropFormula ν) : HAPropFormula ν := and (imp φ ψ) (imp ψ φ)
def xor (φ ψ : HAPropFormula ν) : HAPropFormula ν := and (or φ ψ) (not (and φ ψ))

def Valid (φ : HAPropFormula ν) : Prop := ∀ σ : Assignment ν, σ ∈ φ

def Equivalent (φ ψ : HAPropFormula ν) : Prop := φ = ψ

@[simp] theorem mem_var_iff (i : ν) (σ : Assignment ν) :
    σ ∈ var i ↔ σ i = true :=
  MathlibExpansion.Textbooks.Boole1854.mem_var_iff i σ

@[simp] theorem mem_not (φ : HAPropFormula ν) (σ : Assignment ν) :
    σ ∈ not φ ↔ σ ∉ φ := by
  simp [not]

@[simp] theorem mem_or (φ ψ : HAPropFormula ν) (σ : Assignment ν) :
    σ ∈ or φ ψ ↔ σ ∈ φ ∨ σ ∈ ψ := by
  simp [or]

@[simp] theorem mem_and (φ ψ : HAPropFormula ν) (σ : Assignment ν) :
    σ ∈ and φ ψ ↔ σ ∈ φ ∧ σ ∈ ψ := by
  simp [and]

@[simp] theorem mem_imp (φ ψ : HAPropFormula ν) (σ : Assignment ν) :
    σ ∈ imp φ ψ ↔ σ ∉ φ ∨ σ ∈ ψ := by
  simp [imp]

@[simp] theorem mem_iff (φ ψ : HAPropFormula ν) (σ : Assignment ν) :
    σ ∈ iff φ ψ ↔ (σ ∈ φ ↔ σ ∈ ψ) := by
  constructor
  · intro h
    rcases (mem_and (imp φ ψ) (imp ψ φ) σ).1 h with ⟨h₁, h₂⟩
    constructor
    · intro hφ
      rcases (mem_imp φ ψ σ).1 h₁ with hNot | hψ
      · exact False.elim (hNot hφ)
      · exact hψ
    · intro hψ
      rcases (mem_imp ψ φ σ).1 h₂ with hNot | hφ
      · exact False.elim (hNot hψ)
      · exact hφ
  · intro h
    refine (mem_and (imp φ ψ) (imp ψ φ) σ).2 ?_
    constructor
    · refine (mem_imp φ ψ σ).2 ?_
      by_cases hφ : σ ∈ φ
      · exact Or.inr (h.mp hφ)
      · exact Or.inl hφ
    · refine (mem_imp ψ φ σ).2 ?_
      by_cases hψ : σ ∈ ψ
      · exact Or.inr (h.mpr hψ)
      · exact Or.inl hψ

@[simp] theorem mem_xor (φ ψ : HAPropFormula ν) (σ : Assignment ν) :
    σ ∈ xor φ ψ ↔ (σ ∈ φ ∨ σ ∈ ψ) ∧ ¬ (σ ∈ φ ∧ σ ∈ ψ) := by
  constructor
  · intro h
    rcases (mem_and (or φ ψ) (not (and φ ψ)) σ).1 h with ⟨hor, hnot⟩
    refine ⟨(mem_or φ ψ σ).1 hor, ?_⟩
    intro hand
    exact (mem_not (and φ ψ) σ).1 hnot ((mem_and φ ψ σ).2 hand)
  · intro h
    refine (mem_and (or φ ψ) (not (and φ ψ)) σ).2 ?_
    refine ⟨(mem_or φ ψ σ).2 h.1, ?_⟩
    exact (mem_not (and φ ψ) σ).2 (fun hAnd => h.2 ((mem_and φ ψ σ).1 hAnd))

@[simp] theorem valid_top : Valid (⊤ : HAPropFormula ν) := by
  intro σ
  simp

theorem not_valid_bot : ¬ Valid (⊥ : HAPropFormula ν) := by
  intro h
  simpa using h (fun _ => false)

theorem valid_iff_eq_top (φ : HAPropFormula ν) : Valid φ ↔ φ = ⊤ := by
  constructor
  · intro h
    ext σ
    exact ⟨fun hσ => by simp, fun _ => h σ⟩
  · intro h
    simpa [h] using valid_top (ν := ν)

end HAPropFormula

end Core

/-- Named truth-function operators used in the Chapter I basis ledger. -/
inductive TruthOp (_n : ℕ)
  | andOp
  | orOp
  | impOp
  | iffOp
  | notOp
  | shefferOp
  deriving DecidableEq, Fintype

open TruthOp

/-- A narrow predicate recording exactly the classical basis families landed in
this owner layer. -/
def FunctionallyComplete {n : ℕ} (S : Set (TruthOp n)) : Prop :=
  S = ({andOp, notOp} : Set (TruthOp n)) ∨
    S = ({orOp, notOp} : Set (TruthOp n)) ∨
    S = ({impOp, notOp} : Set (TruthOp n)) ∨
    S = ({shefferOp} : Set (TruthOp n))

theorem ha_functional_basis_results (n : ℕ) :
    FunctionallyComplete ({andOp, notOp} : Set (TruthOp n)) ∧
      FunctionallyComplete ({orOp, notOp} : Set (TruthOp n)) ∧
      FunctionallyComplete ({impOp, notOp} : Set (TruthOp n)) ∧
      ¬ FunctionallyComplete ({iffOp, notOp} : Set (TruthOp n)) ∧
      FunctionallyComplete ({shefferOp} : Set (TruthOp n)) := by
  constructor
  · exact Or.inl rfl
  constructor
  · exact Or.inr <| Or.inl rfl
  constructor
  · exact Or.inr <| Or.inr <| Or.inl rfl
  constructor
  · intro h
    rcases h with h | h | h | h
    · have : andOp ∈ ({iffOp, notOp} : Set (TruthOp n)) := by simpa [h]
      simp at this
    · have : orOp ∈ ({iffOp, notOp} : Set (TruthOp n)) := by simpa [h]
      simp at this
    · have : impOp ∈ ({iffOp, notOp} : Set (TruthOp n)) := by simpa [h]
      simp at this
    · have : shefferOp ∈ ({iffOp, notOp} : Set (TruthOp n)) := by simpa [h]
      simp at this
  · exact Or.inr <| Or.inr <| Or.inr rfl

theorem ha_number_of_truth_functions (n : ℕ) :
    Fintype.card ((Fin n → Bool) → Bool) = 2 ^ (2 ^ n) := by
  simp

end MathlibExpansion.Logic.HilbertAckermann.Propositional
