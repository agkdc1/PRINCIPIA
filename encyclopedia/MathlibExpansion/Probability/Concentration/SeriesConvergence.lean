import MathlibExpansion.Probability.Concentration.Basic

/-!
# Concentration and convergence of independent series

This file packages the Lévy convergence theorem and its lower-dispersion
obstruction counterpart.
-/

namespace MathlibExpansion
namespace Probability
namespace Concentration

open MeasureTheory Filter Function
open scoped Topology

/-- Tail-law carrier for the tail series starting at `N`.

When an a.e. measurable limit of the tail partial sums is available, this is its push-forward law;
otherwise it falls back to the default real probability law. This removes the former data axiom while
keeping the total API needed by the Doeblin-Levy obstruction boundary.

Source spine for the intended tail-law construction: Paul Levy, "Sur les series dont les termes
sont des variables eventuelles independantes", *Studia Mathematica* 3 (1931), 119-155,
DOI 10.4064/sm-3-1-119-155, and Levy, *Theorie de l'addition des variables aleatoires*
(1937; 2nd ed. 1954), Chapter 6, "La dispersion limite pour une serie a termes aleatoires
independants". -/
noncomputable def tailLaw {Ω : Type*} [MeasurableSpace Ω] (μ : ProbabilityMeasure Ω)
    (X : ℕ → Ω → ℝ) (N : ℕ) : ProbabilityMeasure ℝ := by
  classical
  let tailPartial : ℕ → Ω → ℝ := fun n ω ↦ ∑ i ∈ Finset.Ico N (N + n), X i ω
  by_cases h :
      ∃ g : Ω → ℝ, AEMeasurable g (μ : Measure Ω) ∧
        ∀ᵐ ω ∂(μ : Measure Ω), Tendsto (fun n ↦ tailPartial n ω) atTop (𝓝 (g ω))
  · exact μ.map (Classical.choose_spec h).1
  · exact default

private theorem partialSums_aestronglyMeasurable {Ω : Type*} [MeasurableSpace Ω]
    (μ : ProbabilityMeasure Ω) (X : ℕ → Ω → ℝ)
    (hX : ∀ n, AEMeasurable (X n) (μ : Measure Ω)) :
    ∀ n, AEStronglyMeasurable (fun ω ↦ ∑ i ∈ Finset.range n, X i ω) (μ : Measure Ω) := by
  intro n
  refine aestronglyMeasurable_iff_aemeasurable.mpr ?_
  induction n with
  | zero =>
      simp
  | succ n ih =>
      have hsum : AEMeasurable (fun ω ↦ ∑ i ∈ Finset.range n, X i ω) (μ : Measure Ω) := ih
      simpa [Finset.sum_range_succ, Pi.add_apply] using hsum.add (hX n)

/-- Levy's hard direction for independent partial sums: convergence in probability forces
almost-sure convergence.

This is the remaining upstream-narrow theorem boundary after the reverse direction is discharged
below from Mathlib's finite-measure theorem `tendstoInMeasure_of_tendsto_ae`.

Exact source spine: Paul Levy, "Sur les series dont les termes sont des variables eventuelles
independantes", *Studia Mathematica* 3 (1931), 119-155, DOI 10.4064/sm-3-1-119-155; modern
numbered reference: Theorem III.8 (Paul Levy) in the independent-random-series chapter, stating
equivalence of almost-sure, in-probability, and in-distribution convergence for independent real
series. -/
axiom ae_tendsto_of_indep_partialSums_tendstoInProbability {Ω : Type*} [MeasurableSpace Ω]
    (μ : ProbabilityMeasure Ω) (X : ℕ → Ω → ℝ)
    (hX : ∀ n, AEMeasurable (X n) (μ : Measure Ω))
    (hindep : Pairwise ((ProbabilityTheory.IndepFun · · (μ : Measure Ω)) on X)) :
    (∃ g : Ω → ℝ, TendstoInMeasure (μ : Measure Ω)
      (fun n ω ↦ ∑ i ∈ Finset.range n, X i ω) atTop g) →
      (∃ g : Ω → ℝ, ∀ᵐ ω ∂(μ : Measure Ω),
        Tendsto (fun n ↦ ∑ i ∈ Finset.range n, X i ω) atTop (𝓝 (g ω)))

/-- For independent partial sums, convergence in probability is equivalent to almost-sure
convergence. -/
theorem indep_partialSums_tendstoInProbability_iff_ae_tendsto {Ω : Type*} [MeasurableSpace Ω]
    (μ : ProbabilityMeasure Ω) (X : ℕ → Ω → ℝ)
    (hX : ∀ n, AEMeasurable (X n) (μ : Measure Ω))
    (hindep : Pairwise ((ProbabilityTheory.IndepFun · · (μ : Measure Ω)) on X)) :
    (∃ g : Ω → ℝ, TendstoInMeasure (μ : Measure Ω)
      (fun n ω ↦ ∑ i ∈ Finset.range n, X i ω) atTop g) ↔
      (∃ g : Ω → ℝ, ∀ᵐ ω ∂(μ : Measure Ω),
        Tendsto (fun n ↦ ∑ i ∈ Finset.range n, X i ω) atTop (𝓝 (g ω))) := by
  constructor
  · exact ae_tendsto_of_indep_partialSums_tendstoInProbability μ X hX hindep
  · rintro ⟨g, hg⟩
    exact ⟨g, tendstoInMeasure_of_tendsto_ae (partialSums_aestronglyMeasurable μ X hX) hg⟩

/-- A uniform positive tail-dispersion scale obstructs convergence of the partial sums.

Exact source spine: Wolfgang Doeblin and Paul Levy, "Sur les sommes de variables aleatoires
independantes a dispersions bornees inferieurement", *Comptes rendus de l'Academie des sciences*
202 (1936), 2027-2029, main theorem (the note is unnumbered), as organized for series tails in
Levy, *Theorie de l'addition des variables aleatoires* (1937; 2nd ed. 1954), Chapter 6, "Sommes de
termes a dispersions bornees inferieurement". -/
axiom not_tendsto_of_tail_dispersion_bounded_below {Ω : Type*} [MeasurableSpace Ω]
    (μ : ProbabilityMeasure Ω) (X : ℕ → Ω → ℝ)
    (hX : ∀ n, AEMeasurable (X n) (μ : Measure Ω))
    (hindep : Pairwise ((ProbabilityTheory.IndepFun · · (μ : Measure Ω)) on X))
    {p : ℝ} (hp : 0 < p ∧ p < 1) {L : ℝ}
    (hL : ∀ N, L ≤ dispersionFunction (tailLaw μ X N) ⟨p, hp.1.le, hp.2.le⟩) :
    ¬ ∃ g : Ω → ℝ, TendstoInMeasure (μ : Measure Ω)
      (fun n ω ↦ ∑ i ∈ Finset.range n, X i ω) atTop g

end Concentration
end Probability
end MathlibExpansion
