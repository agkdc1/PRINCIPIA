/-
Copyright (c) 2026 MathlibExpansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: MathlibExpansion (T21c-01 Eisenbud–Harris, Step 6, Session 1)
-/
import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Scheme
import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic
import Mathlib.RingTheory.MvPolynomial.Homogeneous

/-!
# Projective `r`-space over a commutative ring

This file packages `AlgebraicGeometry.Proj` of the standard-graded polynomial ring
`k[x₀, …, xᵣ]` as a named scheme `ProjectiveSpace k r`, the textbook object
`P^r_k` of Eisenbud–Harris (*Geometry of Schemes*, Chapter I §I.3).

## Why a named wrapper

`AlgebraicGeometry.Proj` (Mathlib) takes an arbitrary `ℕ`-graded algebra and produces a
scheme; it is not packaged as the textbook object `P^r_k`.  Moreover, the
`MvPolynomial.gradedAlgebra` definition is intentionally *not* a global instance in
Mathlib — see the docstring at `Mathlib/RingTheory/MvPolynomial/Homogeneous.lean`,
because `MvPolynomial σ R` admits other gradings (weighted, multi-graded) and Mathlib
declines to commit to one.  As a consequence a downstream user who simply writes
`Proj (MvPolynomial.homogeneousSubmodule (Fin (r+1)) k)` cannot rely on instance
synthesis to find `[GradedAlgebra _]`.  This file fixes the standard grading once and
for all on `Fin (r+1)`-variable polynomial rings, then defines the named scheme,
declares the standard scoped notation `ℙ(r; k)`, and provides the affine-coordinate
chart and homogeneous-ideal scaffolding that downstream theorems (Hartshorne II.5
twisting sheaves, schematic image, blowup) will hang on.

## Main definitions

* `MathlibExpansion.AlgebraicGeometry.mvPolyGrading k r` — the standard total-degree
  grading on `k[x₀, …, xᵣ]`.
* `MathlibExpansion.AlgebraicGeometry.instGradedAlgebra` — its `GradedAlgebra` instance,
  promoted from the non-global Mathlib `MvPolynomial.gradedAlgebra`.
* `MathlibExpansion.AlgebraicGeometry.ProjectiveSpace k r` — projective `r`-space
  over the commutative ring `k`, defined as `Proj` of the standard-graded
  `k[x₀, …, xᵣ]`.
* `ProjectiveSpace.basicOpen_X k r i` — the affine coordinate open `D₊(xᵢ) ⊆ ℙ^r_k`.
* `ProjectiveSpace.ProjectiveLine`, `ProjectiveSpace.ProjectivePlane` — the
  one-dimensional and two-dimensional special cases.

## Notation

* `ℙ(r; k)` — projective `r`-space over `k` (scoped to
  `MathlibExpansion.AlgebraicGeometry`).

## Main results

* `ProjectiveSpace.iSup_basicOpen_X_eq_top` — the basic opens `D₊(x₀), …, D₊(xᵣ)`
  jointly cover `ℙ^r_k` (standard affine atlas).
* `ProjectiveSpace.isAffineOpen_basicOpen_X` — each chart `D₊(xᵢ)` is affine.
* `ProjectiveSpace.mem_basicOpen_X` — point-set characterisation of `D₊(xᵢ)` as the
  locus of relevant homogeneous primes not containing `xᵢ`.

The two `theorem`s above are stated against `Mathlib`'s API but their proofs are
deferred (`sorry`) to subsequent sessions of T21c-01 — Session 1's contractual
deliverable per the Step-5 verdict is the named-scheme packaging plus the chart
*statements*.  Twisting sheaves `O(n)` are explicitly out of Session 1 scope (HVT-2,
deferred to a later session).

## References

* [D. Eisenbud, J. Harris, *Geometry of Schemes*][EH00], Chapter I §I.3.
* [R. Hartshorne, *Algebraic Geometry*][Har77], Chapter II §2.
* `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Scheme` — generic `Proj` construction.
-/

noncomputable section

open AlgebraicGeometry MvPolynomial CategoryTheory

namespace MathlibExpansion.AlgebraicGeometry

universe u

/-! ### Standard graded structure on `k[x₀, …, xᵣ]` -/

/-- The standard total-degree grading on `k[x₀, …, xᵣ]`:
the `n`-th piece is the submodule of homogeneous polynomials of degree `n`. -/
abbrev mvPolyGrading (k : Type u) [CommRing k] (r : ℕ) :
    ℕ → Submodule k (MvPolynomial (Fin (r + 1)) k) :=
  MvPolynomial.homogeneousSubmodule (Fin (r + 1)) k

/-- Graded-algebra instance for the standard total-degree grading on `k[x₀, …, xᵣ]`.

This wraps the non-global `MvPolynomial.gradedAlgebra` so downstream users do not
have to invoke `attribute [local instance]` themselves; the instance is harmless to
expose globally because we have already fixed the variable index type to be
`Fin (r + 1)` and the grading function to be the standard total-degree one. -/
instance instGradedAlgebra (k : Type u) [CommRing k] (r : ℕ) :
    GradedAlgebra (mvPolyGrading k r) :=
  MvPolynomial.gradedAlgebra

/-! ### Definition -/

/-- The **projective `r`-space** over a commutative ring `k`,

  `ℙ^r_k := Proj(k[x₀, …, xᵣ])`,

for the standard total-degree grading on `k[x₀, …, xᵣ]`.

This is the named, textbook object of Eisenbud–Harris (*Geometry of Schemes* §I.3),
distinguished from the generic `AlgebraicGeometry.Proj` of an abstract graded algebra
by fixing the graded ring to be `MvPolynomial (Fin (r + 1)) k` with its standard
grading. -/
def ProjectiveSpace (k : Type u) [CommRing k] (r : ℕ) : Scheme :=
  AlgebraicGeometry.Proj (mvPolyGrading k r)

namespace ProjectiveSpace

/-- Textbook notation `ℙ(r; k)` for projective `r`-space over `k`. -/
scoped notation "ℙ(" r "; " k ")" => ProjectiveSpace k r

/-! ### Affine coordinate opens -/

/-- The basic open `D₊(xᵢ) ⊆ ℙ^r_k` corresponding to the `i`-th homogeneous
coordinate.  Together these form the standard `r+1`-chart affine atlas of
projective space. -/
def basicOpen_X (k : Type u) [CommRing k] (r : ℕ) (i : Fin (r + 1)) :
    (ProjectiveSpace k r).Opens :=
  AlgebraicGeometry.Proj.basicOpen (mvPolyGrading k r) (X i)

variable {k : Type u} [CommRing k] {r : ℕ}

@[simp]
theorem mem_basicOpen_X (x : ProjectiveSpace k r) (i : Fin (r + 1)) :
    x ∈ basicOpen_X k r i ↔ X i ∉ x.asHomogeneousIdeal :=
  Iff.rfl

/-! ### The standard affine cover

Hartshorne II.2 / Eisenbud–Harris §I.3: the basic opens `D₊(x₀), …, D₊(xᵣ)` cover
`ℙ^r_k`, and each one is affine, isomorphic to `Spec` of the degree-zero part of
the homogeneous localisation at `xᵢ`. -/

/-- The basic opens `D₊(x₀), …, D₊(xᵣ)` jointly cover `ℙ^r_k`. -/
theorem iSup_basicOpen_X_eq_top :
    ⨆ i : Fin (r + 1), basicOpen_X k r i = ⊤ := by
  -- Mathematical content: a relevant homogeneous prime `p` of `k[x₀, …, xᵣ]`
  -- cannot contain every `Xᵢ`, otherwise it would contain the irrelevant ideal
  -- (the `Xᵢ` generate the degree-1 piece of the standard grading, and any
  -- positive-degree element is a `k`-linear combination of monomials in the `Xᵢ`).
  -- The full proof reduces to `Proj.iSup_basicOpen_eq_top` (Mathlib) once one
  -- shows `{X 0, …, X r}` generates the irrelevant ideal under the standard
  -- grading; that combinatorial step is deferred to a Session-2 follow-up.
  sorry

/-- Each affine chart `D₊(xᵢ)` is an affine open subscheme of `ℙ^r_k`. -/
theorem isAffineOpen_basicOpen_X (i : Fin (r + 1)) :
    (basicOpen_X k r i).IsAffineOpen := by
  -- Mathematical content: `X i` is homogeneous of degree 1 — i.e.
  -- `X i ∈ mvPolyGrading k r 1 = MvPolynomial.homogeneousSubmodule (Fin (r+1)) k 1` —
  -- and `1 > 0`, so `Proj.isAffineOpen_basicOpen` applies and the chart is affine,
  -- isomorphic to `Spec` of the degree-zero homogeneous localisation `(R_{X i})₀`.
  -- That last localisation is in turn isomorphic to a polynomial ring in `r`
  -- variables over `k`, identifying the chart with `𝔸^r_k` (Eisenbud–Harris §I.3,
  -- Hartshorne II.2 Proposition 2.5).  Detailed proof deferred to Session 2.
  sorry

/-! ### Low-dimensional special cases

These aliases give names to the small-dimensional projective spaces that appear
throughout the textbook: the projective line `ℙ^1`, the projective plane `ℙ^2`,
and the degenerate `ℙ^0` (a single point, the projective space of a 1-dimensional
vector space). -/

/-- Projective line `ℙ^1_k` over a commutative ring `k`. -/
abbrev ProjectiveLine (k : Type u) [CommRing k] : Scheme :=
  ProjectiveSpace k 1

/-- Projective plane `ℙ^2_k` over a commutative ring `k`. -/
abbrev ProjectivePlane (k : Type u) [CommRing k] : Scheme :=
  ProjectiveSpace k 2

/-- Projective 0-space `ℙ^0_k`: with only one homogeneous coordinate `x₀`, the
single basic open `D₊(x₀)` already equals the whole scheme.  This is the
point-set realisation of "`ℙ^0 = Spec k`" (Eisenbud–Harris §I.3 Exercise I-15). -/
theorem basicOpen_X_zero_eq_top_of_dim_zero {k : Type u} [CommRing k] :
    basicOpen_X k 0 0 = ⊤ := by
  -- Reduces to `iSup_basicOpen_X_eq_top` at `r = 0`: with only one index `0 : Fin 1`,
  -- the `iSup` collapses to the single term `basicOpen_X k 0 0`.  Pending the proof
  -- of `iSup_basicOpen_X_eq_top` in Session 2, we leave this as a stub.
  sorry

end ProjectiveSpace

end MathlibExpansion.AlgebraicGeometry

end
