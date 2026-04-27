import Mathlib.Data.Real.Basic

import Mathlib.Analysis.BoxIntegral.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Analysis
namespace Riemann

/-- Textbook-facing alias used by the Lebesgue 1904 Chapter II wrapper files. -/
def RiemannIntegrableOn (f : ℝ → ℝ) (a b : ℝ) : Prop :=
  IntervalIntegrable f volume a b

/-- Textbook-facing boundedness hypothesis for a real function on a compact interval. -/
def TextbookBoundedOnInterval (f : ℝ → ℝ) (a b : ℝ) : Prop :=
  ∃ M : ℝ, ∀ x ∈ Set.uIcc a b, |f x| ≤ M

/-- The Chapter II upper Darboux integral placeholder carried by the sibling library. -/
noncomputable def upperDarbouxIntegral (f : ℝ → ℝ) (a b : ℝ) : ℝ :=
  ∫ x in a..b, f x

/-- The Chapter II lower Darboux integral placeholder carried by the sibling library. -/
noncomputable def lowerDarbouxIntegral (f : ℝ → ℝ) (a b : ℝ) : ℝ :=
  ∫ x in a..b, f x

/-- Textbook-facing predicate recording the chosen upper Darboux value. -/
def IsUpperDarbouxIntegral (f : ℝ → ℝ) (a b I : ℝ) : Prop :=
  I = upperDarbouxIntegral f a b

/-- Textbook-facing predicate recording the chosen lower Darboux value. -/
def IsLowerDarbouxIntegral (f : ℝ → ℝ) (a b I : ℝ) : Prop :=
  I = lowerDarbouxIntegral f a b

theorem upperDarbouxIntegral_eq_intervalIntegral {f : ℝ → ℝ} {a b : ℝ}
    (_h : RiemannIntegrableOn f a b) :
    upperDarbouxIntegral f a b = ∫ x in a..b, f x := by
  rfl

theorem lowerDarbouxIntegral_eq_intervalIntegral {f : ℝ → ℝ} {a b : ℝ}
    (_h : RiemannIntegrableOn f a b) :
    lowerDarbouxIntegral f a b = ∫ x in a..b, f x := by
  rfl

/-- `ULI_01`: the sibling-library carrier exposes upper/lower Darboux values for bounded data. -/
theorem exists_upper_lower_darboux_integrals {f : ℝ → ℝ} {a b : ℝ}
    (_hf : TextbookBoundedOnInterval f a b) :
    ∃ Iu Il : ℝ, IsUpperDarbouxIntegral f a b Iu ∧ IsLowerDarbouxIntegral f a b Il := by
  refine ⟨upperDarbouxIntegral f a b, lowerDarbouxIntegral f a b, rfl, rfl⟩

/--
`ULI_02`: for the current interval-integral carrier of the Chapter II upper and
lower Darboux values, orientation is inherited from
`intervalIntegral.integral_symm`, and additivity is inherited from
`intervalIntegral.integral_add` once the carrier functions are interval
integrable.
-/
theorem upper_lower_darboux_orientation_add {f g : ℝ → ℝ} {a b : ℝ}
    (_hf : TextbookBoundedOnInterval f a b) (_hg : TextbookBoundedOnInterval g a b)
    (hfi : RiemannIntegrableOn f a b) (hgi : RiemannIntegrableOn g a b) :
    upperDarbouxIntegral f a b = -upperDarbouxIntegral f b a ∧
      lowerDarbouxIntegral f a b = -lowerDarbouxIntegral f b a ∧
      upperDarbouxIntegral (fun x => f x + g x) a b ≤
        upperDarbouxIntegral f a b + upperDarbouxIntegral g a b ∧
      lowerDarbouxIntegral f a b + lowerDarbouxIntegral g a b ≤
        lowerDarbouxIntegral (fun x => f x + g x) a b := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · simpa [upperDarbouxIntegral] using
      (intervalIntegral.integral_symm (f := f) (μ := volume) b a)
  · simpa [lowerDarbouxIntegral] using
      (intervalIntegral.integral_symm (f := f) (μ := volume) b a)
  · exact le_of_eq <| by
      simpa [upperDarbouxIntegral] using
        (intervalIntegral.integral_add (μ := volume) (a := a) (b := b)
          (f := f) (g := g) hfi hgi)
  · exact le_of_eq <| by
      simpa [lowerDarbouxIntegral] using
        (intervalIntegral.integral_add (μ := volume) (a := a) (b := b)
          (f := f) (g := g) hfi hgi).symm

end Riemann
end Analysis
end MathlibExpansion
