import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic

/-!
# NavierStokes.AxisymNoSwirl.BiotSavart.Carrier

Carrier-unification layer for ANS-B8 (Biot-Savart forward map).

This file fixes the carrier to B1's `ℝ × ℝ × ℝ` (the `NavierStokes.Geometry.Cylindrical.E3`
abbrev) and *re-states* the axisymmetric and no-swirl predicates over that carrier, so the
B8 forward identities never have to bridge through `EuclideanSpace ℝ (Fin 3)` (the carrier
of `NavierStokes.AxisymNoSwirl.Basic.E3`).

The motivation: B8 needs `radialDeriv`, `verticalDeriv`, `eR`, `eTheta`, `eZ`, `rCyl`,
`puncturedSpace` etc., all of which are defined on B1's `ℝ × ℝ × ℝ` carrier. Adapting per
call to / from `EuclideanSpace ℝ (Fin 3)` would poison every theorem with implicit linear
isometries. Per the post-recon CONSENSUS, we pick one carrier and stick to it.

The B2-side unification (linear isometry transport from B1 carrier to B2 carrier) is
*explicitly* out of scope for B8; it is a B2 follow-up.

## Naming
The `*Cyl` suffix on the predicates flags that they live on B1's cylindrical carrier
(`E3 := ℝ × ℝ × ℝ`), as opposed to B2's `E3 := EuclideanSpace ℝ (Fin 3)` versions.

## Z-rotation on `ℝ × ℝ × ℝ`
Defined directly via the explicit cosine / sine matrix action, so we never have to
import `EuclideanSpace`-typed `rotZLin`. This keeps the B8 Pub/Sub build target free of
B2's heavier algebra dependencies.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open Real

namespace NavierStokes.AxisymNoSwirl.BiotSavart

open NavierStokes.Geometry.Cylindrical

/-! ## Z-rotation on the cylindrical carrier `ℝ × ℝ × ℝ` -/

/-- Z-rotation acting directly on the ambient `ℝ × ℝ × ℝ` carrier (no `EuclideanSpace`). -/
def rotZCyl (θ : ℝ) (p : E3) : E3 :=
  (cos θ * p.1 - sin θ * p.2.1, sin θ * p.1 + cos θ * p.2.1, p.2.2)

@[simp] lemma rotZCyl_zero (p : E3) : rotZCyl 0 p = p := by
  simp [rotZCyl]

@[simp] lemma rotZCyl_fst (θ : ℝ) (p : E3) :
    (rotZCyl θ p).1 = cos θ * p.1 - sin θ * p.2.1 := rfl

@[simp] lemma rotZCyl_snd_fst (θ : ℝ) (p : E3) :
    (rotZCyl θ p).2.1 = sin θ * p.1 + cos θ * p.2.1 := rfl

@[simp] lemma rotZCyl_snd_snd (θ : ℝ) (p : E3) :
    (rotZCyl θ p).2.2 = p.2.2 := rfl

/-- The squared cylindrical radius is `rotZCyl`-invariant. -/
lemma rSq_rotZCyl (θ : ℝ) (p : E3) : rSq (rotZCyl θ p) = rSq p := by
  show (rotZCyl θ p).1 ^ 2 + (rotZCyl θ p).2.1 ^ 2 = p.1 ^ 2 + p.2.1 ^ 2
  simp only [rotZCyl_fst, rotZCyl_snd_fst]
  nlinarith [Real.cos_sq_add_sin_sq θ]

/-- The cylindrical radius is `rotZCyl`-invariant. -/
lemma rCyl_rotZCyl (θ : ℝ) (p : E3) : rCyl (rotZCyl θ p) = rCyl p := by
  have h : (rotZCyl θ p).1 ^ 2 + (rotZCyl θ p).2.1 ^ 2 = p.1 ^ 2 + p.2.1 ^ 2 := by
    simp only [rotZCyl_fst, rotZCyl_snd_fst]
    nlinarith [Real.cos_sq_add_sin_sq θ]
  show Real.sqrt ((rotZCyl θ p).1 ^ 2 + (rotZCyl θ p).2.1 ^ 2)
      = Real.sqrt (p.1 ^ 2 + p.2.1 ^ 2)
  rw [h]

/-- `rotZCyl` preserves the punctured space (off-axis remains off-axis). -/
lemma rotZCyl_mem_puncturedSpace {θ : ℝ} {p : E3} (hp : p ∈ puncturedSpace) :
    rotZCyl θ p ∈ puncturedSpace := by
  -- rSq is rotZCyl-invariant; rSq p > 0 since p ∈ puncturedSpace; therefore
  -- (rotZCyl θ p) cannot satisfy both .1 = 0 and .2.1 = 0 simultaneously.
  have hp_sq : 0 < rSq p := rSq_pos_of_mem hp
  have hpr_sq : 0 < rSq (rotZCyl θ p) := by rw [rSq_rotZCyl]; exact hp_sq
  rw [mem_puncturedSpace_iff]
  by_contra h
  push_neg at h
  obtain ⟨hx, hy⟩ := h
  have hzero : rSq (rotZCyl θ p) = 0 := by
    show (rotZCyl θ p).1 ^ 2 + (rotZCyl θ p).2.1 ^ 2 = 0
    rw [hx, hy]; ring
  linarith

/-! ## Axisymmetric / no-swirl predicates on the cylindrical carrier -/

/-- A vector field `u : E3 → E3` is axisymmetric on the cylindrical carrier
    if it commutes with every z-rotation. -/
def AxisymVectorFieldCyl (u : E3 → E3) : Prop :=
  ∀ θ x, u (rotZCyl θ x) = rotZCyl θ (u x)

/-- No-swirl (polynomial form on the cylindrical carrier):
    `x * u_y - y * u_x = 0` everywhere. Equivalent to the azimuthal Cartesian projection
    vanishing where `(x,y) ≠ 0`. -/
def NoSwirlPolyCyl (u : E3 → E3) : Prop :=
  ∀ x : E3, x.1 * (u x).2.1 - x.2.1 * (u x).1 = 0

/-- Combined axisymmetric + no-swirl predicate on the cylindrical carrier. -/
def AxisymNoSwirlPredCyl (u : E3 → E3) : Prop :=
  AxisymVectorFieldCyl u ∧ NoSwirlPolyCyl u

/-- Bundled axisymmetric no-swirl field, on the cylindrical carrier. -/
abbrev AxisymNoSwirlFieldCyl := {u : E3 → E3 // AxisymNoSwirlPredCyl u}

/-! ## Submodule structure on the cylindrical carrier -/

/-- Axisymmetric vector fields on `E3 := ℝ × ℝ × ℝ` form a real vector subspace of `E3 → E3`. -/
def AxisymSubspaceCyl : Submodule ℝ (E3 → E3) where
  carrier := {u | AxisymVectorFieldCyl u}
  zero_mem' := by intro θ x; simp [AxisymVectorFieldCyl, rotZCyl]
  add_mem' {u v} hu hv := by
    intro θ x
    have hux : u (rotZCyl θ x) = rotZCyl θ (u x) := hu θ x
    have hvx : v (rotZCyl θ x) = rotZCyl θ (v x) := hv θ x
    show (u + v) (rotZCyl θ x) = rotZCyl θ ((u + v) x)
    rw [Pi.add_apply, Pi.add_apply, hux, hvx]
    -- Goal: rotZCyl θ (u x) + rotZCyl θ (v x) = rotZCyl θ (u x + v x)
    refine Prod.ext ?_ (Prod.ext ?_ ?_)
    · show (rotZCyl θ (u x)).1 + (rotZCyl θ (v x)).1 = (rotZCyl θ (u x + v x)).1
      simp only [rotZCyl_fst]
      have h1 : (u x + v x).1 = (u x).1 + (v x).1 := rfl
      have h2 : (u x + v x).2.1 = (u x).2.1 + (v x).2.1 := rfl
      rw [h1, h2]; ring
    · show (rotZCyl θ (u x)).2.1 + (rotZCyl θ (v x)).2.1 = (rotZCyl θ (u x + v x)).2.1
      simp only [rotZCyl_snd_fst]
      have h1 : (u x + v x).1 = (u x).1 + (v x).1 := rfl
      have h2 : (u x + v x).2.1 = (u x).2.1 + (v x).2.1 := rfl
      rw [h1, h2]; ring
    · show (rotZCyl θ (u x)).2.2 + (rotZCyl θ (v x)).2.2 = (rotZCyl θ (u x + v x)).2.2
      simp only [rotZCyl_snd_snd]
      rfl
  smul_mem' a {u} hu := by
    intro θ x
    have hux : u (rotZCyl θ x) = rotZCyl θ (u x) := hu θ x
    show (a • u) (rotZCyl θ x) = rotZCyl θ ((a • u) x)
    rw [Pi.smul_apply, Pi.smul_apply, hux]
    -- Goal: a • rotZCyl θ (u x) = rotZCyl θ (a • u x)
    refine Prod.ext ?_ (Prod.ext ?_ ?_)
    · show (a • rotZCyl θ (u x)).1 = (rotZCyl θ (a • u x)).1
      have h1 : (a • u x).1 = a * (u x).1 := rfl
      have h2 : (a • u x).2.1 = a * (u x).2.1 := rfl
      have h3 : (a • rotZCyl θ (u x)).1 = a * (rotZCyl θ (u x)).1 := rfl
      rw [h3, rotZCyl_fst, rotZCyl_fst, h1, h2]; ring
    · show (a • rotZCyl θ (u x)).2.1 = (rotZCyl θ (a • u x)).2.1
      have h1 : (a • u x).1 = a * (u x).1 := rfl
      have h2 : (a • u x).2.1 = a * (u x).2.1 := rfl
      have h3 : (a • rotZCyl θ (u x)).2.1 = a * (rotZCyl θ (u x)).2.1 := rfl
      rw [h3, rotZCyl_snd_fst, rotZCyl_snd_fst, h1, h2]; ring
    · show (a • rotZCyl θ (u x)).2.2 = (rotZCyl θ (a • u x)).2.2
      have h3 : (a • rotZCyl θ (u x)).2.2 = a * (rotZCyl θ (u x)).2.2 := rfl
      rw [h3, rotZCyl_snd_snd, rotZCyl_snd_snd]
      rfl

/-- No-swirl fields form a submodule. -/
def NoSwirlSubspaceCyl : Submodule ℝ (E3 → E3) where
  carrier := {u | NoSwirlPolyCyl u}
  zero_mem' := by intro x; simp [NoSwirlPolyCyl]
  add_mem' {u v} hu hv := by
    intro x
    have h1 : x.1 * (u x).2.1 - x.2.1 * (u x).1 = 0 := hu x
    have h2 : x.1 * (v x).2.1 - x.2.1 * (v x).1 = 0 := hv x
    show x.1 * ((u + v) x).2.1 - x.2.1 * ((u + v) x).1 = 0
    rw [Pi.add_apply]
    have hsnd : (u x + v x).2.1 = (u x).2.1 + (v x).2.1 := rfl
    have hfst : (u x + v x).1 = (u x).1 + (v x).1 := rfl
    rw [hsnd, hfst]
    linarith
  smul_mem' a {u} hu := by
    intro x
    have h1 : x.1 * (u x).2.1 - x.2.1 * (u x).1 = 0 := hu x
    show x.1 * ((a • u) x).2.1 - x.2.1 * ((a • u) x).1 = 0
    rw [Pi.smul_apply]
    have hsnd : (a • u x).2.1 = a * (u x).2.1 := rfl
    have hfst : (a • u x).1 = a * (u x).1 := rfl
    rw [hsnd, hfst]
    have hring : x.1 * (a * (u x).2.1) - x.2.1 * (a * (u x).1)
        = a * (x.1 * (u x).2.1 - x.2.1 * (u x).1) := by ring
    rw [hring, h1, mul_zero]

/-- Axisymmetric no-swirl subspace on the cylindrical carrier. -/
def AxisymNoSwirlSubspaceCyl : Submodule ℝ (E3 → E3) :=
  AxisymSubspaceCyl ⊓ NoSwirlSubspaceCyl

end NavierStokes.AxisymNoSwirl.BiotSavart

end
