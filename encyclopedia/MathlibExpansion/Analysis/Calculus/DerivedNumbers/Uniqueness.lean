import Mathlib.Data.Real.Basic

import Mathlib.Data.Set.Countable
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import MathlibExpansion.Analysis.Calculus.DerivedNumbers

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Analysis
namespace Calculus
namespace DerivedNumbers

/--
`FODN_02`: Scheeffer-style countable exceptional-set uniqueness.

Citation: Henri Lebesgue, *Leçons sur l'intégration et la recherche des
fonctions primitives* (1904), Ch. V, § III, pp. 75-76, the unnumbered
"théorème de Scheeffer"; upstream source Ludwig Scheeffer,
*Zur Theorie der stetigen Funktionen einer reellen Veränderlichen*,
Acta Mathematica 5 (1884), Part I, Satz II, pp. 183-194, and Part II,
pp. 279-296.
-/
axiom eq_add_const_of_rightUpperDeriv_eq_off_countable {f g : ℝ → ℝ} {a b : ℝ} {E : Set ℝ}
    (hf : ContinuousOn f (Set.uIcc a b)) (hg : ContinuousOn g (Set.uIcc a b))
    (hEq : ∀ x ∈ Set.uIcc a b, x ∉ E → upperRightDeriv f x = upperRightDeriv g x)
    (hfin : ∀ x ∈ Set.uIcc a b, x ∉ E →
      upperRightDeriv f x ≠ ⊤ ∧ upperRightDeriv f x ≠ ⊥ ∧
        upperRightDeriv g x ≠ ⊤ ∧ upperRightDeriv g x ≠ ⊥)
    (hE : E.Countable) :
    ∃ c : ℝ, Set.EqOn f (fun x => g x + c) (Set.uIcc a b)

/--
`FODN_01`: one finite right upper derived number determines a continuous
function up to an additive constant.

Citation: Henri Lebesgue, *Leçons sur l'intégration et la recherche des
fonctions primitives* (1904), Ch. V, § III, pp. 74-75, unnumbered
proposition "Notre proposition est démontrée"; also Scheeffer,
*Zur Theorie der stetigen Funktionen einer reellen Veränderlichen*,
Acta Mathematica 5 (1884), Part II, Satz I, pp. 279-296.
-/
theorem eq_add_const_of_rightUpperDeriv_eq_everywhere {f g : ℝ → ℝ} {a b : ℝ}
    (hf : ContinuousOn f (Set.uIcc a b)) (hg : ContinuousOn g (Set.uIcc a b))
    (hEq : ∀ x ∈ Set.uIcc a b, upperRightDeriv f x = upperRightDeriv g x)
    (hfin : ∀ x ∈ Set.uIcc a b,
      upperRightDeriv f x ≠ ⊤ ∧ upperRightDeriv f x ≠ ⊥ ∧
        upperRightDeriv g x ≠ ⊤ ∧ upperRightDeriv g x ≠ ⊥) :
    ∃ c : ℝ, Set.EqOn f (fun x => g x + c) (Set.uIcc a b) := by
  refine eq_add_const_of_rightUpperDeriv_eq_off_countable
    (E := (∅ : Set ℝ)) hf hg ?_ ?_ Set.countable_empty
  · intro x hx _
    exact hEq x hx
  · intro x hx _
    exact hfin x hx

/--
`FODN_04`: null exceptional-set uniqueness under bounded derived numbers.

Citation: Henri Lebesgue, *Leçons sur l'intégration et la recherche des
fonctions primitives* (1904), Ch. V, § III, pp. 78-79, unnumbered
bounded-derived-numbers/null-exception proposition following the
Scheeffer theorem.
-/
axiom eq_add_const_of_rightUpperDeriv_eq_off_null_of_bounded
    {f g : ℝ → ℝ} {a b : ℝ} {E : Set ℝ}
    (hf : ContinuousOn f (Set.uIcc a b)) (hg : ContinuousOn g (Set.uIcc a b))
    (hEq : ∀ x ∈ Set.uIcc a b, x ∉ E → upperRightDeriv f x = upperRightDeriv g x)
    (hbound : ∃ M : ℝ,
      ∀ x ∈ Set.uIcc a b, x ∉ E →
        upperRightDeriv f x ≤ (M : EReal) ∧ upperRightDeriv g x ≤ (M : EReal))
    (hE : volume E = 0) :
    ∃ c : ℝ, Set.EqOn f (fun x => g x + c) (Set.uIcc a b)

end DerivedNumbers
end Calculus
end Analysis
end MathlibExpansion
