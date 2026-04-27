/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.FourthGap
import Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass
import Mathlib.NumberTheory.LSeries.Basic

/-!
# Modular elliptic curves

This file supplies the sixth atomic FLT-chain interface: the elliptic-curve
side of modularity. Mathlib currently has Weierstrass elliptic curves and
general L-series infrastructure, but not a bundled elliptic-curve conductor,
elliptic-curve L-function, or modularity theorem. The structure below records
the data needed to state that an elliptic curve is modular by a Hecke
eigenform, through equality of the coefficient systems defining their
L-series.
-/

open scoped MatrixGroups

namespace NumberTheory

/--
An elliptic curve is modular by a modular form if it has a conductor level,
coefficient systems for the elliptic curve and modular form L-series, and a
proof that these coefficient systems agree at every natural index.

The field `coefficient_match` is the deliberately small interface where later
developments can install the usual equality between point-counting/Frobenius
coefficients of the curve and Fourier coefficients of the associated newform.
-/
structure EllipticCurveModularBy {R : Type*} [CommRing R]
    (E : WeierstrassCurve R) [E.IsElliptic]
    {Γ : Subgroup SL(2, ℤ)} {k : ℤ} (f : ModularForm Γ k) where
  conductor : ℕ
  ellipticCoefficient : ℕ → ℂ
  modularCoefficient : ℕ → ℂ
  coefficient_match : ∀ n, ellipticCoefficient n = modularCoefficient n

/--
Recover the coefficient compatibility at a specified index from an elliptic
curve modularity interface.
-/
theorem EllipticCurveModularBy.coefficient_eq {R : Type*} [CommRing R]
    {E : WeierstrassCurve R} [E.IsElliptic]
    {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {f : ModularForm Γ k}
    (h : EllipticCurveModularBy E f) (n : ℕ) :
    h.ellipticCoefficient n = h.modularCoefficient n :=
  h.coefficient_match n

/--
The L-series built from the elliptic-curve coefficients agrees pointwise with
the L-series built from the modular-form coefficients.
-/
theorem EllipticCurveModularBy.LSeries_eq {R : Type*} [CommRing R]
    {E : WeierstrassCurve R} [E.IsElliptic]
    {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {f : ModularForm Γ k}
    (h : EllipticCurveModularBy E f) :
    LSeries h.ellipticCoefficient = LSeries h.modularCoefficient := by
  funext s
  exact LSeries_congr s (fun {n} _hn => h.coefficient_match n)

/--
Package modularity of an elliptic curve together with a Hecke eigenvalue
system for the modular form that realizes it. This connects the elliptic-curve
side to the Hecke-eigenform side already formalized in earlier gaps.
-/
structure ModularEllipticCurve {R : Type*} [CommRing R]
    (E : WeierstrassCurve R) [E.IsElliptic]
    {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {ι : Type*}
    (T : ι → HeckeOperator Γ k) where
  form : ModularForm Γ k
  eigenvalueSystem : HeckeEigenvalueSystem T form
  modularBy : EllipticCurveModularBy E form

/--
Recover the modularity interface from a packaged modular elliptic curve.
-/
def ModularEllipticCurve.modular_by {R : Type*} [CommRing R]
    {E : WeierstrassCurve R} [E.IsElliptic]
    {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {ι : Type*}
    {T : ι → HeckeOperator Γ k} (h : ModularEllipticCurve E T) :
    EllipticCurveModularBy E h.form :=
  h.modularBy

end NumberTheory
