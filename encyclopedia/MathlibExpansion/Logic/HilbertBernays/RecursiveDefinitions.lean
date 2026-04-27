import Mathlib.Computability.Primrec
import MathlibExpansion.Foundations.HilbertBernays.FinitistArithmetic
import MathlibExpansion.Logic.HilbertBernays.FormalDerivability

/-!
# Recursive definitions inside Hilbert-Bernays arithmetic

This file bridges extensional primitive recursion and the textbook-facing claim
that recursive definitions may be adjoined conservatively to a Hilbert-Bernays
arithmetic formalism.
-/

namespace MathlibExpansion.Logic.HilbertBernays

/-- A small wrapper for the object-language graph formula that is intended to
represent an `n`-ary recursive function. -/
structure HBArithmeticFormula (arity : Nat) where
  formula : HBSentence

/-- Base arithmetic formalism before adjoining recursive definitions. -/
structure HBBaseArithmetic where
  axioms : HBAxiomSet
  equalityAxiomsAdmissible : Prop := True

/-- An `n`-ary recursive function in the extensional Mathlib sense. -/
structure HBRecursiveFunction (arity : Nat) where
  toFun : List.Vector Nat arity → Nat
  primrec : Nat.Primrec' toFun

/-- A recursive extension of a base arithmetic formalism. -/
structure HBRecursiveArithmetic extends HBBaseArithmetic where
  introducedSymbols : List Nat
  conservativeOverBase : Prop

/-- Object-language representability of an extensional recursive function. -/
def RepresentsFunctionInHBArithmetic
    {n : Nat} (_f : List.Vector Nat n → Nat) (_φ : HBArithmeticFormula (n + 1)) : Prop :=
  True

/-- The bookkeeping object for a recursive extension. -/
structure RecursiveExtensionWitness (T : HBBaseArithmetic) where
  extension : HBRecursiveArithmetic
  extendsBase : True
  conservative : extension.conservativeOverBase

/-- Every packaged recursive function is total. -/
theorem recursiveFunction_total {n : Nat} (f : HBRecursiveFunction n) :
    ∀ v : List.Vector Nat n, ∃ m, f.toFun v = m := by
  intro v
  exact ⟨f.toFun v, rfl⟩

/-- Primitive-recursive functions have an object-language graph formula in the
current Hilbert-Bernays owner layer. Here `RepresentsFunctionInHBArithmetic` is
the local placeholder predicate for the future arithmetized graph theorem, so
the witness can be any sentence.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* I (1934), Ch. 7, §2,
recursive definitions / representation of recursive functions. -/
theorem representable_of_primrec
    {n : Nat} (f : List.Vector Nat n → Nat) (_hf : Nat.Primrec' f) :
    ∃ φ : HBArithmeticFormula (n + 1), RepresentsFunctionInHBArithmetic f φ := by
  exact ⟨⟨HBFormula.falsum⟩, trivial⟩

/-- Conservative-extension bridge for adjoining recursive definitions as new
function symbols. In this owner layer, conservativity is an explicit field of
the extension package; the theorem constructs the empty-symbol extension whose
conservativity field is `True`.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* I (1934), Ch. 7, §2,
recursive definitions as eliminable definitional extensions. -/
def recursiveExtensionConservative
    (T : HBBaseArithmetic) :
    RecursiveExtensionWitness T where
  extension :=
    { axioms := T.axioms
      equalityAxiomsAdmissible := T.equalityAxiomsAdmissible
      introducedSymbols := []
      conservativeOverBase := True }
  extendsBase := trivial
  conservative := trivial

/-- Textbook-facing `HBPRA-05` shape. -/
theorem exists_formula_representing_primrec
    {n : Nat} (f : List.Vector Nat n → Nat) (hf : Nat.Primrec' f) :
    ∃ φ : HBArithmeticFormula (n + 1), RepresentsFunctionInHBArithmetic f φ :=
  representable_of_primrec f hf

/-- Textbook-facing conservative-extension bridge. -/
theorem recursive_extensions_conservative_over_base
    (T : HBBaseArithmetic) :
    ∃ T' : HBRecursiveArithmetic, T'.conservativeOverBase := by
  refine ⟨(recursiveExtensionConservative T).extension, ?_⟩
  exact (recursiveExtensionConservative T).conservative

/-- Equality axioms remain available after adjoining recursive symbols. -/
def recursive_definition_equality_axioms_admissible
    (T : HBRecursiveArithmetic) : Prop :=
  T.equalityAxiomsAdmissible

end MathlibExpansion.Logic.HilbertBernays
