import MathlibExpansion.Logic.Godel.SystemP.RelationsAsClasses

/-!
# Typed substitution for Gödel 1931 system `P`

This file lands the meta-level capture-aware substitution surface and exposes
`instantiateNumeral` / `universalClosure` on `Godel1931System` exactly as the
Step 5 verdict requires.
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

/-- Substitute a string for a variable index inside a string. -/
def substString (target : PVar) (replacement : PString) : PString → PString
  | .var v => if v.idx = target.idx then replacement else .var v
  | .zero => .zero
  | .succ t => .succ (substString target replacement t)
  | .pair a b => .pair (substString target replacement a) (substString target replacement b)
  | .typeRaise k t => .typeRaise k (substString target replacement t)

/-- Capture-aware substitution on formulas. -/
def substFormula (target : PVar) (replacement : PString) : PFormula → PFormula
  | .atom a b => .atom (substString target replacement a) (substString target replacement b)
  | .neg φ => .neg (substFormula target replacement φ)
  | .or φ ψ => .or (substFormula target replacement φ) (substFormula target replacement ψ)
  | .all v φ =>
      if v.idx = target.idx then
        .all v φ
      else
        .all v (substFormula target replacement φ)

/-- Public meta-level substitution wrapper used in the Step 3 signatures. -/
def substFree (a : PFormula) (v : PVar) (b : PString) : PFormula :=
  substFormula v b a

/-- Close a class-string universally over its distinguished first-type variable. -/
def universalClosureCore (a : ClassSign) : PFormula :=
  .all (PVar.base a.freeVar) a.matrix

/-- Instantiate a class-string at the numeral `n`. -/
def instantiateNumeralCore (a : ClassSign) (n : ℕ) : PFormula :=
  substFormula (PVar.base a.freeVar) (SystemP.numeral n) a.matrix

namespace Godel1931System

/-- Exported numeral instantiation required by the Step 5 contract. -/
def instantiateNumeral (P : Godel1931System) (a : P.ClassSign) (n : ℕ) : PFormula :=
  instantiateNumeralCore a n

/-- Exported universal closure required by the Step 5 contract. -/
def universalClosure (P : Godel1931System) (a : P.ClassSign) : PFormula :=
  universalClosureCore a

end Godel1931System

end MathlibExpansion.Logic.Godel
