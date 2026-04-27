import Mathlib.Data.Finset.Basic
import Mathlib.Data.Nat.Basic

/-!
# Gödel 1931 system `P` syntax

This file lands the typed object-language carrier used by the Gödel 1931
queue. The syntax is intentionally lightweight: it records the simple-type
discipline, first-type numerals, application atoms, negation, disjunction,
and universal generalization.
-/

namespace MathlibExpansion.Logic.Godel.SystemP

/-- Gödel's simple types, generated from the base number type. -/
inductive PType where
  | base : PType
  | succ : PType → PType
deriving DecidableEq, Repr

/-- Uniformly raise a type by `k` successor steps. -/
def PType.raise : ℕ → PType → PType
  | 0, τ => τ
  | k + 1, τ => PType.raise k (PType.succ τ)

/-- A typed variable of system `P`. -/
structure PVar where
  pType : PType
  idx : ℕ
deriving DecidableEq, Repr

/-- The first-type variable with de Bruijn-style index `idx`. -/
def PVar.base (idx : ℕ) : PVar :=
  { pType := .base, idx := idx }

/-- Uniform type-raising on variables. -/
def PVar.raise (k : ℕ) (v : PVar) : PVar :=
  { pType := v.pType.raise k, idx := v.idx }

/--
Typed strings of system `P`.

The carrier is intentionally syntactic: variables are tagged by type, first-type
strings admit `0` and successor, and tuple / type-raise helpers are kept explicit
because later arithmetization files consume them by name.
-/
inductive PString where
  | var : PVar → PString
  | zero : PString
  | succ : PString → PString
  | pair : PString → PString → PString
  | typeRaise : ℕ → PString → PString
deriving DecidableEq, Repr

/-- The numeral corresponding to `n`. -/
def numeral : ℕ → PString
  | 0 => .zero
  | n + 1 => .succ (numeral n)

/-- The finite set of variable indices appearing in a string. -/
def PString.varIndices : PString → Finset ℕ
  | .var v => {v.idx}
  | .zero => ∅
  | .succ t => t.varIndices
  | .pair a b => a.varIndices ∪ b.varIndices
  | .typeRaise _ t => t.varIndices

/-- Uniform type-raising on strings. -/
def PString.raise (k : ℕ) : PString → PString
  | .var v => .var (v.raise k)
  | .zero => .zero
  | .succ t => .succ (t.raise k)
  | .pair a b => .pair (a.raise k) (b.raise k)
  | .typeRaise j t => .typeRaise (j + k) (t.raise k)

/--
Formulas of system `P`.

Gödel's elementary formulas are recorded as applications `a(b)`; the object
language is then freely closed under negation, disjunction, and generalization.
-/
inductive PFormula where
  | atom : PString → PString → PFormula
  | neg : PFormula → PFormula
  | or : PFormula → PFormula → PFormula
  | all : PVar → PFormula → PFormula
deriving DecidableEq, Repr

/-- Sentences are formulas; later files track free-variable discipline separately. -/
abbrev Sentence := PFormula

/-- Public syntax-facade negation. -/
def neg : PFormula → PFormula := PFormula.neg

/-- Public syntax-facade disjunction. -/
def disj : PFormula → PFormula → PFormula := PFormula.or

/-- Implication is represented via `¬a ∨ b`, matching Gödel's Chapter 2 surface. -/
def imp (a b : PFormula) : PFormula := PFormula.or (PFormula.neg a) b

/-- Uniform type-raising on formulas. -/
def PFormula.typeLift (k : ℕ) : PFormula → PFormula
  | .atom a b => .atom (a.raise k) (b.raise k)
  | .neg φ => .neg (φ.typeLift k)
  | .or φ ψ => .or (φ.typeLift k) (ψ.typeLift k)
  | .all v φ => .all (v.raise k) (φ.typeLift k)

/-- The finite set of free variable indices of a formula. -/
def PFormula.freeVarIndices : PFormula → Finset ℕ
  | .atom a b => a.varIndices ∪ b.varIndices
  | .neg φ => φ.freeVarIndices
  | .or φ ψ => φ.freeVarIndices ∪ ψ.freeVarIndices
  | .all v φ => φ.freeVarIndices.erase v.idx

end MathlibExpansion.Logic.Godel.SystemP
