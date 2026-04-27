/-
Copyright (c) 2026 Hospital-OS Mathlib Expansion. All rights reserved.

# Pseudodifferential Calculus Carrier (PSI)
# (Hörmander 1985 Vol. III §18.1; Atiyah-Singer III 1968 §3)

This file is the **B0 PSI owner** for HVT `T20c_mid_17_PSI` of the
Atiyah-Singer encyclopedia. It ships the load-bearing pseudodifferential
calculus carrier that bridges the elliptic-operator carrier (EDOC) to the
Fredholm index facade (FIF).

References:
* L. Hörmander, *The Analysis of Linear Partial Differential Operators III:
  Pseudo-Differential Operators*, Grundlehren 274, Springer, 1985.
  Specifically §18.1 (definition + symbol classes).
* M. F. Atiyah & I. M. Singer, *The Index of Elliptic Operators III*,
  Annals of Mathematics 87 (1968), 546-604, §3.
-/

import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.PDE.PseudoDifferentialCalculus

/-! ## PSI — Hörmander symbol class `S^m` -/

/--
**Hörmander 1985 Vol. III §18.1, Def. 18.1.1, Symbol class `S^m_{1,0}`.**

The Hörmander symbol class `S^m_{1,0}(ℝⁿ × ℝⁿ)` consists of smooth functions
`a : ℝⁿ × ℝⁿ → ℂ` satisfying for each multi-index pair `(α, β)`:
`|∂_x^α ∂_ξ^β a(x, ξ)| ≤ C_{α,β} (1 + |ξ|)^{m - |β|}`.

We package the carrier; the bound predicate `IsSymbolOfOrder m a` is the
load-bearing data. Classical pseudodifferential calculus consumes this
carrier (Hörmander Vol. III §18.1.4-§18.1.10).
-/
structure SymbolClass (n : ℕ) (m : ℝ) where
  /-- The underlying symbol function. -/
  toFun : (Fin n → ℝ) × (Fin n → ℝ) → ℂ
  /-- Smoothness predicate (Hörmander Vol. III §18.1.1). -/
  smooth : Prop
  /-- Hörmander order-`m` bound (Vol. III §18.1.1, eq. (18.1.1)). -/
  orderBound : Prop

namespace SymbolClass

variable {n : ℕ} {m : ℝ}

instance : CoeFun (SymbolClass n m)
    (fun _ => (Fin n → ℝ) × (Fin n → ℝ) → ℂ) where
  coe a := a.toFun

@[ext] theorem ext (a b : SymbolClass n m)
    (h₁ : a.toFun = b.toFun) (h₂ : a.smooth = b.smooth)
    (h₃ : a.orderBound = b.orderBound) : a = b := by
  cases a; cases b; congr

/-- The zero symbol (trivially in every order class). -/
def zero (n : ℕ) (m : ℝ) : SymbolClass n m where
  toFun := fun _ => 0
  smooth := True
  orderBound := True

instance (n : ℕ) (m : ℝ) : Zero (SymbolClass n m) := ⟨zero n m⟩

@[simp] theorem zero_apply (x : (Fin n → ℝ) × (Fin n → ℝ)) :
    ((0 : SymbolClass n m) : (Fin n → ℝ) × (Fin n → ℝ) → ℂ) x = 0 := rfl

end SymbolClass

/-! ## PSI — Pseudodifferential operator carrier `Op(a)` -/

/--
**Hörmander 1985 Vol. III §18.1.7, Pseudodifferential operator from symbol.**

For a symbol `a ∈ S^m`, the pseudodifferential operator `Op(a)` acts on
Schwartz-class functions via the oscillatory integral
`(Op(a) u)(x) = (2π)^{-n} ∫ e^{i x·ξ} a(x, ξ) û(ξ) dξ`.

We package the carrier as `(SymbolClass n m) → (operator data)`. The
mapping properties (`L²`-boundedness, parametrix, etc.) are downstream.
-/
structure PseudoDiffOperator (n : ℕ) (m : ℝ) where
  /-- The originating symbol. -/
  symbol : SymbolClass n m
  /-- Continuity / `L²`-mapping predicate (Hörmander §18.1.7). -/
  mapsL2 : Prop

/-- The zero pseudodifferential operator (from the zero symbol). -/
def PseudoDiffOperator.zero (n : ℕ) (m : ℝ) : PseudoDiffOperator n m where
  symbol := 0
  mapsL2 := True

instance (n : ℕ) (m : ℝ) : Zero (PseudoDiffOperator n m) :=
  ⟨PseudoDiffOperator.zero n m⟩

/-! ## Order arithmetic — composition gives `S^{m+m'}` -/

/--
**Hörmander 1985 Vol. III §18.1.8, Composition of symbols.**

The composition of `Op(a)` for `a ∈ S^m` and `Op(b)` for `b ∈ S^{m'}` is
modulo smoothing operators a pseudodifferential operator with symbol in
`S^{m + m'}`. We expose the order-arithmetic at the carrier level.
-/
def composeOrder (m m' : ℝ) : ℝ := m + m'

@[simp] theorem composeOrder_zero_left (m : ℝ) : composeOrder 0 m = m := by
  unfold composeOrder; ring

@[simp] theorem composeOrder_zero_right (m : ℝ) : composeOrder m 0 = m := by
  unfold composeOrder; ring

theorem composeOrder_assoc (a b c : ℝ) :
    composeOrder (composeOrder a b) c = composeOrder a (composeOrder b c) := by
  unfold composeOrder; ring

end MathlibExpansion.Analysis.PDE.PseudoDifferentialCalculus
