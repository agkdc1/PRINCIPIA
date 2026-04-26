import Mathlib
import NavierStokes.Mathlib.WeightedSobolev.Graph

/-!
# NavierStokes.Mathlib.WeightedSobolev.Steklov

Steklov time averages for the weighted-parabolic opening tranche.

This file keeps the operator generic in the codomain and then specializes it to
space-time scalar fields and to the three component slots of the weighted
Sobolev graph carrier.

No new axioms.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

open MeasureTheory intervalIntegral

namespace NavierStokes.Mathlib.WeightedSobolev

open NavierStokes.Geometry.Cylindrical

section Banach

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

/-- Steklov average over the backward interval `[t - h, t]`. -/
def steklov (u : ℝ → E) (h : ℝ) : ℝ → E :=
  fun t => (h⁻¹ : ℝ) • ∫ s in t - h..t, u s

@[simp] theorem steklov_apply (u : ℝ → E) (h t : ℝ) :
    steklov u h t = (h⁻¹ : ℝ) • ∫ s in t - h..t, u s := rfl

@[simp] theorem steklov_zero (u : ℝ → E) (t : ℝ) :
    steklov u 0 t = 0 := by
  simp [steklov]

@[simp] theorem steklov_add (u v : ℝ → E) (h t : ℝ)
    (hu : IntervalIntegrable u volume (t - h) t)
    (hv : IntervalIntegrable v volume (t - h) t) :
    steklov (fun s => u s + v s) h t = steklov u h t + steklov v h t := by
  rw [steklov, steklov, steklov, intervalIntegral.integral_add hu hv, smul_add]

@[simp] theorem steklov_sub (u v : ℝ → E) (h t : ℝ)
    (hu : IntervalIntegrable u volume (t - h) t)
    (hv : IntervalIntegrable v volume (t - h) t) :
    steklov (fun s => u s - v s) h t = steklov u h t - steklov v h t := by
  rw [steklov, steklov, steklov, intervalIntegral.integral_sub hu hv, smul_sub]

@[simp] theorem steklov_neg (u : ℝ → E) (h t : ℝ) :
    steklov (fun s => -u s) h t = -steklov u h t := by
  rw [steklov, steklov, intervalIntegral.integral_neg, smul_neg]

@[simp] theorem steklov_smul (c : ℝ) (u : ℝ → E) (h t : ℝ) :
    steklov (fun s => c • u s) h t = c • steklov u h t := by
  rw [steklov, steklov, intervalIntegral.integral_smul, smul_smul, smul_smul, mul_comm]

@[simp] theorem steklov_const (c : E) {h : ℝ} (hh : h ≠ 0) (t : ℝ) :
    steklov (fun _ => c) h t = c := by
  rw [steklov, intervalIntegral.integral_const]
  have hsub : t - (t - h) = h := by ring
  rw [hsub, smul_smul]
  have hmul : h⁻¹ * h = 1 := by field_simp [hh]
  rw [hmul, one_smul]

end Banach

/-- Steklov average of a space-time scalar field, averaging only in time. -/
def steklovField (u : ℝ → E3 → ℝ) (h : ℝ) : ℝ → E3 → ℝ :=
  fun t p => steklov (fun s => u s p) h t

@[simp] theorem steklovField_apply (u : ℝ → E3 → ℝ) (h t : ℝ) (p : E3) :
    steklovField u h t p = (h⁻¹ : ℝ) • ∫ s in t - h..t, u s p := rfl

@[simp] theorem steklovField_add (u v : ℝ → E3 → ℝ) (h t : ℝ)
    (hu : ∀ p, IntervalIntegrable (fun s => u s p) volume (t - h) t)
    (hv : ∀ p, IntervalIntegrable (fun s => v s p) volume (t - h) t) :
    steklovField (fun s p => u s p + v s p) h t =
      fun p => steklovField u h t p + steklovField v h t p := by
  funext p
  exact steklov_add (u := fun s => u s p) (v := fun s => v s p) (h := h) (t := t) (hu p) (hv p)

@[simp] theorem steklovField_smul (c : ℝ) (u : ℝ → E3 → ℝ) (h t : ℝ) :
    steklovField (fun s p => c • u s p) h t =
      fun p => c • steklovField u h t p := by
  funext p
  exact steklov_smul (c := c) (u := fun s => u s p) (h := h) (t := t)

/-- Time-regularized value slot of a graph-valued trajectory. -/
def steklovVal (U : ℝ → Graph) (h : ℝ) : ℝ → E3 → ℝ :=
  steklovField (fun t => (U t).val) h

/-- Time-regularized radial slot of a graph-valued trajectory. -/
def steklovDR (U : ℝ → Graph) (h : ℝ) : ℝ → E3 → ℝ :=
  steklovField (fun t => (U t).dR) h

/-- Time-regularized vertical slot of a graph-valued trajectory. -/
def steklovDZ (U : ℝ → Graph) (h : ℝ) : ℝ → E3 → ℝ :=
  steklovField (fun t => (U t).dZ) h

@[simp] theorem steklovVal_apply (U : ℝ → Graph) (h t : ℝ) (p : E3) :
    steklovVal U h t p = (h⁻¹ : ℝ) • ∫ s in t - h..t, (U s).val p := rfl

@[simp] theorem steklovDR_apply (U : ℝ → Graph) (h t : ℝ) (p : E3) :
    steklovDR U h t p = (h⁻¹ : ℝ) • ∫ s in t - h..t, (U s).dR p := rfl

@[simp] theorem steklovDZ_apply (U : ℝ → Graph) (h t : ℝ) (p : E3) :
    steklovDZ U h t p = (h⁻¹ : ℝ) • ∫ s in t - h..t, (U s).dZ p := rfl

end NavierStokes.Mathlib.WeightedSobolev

end
