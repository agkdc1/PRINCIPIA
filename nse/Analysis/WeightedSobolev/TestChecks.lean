import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic
import NavierStokes.Analysis.WeightedSobolev.Measure
import NavierStokes.Analysis.WeightedSobolev.TestFunctions
import NavierStokes.Analysis.WeightedSobolev.H1
import NavierStokes.Analysis.WeightedSobolev.H2
import NavierStokes.Analysis.WeightedSobolev.Embedding

/-!
# NavierStokes.Analysis.WeightedSobolev.TestChecks

Smoke-tests + axiom prints for the weighted Sobolev stack.

The `#print axioms` commands are kept here (not in the primary API files) so
the main stack stays pure elaborate-only; the checks file is where we log
the axiom dependency graph.  No new axioms introduced by this file.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real
open scoped ENNReal NNReal

namespace NavierStokes.Analysis.WeightedSobolev

open NavierStokes.Geometry.Cylindrical

/-! ## Smoke tests -/

/-- `weightedMeasure` is `SigmaFinite`. -/
example : SigmaFinite weightedMeasure := inferInstance

/-- `weightedMeasure` is `IsLocallyFiniteMeasure`. -/
example : IsLocallyFiniteMeasure weightedMeasure := inferInstance

/-- The zero test function exists. -/
example : TestFn := (0 : TestFn)

/-- Scalar multiplication preserves `TestFn`. -/
example (c : ℝ) (f : TestFn) : TestFn := c • f

/-- Addition preserves `TestFn`. -/
example (f g : TestFn) : TestFn := f + g

/-- Negation preserves `TestFn`. -/
example (f : TestFn) : TestFn := -f

/-- Test-function embedding lands in `Lp ℝ 2 weightedMeasure`. -/
example (f : TestFn) : Lp ℝ 2 weightedMeasure := testFnToLp f

/-- `weightedH1` is a submodule of `Lp ℝ 2 weightedMeasure`. -/
example : Submodule ℝ (Lp ℝ 2 weightedMeasure) := weightedH1

/-- `weightedH2` is a submodule of `Lp ℝ 2 weightedMeasure`. -/
example : Submodule ℝ (Lp ℝ 2 weightedMeasure) := weightedH2

/-- `weightedH2 ≤ weightedH1`. -/
example : weightedH2 ≤ weightedH1 := weightedH2_le_weightedH1

/-- The continuous inclusion `weightedH1 ↪ Lp ℝ 2 weightedMeasure`. -/
example : Continuous (fun u : weightedH1 => (u.1 : Lp ℝ 2 weightedMeasure)) :=
  weightedH1_continuousInclusion_L2

/-- The embedding as a `ContinuousLinearMap`. -/
example : weightedH1 →L[ℝ] Lp ℝ 2 weightedMeasure := weightedH1Embedding

/-- The embedding is injective. -/
example : Function.Injective weightedH1Embedding := weightedH1Embedding_injective

/-! ## Axiom prints -/

#print axioms weightedMeasure
#print axioms instSigmaFiniteWeightedMeasure
#print axioms instLocallyFiniteWeightedMeasure
#print axioms TestFn
#print axioms testFnToLp
#print axioms testFnSpan
#print axioms weightedH1
#print axioms weightedH2
#print axioms weightedH2_le_weightedH1
#print axioms weightedH1Embedding
#print axioms weightedH1_continuousInclusion_L2
#print axioms weightedH1Embedding_injective

end NavierStokes.Analysis.WeightedSobolev

end
