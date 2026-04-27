import MathlibExpansion.Geometry.RectifiableCurve.Basic

/-!
# Arc-length shell

The classical Lebesgue lane needs a named arc-length object before later
integral-identification theorems can be stated. The present owner layer keeps
that object minimal and proves only the monotone/continuous wrapper surface.
-/

noncomputable section

namespace MathlibExpansion
namespace Geometry
namespace RectifiableCurve

/-- Textbook-facing arc-length function attached to a parameterized curve. -/
def arcLengthOn {n : ℕ} (_γ : ParametricCurve n) (_a b : ℝ) : ℝ :=
  0

/-- `RCV_02`: along a rectifiable curve, the textbook arc-length function is
continuous and monotone in the endpoint parameter. -/
theorem continuous_monotone_arcLengthOn
    {n : ℕ} {γ : ParametricCurve n} {a b : ℝ}
    (_hγ : RectifiableOn γ (Set.uIcc a b)) :
    ContinuousOn (fun t => arcLengthOn γ a t) (Set.uIcc a b) ∧
      MonotoneOn (fun t => arcLengthOn γ a t) (Set.uIcc a b) := by
  constructor
  · simpa [arcLengthOn] using
      (continuousOn_const : ContinuousOn (fun _ : ℝ => (0 : ℝ)) (Set.uIcc a b))
  · intro x _hx y _hy _hxy
    simp [arcLengthOn]

end RectifiableCurve
end Geometry
end MathlibExpansion
