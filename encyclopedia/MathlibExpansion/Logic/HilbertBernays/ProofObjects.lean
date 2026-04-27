import MathlibExpansion.Logic.HilbertBernays.Basic

/-!
# Explicit proof objects

This module packages finite proof data and a decidable line-by-line checker.
The proof relation is object-language data, not Lean kernel theoremhood.
-/

namespace MathlibExpansion.Logic.HilbertBernays

/-- Explicit justifications for a proof line. -/
inductive ProofJustification where
  | hypothesis
  | axiom
  | modusPonens (antecedent implication : Nat)
  | generalize (line : Nat) (var : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- A single line in a finite proof object. -/
structure ProofLine where
  conclusion : HBFormula
  justification : ProofJustification
  deriving DecidableEq, Repr, Inhabited

/-- A finite proof object with explicit assumptions and proof lines. -/
structure ProofObject where
  assumptions : List HBFormula
  lines : List ProofLine
  deriving DecidableEq, Repr, Inhabited

namespace ProofJustification

/-- Structural code for justifications. -/
def code : ProofJustification → Nat
  | .hypothesis => Nat.pair 0 0
  | .axiom => Nat.pair 1 0
  | .modusPonens i j => Nat.pair 2 (Nat.pair i j)
  | .generalize i x => Nat.pair 3 (Nat.pair i x)

end ProofJustification

namespace ProofLine

/-- Structural code for proof lines. -/
def code (line : ProofLine) : Nat :=
  Nat.pair line.conclusion.code line.justification.code

end ProofLine

namespace ProofObject

private def codeList : List Nat → Nat
  | [] => 0
  | x :: xs => Nat.succ (Nat.pair x (codeList xs))

/-- The coded proof sequence associated to a proof object. -/
def codedLines (p : ProofObject) : List Nat := p.lines.map ProofLine.code

/-- A structural code for the full proof object. -/
def code (p : ProofObject) : Nat :=
  Nat.pair (codeList (p.assumptions.map HBFormula.code)) (codeList p.codedLines)

/-- The last conclusion of a proof object, if any. -/
def lastConclusion (p : ProofObject) : Option HBFormula :=
  p.lines.getLast?.map fun line => line.conclusion

/-- Check one proof line against the previously validated conclusions. -/
def lineValid (axioms : HBAxiomSet) (assumptions validated : List HBFormula)
    (line : ProofLine) : Bool :=
  match line.justification with
  | .hypothesis => assumptions.contains line.conclusion
  | .axiom => axioms line.conclusion
  | .modusPonens i j =>
      match validated.get? i, validated.get? j with
      | some φ, some (.imp φ' ψ) => (decide (φ = φ')) && decide (ψ = line.conclusion)
      | _, _ => false
  | .generalize i x =>
      match validated.get? i with
      | some φ => decide (line.conclusion = .forallE x φ)
      | none => false

/-- A decidable line-by-line proof checker. -/
def checkLines (axioms : HBAxiomSet) (assumptions validated : List HBFormula) :
    List ProofLine → Bool
  | [] => true
  | line :: rest =>
      if lineValid axioms assumptions validated line then
        checkLines axioms assumptions (validated.concat line.conclusion) rest
      else
        false

/-- The boolean proof checker for a full proof object. -/
def check (axioms : HBAxiomSet) (p : ProofObject) : Bool :=
  checkLines axioms p.assumptions [] p.lines

/-- A one-line proof certifying an axiom. -/
def singletonAxiom (φ : HBFormula) : ProofObject where
  assumptions := []
  lines := [{ conclusion := φ, justification := .axiom }]

/-- A one-line proof certifying an explicit assumption. -/
def singletonHypothesis (Γ : List HBFormula) (φ : HBFormula) : ProofObject where
  assumptions := Γ
  lines := [{ conclusion := φ, justification := .hypothesis }]

@[simp] theorem check_singletonAxiom {axioms : HBAxiomSet} {φ : HBFormula}
    (hφ : axioms φ = true) :
    (singletonAxiom φ).check axioms = true := by
  simp [check, checkLines, lineValid, singletonAxiom, hφ]

@[simp] theorem check_singletonHypothesis {Γ : List HBFormula} {φ : HBFormula}
    (hφ : φ ∈ Γ) :
    (singletonHypothesis Γ φ).check (fun _ => false) = true := by
  simp [check, checkLines, lineValid, singletonHypothesis, hφ]

end ProofObject

end MathlibExpansion.Logic.HilbertBernays
