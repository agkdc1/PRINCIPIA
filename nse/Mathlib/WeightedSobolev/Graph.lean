import Mathlib
import NavierStokes.Analysis.WeightedSobolev.Measure
import NavierStokes.Analysis.WeightedSobolev.TestFunctions

/-!
# NavierStokes.Mathlib.WeightedSobolev.Graph

Opening tranche for the weighted Sobolev graph carrier used by the parabolic
Route W campaign.

The carrier is a structure, not a closure-only submodule: it stores a scalar
field together with two candidate weak-gradient components and the weighted
`L²` witnesses for all three fields.

No new axioms.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real
open scoped ENNReal NNReal

namespace NavierStokes.Mathlib.WeightedSobolev

open NavierStokes.Geometry.Cylindrical
open NavierStokes.Analysis.WeightedSobolev

/-- Structure-level weighted Sobolev graph carrier with explicit radial and
vertical gradient slots. -/
structure Graph where
  val : E3 → ℝ
  dR : E3 → ℝ
  dZ : E3 → ℝ
  memLp_val : MemLp val 2 weightedMeasure
  memLp_dR : MemLp dR 2 weightedMeasure
  memLp_dZ : MemLp dZ 2 weightedMeasure

namespace Graph

instance : CoeFun Graph (fun _ => E3 → ℝ) := ⟨Graph.val⟩

/-- The value field as an element of weighted `L²`. -/
noncomputable def valLp (u : Graph) : Lp ℝ 2 weightedMeasure :=
  u.memLp_val.toLp u.val

/-- The radial graph component as an element of weighted `L²`. -/
noncomputable def dRLp (u : Graph) : Lp ℝ 2 weightedMeasure :=
  u.memLp_dR.toLp u.dR

/-- The vertical graph component as an element of weighted `L²`. -/
noncomputable def dZLp (u : Graph) : Lp ℝ 2 weightedMeasure :=
  u.memLp_dZ.toLp u.dZ

/-- Quadratic graph norm on the opening-tranche carrier. -/
noncomputable def graphNormSq (u : Graph) : ℝ :=
  ‖u.valLp‖ ^ 2 + ‖u.dRLp‖ ^ 2 + ‖u.dZLp‖ ^ 2

/-- Euclidean graph norm on the three weighted `L²` slots. -/
noncomputable def graphNorm (u : Graph) : ℝ :=
  Real.sqrt (graphNormSq u)

lemma graphNormSq_nonneg (u : Graph) : 0 ≤ u.graphNormSq := by
  dsimp [graphNormSq]
  positivity

lemma graphNorm_nonneg (u : Graph) : 0 ≤ u.graphNorm := by
  exact Real.sqrt_nonneg _

/-- Weighted pairing against the existing off-axis test-function surface. -/
noncomputable def pairing (f : E3 → ℝ) (φ : TestFn) : ℝ :=
  ∫ p, f p * φ p ∂ weightedMeasure

/-- Pairing of the graph value field against an off-axis test function. -/
noncomputable def pairingVal (u : Graph) (φ : TestFn) : ℝ :=
  pairing u.val φ

/-- Pairing of the radial graph slot against an off-axis test function. -/
noncomputable def pairingDR (u : Graph) (φ : TestFn) : ℝ :=
  pairing u.dR φ

/-- Pairing of the vertical graph slot against an off-axis test function. -/
noncomputable def pairingDZ (u : Graph) (φ : TestFn) : ℝ :=
  pairing u.dZ φ

instance : Zero Graph where
  zero :=
    { val := 0
      dR := 0
      dZ := 0
      memLp_val := by simp
      memLp_dR := by simp
      memLp_dZ := by simp }

instance : Add Graph where
  add u v :=
    { val := u.val + v.val
      dR := u.dR + v.dR
      dZ := u.dZ + v.dZ
      memLp_val := u.memLp_val.add v.memLp_val
      memLp_dR := u.memLp_dR.add v.memLp_dR
      memLp_dZ := u.memLp_dZ.add v.memLp_dZ }

instance : Neg Graph where
  neg u :=
    { val := -u.val
      dR := -u.dR
      dZ := -u.dZ
      memLp_val := u.memLp_val.neg
      memLp_dR := u.memLp_dR.neg
      memLp_dZ := u.memLp_dZ.neg }

instance : SMul ℝ Graph where
  smul c u :=
    { val := c • u.val
      dR := c • u.dR
      dZ := c • u.dZ
      memLp_val := u.memLp_val.const_smul c
      memLp_dR := u.memLp_dR.const_smul c
      memLp_dZ := u.memLp_dZ.const_smul c }

@[simp] theorem zero_val : (0 : Graph).val = 0 := rfl
@[simp] theorem zero_dR : (0 : Graph).dR = 0 := rfl
@[simp] theorem zero_dZ : (0 : Graph).dZ = 0 := rfl

@[simp] theorem add_val (u v : Graph) : (u + v).val = u.val + v.val := rfl
@[simp] theorem add_dR (u v : Graph) : (u + v).dR = u.dR + v.dR := rfl
@[simp] theorem add_dZ (u v : Graph) : (u + v).dZ = u.dZ + v.dZ := rfl

@[simp] theorem neg_val (u : Graph) : (-u).val = -u.val := rfl
@[simp] theorem neg_dR (u : Graph) : (-u).dR = -u.dR := rfl
@[simp] theorem neg_dZ (u : Graph) : (-u).dZ = -u.dZ := rfl

@[simp] theorem smul_val (c : ℝ) (u : Graph) : (c • u).val = c • u.val := rfl
@[simp] theorem smul_dR (c : ℝ) (u : Graph) : (c • u).dR = c • u.dR := rfl
@[simp] theorem smul_dZ (c : ℝ) (u : Graph) : (c • u).dZ = c • u.dZ := rfl

end Graph

end NavierStokes.Mathlib.WeightedSobolev

end
