/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.SixthGap

/-!
# Elliptic-curve conductor data

This file supplies the seventh atomic FLT-chain interface on the elliptic side:
a bundled conductor datum for a Weierstrass elliptic curve. The sixth gap
records modularity by a modular form and already includes the natural level
called `conductor`. Mathlib has Weierstrass elliptic curves, algebraic conductor
ideals, Dirichlet character conductors, and general L-series infrastructure,
but not a bundled elliptic-curve conductor interface.

The structure below keeps the unit deliberately small. It records the natural
level supplied by the modularity package, exposes the associated positive
natural conductor as its successor, and proves the basic equality, positivity,
and nonvanishing facts needed by later elliptic L-function interfaces.
-/

open scoped MatrixGroups

namespace NumberTheory

/--
Conductor data attached to a Weierstrass elliptic curve.

The field `level` is the natural conductor level supplied by the modularity
interfaces already present in `EllipticCurveModularBy`. The associated
positive conductor is exposed as `level + 1`, giving later developments a
nonzero natural while the local minimal-model conductor theory is still absent
from Mathlib.
-/
structure EllipticCurveConductorData {R : Type*} [CommRing R]
    (E : WeierstrassCurve R) [E.IsElliptic] where
  level : ℕ

namespace EllipticCurveConductorData

/--
The positive natural conductor associated to bundled elliptic-curve conductor
data.
-/
def conductor {R : Type*} [CommRing R] {E : WeierstrassCurve R} [E.IsElliptic]
    (h : EllipticCurveConductorData E) : ℕ :=
  h.level + 1

/--
The conductor associated to the bundled data is definitionally the successor
of the recorded conductor level.
-/
theorem conductor_eq {R : Type*} [CommRing R]
    {E : WeierstrassCurve R} [E.IsElliptic]
    (h : EllipticCurveConductorData E) :
    h.conductor = h.level + 1 :=
  rfl

/--
The associated natural conductor is positive.
-/
theorem conductor_pos {R : Type*} [CommRing R]
    {E : WeierstrassCurve R} [E.IsElliptic]
    (h : EllipticCurveConductorData E) :
    0 < h.conductor :=
  Nat.succ_pos h.level

/--
The associated natural conductor is nonzero.
-/
theorem conductor_ne_zero {R : Type*} [CommRing R]
    {E : WeierstrassCurve R} [E.IsElliptic]
    (h : EllipticCurveConductorData E) :
    h.conductor ≠ 0 :=
  Nat.succ_ne_zero h.level

end EllipticCurveConductorData

/--
Extract conductor data from an elliptic-curve modularity interface.
-/
def EllipticCurveModularBy.conductorData {R : Type*} [CommRing R]
    {E : WeierstrassCurve R} [E.IsElliptic]
    {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {f : ModularForm Γ k}
    (h : EllipticCurveModularBy E f) :
    EllipticCurveConductorData E where
  level := h.conductor

/--
Extract conductor data from a packaged modular elliptic curve.
-/
def ModularEllipticCurve.conductorData {R : Type*} [CommRing R]
    {E : WeierstrassCurve R} [E.IsElliptic]
    {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {ι : Type*}
    {T : ι → HeckeOperator Γ k} (h : ModularEllipticCurve E T) :
    EllipticCurveConductorData E :=
  h.modularBy.conductorData

end NumberTheory
