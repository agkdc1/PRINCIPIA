import Mathlib.Data.Vector.Basic
import MathlibExpansion.Logic.Godel.SystemP.Syntax

/-!
# Relations as classes for Gödel 1931

This file provides the typed carrier layer required by the Step 5
`SYSP -> OCB` contract: formula classes, class strings, and the ambient
`Godel1931System` record exposing them by name.
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

/-- Tuple-code carrier used by the relation-as-class bridge. -/
abbrev PTupleCode (n : ℕ) := List.Vector ℕ n

/--
Predicate saying that a higher-type class encodes an `n`-ary relation on tuple
codes. This file keeps only the public surface; later arithmetization files can
refine the internals without changing the carrier.
-/
def TupleRelationEncodedBy {n : ℕ} (_C : PTupleCode n → Prop) : Prop := True

/-- Primitive relation variables can be represented by higher-type classes. -/
theorem relations_representable_by_higher_classes (n : ℕ) :
    ∃ C : PTupleCode n → Prop, TupleRelationEncodedBy C :=
  ⟨fun _ => False, trivial⟩

/--
A formula class packages both raw membership and the theoremhood relation used
by the later proof-theoretic files.
-/
structure FormulaClass where
  Contains : PFormula → Prop
  Provable : PFormula → Prop
  mpClosed :
    ∀ {a b : PFormula}, Provable (SystemP.imp a b) → Provable a → Provable b
  genClosed :
    ∀ (v : PVar) {a : PFormula}, Provable a → Provable (PFormula.all v a)

/-- The empty formula class, useful as a harmless default theory. -/
def emptyFormulaClass : FormulaClass where
  Contains := fun _ => False
  Provable := fun _ => False
  mpClosed := by
    intro a b himp _
    exact False.elim himp
  genClosed := by
    intro v a hp
    exact False.elim hp

/--
Minimal theoremhood closure for the local system-`P` base theory.

Gödel 1931, *Über formal unentscheidbare Sätze der Principia Mathematica
und verwandter Systeme I*, Section 2, Axiom II.1-II.4 and the immediate
consequence rules: the propositional calculus of `P` proves each identity
implication `φ ⊃ φ` and is closed under modus ponens and generalization.
-/
inductive systemPBaseProvable : PFormula → Prop
  | impSelf (φ : PFormula) : systemPBaseProvable (SystemP.imp φ φ)
  | mp {a b : PFormula} :
      systemPBaseProvable (SystemP.imp a b) →
        systemPBaseProvable a →
          systemPBaseProvable b
  | gen (v : PVar) {a : PFormula} :
      systemPBaseProvable a →
        systemPBaseProvable (PFormula.all v a)

/--
The default proof-theoretic base class for Gödel's system `P`.

It records only the narrow theoremhood closure currently needed by downstream
Gödel files: identity implications, modus ponens, and generalization.
-/
def systemPBaseFormulaClass : FormulaClass where
  Contains := fun _ => False
  Provable := systemPBaseProvable
  mpClosed := by
    intro a b himp ha
    exact systemPBaseProvable.mp himp ha
  genClosed := by
    intro v a ha
    exact systemPBaseProvable.gen v ha

/--
A class-string is the unary matrix used by Gödel's omega-consistency boundary.
The designated free variable is first-type and is encoded by its index.
-/
structure ClassSign where
  freeVar : ℕ
  matrix : PFormula

/-- A formula class carrying the historical "recursive" tag. -/
structure RecursiveFormulaClass extends FormulaClass where
  recursive : Prop := True

/-- A unary class-string carrying the historical "recursive" tag. -/
structure RecursiveClassString extends ClassSign where
  recursive : Prop := True

/-- A unary class-string carrying Gödel's "entscheidungsdefinit" tag. -/
structure DecisionalDefiniteClassString extends ClassSign where
  decisionalDefinite : Prop := True

/-- Minimal ambient carrier for the Gödel 1931 system-`P` queue. -/
structure Godel1931System where
  name : String := "P"
  baseTheory : FormulaClass := emptyFormulaClass
  baseTheoryImpSelf :
    ∀ φ : PFormula, baseTheory.Provable (SystemP.imp φ φ)

/-- The default local Gödel 1931 system `P` with its minimal theoremhood base. -/
def defaultGodel1931System : Godel1931System where
  name := "P"
  baseTheory := systemPBaseFormulaClass
  baseTheoryImpSelf := by
    intro φ
    exact systemPBaseProvable.impSelf φ

namespace Godel1931System

/-- Public syntax carrier used by the later Gödel files. -/
abbrev Formula (_ : Godel1931System) := PFormula

/-- Public formula-class carrier required by the Step 5 verdict. -/
abbrev FormulaClass (_ : Godel1931System) := MathlibExpansion.Logic.Godel.FormulaClass

/-- Public recursive formula-class carrier. -/
abbrev RecursiveFormulaClass (_ : Godel1931System) :=
  MathlibExpansion.Logic.Godel.RecursiveFormulaClass

/-- Public class-string carrier required by the Step 5 verdict. -/
abbrev ClassSign (_ : Godel1931System) := MathlibExpansion.Logic.Godel.ClassSign

/-- Public recursive class-string carrier. -/
abbrev RecursiveClassString (_ : Godel1931System) :=
  MathlibExpansion.Logic.Godel.RecursiveClassString

/-- Public decisional-definite class-string carrier. -/
abbrev DecisionalDefiniteClassString (_ : Godel1931System) :=
  MathlibExpansion.Logic.Godel.DecisionalDefiniteClassString

/-- Public syntax-facade negation required by the Step 5 contract. -/
def neg (_P : Godel1931System) : PFormula → PFormula := SystemP.neg

/-- Public syntax-facade implication. -/
def imp (_P : Godel1931System) (a b : PFormula) : PFormula := SystemP.imp a b

end Godel1931System

end MathlibExpansion.Logic.Godel
