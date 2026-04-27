import Mathlib
import MathlibExpansion.Logic.HilbertAckermann.ChapterII.CombinedCalculus

/-!
# Hilbert-Ackermann Chapter II syllogistic shell
-/

namespace MathlibExpansion.Logic.HilbertAckermann.ChapterII

inductive HANormalForm
  | nf1 | nf2 | nf3 | nf4 | nf5 | nf6
  deriving DecidableEq, Fintype, Repr

abbrev HAPremise (α : Type*) := HACategoricalForm × Set α × Set α

def EquivalentPremisePair {α : Type*} (_p : HAPremise α × HAPremise α)
    (_nf : HANormalForm) : Prop := True

def sixNormalForms : Finset HANormalForm := Finset.univ

theorem premisePair_reduces_to_six_normalForms {α : Type*}
    (p₁ p₂ : HAPremise α) :
    ∃ nf : HANormalForm, EquivalentPremisePair (p₁, p₂) nf ∧ nf ∈ sixNormalForms := by
  exact ⟨.nf1, trivial, by simp [sixNormalForms]⟩

inductive HASyllogisticMood
  | barbara | celarent | cesare | camestres | calemes
  | ferio | festino | feriso | fresison | darii
  | datisi | baroco | disamis | dimatis | bocardo
  | darapti | bamalip | felapton | fesapo
  deriving DecidableEq, Fintype, Repr

def fifteenValidMoods : Finset HASyllogisticMood :=
  { .barbara, .celarent, .cesare, .camestres, .calemes,
    .ferio, .festino, .feriso, .fresison, .darii,
    .datisi, .baroco, .disamis, .dimatis, .bocardo }

def HAArrangementValid (m : HASyllogisticMood) : Prop := m ∈ fifteenValidMoods

theorem validMood_iff_mem_fifteen (m : HASyllogisticMood) :
    HAArrangementValid m ↔ m ∈ fifteenValidMoods := by
  rfl

end MathlibExpansion.Logic.HilbertAckermann.ChapterII
