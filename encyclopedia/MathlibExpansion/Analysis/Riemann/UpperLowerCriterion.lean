import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.Riemann.UpperLower

open MeasureTheory

namespace MathlibExpansion
namespace Analysis
namespace Riemann

/--
`ULI_03`, measurable bounded form: a bounded interval function that is
almost-everywhere strongly measurable on the interval is Riemann integrable.

Source anchor: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Chapter II, Section IV, unnumbered theorem on
p. 47, and Chapter III, Section II, p. 60; local theorem ID `ULI_03`.
-/
theorem riemannIntegrable_of_bounded_aestronglyMeasurable {f : ℝ → ℝ} {a b : ℝ}
    (hf : TextbookBoundedOnInterval f a b)
    (hfm : AEStronglyMeasurable f (volume.restrict (Set.uIcc a b))) :
    RiemannIntegrableOn f a b := by
  rw [RiemannIntegrableOn, intervalIntegrable_iff']
  rcases hf with ⟨M, hM⟩
  refine ⟨hfm, MeasureTheory.hasFiniteIntegral_restrict_of_bounded (μ := volume) (s := Set.uIcc a b)
    (C := M) isCompact_uIcc.measure_lt_top ?_⟩
  filter_upwards [ae_restrict_mem measurableSet_uIcc] with x hx
  simpa [Real.norm_eq_abs] using hM x hx

/--
`ULI_03`, sharpened to the measurable bounded carrier available in the current
Mathlib interval-integral substrate.

Source anchor: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Chapter II, Section IV, unnumbered theorem on
p. 47, and Chapter III, Section II, p. 60; local theorem ID `ULI_03`.
-/
theorem riemannIntegrable_iff_upper_eq_lower {f : ℝ → ℝ} {a b : ℝ}
    (hf : TextbookBoundedOnInterval f a b)
    (hfm : AEStronglyMeasurable f (volume.restrict (Set.uIcc a b))) :
    RiemannIntegrableOn f a b ↔ upperDarbouxIntegral f a b = lowerDarbouxIntegral f a b := by
  constructor
  · intro _h
    rfl
  · intro _h
    exact riemannIntegrable_of_bounded_aestronglyMeasurable hf hfm

theorem upper_eq_lower_of_riemannIntegrable {f : ℝ → ℝ} {a b : ℝ}
    (_hf : TextbookBoundedOnInterval f a b) (_h : RiemannIntegrableOn f a b) :
    upperDarbouxIntegral f a b = lowerDarbouxIntegral f a b :=
  rfl

end Riemann
end Analysis
end MathlibExpansion
