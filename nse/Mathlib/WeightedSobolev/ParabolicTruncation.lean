import Mathlib
import NavierStokes.Mathlib.WeightedSobolev.Graph

/-!
# NavierStokes.Mathlib.WeightedSobolev.ParabolicTruncation

Positive-part truncation on the structure-level weighted Sobolev graph carrier.

This opening tranche records the admissible truncated value field
`(u - k)_+` for nonnegative levels `k`, together with the canonical
Marcus-Mizel candidate gradient slots `1_{u > k} dR` and `1_{u > k} dZ`.

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

namespace Graph

/-- Measurable hull of the superlevel set `{u > k}`. Using `toMeasurable` keeps
indicator-based `MemLp` arguments clean when `u` is only known a.e.-measurable. -/
def superlevelSet (u : Graph) (k : ℝ) : Set E3 :=
  toMeasurable weightedMeasure {p | k < u.val p}

lemma measurableSet_superlevelSet (u : Graph) (k : ℝ) :
    MeasurableSet (u.superlevelSet k) := by
  simp [superlevelSet]

lemma nullMeasurableSet_gt (u : Graph) (k : ℝ) :
    NullMeasurableSet {p : E3 | k < u.val p} weightedMeasure := by
  simpa [Set.preimage] using
    (u.memLp_val.1.aemeasurable.nullMeasurableSet_preimage
      (s := Set.Ioi k) measurableSet_Ioi)

lemma superlevelSet_ae_eq (u : Graph) (k : ℝ) :
    u.superlevelSet k =ᵐ[weightedMeasure] {p : E3 | k < u.val p} := by
  simpa [superlevelSet] using
    (NullMeasurableSet.toMeasurable_ae_eq (u.nullMeasurableSet_gt k))

/-- Generic indicator cutoff preserves weighted `L²`. -/
lemma memLp_indicator {s : Set E3} (hs : MeasurableSet s) {f : E3 → ℝ}
    (hf : MemLp f 2 weightedMeasure) :
    MemLp (s.indicator f) 2 weightedMeasure := by
  refine hf.of_le_mul (c := 1) ?_ (Filter.Eventually.of_forall ?_)
  · simpa using hf.1.indicator hs
  · intro x
    by_cases hx : x ∈ s
    · simp [Set.indicator_of_mem, hx]
    · simp [Set.indicator_of_not_mem, hx]

/-- The scalar positive-part truncation `(u - k)_+`. -/
def shiftedPosPart (u : Graph) (k : ℝ) : E3 → ℝ :=
  fun p => max (u.val p - k) 0

/-- The radial Marcus-Mizel candidate `1_{u > k} dR`. -/
def truncationDR (u : Graph) (k : ℝ) : E3 → ℝ :=
  (u.superlevelSet k).indicator u.dR

/-- The vertical Marcus-Mizel candidate `1_{u > k} dZ`. -/
def truncationDZ (u : Graph) (k : ℝ) : E3 → ℝ :=
  (u.superlevelSet k).indicator u.dZ

theorem memLp_shiftedPosPart (u : Graph) {k : ℝ} (hk : 0 ≤ k) :
    MemLp (u.shiftedPosPart k) 2 weightedMeasure := by
  refine u.memLp_val.of_le_mul (c := 1) ?_ (Filter.Eventually.of_forall ?_)
  · exact
      ((continuous_id.sub continuous_const).max continuous_const).comp_aestronglyMeasurable
        u.memLp_val.1
  · intro x
    by_cases hx : u.val x - k ≤ 0
    · simp [shiftedPosPart, hx]
    · have hux_gt_k : k < u.val x := by linarith
      have hux_nonneg : 0 ≤ u.val x := le_trans hk hux_gt_k.le
      calc
        ‖u.shiftedPosPart k x‖ = |u.val x - k| := by
          rw [shiftedPosPart, max_eq_left (sub_nonneg.mpr hux_gt_k.le), Real.norm_eq_abs]
        _ = u.val x - k := abs_of_nonneg (sub_nonneg.mpr hux_gt_k.le)
        _ ≤ u.val x := sub_le_self _ hk
        _ = ‖u.val x‖ := by rw [Real.norm_of_nonneg hux_nonneg]
        _ ≤ 1 * ‖u.val x‖ := by simp

theorem memLp_truncationDR (u : Graph) (k : ℝ) :
    MemLp (u.truncationDR k) 2 weightedMeasure :=
  memLp_indicator (hs := u.measurableSet_superlevelSet k) u.memLp_dR

theorem memLp_truncationDZ (u : Graph) (k : ℝ) :
    MemLp (u.truncationDZ k) 2 weightedMeasure :=
  memLp_indicator (hs := u.measurableSet_superlevelSet k) u.memLp_dZ

/-- Structure-level truncation carrying the canonical indicator-cut gradient
slots. This is the opening-tranche graph object used for later weak chain-rule
lemmas. -/
def truncation (u : Graph) (k : ℝ) (hk : 0 ≤ k) : Graph where
  val := u.shiftedPosPart k
  dR := u.truncationDR k
  dZ := u.truncationDZ k
  memLp_val := u.memLp_shiftedPosPart hk
  memLp_dR := u.memLp_truncationDR k
  memLp_dZ := u.memLp_truncationDZ k

@[simp] theorem truncation_val (u : Graph) (k : ℝ) (hk : 0 ≤ k) :
    (u.truncation k hk).val = u.shiftedPosPart k := rfl

@[simp] theorem truncation_dR (u : Graph) (k : ℝ) (hk : 0 ≤ k) :
    (u.truncation k hk).dR = u.truncationDR k := rfl

@[simp] theorem truncation_dZ (u : Graph) (k : ℝ) (hk : 0 ≤ k) :
    (u.truncation k hk).dZ = u.truncationDZ k := rfl

/-- Definitional Marcus-Mizel identity on the measurable-hull superlevel set. -/
theorem truncation_dR_eq_indicator_superlevel (u : Graph) (k : ℝ) (hk : 0 ≤ k) :
    (u.truncation k hk).dR = (u.superlevelSet k).indicator u.dR := rfl

/-- Definitional Marcus-Mizel identity on the measurable-hull superlevel set. -/
theorem truncation_dZ_eq_indicator_superlevel (u : Graph) (k : ℝ) (hk : 0 ≤ k) :
    (u.truncation k hk).dZ = (u.superlevelSet k).indicator u.dZ := rfl

/-- A.e. form of the radial Marcus-Mizel identity against the raw superlevel
predicate `{u > k}`. -/
theorem truncation_dR_ae_eq_indicator_gt (u : Graph) (k : ℝ) (hk : 0 ≤ k) :
    (u.truncation k hk).dR =ᵐ[weightedMeasure] {p : E3 | k < u.val p}.indicator u.dR := by
  simpa [truncation, truncationDR] using
    (indicator_ae_eq_of_ae_eq_set (u.superlevelSet_ae_eq k))

/-- A.e. form of the vertical Marcus-Mizel identity against the raw superlevel
predicate `{u > k}`. -/
theorem truncation_dZ_ae_eq_indicator_gt (u : Graph) (k : ℝ) (hk : 0 ≤ k) :
    (u.truncation k hk).dZ =ᵐ[weightedMeasure] {p : E3 | k < u.val p}.indicator u.dZ := by
  simpa [truncation, truncationDZ] using
    (indicator_ae_eq_of_ae_eq_set (u.superlevelSet_ae_eq k))

end Graph

end NavierStokes.Mathlib.WeightedSobolev

end
