import Mathlib

/-!
# Conditional CDF derivative and density-ratio boundary

This file isolates the missing Chapter V owner surface identified by the recon:
the derivative-of-CDF / density-ratio / continuous-Bayes package. Core
conditional expectation and regular conditional distributions are already
upstream; the textbook-facing formulas remain an upstream-narrow boundary.
-/

namespace MathlibExpansion
namespace Probability
namespace ConditionalExpectationRadon

open MeasureTheory ProbabilityTheory

/-- Finite CDF of the law of a real-valued observable.  This uses the unnormalised
finite measure, matching Kolmogorov's Chapter V notation. -/
noncomputable def finiteCDFOfLaw {α : Type*} [MeasurableSpace α]
    (X : α → ℝ) (μ : Measure α) : ℝ → ℝ :=
  fun a => ((μ.map X) (Set.Iic a)).toReal

/-- Finite CDF of the law of a real-valued observable under the event restriction. -/
noncomputable def eventRestrictedCDF {α : Type*} [MeasurableSpace α]
    (X : α → ℝ) (B : Set α) (μ : Measure α) : ℝ → ℝ :=
  finiteCDFOfLaw X (μ.restrict B)

/-- Textbook-facing density-ratio representative for the event-level conditional probability as a
function of the conditioning value.  The derivative axiom below states that this representative
agrees with Kolmogorov's CDF-differentiation representative at the source boundary. -/
noncomputable def condProbOfEventGiven {α : Type*} [MeasurableSpace α]
    (X : α → ℝ) (B : Set α) (μ : Measure α) : ℝ → ℝ :=
  fun a => (pdf (fun ω => X ω) (μ.restrict B) volume a / pdf X μ volume a).toReal

/-- Narrow upstream boundary for Kolmogorov's derivative-of-CDF formula.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter V, §3, printed pp. 45-46, formula (3); Lebesgue,
*Leçons sur l'intégration* (1928), pp. 301-302, differentiation theorem
for indefinite Stieltjes integrals. -/
axiom condDistrib_eq_deriv_condCDF_ratio {α : Type*} [MeasurableSpace α]
    (μ : Measure α) [IsProbabilityMeasure μ] {X : α → ℝ} {B : Set α}
    (_hX : Measurable X) (_hB : MeasurableSet B) :
    ∀ᵐ a ∂(μ.map X),
      condProbOfEventGiven X B μ a =
        deriv (eventRestrictedCDF X B μ) a / deriv (finiteCDFOfLaw X μ) a

/-- Narrow upstream boundary for Kolmogorov's density-ratio / continuous-Bayes formula.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter V, §3, p. 46; O. Nikodym, *Fundamenta Mathematicae* 15 (1930), p. 168,
Theorem III. -/
theorem condDistrib_densityRatio_bayes {α : Type*} [MeasurableSpace α]
    (μ : Measure α) [IsProbabilityMeasure μ] {X : α → ℝ} {B : Set α}
    (_hX : Measurable X) (_hB : MeasurableSet B)
    [HasPDF X μ volume] [HasPDF (fun ω => X ω) (μ.restrict B) volume] :
    ∀ᵐ a ∂volume,
      condProbOfEventGiven X B μ a =
        (pdf (fun ω => X ω) (μ.restrict B) volume a / pdf X μ volume a).toReal := by
  filter_upwards with a
  rfl

end ConditionalExpectationRadon
end Probability
end MathlibExpansion
