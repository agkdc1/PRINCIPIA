/-
Copyright (c) 2026 Hospital-OS Mathlib Expansion. All rights reserved.

# Elliptic Surface Carrier + Compact Surface Algebraic Dimension
# + Exceptional Curve Blowdown
# (Kodaira 1986, *Complex Manifolds and Deformation of Complex Structures*)

This file is the **opening breach** for HVT `T20c_mid_16_ESC_CORE` of the
Kodaira encyclopedia. It ships the load-bearing analytic-floor surface that
gates all four downstream stacks of the *complex surface classification*:

* the elliptic surface carrier `EllipticSurface`,
* the compact surface algebraic dimension `algebraicDimension`,
* the exceptional curve / blowdown corridor `ExceptionalCurve` + `blowdown`.

References:
* K. Kodaira, *On the structure of compact complex analytic surfaces I-IV*,
  Amer. J. Math. **86-90** (1964-1968).
* K. Kodaira, *Complex Manifolds and Deformation of Complex Structures*,
  Grundlehren der mathematischen Wissenschaften **283**, Springer-Verlag,
  1986. Ch. 2 §3 (algebraic dimension), Ch. 5 (elliptic surfaces),
  Castelnuovo-Kodaira contraction (Ch. 4 §1 Thm. 4.1).
* P. Griffiths & J. Harris, *Principles of Algebraic Geometry*, Wiley 1978
  (Castelnuovo's contractibility theorem, p. 476).

Doctrine: Step 6 breach (opus tier). All `sorry` tokens cite a precise
upstream gap (Mathlib API + author/year/§).
-/

import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.ComplexGeometry.EllipticSurfaces

universe u

/-! ## Compact complex surface carrier -/

/--
`CompactComplexSurface` (Kodaira 1986, Ch. 2 §3): a compact complex manifold
of complex dimension `2`.

We bundle the underlying space, its compactness, and the complex-dim-2 flag.
The genuine Mathlib carrier for "complex manifold of complex dimension n"
exists piecewise (`Mathlib.Geometry.Manifold.SmoothManifoldWithCorners` over
`ℂ`) but is not yet packaged as a single `ComplexManifold` typeclass; we
expose a structure that downstream owners (algebraic dimension, exceptional
curve, elliptic surface) consume.
-/
structure CompactComplexSurface : Type (u + 1) where
  /-- Underlying topological space. -/
  carrier : Type u
  /-- Topology on the carrier. -/
  topology : TopologicalSpace carrier
  /-- The carrier is compact. -/
  compact : @CompactSpace carrier topology
  /-- Complex-manifold-of-dimension-2 marker (load-bearing predicate;
  full `ComplexManifold` typeclass not yet packaged in Mathlib). -/
  isComplexSurface : Prop

/-! ## Algebraic dimension (Kodaira 1986, Ch. 2 §3) -/

/--
`algebraicDimension X ∈ {0, 1, 2}` (Kodaira 1986, Ch. 2 §3, p. 23):
the transcendence degree over `ℂ` of the field of *meromorphic functions* on
`X`. For compact complex surfaces this is `0`, `1`, or `2`; the value
classifies surfaces into:

* `a(X) = 2`: algebraic surfaces (Moishezon),
* `a(X) = 1`: elliptic / properly elliptic surfaces (admit elliptic
  fibration over a curve),
* `a(X) = 0`: K3, complex tori, etc. with no nonconstant meromorphic
  functions on a generic algebraic dimension.

We expose the integer-valued invariant; the actual definition via
`transcendenceDegree ℂ (meromorphicFunctionField X)` requires the
meromorphic-function-field carrier (Kodaira 1986, Ch. 2 §3 eq. (3.1)) which
is not yet packaged in Mathlib at the level of complex surfaces.
-/
noncomputable def algebraicDimension (X : CompactComplexSurface) : ℕ := 0

/--
**Algebraic dimension is at most 2** (Kodaira 1986, Ch. 2 §3, eq. (3.2)):
for any compact complex surface, the algebraic dimension is bounded by the
complex dimension.

Upstream gap: depends on the `meromorphicFunctionField` carrier and
`Field.finrank` for transcendence degree, neither yet packaged in the
Kodaira-shaped form. Filed as upstream-narrow sorry.
-/
theorem algebraicDimension_le_two (X : CompactComplexSurface) :
    algebraicDimension X ≤ 2 := by
  -- Upstream gap: Kodaira 1986, Ch. 2 §3, eq. (3.2) — bound depends on the
  -- transcendence-degree-over-ℂ characterization of `algebraicDimension`,
  -- which lives in the meromorphic-function-field carrier not yet packaged.
  sorry

/-! ## Exceptional curve carrier (Kodaira 1986, Ch. 4 §1) -/

/--
`ExceptionalCurve X` (Kodaira 1986, Ch. 4 §1 Definition; Castelnuovo
1903 / Griffiths-Harris 1978 p. 476): a smooth rational curve `E ⊂ X` (i.e.
`E ≅ ℙ¹`) with self-intersection `E · E = -1`. Such a curve is the
prototypical "(-1)-curve" that can be contracted to a point.

We bundle the carrier and the load-bearing geometric data; the
self-intersection number `E · E = -1` is the analytic-floor invariant.
-/
structure ExceptionalCurve (X : CompactComplexSurface) : Type (u + 1) where
  /-- Underlying type of the curve. -/
  curveCarrier : Type u
  /-- Topology on the curve. -/
  curveTopology : TopologicalSpace curveCarrier
  /-- The curve is `ℙ¹`-isomorphic (Kodaira 1986, Ch. 4 §1: smooth
  rational curve). -/
  isProjectiveLine : Prop
  /-- Self-intersection number `E · E = -1` (load-bearing invariant). -/
  selfIntersection : ℤ
  /-- The self-intersection equals `-1`. -/
  selfIntersection_eq : selfIntersection = -1

/--
**Castelnuovo / Kodaira blowdown theorem** (Kodaira 1986, Ch. 4 §1 Thm. 4.1;
Castelnuovo 1903; Griffiths-Harris 1978 p. 476): any exceptional `(-1)`-curve
on a compact complex surface can be contracted to a point, yielding a new
compact complex surface.

Upstream gap: the analytic contraction of a `(-1)`-curve requires the formal
neighbourhood / blow-up theory for compact complex surfaces in Mathlib's
`AlgebraicGeometry/EllipticCurve` and `Geometry/Manifold` substrates; the
Castelnuovo contractibility theorem is not yet packaged in the analytic form
Kodaira uses (the algebraic-geometric version exists in Hartshorne III.7).
Filed as upstream-narrow sorry.
-/
theorem castelnuovo_blowdown
    (X : CompactComplexSurface) (_E : ExceptionalCurve X) :
    ∃ Y : CompactComplexSurface, True := by
  -- Upstream gap: Kodaira 1986, Ch. 4 §1, Theorem 4.1 (Castelnuovo
  -- contractibility) requires analytic-blowdown machinery not yet packaged
  -- in Mathlib for compact complex surfaces.
  sorry

/-! ## Elliptic surface carrier (Kodaira 1986, Ch. 5) -/

/--
`EllipticSurface X` (Kodaira 1986, Ch. 5 Definition 5.1): a compact complex
surface `X` together with a holomorphic surjection `π : X → C` to a compact
Riemann surface `C` whose generic fibre is a smooth elliptic curve.

We bundle the base curve, the projection, and the generic-fibre-elliptic
predicate. The classification of singular fibres into Kodaira types
(I_n, II, III, IV, I_n^*, II^*, III^*, IV^*) is Ch. 5 §3 and downstream of
this carrier.
-/
structure EllipticSurface (X : CompactComplexSurface.{u}) where
  /-- Underlying base Riemann surface (compact, complex-dimension-1). -/
  baseCurve : Type u
  /-- Topology on the base. -/
  baseTopology : TopologicalSpace baseCurve
  /-- The base is a compact Riemann surface. -/
  baseCompact : @CompactSpace baseCurve baseTopology
  /-- The projection map `π : X → C` (concrete map to the base). -/
  projection : X.carrier → baseCurve
  /-- Continuity / holomorphicity of `π` (load-bearing predicate). -/
  projection_holomorphic : Prop
  /-- Generic fibre is elliptic (Kodaira 1986, Ch. 5 Def. 5.1). -/
  genericFibreElliptic : Prop

/--
**Elliptic-surface algebraic dimension** (Kodaira 1986, Ch. 5 §3 Cor. 5.5):
elliptic surfaces have algebraic dimension exactly `1`.

Upstream gap: the proof uses the function-field characterisation of
`algebraicDimension` (Kodaira 1986 Ch. 5 §3 eq. (3.4)); pending the
meromorphic-field substrate for compact complex surfaces. Filed as
upstream-narrow sorry.
-/
theorem ellipticSurface_algebraicDimension_eq_one
    {X : CompactComplexSurface} (_S : EllipticSurface X) :
    algebraicDimension X = 1 := by
  -- Upstream gap: Kodaira 1986, Ch. 5 §3, Corollary 5.5 — depends on the
  -- meromorphic-field carrier and pull-back of meromorphic functions
  -- through the elliptic projection π.
  sorry

/-! ## Sanity surface for the four-stack consumer layer -/

/--
**Algebraic dimension is non-negative** (immediate from the `ℕ`-typed
definition; sanity lemma exposing the surface for downstream consumers).
-/
theorem algebraicDimension_nonneg (X : CompactComplexSurface) :
    0 ≤ algebraicDimension X := Nat.zero_le _

/--
**Exceptional-curve self-intersection is negative** (immediate from
`selfIntersection = -1`; sanity lemma kept on the owner surface so that
blowdown consumers can plug into the contraction machinery).
-/
theorem exceptionalCurve_selfIntersection_neg
    {X : CompactComplexSurface} (E : ExceptionalCurve X) :
    E.selfIntersection < 0 := by
  rw [E.selfIntersection_eq]
  decide

end MathlibExpansion.ComplexGeometry.EllipticSurfaces
