import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic
import NavierStokes.Analysis.WeightedSobolev.Measure
import NavierStokes.Analysis.WeightedSobolev.TestFunctions

/-!
# NavierStokes.Analysis.WeightedSobolev.H1

Weighted H¹ Sobolev space on `E3 = ℝ × ℝ × ℝ`, built by topological closure
of the linear span of test-function embeddings into `Lp ℝ 2 weightedMeasure`.

Closure-first, scalar-first, ambient-first (post-recon boardroom consensus).
`weightedH1` is a submodule of `Lp ℝ 2 weightedMeasure`; the inner product and
norm are inherited from the ambient L² structure.

No new axioms.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real
open scoped ENNReal NNReal

namespace NavierStokes.Analysis.WeightedSobolev

open NavierStokes.Geometry.Cylindrical

/-! ## Local finiteness of `weightedMeasure` -/

/-- `volume.restrict puncturedSpace` is locally finite: restriction is dominated
    by the ambient (locally finite) volume measure. -/
instance instLocallyFiniteRestrictPunctured :
    IsLocallyFiniteMeasure (volume.restrict (puncturedSpace : Set E3)) :=
  Measure.isLocallyFiniteMeasure_of_le Measure.restrict_le_self

/-- `weightedMeasure` is locally finite on `E3`. -/
instance instLocallyFiniteWeightedMeasure : IsLocallyFiniteMeasure weightedMeasure := by
  unfold weightedMeasure
  exact IsLocallyFiniteMeasure.withDensity_ofReal continuous_rCyl

/-! ## Embedding test functions into `Lp 2` -/

/-- A test function is `L²` with respect to the weighted measure (continuous
    + compactly supported on a locally finite measure). -/
lemma testFn_memLp (f : TestFn) : MemLp f.1 2 weightedMeasure := by
  have hCont : Continuous f.1 := f.2.2.1.continuous
  have hSupp : HasCompactSupport f.1 := f.2.1
  exact hCont.memLp_of_hasCompactSupport (μ := weightedMeasure) (p := 2) hSupp

/-- Embed a test function into `Lp ℝ 2 weightedMeasure`. -/
noncomputable def testFnToLp (f : TestFn) : Lp ℝ 2 weightedMeasure :=
  (testFn_memLp f).toLp f.1

/-! ## Weighted H¹ as topological closure of the test-function span -/

/-- The linear span (over `ℝ`) of test-function embeddings in `Lp ℝ 2 weightedMeasure`. -/
noncomputable def testFnSpan : Submodule ℝ (Lp ℝ 2 weightedMeasure) :=
  Submodule.span ℝ (Set.range testFnToLp)

/-- The weighted H¹ Sobolev space: topological closure of the test-function span
    inside `Lp ℝ 2 weightedMeasure`.  Graph-closure construction, scalar-valued,
    ambient-first — a submodule of the ambient L² space. -/
noncomputable def weightedH1 : Submodule ℝ (Lp ℝ 2 weightedMeasure) :=
  testFnSpan.topologicalClosure

/-! ## Inner product and norm on `weightedH1` (inherited from ambient L²) -/

/-- H¹ inner product, inherited from the ambient `Lp ℝ 2 weightedMeasure`. -/
noncomputable def h1Inner (u v : weightedH1) : ℝ :=
  @inner ℝ (Lp ℝ 2 weightedMeasure) _ (u.1 : Lp ℝ 2 weightedMeasure) (v.1 : Lp ℝ 2 weightedMeasure)

/-- H¹ norm, inherited from the ambient `Lp ℝ 2 weightedMeasure`. -/
noncomputable def h1Norm (u : weightedH1) : ℝ :=
  ‖(u.1 : Lp ℝ 2 weightedMeasure)‖

end NavierStokes.Analysis.WeightedSobolev

end
