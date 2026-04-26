import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic

/-!
# NavierStokes.Analysis.WeightedSobolev.Measure

Weighted Lebesgue measure on `E3 = ℝ × ℝ × ℝ` with density `rCyl = √(x² + y²)`,
restricted to `puncturedSpace = E3 \ zAxis`.

Scope: closure-first, scalar-first, ambient-first (post-recon boardroom
`board-ans-b3-postrecon-20260421-01` round 1 CONSENSUS).

No new axioms.  The σ-finiteness is provided by the Mathlib instance
`MeasureTheory.SigmaFinite.withDensity_ofReal` applied to the already σ-finite
`volume.restrict puncturedSpace`.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real
open scoped ENNReal NNReal

namespace NavierStokes.Analysis.WeightedSobolev

open NavierStokes.Geometry.Cylindrical

/-! ## Measurability of the cylindrical radius -/

/-- `rCyl` is continuous on all of `E3` (no restriction needed —
    `√(x² + y²)` is continuous on `ℝ²` and hence on `E3` by projection). -/
lemma continuous_rCyl : Continuous rCyl := by
  unfold rCyl; fun_prop

/-- `rCyl` is Borel-measurable. -/
lemma measurable_rCyl : Measurable rCyl :=
  continuous_rCyl.measurable

/-- `puncturedSpace` is a Borel-measurable set (it is open). -/
lemma measurableSet_puncturedSpace : MeasurableSet puncturedSpace :=
  isOpen_puncturedSpace.measurableSet

/-! ## Weighted Lebesgue measure -/

/-- Weighted Lebesgue measure on `E3`: Lebesgue restricted to the punctured
    space and re-weighted by the cylindrical radius `rCyl = √(x² + y²)`.
    This is the base measure for the weighted Sobolev spaces. -/
def weightedMeasure : Measure E3 :=
  (volume.restrict puncturedSpace).withDensity
    (fun p => ENNReal.ofReal (rCyl p))

/-- σ-finiteness of `weightedMeasure`.  `volume.restrict puncturedSpace`
    is σ-finite (restriction preserves σ-finiteness), and
    `SigmaFinite.withDensity_ofReal` shows that the `ENNReal.ofReal`-density
    with a real-valued density preserves σ-finiteness. -/
instance instSigmaFiniteWeightedMeasure : SigmaFinite weightedMeasure := by
  unfold weightedMeasure
  infer_instance

end NavierStokes.Analysis.WeightedSobolev

end
