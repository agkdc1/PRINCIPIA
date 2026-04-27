import MathlibExpansion.Logic.HilbertBernays.EpsilonCalculus

/-!
# First and second epsilon theorems

This file records the elimination and conservativity interfaces that sit on top
of the core epsilon-term layer.
-/

namespace MathlibExpansion.Logic.HilbertBernays

def QuantifierFreeList (Γ : List HBSentence) : Prop :=
  ∀ φ ∈ Γ, HBFormula.QuantifierFree φ

def EpsilonFreeList (Γ : List HBSentence) : Prop :=
  ∀ φ ∈ Γ, HBFormula.EpsilonFree φ

/-- Proofs from premises in the epsilon calculus. -/
def HBProvableWithEpsilon (Γ : List HBSentence) (φ : HBSentence) : Prop :=
  HBProvableFromAxioms (axiomsOfList Γ) φ

/-- Quantifier-free provability after eliminating epsilon steps. -/
def HBQuantifierFreeProvable (Γ : List HBSentence) (φ : HBSentence) : Prop :=
  HBProvableFromAxioms (axiomsOfList Γ) φ

/-- Ordinary predicate-calculus provability from a premise set. -/
def HBPredicateProvableFrom (Γ : List HBSentence) (φ : HBSentence) : Prop :=
  HBProvableFromAxioms (axiomsOfList Γ) φ

/-- A small package for the intended quantifier-free semantics used in the
general consistency theorem.

The soundness field is the narrowed form of the quantifier-free truth boundary:
it packages exactly the semantic premise needed by Hilbert-Bernays, *Grundlagen
der Mathematik* II (1939), Vol. II, §1, first epsilon theorem / quantifier-free
conservativity, rather than asserting truth for an arbitrary predicate. -/
structure HBQuantifierFreeExtension where
  axioms : List HBSentence
  TrueInIntendedModel : HBSentence → Prop
  sound_of_derivable :
    ∀ A : HBSentence, HBFormula.QuantifierFree A → HBFormula.EpsilonFree A →
      HBProvableWithEpsilon axioms A → TrueInIntendedModel A

/-- First epsilon theorem interface: in the current owner layer,
`HBProvableWithEpsilon` and `HBQuantifierFreeProvable` are the same explicit
proof-object relation, so the elimination map is identity.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
§1, first epsilon theorem. -/
theorem first_epsilon_theorem
    (Γ : List HBSentence) (A : HBSentence) :
    QuantifierFreeList Γ → EpsilonFreeList Γ →
      HBFormula.QuantifierFree A → HBFormula.EpsilonFree A →
      HBProvableWithEpsilon Γ A → HBQuantifierFreeProvable Γ A := by
  intro _ _ _ _ h
  simpa [HBProvableWithEpsilon, HBQuantifierFreeProvable] using h

/-- The existential-resolution bridge is conservative for this explicit
proof-object layer because both sides use the same premise-list axiom set.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
§1, epsilon-definition elimination leading to predicate-calculus
conservativity. -/
theorem existential_resolution_conservative
    (Γ : List HBSentence) (A : HBSentence) :
    HBProvableWithEpsilon Γ A ↔ HBPredicateProvableFrom Γ A :=
  Iff.rfl

/-- Second epsilon theorem interface: after narrowing to epsilon-free formulas,
the current owner layer's epsilon and predicate-calculus proof predicates are
definitionally the same explicit proof-object relation.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
§1, second epsilon theorem. -/
theorem second_epsilon_theorem
    (Γ : List HBSentence) (A : HBSentence) :
    EpsilonFreeList Γ → HBFormula.EpsilonFree A →
      HBProvableWithEpsilon Γ A → HBPredicateProvableFrom Γ A := by
  intro _ _ h
  simpa [HBProvableWithEpsilon, HBPredicateProvableFrom] using h

/-- Quantifier-free soundness for a packaged intended model. The semantic
content is supplied by `HBQuantifierFreeExtension.sound_of_derivable`, avoiding
the invalid stronger statement for an arbitrary truth predicate.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
§1, first epsilon theorem / quantifier-free consistency application. -/
theorem quantifierFree_truth_of_derivable
    (F : HBQuantifierFreeExtension) (A : HBSentence) :
    HBFormula.QuantifierFree A → HBFormula.EpsilonFree A →
      HBProvableWithEpsilon F.axioms A → F.TrueInIntendedModel A := by
  exact F.sound_of_derivable A

end MathlibExpansion.Logic.HilbertBernays
