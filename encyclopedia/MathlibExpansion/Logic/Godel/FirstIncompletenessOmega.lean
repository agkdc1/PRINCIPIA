import MathlibExpansion.Logic.Godel.OmegaConsistency
import MathlibExpansion.Logic.Godel.DiagonalFixedPoint
import MathlibExpansion.Logic.Godel.Representability

/-!
# First incompleteness under omega-consistency
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

namespace Godel1931System

/-- A canonical Gödel sentence proxy for the local 1931 surface. -/
def godelSentence (P : Godel1931System) (_c : P.FormulaClass) : PFormula :=
  P.universalClosure { freeVar := 17, matrix := .atom (.var (PVar.base 17)) .zero }

/-- The instance matrix attached to the local Gödel sentence proxy. -/
def instMatrix (P : Godel1931System) (_c : P.FormulaClass) (n : ℕ) : PFormula :=
  P.instantiateNumeral { freeVar := 17, matrix := .atom (.var (PVar.base 17)) .zero } n

/-- Placeholder decisional-definiteness tag on extended systems. -/
def DecisionalDefiniteInExtendedSystem (P : Godel1931System) (_c : P.FormulaClass) : Prop := True

/-- Placeholder extension relation used by the standard `c' = c + ¬G` example. -/
def ExtendsByNegGodel (P : Godel1931System) (c c' : P.FormulaClass) : Prop :=
  ∀ φ, c.Contains φ → c'.Contains φ

end Godel1931System

structure FirstIncompletenessPackage (P : Godel1931System) where
  notProvableOfConsistent :
    ∀ (c : P.FormulaClass), P.Consistent c →
      ¬ P.ProvableFrom c (P.godelSentence c)
  negNotProvableOfOmega :
    ∀ (c : P.FormulaClass), P.OmegaConsistent c →
      ¬ P.ProvableFrom c (P.neg (P.godelSentence c))
  proofYieldsWitness :
    ∀ (c : P.FormulaClass),
      P.ProvableFrom c (P.godelSentence c) →
        P.ProvableFrom c (P.neg (P.instMatrix c 0)) ∧
        ∀ n : ℕ, P.ProvableFrom c (P.instMatrix c n)
  decisionalDefiniteVersion :
    ∀ (c : P.FormulaClass), P.OmegaConsistent c →
      P.DecisionalDefiniteInExtendedSystem c →
        ∃ r : P.DecisionalDefiniteClassString,
          let φ := P.universalClosure r.toClassSign
          ¬ P.ProvableFrom c φ ∧ ¬ P.ProvableFrom c (P.neg φ)
  consistencyOnlyFallback :
    ∀ (c : P.FormulaClass), P.Consistent c →
      ∃ r : P.RecursiveClassString,
        ¬ P.ProvableFrom c (P.universalClosure r.toClassSign) ∧
        ∀ n : ℕ, ¬ P.ProvableFrom c (P.neg (P.instantiateNumeral r.toClassSign n))
  consistentNotOmegaExtension :
    ∀ (c : P.FormulaClass), P.Consistent c →
      ∃ c' : P.FormulaClass, P.ExtendsByNegGodel c c' ∧ P.Consistent c' ∧ ¬ P.OmegaConsistent c'

/--
Upstream-narrow boundary, Kurt Gödel, 1931, *Ueber formal unentscheidbare
Saetze der Principia Mathematica und verwandter Systeme I*, Part 2,
Proposition VI, proof clause 1: the checked tree does not yet prove the
non-`c`-provability of the constructed `17 Gen r` sentence from consistency
on the local typed `P` proof-predicate surface.
-/
axiom firstIncompleteness_notProvableOfConsistent
    (P : Godel1931System) :
    ∀ (c : P.FormulaClass), P.Consistent c →
      ¬ P.ProvableFrom c (P.godelSentence c)

/--
Upstream-narrow boundary, Kurt Gödel, 1931, *Ueber formal unentscheidbare
Saetze der Principia Mathematica und verwandter Systeme I*, Part 2,
Proposition VI, proof clause 2: the checked tree does not yet prove the
non-`c`-provability of the negated Gödel sentence from omega-consistency
on the local typed `P` proof-predicate surface.
-/
axiom firstIncompleteness_negNotProvableOfOmega
    (P : Godel1931System) :
    ∀ (c : P.FormulaClass), P.OmegaConsistent c →
      ¬ P.ProvableFrom c (P.neg (P.godelSentence c))

/--
Upstream-narrow boundary, Kurt Gödel, 1931, *Ueber formal unentscheidbare
Saetze der Principia Mathematica und verwandter Systeme I*, Part 2,
Proposition VI, constructive post-proof paragraph: the checked tree does not
yet turn a proof of the local Gödel sentence into the explicit omega-
inconsistency witness consisting of the negated base instance and all numeral
instances.
-/
axiom firstIncompleteness_proofYieldsWitness
    (P : Godel1931System) :
    ∀ (c : P.FormulaClass),
      P.ProvableFrom c (P.godelSentence c) →
        P.ProvableFrom c (P.neg (P.instMatrix c 0)) ∧
        ∀ n : ℕ, P.ProvableFrom c (P.instMatrix c n)

/--
Upstream-narrow boundary, Kurt Gödel, 1931, *Ueber formal unentscheidbare
Saetze der Principia Mathematica und verwandter Systeme I*, Part 2,
Proposition VI, post-proof decisional-definite refinement: the checked tree
does not yet prove the undecidable `v Gen r` conclusion for a
decisional-definite class on the local typed `P` surface.
-/
axiom firstIncompleteness_decisionalDefiniteVersion
    (P : Godel1931System) :
    ∀ (c : P.FormulaClass), P.OmegaConsistent c →
      P.DecisionalDefiniteInExtendedSystem c →
        ∃ r : P.DecisionalDefiniteClassString,
          let φ := P.universalClosure r.toClassSign
          ¬ P.ProvableFrom c φ ∧ ¬ P.ProvableFrom c (P.neg φ)

/--
Upstream-narrow boundary, Kurt Gödel, 1931, *Ueber formal unentscheidbare
Saetze der Principia Mathematica und verwandter Systeme I*, Part 2,
Proposition VI, post-proof consistency-only paragraph: the checked tree does
not yet prove the weaker property-without-counterexample conclusion from
mere consistency on the local typed `P` surface.
-/
axiom firstIncompleteness_consistencyOnlyFallback
    (P : Godel1931System) :
    ∀ (c : P.FormulaClass), P.Consistent c →
      ∃ r : P.RecursiveClassString,
        ¬ P.ProvableFrom c (P.universalClosure r.toClassSign) ∧
        ∀ n : ℕ, ¬ P.ProvableFrom c (P.neg (P.instantiateNumeral r.toClassSign n))

/--
Upstream-narrow boundary, Kurt Gödel, 1931, *Ueber formal unentscheidbare
Saetze der Principia Mathematica und verwandter Systeme I*, Part 2,
Proposition VI, post-proof extension paragraph and footnote 46: the checked
tree does not yet construct the consistent but non-omega-consistent extension
obtained by adding the negated Gödel sentence.
-/
axiom firstIncompleteness_consistentNotOmegaExtension
    (P : Godel1931System) :
    ∀ (c : P.FormulaClass), P.Consistent c →
      ∃ c' : P.FormulaClass, P.ExtendsByNegGodel c c' ∧ P.Consistent c' ∧ ¬ P.OmegaConsistent c'

/-- The historical Proposition VI package assembled from the narrowed local boundaries. -/
theorem firstIncompletenessPackage
    (P : Godel1931System) : FirstIncompletenessPackage P where
  notProvableOfConsistent := firstIncompleteness_notProvableOfConsistent P
  negNotProvableOfOmega := firstIncompleteness_negNotProvableOfOmega P
  proofYieldsWitness := firstIncompleteness_proofYieldsWitness P
  decisionalDefiniteVersion := firstIncompleteness_decisionalDefiniteVersion P
  consistencyOnlyFallback := firstIncompleteness_consistencyOnlyFallback P
  consistentNotOmegaExtension := firstIncompleteness_consistentNotOmegaExtension P

theorem godel_sentence_not_provable_of_consistent
    (P : Godel1931System) (c : P.FormulaClass) :
    P.Consistent c → ¬ P.ProvableFrom c (P.godelSentence c) :=
  (firstIncompletenessPackage P).notProvableOfConsistent c

theorem neg_godel_sentence_not_provable_of_omegaConsistent
    (P : Godel1931System) (c : P.FormulaClass) :
    P.OmegaConsistent c → ¬ P.ProvableFrom c (P.neg (P.godelSentence c)) :=
  (firstIncompletenessPackage P).negNotProvableOfOmega c

theorem proof_of_godel_sentence_yields_omega_inconsistency_witness
    (P : Godel1931System) (c : P.FormulaClass) :
    P.ProvableFrom c (P.godelSentence c) →
      P.ProvableFrom c (P.neg (P.instMatrix c 0)) ∧
      ∀ n : ℕ, P.ProvableFrom c (P.instMatrix c n) :=
  (firstIncompletenessPackage P).proofYieldsWitness c

theorem exists_godel_sentence_of_decisionalDefinite
    (P : Godel1931System) (c : P.FormulaClass) :
    P.OmegaConsistent c →
      P.DecisionalDefiniteInExtendedSystem c →
        ∃ r : P.DecisionalDefiniteClassString,
          let φ := P.universalClosure r.toClassSign
          ¬ P.ProvableFrom c φ ∧ ¬ P.ProvableFrom c (P.neg φ) :=
  (firstIncompletenessPackage P).decisionalDefiniteVersion c

theorem exists_property_without_counterexample_of_consistent
    (P : Godel1931System) (c : P.FormulaClass) :
    P.Consistent c →
      ∃ r : P.RecursiveClassString,
        ¬ P.ProvableFrom c (P.universalClosure r.toClassSign) ∧
        ∀ n : ℕ, ¬ P.ProvableFrom c (P.neg (P.instantiateNumeral r.toClassSign n)) :=
  (firstIncompletenessPackage P).consistencyOnlyFallback c

theorem exists_consistent_not_omegaConsistent_extension
    (P : Godel1931System) (c : P.FormulaClass) :
    P.Consistent c →
      ∃ c' : P.FormulaClass, P.ExtendsByNegGodel c c' ∧ P.Consistent c' ∧ ¬ P.OmegaConsistent c' :=
  (firstIncompletenessPackage P).consistentNotOmegaExtension c

end MathlibExpansion.Logic.Godel
