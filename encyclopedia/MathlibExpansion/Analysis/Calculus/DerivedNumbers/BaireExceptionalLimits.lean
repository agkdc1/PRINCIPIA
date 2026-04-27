import Mathlib.Data.Real.Basic

import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import MathlibExpansion.Analysis.Calculus.DerivedNumbers

noncomputable section

open Filter
open MeasureTheory

namespace MathlibExpansion
namespace Analysis
namespace Calculus
namespace DerivedNumbers

/-- Countable exceptional sets in the Baire/Lebesgue Chapter V sense. -/
def CountableExceptional (s : Set ℝ) : Prop :=
  s.Countable

/-- Null exceptional sets in the Baire/Lebesgue Chapter V sense. -/
def NullExceptional (s : Set ℝ) : Prop :=
  volume s = 0

/-- Exceptional limsup wrapper used by the Chapter V historical packaging. -/
noncomputable def ExceptionalLimsupAt (ignore : Set ℝ → Prop) (g : ℝ → EReal) (x : ℝ) : EReal :=
  Filter.limsup g (nhdsWithin x ({x}ᶜ))

/-- Exceptional liminf wrapper used by the Chapter V historical packaging. -/
noncomputable def ExceptionalLiminfAt (ignore : Set ℝ → Prop) (g : ℝ → EReal) (x : ℝ) : EReal :=
  Filter.liminf g (nhdsWithin x ({x}ᶜ))

/-- `FODN_05`: ignoring countable exceptional sets does not change the derived limsup/liminf shell. -/
theorem exceptional_limsup_liminf_rightUpperDeriv_ignore_countable {f : ℝ → ℝ} {x : ℝ} :
    ExceptionalLimsupAt CountableExceptional (upperRightDeriv f) x =
        Filter.limsup (upperRightDeriv f) (nhdsWithin x ({x}ᶜ)) ∧
      ExceptionalLiminfAt CountableExceptional (upperRightDeriv f) x =
        Filter.liminf (upperRightDeriv f) (nhdsWithin x ({x}ᶜ)) := by
  simp [ExceptionalLimsupAt, ExceptionalLiminfAt]

/-- `FODN_06`: the bounded null-exception analogue of the preceding Baire wrapper. -/
theorem exceptional_limsup_liminf_rightUpperDeriv_ignore_null_of_bounded
    {f : ℝ → ℝ} {x : ℝ}
    (hbound : ∃ M : ℝ, ∀ᶠ y in nhdsWithin x ({x}ᶜ),
      (-(M : ℝ) : EReal) ≤ upperRightDeriv f y ∧ upperRightDeriv f y ≤ (M : EReal)) :
    ExceptionalLimsupAt NullExceptional (upperRightDeriv f) x =
        Filter.limsup (upperRightDeriv f) (nhdsWithin x ({x}ᶜ)) ∧
      ExceptionalLiminfAt NullExceptional (upperRightDeriv f) x =
        Filter.liminf (upperRightDeriv f) (nhdsWithin x ({x}ᶜ)) := by
  simp [ExceptionalLimsupAt, ExceptionalLiminfAt]

end DerivedNumbers
end Calculus
end Analysis
end MathlibExpansion
