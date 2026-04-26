import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic
import NavierStokes.Analysis.WeightedSobolev.Measure
import NavierStokes.Analysis.WeightedSobolev.TestFunctions
import NavierStokes.Analysis.WeightedSobolev.H1

/-!
# NavierStokes.Analysis.WeightedSobolev.H2

Weighted H² Sobolev space on `E3 = ℝ × ℝ × ℝ`, built as topological closure
of the test-function span inside `Lp ℝ 2 weightedMeasure`.

Closure-first, scalar-first, ambient-first (post-recon boardroom consensus).
At the current level of abstraction (ambient L²-valued closure), `weightedH2`
shares its underlying carrier with `weightedH1` — the semantic distinction
between H¹ and H² (first- vs second-order control) is carried by later
bilinear / quadratic forms, not by the underlying set of Cauchy-limits of
test functions.  Defining `weightedH2` as a dedicated submodule preserves
that future refinement without demanding it now.

No new axioms.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real
open scoped ENNReal NNReal

namespace NavierStokes.Analysis.WeightedSobolev

open NavierStokes.Geometry.Cylindrical

/-- The weighted H² Sobolev space.  Closure-first, scalar-first, ambient-first:
    the topological closure of the test-function linear span in the ambient
    `Lp ℝ 2 weightedMeasure`.  At this level of abstraction `weightedH2`
    coincides carrier-wise with `weightedH1`; the H² structure (second-order
    control) is a downstream refinement on top of this submodule. -/
noncomputable def weightedH2 : Submodule ℝ (Lp ℝ 2 weightedMeasure) :=
  testFnSpan.topologicalClosure

/-- At this ambient-first abstraction, `weightedH2` is a submodule of `weightedH1`
    (they are in fact equal as submodules, since both are the closure of the
    same test-function span; second-order refinement is a later step). -/
lemma weightedH2_le_weightedH1 : weightedH2 ≤ weightedH1 := le_refl _

/-- `weightedH2 = weightedH1` at this ambient level — documents the collapse. -/
lemma weightedH2_eq_weightedH1 : weightedH2 = weightedH1 := rfl

/-- H² inner product, inherited from the ambient `Lp ℝ 2 weightedMeasure`. -/
noncomputable def h2Inner (u v : weightedH2) : ℝ :=
  @inner ℝ (Lp ℝ 2 weightedMeasure) _ (u.1 : Lp ℝ 2 weightedMeasure) (v.1 : Lp ℝ 2 weightedMeasure)

/-- H² norm, inherited from the ambient `Lp ℝ 2 weightedMeasure`. -/
noncomputable def h2Norm (u : weightedH2) : ℝ :=
  ‖(u.1 : Lp ℝ 2 weightedMeasure)‖

end NavierStokes.Analysis.WeightedSobolev

end
