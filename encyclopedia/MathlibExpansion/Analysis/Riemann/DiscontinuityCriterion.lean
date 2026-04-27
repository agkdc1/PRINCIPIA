import Mathlib.Data.Real.Basic

import Mathlib.MeasureTheory.Constructions.BorelSpace.Basic
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import MathlibExpansion.Analysis.Riemann.UpperLowerCriterion

open MeasureTheory

namespace MathlibExpansion
namespace Analysis
namespace Riemann

/--
`RIC`: necessity half of Lebesgue's Riemann-integrability discontinuity
criterion.

Source anchor: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Chapter II, Section II, unnumbered theorem on
1904.djvu/40-41; local theorem ID `RIDC_02`.
-/
axiom measure_zero_discontinuities_of_riemannIntegrable {f : ℝ → ℝ} {a b : ℝ}
    (hbdd : TextbookBoundedOnInterval f a b) (hf : RiemannIntegrableOn f a b) :
    volume {x | x ∈ Set.uIcc a b ∧ ¬ ContinuousWithinAt f (Set.uIcc a b) x} = 0

/--
`RIC`: sufficiency half of Lebesgue's Riemann-integrability discontinuity
criterion.

Source anchor: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Chapter II, Section II, unnumbered theorem on
1904.djvu/40-41; local theorem ID `RIDC_02`.
-/
axiom riemannIntegrable_of_measure_zero_discontinuities {f : ℝ → ℝ} {a b : ℝ}
    (hbdd : TextbookBoundedOnInterval f a b)
    (hnull :
      volume {x | x ∈ Set.uIcc a b ∧ ¬ ContinuousWithinAt f (Set.uIcc a b) x} = 0
    ) :
    RiemannIntegrableOn f a b

/--
`RIC`: bounded interval functions are Riemann-integrable exactly when their
discontinuity set has volume zero.
-/
theorem riemannIntegrable_iff_measure_zero_discontinuities {f : ℝ → ℝ} {a b : ℝ}
    (hbdd : TextbookBoundedOnInterval f a b) :
    RiemannIntegrableOn f a b ↔
      volume {x | x ∈ Set.uIcc a b ∧ ¬ ContinuousWithinAt f (Set.uIcc a b) x} = 0 :=
  ⟨measure_zero_discontinuities_of_riemannIntegrable hbdd,
    riemannIntegrable_of_measure_zero_discontinuities hbdd⟩

/-- Countably many discontinuities suffice for the Chapter II criterion. -/
theorem riemannIntegrable_of_countable_discontinuities {f : ℝ → ℝ} {a b : ℝ}
    (hbdd : TextbookBoundedOnInterval f a b)
    (hcount : Set.Countable {x | x ∈ Set.uIcc a b ∧ ¬ ContinuousWithinAt f (Set.uIcc a b) x}) :
    RiemannIntegrableOn f a b :=
  riemannIntegrable_of_measure_zero_discontinuities hbdd (hcount.measure_zero volume)

end Riemann
end Analysis
end MathlibExpansion
