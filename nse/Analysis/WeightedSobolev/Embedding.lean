import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic
import NavierStokes.Analysis.WeightedSobolev.Measure
import NavierStokes.Analysis.WeightedSobolev.TestFunctions
import NavierStokes.Analysis.WeightedSobolev.H1

/-!
# NavierStokes.Analysis.WeightedSobolev.Embedding

Continuous embedding `weightedH1 ↪ L²(weightedMeasure)`.

Since `weightedH1` is defined as a `Submodule ℝ (Lp ℝ 2 weightedMeasure)`
(closure-first, scalar-first, ambient-first), the embedding into the ambient
`Lp ℝ 2 weightedMeasure` is precisely the submodule subtype map — a
continuous linear map by construction.  Hence the "continuous embedding"
property is immediate and carries zero axiom cost.

No new axioms.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real
open scoped ENNReal NNReal

namespace NavierStokes.Analysis.WeightedSobolev

open NavierStokes.Geometry.Cylindrical

/-- The canonical continuous linear embedding `weightedH1 ↪ Lp ℝ 2 weightedMeasure`.
    This is the submodule subtype as a `ContinuousLinearMap`. -/
noncomputable def weightedH1Embedding :
    weightedH1 →L[ℝ] Lp ℝ 2 weightedMeasure :=
  (weightedH1.subtypeL : weightedH1 →L[ℝ] Lp ℝ 2 weightedMeasure)

/-- The embedding `weightedH1 ↪ Lp ℝ 2 weightedMeasure` is continuous. -/
theorem weightedH1_continuousInclusion_L2 :
    Continuous (fun u : weightedH1 => (u.1 : Lp ℝ 2 weightedMeasure)) :=
  continuous_subtype_val

/-- The embedding is the underlying map of the `ContinuousLinearMap` above. -/
@[simp] lemma weightedH1Embedding_apply (u : weightedH1) :
    weightedH1Embedding u = (u.1 : Lp ℝ 2 weightedMeasure) := rfl

/-- Injectivity of the embedding (submodule subtype is always injective). -/
theorem weightedH1Embedding_injective : Function.Injective weightedH1Embedding := by
  intro u v h
  exact Subtype.ext h

end NavierStokes.Analysis.WeightedSobolev

end
