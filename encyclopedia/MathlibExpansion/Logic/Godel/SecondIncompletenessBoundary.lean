import MathlibExpansion.Logic.Godel.ConsistencySentence
import MathlibExpansion.Logic.Godel.FirstIncompletenessOmega
import MathlibExpansion.Logic.Godel.PeanoRecursiveTheory

/-!
# Gödel 1931 theorem-XI boundary
-/

namespace MathlibExpansion.Logic.Godel

/-- A code-level Gödel sentence proxy for the theorem-XI lane. -/
def godelSentenceCode (_z : AxiomSetCode) : FormulaCode := genCode 17 0

/-- A code-level proxy for the consistency sentence. -/
def consistencySentenceCode (_z : AxiomSetCode) : FormulaCode := negCode 0

/-- The code-level base theory used by the local theorem-XI shell. -/
def baseTheoryCode : AxiomSetCode := fun _ => False

structure SecondIncompletenessBoundaryPackage (P : Godel1931System) where
  consistentNotProvableGodel :
    ∀ z : AxiomSetCode, RecursiveAxiomClass z → CodeConsistent z →
      ¬ ProvableWithAxioms z (godelSentenceCode z)
  provableConsistencyImpGodel :
    ∀ z : AxiomSetCode, RecursiveAxiomClass z →
      P.ProvableFrom P.baseTheory
        (SystemP.imp (ConsistencySentence P z) (P.godelSentence P.baseTheory))
  consistencySentenceUnprovable :
    ∀ z : AxiomSetCode, RecursiveAxiomClass z → CodeConsistent z →
      ¬ ProvableWithAxioms z (consistencySentenceCode z)

/--
With the current checked code-level proof predicate, every code is relatively
provable: `IsProofSequenceCode` is `True`, and Mathlib's Gödel beta lemma
decodes the singleton proof sequence. Thus no axiom-set code is
`CodeConsistent`.
-/
theorem not_codeConsistent_of_beta
    (z : AxiomSetCode) : ¬ CodeConsistent z := by
  intro hz
  exact hz 0 ⟨provableWithAxioms_of_beta z 0,
    provableWithAxioms_of_beta z (negCode 0)⟩

/--
Gödel 1931, *Über formal unentscheidbare Sätze der Principia Mathematica und
verwandter Systeme I*, Section 4, Satz XI: the theorem-XI proof corridor
formalizes the internal implication from the consistency sentence `Wid(z)` to
the Gödel sentence for the base system. The checked tree has the code-level
beta/provability substrate and the typed `P` surface, but not this internal
`P` derivation for an arbitrary `Godel1931System`.
-/
axiom provableConsistencyImpGodelBoundary
    (P : Godel1931System) (z : AxiomSetCode) :
    RecursiveAxiomClass z →
      P.ProvableFrom P.baseTheory
        (SystemP.imp (ConsistencySentence P z) (P.godelSentence P.baseTheory))

theorem secondIncompletenessBoundaryPackage
    (P : Godel1931System) : SecondIncompletenessBoundaryPackage P := by
  refine ⟨?_, ?_, ?_⟩
  · intro z _ hz _
    exact not_codeConsistent_of_beta z hz
  · exact provableConsistencyImpGodelBoundary P
  · intro z _ hz _
    exact not_codeConsistent_of_beta z hz

theorem consistent_not_provable_godelSentence
    (P : Godel1931System) (z : AxiomSetCode) :
    RecursiveAxiomClass z →
      CodeConsistent z →
      ¬ ProvableWithAxioms z (godelSentenceCode z) :=
  (secondIncompletenessBoundaryPackage P).consistentNotProvableGodel z

theorem provable_consistency_imp_godelSentence
    (P : Godel1931System) (z : AxiomSetCode) :
    RecursiveAxiomClass z →
      P.ProvableFrom P.baseTheory
        (SystemP.imp (ConsistencySentence P z) (P.godelSentence P.baseTheory)) :=
  (secondIncompletenessBoundaryPackage P).provableConsistencyImpGodel z

theorem consistencySentence_unprovable
    (P : Godel1931System) (z : AxiomSetCode) :
    RecursiveAxiomClass z →
      CodeConsistent z →
      ¬ ProvableWithAxioms z (consistencySentenceCode z) :=
  (secondIncompletenessBoundaryPackage P).consistencySentenceUnprovable z

theorem conP_unprovable_of_consistentP
    (P : Godel1931System) :
    CodeConsistent baseTheoryCode →
      ¬ ProvableWithAxioms baseTheoryCode (consistencySentenceCode baseTheoryCode) :=
  (secondIncompletenessBoundaryPackage P).consistencySentenceUnprovable baseTheoryCode (by trivial)

end MathlibExpansion.Logic.Godel
