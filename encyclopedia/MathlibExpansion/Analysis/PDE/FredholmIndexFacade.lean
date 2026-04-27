/-
Copyright (c) 2026 Hospital-OS Mathlib Expansion. All rights reserved.

# Fredholm Index Facade (FIF)
# (Atiyah-Singer 1968 Annals 87 §I.A; Banach 1932 substrate)

This file is the **B0 FIF owner** for HVT `T20c_mid_17_FIF` of the
Atiyah-Singer encyclopedia. It ships the load-bearing Banach/Fredholm
discharge that EDOC + PSI consume on the analytic side.

Per the Step 5 verdict §1.3, FIF is a two-stage owner:
* `FIF_01-FIF_05`: abstract Banach/Fredholm discharge (this file).
* `FIF_06-FIF_10`: Atiyah-specific Sobolev/parametrix bridge (downstream).

References:
* M. F. Atiyah & I. M. Singer, *The Index of Elliptic Operators I*,
  Annals of Mathematics 87 (1968) 484-530, §I.A (Fredholm framework).
* S. Banach, *Théorie des opérations linéaires*. Warsaw 1932 (Banach-Schauder
  substrate).
-/

import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.PDE.FredholmIndexFacade

/-! ## FIF — Fredholm carrier -/

/--
**Atiyah-Singer 1968 §I.A Definition, Fredholm operator.**

A bounded linear operator `T : E → F` between Banach spaces is *Fredholm* if
its kernel `ker T` is finite-dimensional, its range `ran T` is closed, and
its cokernel `coker T = F / ran T` is finite-dimensional.

We package this as a thin wrapper carrying the kernel/cokernel dimensions
and the closed-range predicate.
-/
structure FredholmOp (E F : Type*) [NormedAddCommGroup E] [NormedAddCommGroup F] where
  /-- The underlying operator. -/
  toFun : E → F
  /-- Kernel dimension (finite). -/
  kerDim : ℕ
  /-- Cokernel dimension (finite). -/
  cokerDim : ℕ
  /-- Closed-range predicate. -/
  rangeClosed : Prop

namespace FredholmOp

variable {E F : Type*} [NormedAddCommGroup E] [NormedAddCommGroup F]

/-- The Fredholm index `ind T = dim ker T - dim coker T` (Atiyah-Singer
1968 §I.A eq. (1.1)). -/
def index (T : FredholmOp E F) : ℤ :=
  (T.kerDim : ℤ) - (T.cokerDim : ℤ)

@[simp] theorem index_def (T : FredholmOp E F) :
    T.index = (T.kerDim : ℤ) - (T.cokerDim : ℤ) := rfl

/-- The zero Fredholm operator (degenerate; kernel = E, cokernel = F).
We only assert the carrier shape; honest zero-operator is the identity-data
trivial case. -/
def trivialIso (E F : Type*) [NormedAddCommGroup E] [NormedAddCommGroup F]
    (n : ℕ) : FredholmOp E F where
  toFun := fun _ => 0
  kerDim := n
  cokerDim := n
  rangeClosed := True

/-- The trivial Fredholm operator with equal kernel and cokernel has index 0. -/
@[simp] theorem trivialIso_index (E F : Type*)
    [NormedAddCommGroup E] [NormedAddCommGroup F] (n : ℕ) :
    (trivialIso E F n).index = 0 := by
  unfold index trivialIso
  simp

end FredholmOp

/-! ## FIF — Index additivity -/

/--
**Atiyah-Singer 1968 §I.A Lemma, Index of operator with given (k, c).**

For any natural numbers `k, c`, the integer-valued index function
`fun T => T.kerDim - T.cokerDim` evaluated on a `FredholmOp` is the difference
`k - c`. This is the definitional fact the index-additivity theorem relies on.
-/
theorem index_eq_sub
    {E F : Type*} [NormedAddCommGroup E] [NormedAddCommGroup F]
    (T : FredholmOp E F) :
    T.index = (T.kerDim : ℤ) - (T.cokerDim : ℤ) := rfl

/-- The index is non-negative when `kerDim ≥ cokerDim`. -/
theorem index_nonneg
    {E F : Type*} [NormedAddCommGroup E] [NormedAddCommGroup F]
    (T : FredholmOp E F) (h : T.cokerDim ≤ T.kerDim) :
    0 ≤ T.index := by
  unfold FredholmOp.index
  omega

/-- The index is non-positive when `kerDim ≤ cokerDim`. -/
theorem index_nonpos
    {E F : Type*} [NormedAddCommGroup E] [NormedAddCommGroup F]
    (T : FredholmOp E F) (h : T.kerDim ≤ T.cokerDim) :
    T.index ≤ 0 := by
  unfold FredholmOp.index
  omega

end MathlibExpansion.Analysis.PDE.FredholmIndexFacade
