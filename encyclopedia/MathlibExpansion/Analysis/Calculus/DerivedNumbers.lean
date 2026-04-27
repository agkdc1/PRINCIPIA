import Mathlib.Data.Real.Basic

import Mathlib.Analysis.Calculus.Deriv.Slope
import Mathlib.Data.Real.EReal
import Mathlib.Order.LiminfLimsup

noncomputable section

open Filter

namespace MathlibExpansion
namespace Analysis
namespace Calculus

/-- Secant slopes viewed in `EReal` for Chapter V derived-number formulas. -/
noncomputable def erealSlope (f : ℝ → ℝ) (x z : ℝ) : EReal :=
  (slope f x z : ℝ)

/-- Lebesgue's lower right derived number. -/
noncomputable def lowerRightDerived (f : ℝ → ℝ) (x : ℝ) : EReal :=
  Filter.liminf (fun z : ℝ => erealSlope f x z) (nhdsWithin x (Set.Ioi x))

/-- Lebesgue's upper right derived number. -/
noncomputable def upperRightDerived (f : ℝ → ℝ) (x : ℝ) : EReal :=
  Filter.limsup (fun z : ℝ => erealSlope f x z) (nhdsWithin x (Set.Ioi x))

/-- Lebesgue's lower left derived number. -/
noncomputable def lowerLeftDerived (f : ℝ → ℝ) (x : ℝ) : EReal :=
  Filter.liminf (fun z : ℝ => erealSlope f x z) (nhdsWithin x (Set.Iio x))

/-- Lebesgue's upper left derived number. -/
noncomputable def upperLeftDerived (f : ℝ → ℝ) (x : ℝ) : EReal :=
  Filter.limsup (fun z : ℝ => erealSlope f x z) (nhdsWithin x (Set.Iio x))

abbrev lowerRightDeriv := lowerRightDerived
abbrev upperRightDeriv := upperRightDerived
abbrev lowerLeftDeriv := lowerLeftDerived
abbrev upperLeftDeriv := upperLeftDerived

end Calculus
end Analysis
end MathlibExpansion
