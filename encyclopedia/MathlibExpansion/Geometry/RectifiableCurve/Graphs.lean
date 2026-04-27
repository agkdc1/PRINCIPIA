import MathlibExpansion.Geometry.RectifiableCurve.Basic

/-!
# Graph rectifiability wrappers
-/

noncomputable section

namespace MathlibExpansion
namespace Geometry
namespace RectifiableCurve

/-- Graph curve of a real function on an interval. -/
def graphCurve (f : ℝ → ℝ) : ParametricCurve 2 :=
  fun x i => Fin.cases x (fun _ => f x) i

/-- `RCV_04`: the graph of a continuous bounded-variation function is
rectifiable in the textbook boundary layer. -/
theorem rectifiableOn_graph_of_continuous_bv
    {f : ℝ → ℝ} {a b : ℝ}
    (_hcont : ContinuousOn f (Set.uIcc a b))
    (hbv : BoundedVariationOn f (Set.uIcc a b)) :
    RectifiableOn (graphCurve f) (Set.uIcc a b) := by
  intro i
  fin_cases i
  · simpa [graphCurve] using
      (@monotoneOn_id ℝ _ (Set.uIcc a b)).locallyBoundedVariationOn
  · simpa [graphCurve] using hbv.locallyBoundedVariationOn

end RectifiableCurve
end Geometry
end MathlibExpansion
