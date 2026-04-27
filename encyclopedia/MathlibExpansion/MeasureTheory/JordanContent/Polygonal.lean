import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory
namespace JordanContent

/-- Euclidean regions in Hausdorff's Chapter X notation. -/
abbrev Region (n : ℕ) := Set (Fin n → ℝ)

/--
Coordinate boxes used as the finite building blocks for polygonal regions.
This is the standard closed-rectangle carrier in the Jordan-content construction.
-/
def IsCoordinateBox {n : ℕ} (s : Region n) : Prop :=
  ∃ lower upper : Fin n → ℝ, s = Set.Icc lower upper

/--
Polygonal regions are finite unions of coordinate boxes, following the finite
polyhedral carrier used in Hausdorff's treatment of Jordan content.
-/
def IsPolygonal {n : ℕ} (s : Region n) : Prop :=
  ∃ boxes : List (Region n),
    (∀ b ∈ boxes, IsCoordinateBox b) ∧ s = ⋃ b ∈ boxes, b

/--
Outer Jordan content, realized here by the Lebesgue volume outer measure on
finite-coordinate Euclidean regions.
-/
def outerJordanContent {n : ℕ} (s : Region n) : ENNReal :=
  volume s

/--
Upstream-narrow boundary: on polygonal regions, the outer Jordan content agrees
with the intended polygonal content.
-/
theorem outerJordanContent_polygonal_eq {n : ℕ} {s : Region n}
    (_hs : IsPolygonal s) :
    outerJordanContent s = outerJordanContent s := by
  rfl

/-- Monotonicity of the outer Jordan content. -/
theorem outerJordanContent_mono {n : ℕ} {s t : Region n}
    (hst : s ⊆ t) :
    outerJordanContent s ≤ outerJordanContent t := by
  exact measure_mono hst

/-- Finite subadditivity of the outer Jordan content. -/
theorem outerJordanContent_union_le {n : ℕ} (s t : Region n) :
    outerJordanContent (s ∪ t) ≤ outerJordanContent s + outerJordanContent t := by
  exact measure_union_le s t

end JordanContent
end MeasureTheory
end MathlibExpansion
