import Mathlib.Data.Real.Basic

import Mathlib.MeasureTheory.Function.SimpleFunc
import MathlibExpansion.Analysis.Riemann.UpperLowerCriterion

/-!
# Two-sided step envelopes for interval integrability

This module keeps the textbook-facing statement of Lebesgue's two-sided
step-envelope criterion for Riemann integrability on a compact real interval.
The old biconditional axiom has been split into its necessity and sufficiency
directions; the public biconditional is now assembled as a theorem.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Analysis
namespace Riemann

/-- The interval integral of a finite-valued step function on `ℝ`. -/
noncomputable def stepIntegral (a b : ℝ) (φ : SimpleFunc ℝ ℝ) : ℝ :=
  ∫ x in a..b, φ x

/--
`ULI_06a` is the necessity half of the textbook two-sided step-envelope
criterion for Riemann integrability.

Source anchor: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Chapter II, Section IV, pp. 33-35, on Darboux
upper/lower integrals, together with the unnumbered Chapter VII, Section IV
constructive-integral proposition on pp. 113-115, beginning with "Toute
fonction mesurable bornee est sommable"; local theorem ID `ULI_06a`.
-/
axiom exists_step_bounds_integral_gap_lt_of_riemannIntegrable {f : ℝ → ℝ} {a b : ℝ}
    (hf : TextbookBoundedOnInterval f a b) (h : RiemannIntegrableOn f a b) :
    ∀ ε > 0, ∃ φ ψ : SimpleFunc ℝ ℝ,
      (∀ x ∈ Set.uIcc a b, φ x ≤ f x ∧ f x ≤ ψ x) ∧
        stepIntegral a b ψ - stepIntegral a b φ < ε

/--
`ULI_06b` is the sufficiency half of the textbook two-sided step-envelope
criterion for Riemann integrability.

Source anchor: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Chapter II, Section IV, pp. 33-35, on Darboux
upper/lower integrals, together with the unnumbered Chapter VII, Section IV
constructive-integral proposition on pp. 113-115, beginning with "Toute
fonction mesurable bornee est sommable"; local theorem ID `ULI_06b`.
-/
axiom riemannIntegrable_of_exists_step_bounds_integral_gap_lt {f : ℝ → ℝ} {a b : ℝ}
    (hf : TextbookBoundedOnInterval f a b)
    (hstep :
      ∀ ε > 0, ∃ φ ψ : SimpleFunc ℝ ℝ,
        (∀ x ∈ Set.uIcc a b, φ x ≤ f x ∧ f x ≤ ψ x) ∧
          stepIntegral a b ψ - stepIntegral a b φ < ε) :
    RiemannIntegrableOn f a b

/--
`ULI_06` is the textbook two-sided step-envelope criterion for Riemann
integrability, assembled from its two upstream-narrow directions.

Source anchor: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Chapter II, Section IV, pp. 33-35, and the
unnumbered Chapter VII, Section IV constructive-integral proposition on
pp. 113-115.
-/
theorem exists_step_bounds_integral_gap_lt_iff {f : ℝ → ℝ} {a b : ℝ}
    (hf : TextbookBoundedOnInterval f a b) :
    RiemannIntegrableOn f a b ↔
      ∀ ε > 0, ∃ φ ψ : SimpleFunc ℝ ℝ,
        (∀ x ∈ Set.uIcc a b, φ x ≤ f x ∧ f x ≤ ψ x) ∧
          stepIntegral a b ψ - stepIntegral a b φ < ε :=
  ⟨exists_step_bounds_integral_gap_lt_of_riemannIntegrable hf,
    riemannIntegrable_of_exists_step_bounds_integral_gap_lt hf⟩

end Riemann
end Analysis
end MathlibExpansion
