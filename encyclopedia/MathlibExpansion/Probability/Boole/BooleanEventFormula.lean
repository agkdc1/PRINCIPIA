import Mathlib
import MathlibExpansion.Textbooks.Boole1854.BooleanFormula

/-!
# Boolean event formulas for Boole-style probability

This file is the probability consumer of the Boole 1854 owner stack.
It keeps the model boundary explicit: the event evaluator and the atom-sum
probability expressions are definitions, while the independence bridge is proved
from Mathlib's finite-family independence API.
-/

open scoped BigOperators
open MeasureTheory ProbabilityTheory

namespace MathlibExpansion
namespace Probability
namespace Boole

open MathlibExpansion.Textbooks.Boole1854

section Core

variable {ι Ω : Type*} [Fintype ι] [DecidableEq ι]

/-- The truth assignment induced by a family of events at a point `ω`. -/
noncomputable def eventAssignment (s : ι → Set Ω) (ω : Ω) : Assignment ι :=
  by
    classical
    exact fun i => decide (ω ∈ s i)

/-- The event cut out by a Boolean formula in the event variables `s i`. -/
noncomputable def evalEvent (s : ι → Set Ω) (φ : BooleanFormula ι) : Set Ω :=
  {ω | eventAssignment s ω ∈ φ}

/-- The atom event corresponding to a fixed truth assignment. -/
noncomputable def eventAtom (s : ι → Set Ω) (σ : Assignment ι) : Set Ω :=
  {ω | eventAssignment s ω = σ}

theorem mem_evalEvent_iff (s : ι → Set Ω) (φ : BooleanFormula ι) (ω : Ω) :
    ω ∈ evalEvent s φ ↔ eventAssignment s ω ∈ φ :=
  Iff.rfl

theorem mem_eventAtom_iff (s : ι → Set Ω) (σ : Assignment ι) (ω : Ω) :
    ω ∈ eventAtom s σ ↔ eventAssignment s ω = σ :=
  Iff.rfl

/-- The atom weight predicted by independent event probabilities `p i`. -/
noncomputable def atomMass (p : ι → ENNReal) (σ : Assignment ι) : ENNReal :=
  ∏ i, if σ i then p i else 1 - p i

/-- The Boole/Laplace probability expression obtained by summing the atom weights. -/
noncomputable def formulaMass (p : ι → ENNReal) (φ : BooleanFormula ι) : ENNReal :=
  ∑ σ ∈ φ, atomMass p σ

/-- Conditional probability expression attached to two Boolean formulas. -/
noncomputable def conditionalFormulaMass (p : ι → ENNReal) (φ ψ : BooleanFormula ι) : ENNReal :=
  formulaMass p (φ ⊓ ψ) / formulaMass p φ

theorem formulaMass_inter (p : ι → ENNReal) (φ ψ : BooleanFormula ι) :
    formulaMass p (φ ⊓ ψ) = ∑ σ ∈ (φ ⊓ ψ), atomMass p σ :=
  rfl

end Core

section IndependenceBridge

variable {ι Ω : Type*} [Fintype ι] [DecidableEq ι]
variable [MeasurableSpace Ω]

private def atomChoice (s : ι → Set Ω) (σ : Assignment ι) (i : ι) : Set Ω :=
  if σ i then s i else (s i)ᶜ

@[simp]
private theorem mem_atomChoice_iff (s : ι → Set Ω) (σ : Assignment ι) (i : ι) (ω : Ω) :
    ω ∈ atomChoice s σ i ↔ eventAssignment s ω i = σ i := by
  classical
  change ω ∈ atomChoice s σ i ↔ decide (ω ∈ s i) = σ i
  by_cases hσ : σ i <;> simp [atomChoice, hσ]

private theorem eventAtom_eq_iInter_atomChoice (s : ι → Set Ω) (σ : Assignment ι) :
    eventAtom s σ = ⋂ i, atomChoice s σ i := by
  ext ω
  simp [eventAtom, eventAssignment, funext_iff]

private theorem measurableSet_atomChoice (s : ι → Set Ω) (hs : ∀ i, MeasurableSet (s i))
    (σ : Assignment ι) (i : ι) :
    MeasurableSet (atomChoice s σ i) := by
  by_cases hσ : σ i <;> simp [atomChoice, hσ, hs i]

theorem measurableSet_eventAtom (s : ι → Set Ω) (hs : ∀ i, MeasurableSet (s i))
    (σ : Assignment ι) :
    MeasurableSet (eventAtom s σ) := by
  rw [eventAtom_eq_iInter_atomChoice]
  exact MeasurableSet.iInter fun i => measurableSet_atomChoice s hs σ i

private theorem evalEvent_eq_biUnion_eventAtom (s : ι → Set Ω) (φ : BooleanFormula ι) :
    evalEvent s φ = ⋃ σ ∈ φ, eventAtom s σ := by
  ext ω
  simp [evalEvent, eventAtom]

theorem measurableSet_evalEvent (s : ι → Set Ω) (hs : ∀ i, MeasurableSet (s i))
    (φ : BooleanFormula ι) :
    MeasurableSet (evalEvent s φ) := by
  rw [evalEvent_eq_biUnion_eventAtom]
  exact Finset.measurableSet_biUnion φ fun σ _ => measurableSet_eventAtom s hs σ

private theorem measurableSet_generateFrom_atomChoice (s : ι → Set Ω) (σ : Assignment ι) (i : ι) :
    MeasurableSet[MeasurableSpace.generateFrom {s i}] (atomChoice s σ i) := by
  by_cases hσ : σ i
  · simpa [atomChoice, hσ] using
      (MeasurableSpace.measurableSet_generateFrom (Set.mem_singleton (s i)))
  · simpa [atomChoice, hσ] using
      (MeasurableSpace.measurableSet_generateFrom (Set.mem_singleton (s i))).compl

private theorem measure_atomChoice (μ : Measure Ω) [IsProbabilityMeasure μ]
    (s : ι → Set Ω) (hs : ∀ i, MeasurableSet (s i)) (σ : Assignment ι) (i : ι) :
    μ (atomChoice s σ i) = if σ i then μ (s i) else 1 - μ (s i) := by
  by_cases hσ : σ i
  · simp [atomChoice, hσ]
  · simp [atomChoice, hσ, measure_compl (hs i) (measure_ne_top μ (s i)), measure_univ]

theorem measure_eventAtom_eq_atomMass
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (s : ι → Set Ω) (hs : ∀ i, MeasurableSet (s i)) (hind : iIndepSet s μ)
    (σ : Assignment ι) :
    μ (eventAtom s σ) = atomMass (fun i => μ (s i)) σ := by
  rw [eventAtom_eq_iInter_atomChoice]
  have h :=
    ((ProbabilityTheory.iIndepSet_iff s μ).1 hind) Finset.univ
      (f := fun i => atomChoice s σ i)
      (fun i _ => measurableSet_generateFrom_atomChoice s σ i)
  simpa [atomMass, measure_atomChoice μ s hs σ] using h

/-- Independent measurable event formulas evaluate to Boole's finite atom-sum expression
(Boole 1854, *An Investigation of the Laws of Thought*, Ch. XVI, Problems in the
Theory of Probabilities). -/
theorem measure_evalEvent_eq_formulaMass
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (s : ι → Set Ω) (hs : ∀ i, MeasurableSet (s i)) (hind : iIndepSet s μ)
    (φ : BooleanFormula ι) :
    μ (evalEvent s φ) = formulaMass (fun i => μ (s i)) φ := by
  classical
  calc
    μ (evalEvent s φ) = ∑ σ ∈ φ, μ (eventAtom s σ) := by
      have h :=
        (sum_measure_preimage_singleton (μ := μ) φ (f := eventAssignment s)
          (fun σ _ => by
            simpa [Set.preimage, eventAtom, Set.mem_singleton_iff] using
              measurableSet_eventAtom s hs σ)).symm
      simpa [evalEvent, eventAtom] using h
    _ = formulaMass (fun i => μ (s i)) φ := by
      simp [formulaMass, measure_eventAtom_eq_atomMass μ s hs hind]

/-- Boole's conditional event evaluator is the ratio of the finite atom sums
(Boole 1854, *An Investigation of the Laws of Thought*, Ch. XVI, Problems in the
Theory of Probabilities). -/
theorem cond_evalEvent_eq_conditionalFormulaMass
    (μ : Measure Ω) [IsFiniteMeasure μ]
    (s : ι → Set Ω) (hs : ∀ i, MeasurableSet (s i)) (hind : iIndepSet s μ)
    (φ ψ : BooleanFormula ι) :
    μ[evalEvent s ψ | evalEvent s φ] =
      conditionalFormulaMass (fun i => μ (s i)) φ ψ := by
  classical
  haveI : IsProbabilityMeasure μ := hind.isProbabilityMeasure
  have hφ : MeasurableSet (evalEvent s φ) := measurableSet_evalEvent s hs φ
  have hInter : evalEvent s φ ∩ evalEvent s ψ = evalEvent s (φ ⊓ ψ) := by
    ext ω
    simp [evalEvent, and_comm]
  calc
    μ[evalEvent s ψ | evalEvent s φ]
        = (μ (evalEvent s φ))⁻¹ * μ (evalEvent s φ ∩ evalEvent s ψ) := by
          rw [ProbabilityTheory.cond_apply hφ μ]
    _ = (formulaMass (fun i => μ (s i)) φ)⁻¹ *
          formulaMass (fun i => μ (s i)) (φ ⊓ ψ) := by
          rw [hInter, measure_evalEvent_eq_formulaMass μ s hs hind,
            measure_evalEvent_eq_formulaMass μ s hs hind]
    _ = conditionalFormulaMass (fun i => μ (s i)) φ ψ := by
          rw [conditionalFormulaMass, ← ENNReal.div_eq_inv_mul]

end IndependenceBridge

end Boole
end Probability
end MathlibExpansion
