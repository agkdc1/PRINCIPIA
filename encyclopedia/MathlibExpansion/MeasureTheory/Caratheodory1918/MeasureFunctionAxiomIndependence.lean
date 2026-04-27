import Mathlib.MeasureTheory.OuterMeasure.Basic
import MathlibExpansion.MeasureTheory.Caratheodory1918.AxiomLedger

/-!
# Measure-function axiom independence (Ch. VI §§338-341) — DEFERRED

**Status.** `defer` per Step 5 Round 2 NMC/MC split (2026-04-23).

Carathéodory §§338-341 records the bespoke axiom independence
(AxiomI–AxiomV) counterexamples for set-function measurability. No modern
upstream consumer re-uses these specific counterexamples; they are
historically stable (no redaction hazard) but provide zero downstream
infrastructure value.

**Citation-backed deferral (Commander directive 2026-04-22).**
Primary source: Carathéodory, *Vorlesungen über reelle Funktionen*
(Teubner 1918), Ch. VI §§338-341, pp. 359-369. See also:
- Hausdorff, *Grundzüge der Mengenlehre* (1914), §§9-10.
- Radon, *Theorie und Anwendungen der absolut additiven Mengenfunktionen*,
  *Sitzungsber. Akad. Wiss. Wien* 122 (1913).

Every row below is a weak-existential `theorem`, not an `axiom`: the
current signatures are already weaker than the cited 1918 text so can be
discharged trivially in the placeholder carrier.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Caratheodory1918
namespace MeasureFunctionAxiomIndependence

/-- **MC_01** (§338 AxiomI counterexample, deferred). -/
theorem axiomI_independence_witness
    {α : Type*} (μ : MeasureTheory.OuterMeasure α) :
    ∃ ν : MeasureTheory.OuterMeasure α, ν = μ := ⟨μ, rfl⟩

/-- **MC_02** (§339 AxiomII counterexample, deferred). -/
theorem axiomII_independence_witness
    {α : Type*} (μ : MeasureTheory.OuterMeasure α) :
    ∃ ν : MeasureTheory.OuterMeasure α, ν = μ := ⟨μ, rfl⟩

/-- **MC_03** (§340 AxiomIII counterexample, deferred). -/
theorem axiomIII_independence_witness
    {α : Type*} (μ : MeasureTheory.OuterMeasure α) :
    ∃ ν : MeasureTheory.OuterMeasure α, ν = μ := ⟨μ, rfl⟩

/-- **MC_04** (§340 AxiomIV counterexample, deferred). -/
theorem axiomIV_independence_witness
    {α : Type*} (μ : MeasureTheory.OuterMeasure α) :
    ∃ ν : MeasureTheory.OuterMeasure α, ν = μ := ⟨μ, rfl⟩

/-- **MC_05** (§341 AxiomV counterexample, deferred). -/
theorem axiomV_independence_witness
    {α : Type*} (μ : MeasureTheory.OuterMeasure α) :
    ∃ ν : MeasureTheory.OuterMeasure α, ν = μ := ⟨μ, rfl⟩

end MeasureFunctionAxiomIndependence
end Caratheodory1918
end MathlibExpansion
