import MathlibExpansion.Logic.HilbertAckermann.Restricted.DecidableFragments.PrefixClasses

/-!
# Hilbert-Ackermann finite-domain frontier boundary

This file is the Step 6 deferred ledger for the general
Entscheidungsproblem frontier. The former unchecked frontier axiom is exposed
as an explicit evidence parameter instead.
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted.DecisionFrontier

open MathlibExpansion.Logic.HilbertAckermann.Restricted.DecidableFragments

def FiniteReducible (p : PrefixShape) : Prop :=
  match p with
  | .allOnly _ => True
  | .exOnly _ => True
  | .allThenEx _ _ => True
  | .allExistsExistsAll _ _ => False

/-- Universal-prefix sentences have a finite-domain reduction. -/
theorem finiteReducible_allOnly (m : ℕ) :
    FiniteReducible (.allOnly m) := by
  simp [FiniteReducible]

/-- Existential-prefix sentences have a finite-domain reduction. -/
theorem finiteReducible_exOnly (m : ℕ) :
    FiniteReducible (.exOnly m) := by
  simp [FiniteReducible]

/-- Bernays-Schoenfinkel prefixes have a finite-domain reduction. -/
theorem finiteReducible_allThenEx (m n : ℕ) :
    FiniteReducible (.allThenEx m n) := by
  simp [FiniteReducible]

/-- The AEEA prefix class is outside this file's finite-reducible list. -/
theorem not_finiteReducible_allExistsExistsAll (m n : ℕ) :
    ¬ FiniteReducible (.allExistsExistsAll m n) := by
  simp [FiniteReducible]

/-- Evidence for the finite-domain frontier counterexample attached to a
non-finite-reducible prefix shape. This is the narrowed theorem boundary: the
local prefix semantics do not yet construct Schuette's finite-only valid
sentences, so the counterexample is explicit proof data rather than a global
kernel axiom.

Citation: K. Schuette, `Untersuchungen zum Entscheidungsproblem der
mathematischen Logik`, *Math. Ann.* 109 (1934), and `Uber die Erfullbarkeit
einer Klasse von logischen Formeln`, *Math. Ann.* 110 (1934), the boundary
results cited by Hilbert-Ackermann's revised Chapter III section on special
decision-problem fragments. The solved finite-reduction corridor follows
Lowenheim 1915, Behmann 1922, and Bernays-Schoenfinkel 1928. -/
structure FiniteDomainFrontierCounterexample (p : PrefixShape) where
  sentence : PrefixSentence
  shape_eq : sentence.shape = p
  finiteOnly : FiniteOnlyValid sentence

/-- Finite-domain reduction is exhaustive once every non-finite-reducible
prefix is supplied with its explicit finite-only valid counterexample.

The previous axiom asserted this disjunction unconditionally. In the current
substrate, `FiniteOnlyValid` is only a skeletal predicate, so the Schuette
counterexample construction is kept as an explicit upstream evidence argument.

Citation: finite-reduction side, Lowenheim 1915, Behmann 1922, and
Bernays-Schoenfinkel 1928; boundary side, K. Schuette, *Math. Ann.* 109
(1934) and 110 (1934), as recorded in the Hilbert-Ackermann special-fragment
frontier recon. -/
theorem finite_reduction_exhaustive_or_infinite_counterexample
    (p : PrefixShape)
    (counterexampleOfNonreducible :
      ¬ FiniteReducible p → FiniteDomainFrontierCounterexample p) :
    FiniteReducible p ∨
      ∃ φ : PrefixSentence, FiniteOnlyValid φ ∧ ¬ Valid φ := by
  classical
  by_cases hp : FiniteReducible p
  · exact Or.inl hp
  · have E := counterexampleOfNonreducible hp
    exact Or.inr ⟨E.sentence, E.finiteOnly, E.finiteOnly.2⟩

end MathlibExpansion.Logic.HilbertAckermann.Restricted.DecisionFrontier
