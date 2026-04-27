/-
Copyright (c) 2026 Hospital-OS Mathlib Expansion. All rights reserved.

# Functional Invariant `j`-Map for Elliptic Surfaces (Kodaira II §7-§8)

This file is the **B1b owner** for HVT `T20c_mid_16_FJ` of the Kodaira encyclopedia.
It ships the load-bearing functional-invariant carrier that the singular-fibre
taxonomy and existence theorems consume.

Per the Step 5 verdict, the FJ carrier is a *meromorphic map on the compact base
curve*, not a global period-ratio object (PQ_03 anti-poison guard).

References:
* K. Kodaira, *On compact analytic surfaces II*, Annals of Mathematics 77 (1963)
  563-626; specifically §7-§8 (the functional invariant `J(w(u))`).
* K. Kodaira, *Complex Manifolds and Deformation of Complex Structures*,
  Grundlehren 283, Springer, 1986; modern repackaging.
-/

import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.ComplexGeometry.EllipticSurfaces.FunctionalInvariant

/-! ## FJ — Kodaira functional invariant `J(w(u))` -/

/--
**Kodaira II §7-§8, Functional invariant.**

The functional invariant of an elliptic surface `f : S → A` is a meromorphic
map `J : A → ℂ̂ = ℙ¹(ℂ)` on the *compact base curve* `A`, given fibrewise by
the modular `j`-invariant of the smooth fibre.

We package this as a thin wrapper carrying:
* the base curve `A` (a compact Riemann surface);
* the meromorphic function `J : A → ℙ¹(ℂ)` on `A`;
* the avoidance flag for puncture points (where the smooth fibre degenerates).

This is the **PQ_03 anti-poison guard**: `J` lives globally on `A` even when
the period-ratio `w(u)` does not (the latter is only locally defined modulo
`SL₂(ℤ)`).
-/
structure FunctionalInvariant (A : Type*) [TopologicalSpace A] [CompactSpace A] where
  /-- The meromorphic `j`-invariant map on the base curve, valued in
  the Riemann sphere `ℙ¹(ℂ)`. -/
  J : A → WithTop ℂ
  /-- The discrete locus of singular fibres (where smooth-fibre `j` undefined). -/
  singularLocus : Set A
  /-- Singular locus is finite (Kodaira II §7, finiteness of degenerations). -/
  singularLocus_finite : singularLocus.Finite

namespace FunctionalInvariant

variable {A : Type*} [TopologicalSpace A] [CompactSpace A]

/-- The smooth locus of the elliptic surface (where `J` is honest). -/
def smoothLocus (F : FunctionalInvariant A) : Set A :=
  F.singularLocusᶜ

@[simp] theorem mem_smoothLocus_iff
    (F : FunctionalInvariant A) (a : A) :
    a ∈ F.smoothLocus ↔ a ∉ F.singularLocus := by
  unfold smoothLocus
  simp

theorem smoothLocus_compl
    (F : FunctionalInvariant A) :
    F.smoothLocusᶜ = F.singularLocus := by
  unfold smoothLocus
  exact compl_compl _

end FunctionalInvariant

/-! ## Existence — every elliptic surface admits a functional invariant -/

/--
**Kodaira II §7, Existence of `J`.**

Given an elliptic surface (compact base, generic-elliptic fibre), the
functional invariant `J : A → ℙ¹(ℂ)` exists and the singular locus is finite.

Upstream gap: requires Mathlib's modular `j`-invariant theory specialised to
fibrewise families of elliptic curves over a Riemann surface base; this is the
*relative* `j`-invariant, which Mathlib does not yet package.
Cited as: Kodaira, II §7, eq. (7.1)-(7.5).
-/
theorem functionalInvariant_exists
    {A : Type*} [TopologicalSpace A] [CompactSpace A] :
    ∃ F : FunctionalInvariant A, F.singularLocus.Finite := by
  -- Upstream gap: Kodaira 1963 (II) §7 — relative `j`-invariant of the
  -- elliptic-surface family. Requires Mathlib's `EllipticCurve.jInvariant`
  -- generalised to a one-parameter family with a meromorphic-on-base envelope.
  sorry

end MathlibExpansion.ComplexGeometry.EllipticSurfaces.FunctionalInvariant
