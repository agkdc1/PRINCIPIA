import Mathlib.Computability.Primrec
import MathlibExpansion.Logic.Godel.SystemP.Derivability

/-!
# Numeralwise representation for Gödel 1931
-/

namespace MathlibExpansion.Logic.Godel

open SystemP

/--
`φ` numeralwise represents `R` in the ambient system `P` when positive and
negative instances are provable in the base theory.
-/
structure NumeralwiseRepresents (P : Godel1931System)
    {n : ℕ} (R : List.Vector ℕ n → Prop) (φ : PFormula) : Prop where
  positive : ∀ v, R v → P.ProvableFrom P.baseTheory φ
  negative : ∀ v, ¬ R v → P.ProvableFrom P.baseTheory (P.neg φ)

/-- Gödel's `entscheidungsdefinit` wrapper. -/
def DecisionDefinite (P : Godel1931System) {n : ℕ} (R : List.Vector ℕ n → Prop) : Prop :=
  ∃ φ : PFormula, NumeralwiseRepresents P R φ

structure NumeralwiseRepresentationPackage (P : Godel1931System) where
  existsRepresenting :
    ∀ {n : ℕ} (R : List.Vector ℕ n → Prop) [DecidablePred R]
      (_hR : PrimrecPred R),
      ∃ φ : PFormula, NumeralwiseRepresents P R φ
  existsGraphRepresenting :
    ∀ {n : ℕ} (f : List.Vector ℕ n → ℕ) (_hf : Primrec f),
      ∃ φ : PFormula,
        NumeralwiseRepresents P (fun v => v.head = f v.tail) φ
  primrecDecisionDefinite :
    ∀ {n : ℕ} (R : List.Vector ℕ n → Prop) [DecidablePred R]
      (_hR : PrimrecPred R),
      DecisionDefinite P R

/--
Upstream-narrow boundary: Gödel 1931, *Über formal unentscheidbare Sätze der
Principia Mathematica und verwandter Systeme I*, Satz V.  The checked tree
contains Mathlib's primitive-recursive computability substrate, but not the
object-language construction of a typed-system-`P` formula whose numeral
instances prove a primitive-recursive predicate and whose negated numeral
instances prove its complement.
-/
axiom existsNumeralwiseRepresentsPrimrec
    (P : Godel1931System) {n : ℕ} (R : List.Vector ℕ n → Prop) [DecidablePred R]
    (hR : PrimrecPred R) :
    ∃ φ : PFormula, NumeralwiseRepresents P R φ

/-- Package form of Gödel's Satz V numeralwise-representation boundary. -/
theorem numeralwiseRepresentationPackage
    (P : Godel1931System) : NumeralwiseRepresentationPackage P where
  existsRepresenting := by
    intro n R _ hR
    exact existsNumeralwiseRepresentsPrimrec P R hR
  existsGraphRepresenting := by
    intro n f hf
    have hGraph : PrimrecPred (fun v : List.Vector ℕ (n + 1) => v.head = f v.tail) := by
      exact Primrec.eq.comp Primrec.vector_head (hf.comp Primrec.vector_tail)
    exact existsNumeralwiseRepresentsPrimrec P
      (fun v : List.Vector ℕ (n + 1) => v.head = f v.tail) hGraph
  primrecDecisionDefinite := by
    intro n R _ hR
    exact existsNumeralwiseRepresentsPrimrec P R hR

theorem exists_systemP_formula_numeralwise_represents_primrec
    (P : Godel1931System) {n : ℕ} (R : List.Vector ℕ n → Prop) [DecidablePred R]
    (hR : PrimrecPred R) :
    ∃ φ : PFormula, NumeralwiseRepresents P R φ :=
  (numeralwiseRepresentationPackage P).existsRepresenting R hR

theorem exists_systemP_formula_numeralwise_represents_primrec_graph
    (P : Godel1931System) {n : ℕ} (f : List.Vector ℕ n → ℕ) (hf : Primrec f) :
    ∃ φ : PFormula, NumeralwiseRepresents P (fun v => v.head = f v.tail) φ :=
  (numeralwiseRepresentationPackage P).existsGraphRepresenting f hf

theorem primrec_decisionDefinite
    (P : Godel1931System) {n : ℕ} (R : List.Vector ℕ n → Prop) [DecidablePred R]
    (hR : PrimrecPred R) :
    DecisionDefinite P R :=
  (numeralwiseRepresentationPackage P).primrecDecisionDefinite R hR

end MathlibExpansion.Logic.Godel
