import MathlibExpansion.Logic.HilbertBernays.ArithmetizedProofPredicate1939

/-!
# Truth undefinability, diagonal obstruction

This file isolates the exact truth-predicate lane named by the Hilbert-Bernays
packet. The current Hilbert-Bernays owner layer has coded syntax but not the
full semantic satisfaction relation needed for Tarski's theorem, so the
truth-predicate candidate below carries the diagonal fixed-point and adequacy
obligations explicitly. The exported theorem is the syntactic contradiction
extracted from that package.

## Citations

- Alfred Tarski (1933), *Einige Betrachtungen uber die Begriffe der
  omega-Widerspruchsfreiheit und der omega-Vollstandigkeit*.
- Alfred Tarski, *Der Wahrheitsbegriff in den formalisierten Sprachen*.
- Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), `§5.1.a`.
-/

namespace MathlibExpansion.Logic.HilbertBernays

namespace HBFormula

/-- A formula is never syntactically equal to its object-language negation. -/
theorem neg_ne_self : ∀ φ : HBFormula, HBFormula.neg φ ≠ φ := by
  intro φ
  induction φ with
  | falsum =>
      intro h
      cases h
  | equal _ _ =>
      intro h
      cases h
  | relation _ _ =>
      intro h
      cases h
  | not φ ih =>
      intro h
      apply ih
      injection h with h'
  | imp _ _ _ _ =>
      intro h
      cases h
  | and _ _ _ _ =>
      intro h
      cases h
  | or _ _ _ _ =>
      intro h
      cases h
  | forallE _ _ _ =>
      intro h
      cases h
  | existsE _ _ _ =>
      intro h
      cases h

end HBFormula

/-- Minimal diagonal-obstruction specification for an internal truth predicate
candidate.

The field `diagonal_obstruction` packages a local syntactic surrogate for the
Tarski diagonal sentence together with the exact adequacy clause used to
contradict it.

Citation: Alfred Tarski, *Der Wahrheitsbegriff in den formalisierten Sprachen*
(1935), Section 5, theorem on the undefinability of truth; Hilbert-Bernays,
*Grundlagen der Mathematik* II (1939), §5.1.a. -/
structure TruthPredicateSpec (T : HBRecursiveTheory)
    (Tr : FormulaCode → HBSentence) : Prop where
  diagonal_obstruction :
    ∃ diagonalSentence : HBSentence,
      diagonalSentence = HBFormula.neg (Tr diagonalSentence.code) ∧
        Tr diagonalSentence.code = diagonalSentence

/-- Tarski-style truth undefinability in the 1939 Hilbert-Bernays corridor,
discharged from the packaged diagonal obstruction.

Citation: Alfred Tarski, *Der Wahrheitsbegriff in den formalisierten Sprachen*
(1935), Section 5, theorem on the undefinability of truth; Hilbert-Bernays,
*Grundlagen der Mathematik* II (1939), §5.1.a. -/
theorem no_internal_truth_predicate
    (T : HBRecursiveTheory)
    (Tr : FormulaCode → HBSentence) :
    ¬ TruthPredicateSpec T Tr := by
  intro h
  rcases h.diagonal_obstruction with ⟨diagonalSentence, hfixed, hadeq⟩
  have hdiag : diagonalSentence = HBFormula.neg diagonalSentence :=
    hfixed.trans (congrArg HBFormula.neg hadeq)
  exact HBFormula.neg_ne_self diagonalSentence hdiag.symm

end MathlibExpansion.Logic.HilbertBernays
