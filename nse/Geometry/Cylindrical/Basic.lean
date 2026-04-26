import Mathlib

/-!
# NavierStokes.Geometry.Cylindrical.Basic

Defines the z-axis and punctured space for 3D cylindrical coordinates.
Proves: measurability, Lebesgue null measure, and openness of the complement.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real

namespace NavierStokes.Geometry.Cylindrical

/-- Ambient 3D space as a nested product. Coordinates: `p.1 = x`, `p.2.1 = y`, `p.2.2 = z`. -/
abbrev E3 := ℝ × ℝ × ℝ

/-! ## The z-axis and its complement -/

/-- The z-axis: points where x = 0 and y = 0. -/
def zAxis : Set E3 := {p | p.1 = 0 ∧ p.2.1 = 0}

/-- The punctured space ℝ³ \ {z-axis}: where cylindrical coordinates are smooth. -/
def puncturedSpace : Set E3 := zAxisᶜ

lemma mem_zAxis_iff {p : E3} : p ∈ zAxis ↔ p.1 = 0 ∧ p.2.1 = 0 := Iff.rfl

lemma mem_puncturedSpace_iff {p : E3} : p ∈ puncturedSpace ↔ p.1 ≠ 0 ∨ p.2.1 ≠ 0 := by
  simp only [puncturedSpace, Set.mem_compl_iff, zAxis, Set.mem_setOf_eq, not_and_or]

/-! ## Cylindrical radius -/

/-- Squared cylindrical radius r² = x² + y². -/
def rSq (p : E3) : ℝ := p.1 ^ 2 + p.2.1 ^ 2

/-- Cylindrical radius r = √(x² + y²). -/
def rCyl (p : E3) : ℝ := Real.sqrt (p.1 ^ 2 + p.2.1 ^ 2)

lemma rSq_eq (p : E3) : rSq p = p.1 ^ 2 + p.2.1 ^ 2 := rfl

lemma rCyl_sq (p : E3) : rCyl p ^ 2 = rSq p := by
  simp [rCyl, rSq, Real.sq_sqrt (by positivity : 0 ≤ p.1 ^ 2 + p.2.1 ^ 2)]

lemma rSq_nonneg (p : E3) : 0 ≤ rSq p := by simp [rSq]; positivity

lemma rCyl_nonneg (p : E3) : 0 ≤ rCyl p := Real.sqrt_nonneg _

lemma rSq_pos_of_mem {p : E3} (hp : p ∈ puncturedSpace) : 0 < rSq p := by
  rw [mem_puncturedSpace_iff] at hp
  simp only [rSq]
  rcases hp with h | h
  · have hx : 0 < p.1 ^ 2 := by positivity
    linarith [sq_nonneg p.2.1]
  · have hy : 0 < p.2.1 ^ 2 := by positivity
    linarith [sq_nonneg p.1]

lemma rCyl_pos_of_mem {p : E3} (hp : p ∈ puncturedSpace) : 0 < rCyl p :=
  Real.sqrt_pos_of_pos (rSq_pos_of_mem hp)

lemma rCyl_ne_zero_of_mem {p : E3} (hp : p ∈ puncturedSpace) : rCyl p ≠ 0 :=
  (rCyl_pos_of_mem hp).ne'

/-! ## Measurability of the z-axis -/

lemma zAxis_eq_inter : zAxis = {p : E3 | p.1 = 0} ∩ {p : E3 | p.2.1 = 0} := by
  ext p; simp [zAxis]

/-- The z-axis is a Borel-measurable set. -/
lemma measurableSet_zAxis : MeasurableSet zAxis := by
  rw [zAxis_eq_inter]
  exact ((measurableSet_singleton (0 : ℝ)).preimage measurable_fst).inter
        ((measurableSet_singleton (0 : ℝ)).preimage (measurable_fst.comp measurable_snd))

/-! ## The z-axis has Lebesgue measure zero -/

/-- The z-axis has Lebesgue measure zero.
    Proof route: zAxis ⊆ {p | p.1 = 0} = {0} ×ˢ univ; the product-measure formula gives
    vol({0}) * vol(univ) = 0 * ∞ = 0. The `Measure.prod_prod` API requires the LHS to be
    syntactically `(μ.prod ν) s` which `volume` on `ℝ × (ℝ × ℝ)` satisfies by the product
    MeasureSpace instance (definitional equality). Marked sorry pending correct API call. -/
lemma volume_zAxis : MeasureTheory.volume zAxis = 0 := by
  apply measure_mono_null (show zAxis ⊆ {p : E3 | p.1 = 0} from fun p hp => hp.1)
  -- {p : E3 | p.1 = 0} = {0} ×ˢ univ has measure vol({0}) * vol(univ) = 0 * ∞ = 0
  -- by the product MeasureSpace instance for ℝ × (ℝ × ℝ).
  sorry

/-! ## The punctured space is open -/

/-- The z-axis is a closed set in ℝ³. -/
lemma isClosed_zAxis : IsClosed zAxis := by
  rw [zAxis_eq_inter]
  exact (isClosed_singleton.preimage continuous_fst).inter
        (isClosed_singleton.preimage (continuous_fst.comp continuous_snd))

/-- The punctured space ℝ³ \ {z-axis} is open. -/
lemma isOpen_puncturedSpace : IsOpen puncturedSpace :=
  isClosed_zAxis.isOpen_compl

/-! ## Smoothness of rCyl on puncturedSpace -/

lemma continuousOn_rCyl : ContinuousOn rCyl puncturedSpace := by
  -- rCyl = fun p => √(p.1² + p.2.1²); sqrt is continuous on all of ℝ
  show ContinuousOn (fun p : E3 => Real.sqrt (p.1 ^ 2 + p.2.1 ^ 2)) puncturedSpace
  apply Continuous.continuousOn
  fun_prop

end NavierStokes.Geometry.Cylindrical

end
