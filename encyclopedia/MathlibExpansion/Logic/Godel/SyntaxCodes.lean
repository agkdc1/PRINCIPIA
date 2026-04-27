import Mathlib.Computability.Primrec
import Mathlib.Logic.Encodable.Basic
import MathlibExpansion.Logic.Godel.SystemP

/-!
# Gödel-number carriers for the 1931 queue

This file names the natural-number code layer used by the later Gödel files.
It intentionally keeps the public API concrete and lightweight.
-/

namespace MathlibExpansion.Logic.Godel

/-- Primitive signs used by the local Gödel-numbering facade. -/
inductive GodelPSymbol where
  | zero
  | succ
  | neg
  | disj
  | all
  | var (idx : ℕ)
  | lparen
  | rparen
  | comma
deriving DecidableEq, Repr

instance : Encodable GodelPSymbol where
  encode
    | .zero => Nat.pair 0 0
    | .succ => Nat.pair 1 0
    | .neg => Nat.pair 2 0
    | .disj => Nat.pair 3 0
    | .all => Nat.pair 4 0
    | .var idx => Nat.pair 5 idx
    | .lparen => Nat.pair 6 0
    | .rparen => Nat.pair 7 0
    | .comma => Nat.pair 8 0
  decode n :=
    match n.unpair with
    | (0, _) => some .zero
    | (1, _) => some .succ
    | (2, _) => some .neg
    | (3, _) => some .disj
    | (4, _) => some .all
    | (5, idx) => some (.var idx)
    | (6, _) => some .lparen
    | (7, _) => some .rparen
    | (8, _) => some .comma
    | _ => none
  encodek := by
    intro s
    cases s <;> simp [Nat.unpair_pair]

/-- Public string-code map for lists of primitive signs. -/
def godelEncode : List GodelPSymbol → ℕ := Encodable.encode

theorem godelEncode_injective : Function.Injective godelEncode :=
  fun _ _ h => Encodable.encode_injective h

/-- Formula codes are natural numbers. -/
abbrev FormulaCode := ℕ

/-- Gödel's extra axiom classes are represented as sets of formula codes. -/
abbrev AxiomSetCode := Set FormulaCode

/-- Primitive-recursive ternary function predicate, used by the code layer. -/
abbrev Primrec3 (f : ℕ → ℕ → ℕ → ℕ) : Prop :=
  Nat.Primrec' fun v : List.Vector ℕ 3 =>
    f (v.get ⟨0, by decide⟩) (v.get ⟨1, by decide⟩) (v.get ⟨2, by decide⟩)

/-- Primitive-recursive binary function predicate, used by the code layer. -/
abbrev Primrec2Nat (f : ℕ → ℕ → ℕ) : Prop := Primrec₂ f

/-- The public numeral-code facade. -/
def numeralCode (n : ℕ) : FormulaCode := n

/-- Gödel's `Gen` code constructor. -/
def genCode (v q : FormulaCode) : FormulaCode := Nat.pair (v + 1) q

/-- Public negation-code constructor. -/
def negCode (q : FormulaCode) : FormulaCode := Nat.pair 0 q

/-- Public substitution-code constructor. -/
def substCode (q v t : FormulaCode) : FormulaCode := Nat.pair q (Nat.pair v t)

/-- Public two-variable substitution-code constructor. -/
def substCode₂ (q v₁ t₁ v₂ t₂ : FormulaCode) : FormulaCode :=
  substCode (substCode q v₁ t₁) v₂ t₂

/-- Public type-raising code constructor. -/
def typeRaiseCode (k q : FormulaCode) : FormulaCode := Nat.pair k q

end MathlibExpansion.Logic.Godel
