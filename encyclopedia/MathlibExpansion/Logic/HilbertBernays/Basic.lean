import Mathlib

/-!
# Hilbert-Bernays basic syntax

This file provides a small object-language syntax that the Hilbert-Bernays
Step 6 breach files can share without collapsing into Lean theoremhood or
semantic satisfiability.
-/

namespace MathlibExpansion.Logic.HilbertBernays

/-- Hilbert-Bernays terms, including an explicit epsilon-term constructor.

The epsilon constructor records the bound variable together with a code for the
matrix it came from; this keeps the shared syntax simple and avoids reusing
Lean-side choice operators as a surrogate for textbook epsilon terms.
-/
inductive HBTerm where
  | var : Nat → HBTerm
  | zero : HBTerm
  | succ : HBTerm → HBTerm
  | pair : HBTerm → HBTerm → HBTerm
  | epsilon : Nat → Nat → HBTerm
  deriving DecidableEq, Repr, Inhabited

/-- Hilbert-Bernays formulas in a small first-order presentation. -/
inductive HBFormula where
  | falsum : HBFormula
  | equal : HBTerm → HBTerm → HBFormula
  | relation : Nat → List HBTerm → HBFormula
  | not : HBFormula → HBFormula
  | imp : HBFormula → HBFormula → HBFormula
  | and : HBFormula → HBFormula → HBFormula
  | or : HBFormula → HBFormula → HBFormula
  | forallE : Nat → HBFormula → HBFormula
  | existsE : Nat → HBFormula → HBFormula
  deriving DecidableEq, Repr, Inhabited

/-- The textbook-facing sentence carrier exported downstream. -/
abbrev HBSentence := HBFormula

/-- A decidable object-language axiom set. -/
abbrev HBAxiomSet := HBFormula → Bool

namespace HBTerm

/-- Object-language numerals. -/
def numeral : Nat → HBTerm
  | 0 => .zero
  | n + 1 => .succ (numeral n)

private def codeList : List Nat → Nat
  | [] => 0
  | x :: xs => Nat.succ (Nat.pair x (codeList xs))

/-- Structural code for terms. -/
def code : HBTerm → Nat
  | .var n => Nat.pair 0 n
  | .zero => Nat.pair 1 0
  | .succ t => Nat.pair 2 (code t)
  | .pair t u => Nat.pair 3 (Nat.pair (code t) (code u))
  | .epsilon x bodyCode => Nat.pair 4 (Nat.pair x bodyCode)

/-- Capture-aware substitution on terms. -/
def substitute (x : Nat) (s : HBTerm) : HBTerm → HBTerm
  | .var y => if y = x then s else .var y
  | .zero => .zero
  | .succ t => .succ (substitute x s t)
  | .pair t u => .pair (substitute x s t) (substitute x s u)
  | .epsilon y bodyCode => .epsilon y bodyCode

/-- Whether a term contains an epsilon-subterm. -/
def hasEpsilon : HBTerm → Bool
  | .var _ => false
  | .zero => false
  | .succ t => hasEpsilon t
  | .pair t u => hasEpsilon t || hasEpsilon u
  | .epsilon _ _ => true

/-- Free variables of a term. -/
def freeVars : HBTerm → Finset Nat
  | .var x => {x}
  | .zero => ∅
  | .succ t => freeVars t
  | .pair t u => freeVars t ∪ freeVars u
  | .epsilon x _ => {x}

@[simp] theorem substitute_var_eq (x : Nat) (t : HBTerm) :
    HBTerm.substitute x t (.var x) = t := by
  simp [HBTerm.substitute]

@[simp] theorem numeral_zero : HBTerm.numeral 0 = .zero := rfl

@[simp] theorem numeral_succ (n : Nat) :
    HBTerm.numeral (n + 1) = .succ (HBTerm.numeral n) := rfl

end HBTerm

namespace HBFormula

/-- Structural code for formulas. -/
def code : HBFormula → Nat
  | .falsum => Nat.pair 0 0
  | .equal t u => Nat.pair 1 (Nat.pair t.code u.code)
  | .relation r ts =>
      Nat.pair 2 (Nat.pair r (ts.foldr (fun t acc => Nat.succ (Nat.pair t.code acc)) 0))
  | .not φ => Nat.pair 3 (code φ)
  | .imp φ ψ => Nat.pair 4 (Nat.pair (code φ) (code ψ))
  | .and φ ψ => Nat.pair 5 (Nat.pair (code φ) (code ψ))
  | .or φ ψ => Nat.pair 6 (Nat.pair (code φ) (code ψ))
  | .forallE x φ => Nat.pair 7 (Nat.pair x (code φ))
  | .existsE x φ => Nat.pair 8 (Nat.pair x (code φ))

/-- Capture-aware substitution on formulas. -/
def substitute (x : Nat) (s : HBTerm) : HBFormula → HBFormula
  | .falsum => .falsum
  | .equal t u => .equal (HBTerm.substitute x s t) (HBTerm.substitute x s u)
  | .relation r ts => .relation r (ts.map (HBTerm.substitute x s))
  | .not φ => .not (substitute x s φ)
  | .imp φ ψ => .imp (substitute x s φ) (substitute x s ψ)
  | .and φ ψ => .and (substitute x s φ) (substitute x s ψ)
  | .or φ ψ => .or (substitute x s φ) (substitute x s ψ)
  | .forallE y φ => if y = x then .forallE y φ else .forallE y (substitute x s φ)
  | .existsE y φ => if y = x then .existsE y φ else .existsE y (substitute x s φ)

/-- Free variables of a formula. -/
def freeVars : HBFormula → Finset Nat
  | .falsum => ∅
  | .equal t u => t.freeVars ∪ u.freeVars
  | .relation _ ts => ts.foldl (fun acc t => acc ∪ t.freeVars) ∅
  | .not φ => freeVars φ
  | .imp φ ψ => freeVars φ ∪ freeVars ψ
  | .and φ ψ => freeVars φ ∪ freeVars ψ
  | .or φ ψ => freeVars φ ∪ freeVars ψ
  | .forallE x φ => (freeVars φ).erase x
  | .existsE x φ => (freeVars φ).erase x

/-- A syntactic quantifier-free predicate. -/
def QuantifierFree : HBFormula → Prop
  | .falsum => True
  | .equal _ _ => True
  | .relation _ _ => True
  | .not φ => QuantifierFree φ
  | .imp φ ψ => QuantifierFree φ ∧ QuantifierFree ψ
  | .and φ ψ => QuantifierFree φ ∧ QuantifierFree ψ
  | .or φ ψ => QuantifierFree φ ∧ QuantifierFree ψ
  | .forallE _ _ => False
  | .existsE _ _ => False

/-- A syntactic epsilon-free predicate. -/
def EpsilonFree : HBFormula → Prop
  | .falsum => True
  | .equal t u => ¬ t.hasEpsilon ∧ ¬ u.hasEpsilon
  | .relation _ ts => ∀ t ∈ ts, ¬ t.hasEpsilon
  | .not φ => EpsilonFree φ
  | .imp φ ψ => EpsilonFree φ ∧ EpsilonFree ψ
  | .and φ ψ => EpsilonFree φ ∧ EpsilonFree ψ
  | .or φ ψ => EpsilonFree φ ∧ EpsilonFree ψ
  | .forallE _ φ => EpsilonFree φ
  | .existsE _ φ => EpsilonFree φ

/-- A syntactic monadicity predicate: every relation occurrence has arity at
most one. -/
def Monadic : HBFormula → Prop
  | .falsum => True
  | .equal _ _ => True
  | .relation _ ts => ts.length ≤ 1
  | .not φ => Monadic φ
  | .imp φ ψ => Monadic φ ∧ Monadic ψ
  | .and φ ψ => Monadic φ ∧ Monadic ψ
  | .or φ ψ => Monadic φ ∧ Monadic ψ
  | .forallE _ φ => Monadic φ
  | .existsE _ φ => Monadic φ

/-- The canonical contradiction witness exported downstream. -/
def zeroEqSuccZero : HBFormula := .equal .zero (.succ .zero)

/-- Object-language negation wrapper. -/
def neg (φ : HBFormula) : HBFormula := .not φ

/-- Instantiate a single free variable by a term. -/
def instantiate (x : Nat) (t : HBTerm) (φ : HBFormula) : HBFormula :=
  substitute x t φ

/-- Instantiate a single free variable by a numeral. -/
def instantiateNumeral (x n : Nat) (φ : HBFormula) : HBFormula :=
  instantiate x (HBTerm.numeral n) φ

@[simp] theorem freeVars_zeroEqSuccZero :
    HBFormula.freeVars zeroEqSuccZero = ∅ := by
  simp [zeroEqSuccZero, HBFormula.freeVars, HBTerm.freeVars]

end HBFormula

end MathlibExpansion.Logic.HilbertBernays
