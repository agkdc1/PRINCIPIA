import MathlibExpansion.Logic.HilbertBernays.SecondIncompleteness1939

/-!
# Formalizability barrier

Hilbert-Bernays isolate the obstruction showing that the older proof-theoretic
consistency route cannot be wholly formalized inside the full arithmetic
formalism itself.
-/

namespace MathlibExpansion.Logic.HilbertBernays

/-- A prior proof-theoretic consistency method, represented by the sentence
that would encode its correctness if it were internalized. -/
structure PriorProofTheoreticConsistencyMethod where
  certificate : HBSentence

/-- Internal formalizability of a prior consistency method inside `T`. -/
def FormalizableIn (T : HBRecursiveTheory)
    (M : PriorProofTheoreticConsistencyMethod) : Prop :=
  HBProvableFrom T M.certificate

/--
Upstream-narrow formalizability barrier for the old consistency methods.

Citation: Hilbert-Bernays, *Grundlagen der Mathematik* II (1939), Vol. II,
Section 5, second incompleteness analysis; instantiated here through the local
`consistency_unprovable` bridge for the Hilbert-Bernays consistency sentence.
-/
theorem not_all_prior_consistency_methods_formalizable_in_Z
    (T : HBRecursiveTheory) :
    Consistent T →
      ¬ ∀ M : PriorProofTheoreticConsistencyMethod, FormalizableIn T M := by
  intro hcons hall
  exact consistency_unprovable T hcons (hall ⟨HBConsistencySentence T⟩)

end MathlibExpansion.Logic.HilbertBernays
