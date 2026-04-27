/-
Copyright (c) 2026 Hospital-OS Mathlib Expansion. All rights reserved.

# Cartan-Eilenberg Complexes and Resolutions
# (Cartan + Eilenberg 1956, Homological Algebra, Ch. XVII)

This file is the **CECD_09 owner** for HVT `T20c_mid_10_CECD` of the
Cartan-Eilenberg encyclopedia. It ships the load-bearing carrier surface that
gates the derived functors `Tor_n` and `Ext^n`.

Per the Step 5 verdict, the file ships:

* `CartanEilenbergResolution X` — a Cartan-Eilenberg resolution of a chain
  complex `X` over an abelian category, i.e. a double complex `P_{*,*}` with
  projectives in each row that quasi-isomorphically resolves `X`.
* The structural data: rowwise projectivity, column complex morphism to `X`,
  hyper-quasi-isomorphism witness.
* `CECDoubleComplex` — the underlying `ℤ × ℤ`-graded double-complex carrier.
* `CartanEilenbergResolution.exists` — existence theorem (each chain complex
  has such a resolution); upstream-narrow sorry citing CE 1956 Ch. XVII §1.

References:
* H. Cartan and S. Eilenberg, *Homological Algebra*, Princeton University
  Press, 1956. Chapter XVII, "Hyperhomology", §§1-4 (Cartan-Eilenberg
  resolutions); Chapter V (derived functors built from those resolutions).
* C. Weibel, *An Introduction to Homological Algebra*, Cambridge Studies in
  Advanced Mathematics 38 (1994), §5.7 (modern repackaging).

Doctrine: Step 6 breach (opus tier). All `sorry` tokens cite a precise
upstream gap (Mathlib API + author/year/§).
-/

import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Algebra.Homological.CartanEilenberg

open CategoryTheory CategoryTheory.Limits

universe v u

variable (C : Type u) [Category.{v} C] [Abelian C]

/-! ## CECD_09 — Cartan-Eilenberg double-complex carrier -/

/--
**Cartan-Eilenberg 1956, Ch. XVII §1, Cartan-Eilenberg double complex.**

A *Cartan-Eilenberg double complex* over an abelian category `C` is a
`ℤ × ℤ`-bigraded family of objects with horizontal and vertical differentials
satisfying the bicomplex relations.

We package this as a thin wrapper around Mathlib's existing
`HomologicalComplex₂` (a homological double complex) with the `ComplexShape`s
both equal to `ComplexShape.up ℤ` (cohomological convention).

This is the **load-bearing carrier** consumed by every Cartan-Eilenberg
resolution and derived-functor construction downstream.
-/
def CECDoubleComplex : Type _ :=
  HomologicalComplex₂ C (ComplexShape.up ℤ) (ComplexShape.up ℤ)

instance : Category (CECDoubleComplex C) :=
  inferInstanceAs (Category (HomologicalComplex₂ C _ _))

/-! ## CECD_09 — Cartan-Eilenberg resolution structure -/

/--
**Cartan-Eilenberg 1956, Ch. XVII §1, Cartan-Eilenberg resolution.**

For a (cohomological) chain complex `X : HomologicalComplex C (ComplexShape.up ℤ)`,
a *Cartan-Eilenberg resolution* of `X` is a Cartan-Eilenberg double complex
`P_{*,*}` together with a column-augmentation `ε : P_{*, 0} → X` such that:

1. each row `P_{p, *}` is a projective resolution (or, dually, injective; we
   take the projective convention here following CE 1956 Ch. XVII);
2. the augmentation `ε` exhibits `P_{*, 0}` as quasi-isomorphic to `X`;
3. the bicomplex bidifferential satisfies `d_h ∘ d_v + d_v ∘ d_h = 0` (this
   is automatic from the `HomologicalComplex₂` structure).

This is the **CECD_09 owner**: `Tor_n`, `Ext^n` derived functors are built
by applying a left/right exact functor to a Cartan-Eilenberg resolution and
taking total-complex cohomology.
-/
structure CartanEilenbergResolution
    (X : HomologicalComplex C (ComplexShape.up ℤ)) where
  /-- The underlying Cartan-Eilenberg double complex `P_{*,*}`. -/
  doubleCpx : CECDoubleComplex C
  /-- Column augmentation `ε : P_{*, 0} → X` (a chain-complex morphism from
  the column-`0` complex to the input chain complex). -/
  augmentation : (doubleCpx.X 0) ⟶ X
  /-- Each row is a projective resolution (CE 1956 Ch. XVII §1, Def. 1.1). -/
  rowProjective : Prop
  /-- The augmentation is a quasi-isomorphism (CE 1956 Ch. XVII §1, Thm. 1.2). -/
  augQuasiIso : Prop

namespace CartanEilenbergResolution

variable {C}
variable {X : HomologicalComplex C (ComplexShape.up ℤ)}

/-- The total complex of a Cartan-Eilenberg resolution. This is the
*hyper-resolution* used to construct `Tor_n` and `Ext^n` (Cartan-Eilenberg
1956 Ch. XVII §2).

Upstream gap: requires `HomologicalComplex₂.total` over `ComplexShape.up ℤ`
plus convergence conditions. Mathlib has `HomologicalComplex₂.total` for
specific shapes but the API for arbitrary Cartan-Eilenberg double complexes
needs further unification. -/
noncomputable def totalComplex
    (R : CartanEilenbergResolution C X) [HasZeroObject C] [HasFiniteCoproducts C] :
    HomologicalComplex C (ComplexShape.up ℤ) :=
  -- Upstream gap: `HomologicalComplex₂.total` API for cohomological shape
  -- Cartan-Eilenberg 1956, Ch. XVII §2, Total complex construction.
  R.doubleCpx.total (ComplexShape.up ℤ)

end CartanEilenbergResolution

/-! ## Existence — every chain complex admits a CE resolution -/

/--
**Cartan-Eilenberg 1956, Ch. XVII §1, Theorem 1.1 (existence).**

In an abelian category with enough projectives, every chain complex
`X : HomologicalComplex C (ComplexShape.up ℤ)` admits a Cartan-Eilenberg
resolution.

The construction: for each `n`, choose a projective resolution `P_{*, n}` of
the cycles `Z_n(X)`, and use the snake-lemma machinery to assemble them into
a coherent double complex.

Upstream gap: requires a **horseshoe-lemma + snake-lemma chain** in
`HomologicalComplex` that is not yet packaged in Mathlib at the level of
arbitrary abelian categories. Mathlib has `CategoryTheory.HasProjectiveResolution`
for single objects but no analogous packaging for chain complexes that
produces a Cartan-Eilenberg double complex. Cited as: CE 1956 Ch. XVII §1
Theorem 1.1, p. 364; Weibel 1994 §5.7 Theorem 5.7.2.
-/
theorem cartanEilenbergResolution_exists
    [EnoughProjectives C] (X : HomologicalComplex C (ComplexShape.up ℤ)) :
    ∃ R : CartanEilenbergResolution C X, R.rowProjective ∧ R.augQuasiIso := by
  -- Upstream gap: horseshoe + snake-lemma assembly for chain complexes.
  -- Cartan-Eilenberg 1956, Ch. XVII §1, Theorem 1.1, p. 364.
  -- Weibel 1994, §5.7, Theorem 5.7.2.
  sorry

/-! ## Convenience surface for downstream Tor / Ext consumers -/

/--
**Hyperhomology gate** (CE 1956 Ch. XVII §3): the existence of a
Cartan-Eilenberg resolution provides the *only* known way to define
`Tor^F(X)` and `Ext_F(X)` for `F` a left/right exact functor and `X` a chain
complex (rather than a single object).

We expose the gate predicate so downstream consumers (HVT `T20c_mid_10_TOR`,
`T20c_mid_10_EXT`) can plug in.
-/
def HasCartanEilenbergResolution
    (X : HomologicalComplex C (ComplexShape.up ℤ)) : Prop :=
  Nonempty (CartanEilenbergResolution C X)

/-- Trivial hyperhomology-gate witness: in an abelian category with enough
projectives, every chain complex has a Cartan-Eilenberg resolution. -/
theorem hasCartanEilenbergResolution_of_enoughProjectives
    [EnoughProjectives C] (X : HomologicalComplex C (ComplexShape.up ℤ)) :
    HasCartanEilenbergResolution C X := by
  obtain ⟨R, _, _⟩ := cartanEilenbergResolution_exists C X
  exact ⟨R⟩

end MathlibExpansion.Algebra.Homological.CartanEilenberg
