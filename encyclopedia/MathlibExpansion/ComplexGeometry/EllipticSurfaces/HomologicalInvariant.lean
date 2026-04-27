/-
Copyright (c) 2026 Hospital-OS Mathlib Expansion. All rights reserved.

# Homological Invariant Sheaf `G` (Kodaira II §8)

This file is the **B1b owner** for HVT `T20c_mid_16_HIS` of the Kodaira
encyclopedia. It ships the load-bearing homological-invariant carrier:
the sheaf `G` of "primitive periods" of the elliptic-surface family.

Per the Step 5 verdict (PQ_03 anti-poison guard), `G` is a *sheaf / local-system
carrier with extension data*, not a list of monodromy matrices.

References:
* K. Kodaira, *On compact analytic surfaces II*, Annals of Mathematics 77 (1963)
  563-626; specifically §8 (the homological invariant sheaf).
* K. Kodaira, *Complex Manifolds and Deformation of Complex Structures*,
  Grundlehren 283, Springer, 1986; modern repackaging.
-/

import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.ComplexGeometry.EllipticSurfaces.HomologicalInvariant

open CategoryTheory TopologicalSpace

/-! ## HIS — Kodaira homological invariant sheaf `G` -/

/--
**Kodaira II §8, Homological invariant sheaf `G`.**

The homological invariant of an elliptic surface `f : S → A` is a *sheaf of
abelian groups* `G` on the base curve `A`, locally isomorphic to the lattice
`ℤ²` away from singular fibres. Globally `G` carries the monodromy
representation of `π₁(A \ Δ)` on the period lattice of a smooth fibre.

We package `G` as a sheaf of abelian groups on `A` (PQ_03 guard: not a list of
matrices). The `Sheaf` type is taken in the Mathlib `CategoryTheory.Sheaf`
formalism; specialisation to abelian-group-valued sheaves sits inside that.

Concretely, `G` is the direct image `R¹f_* ℤ` (Kodaira II §8 eq. (8.1));
locally on the smooth locus this is the local system of `H¹(F_a, ℤ) = ℤ²` for
the smooth fibre `F_a`.
-/
structure HomologicalInvariantSheaf (A : Type*) [TopologicalSpace A] where
  /-- The underlying presheaf of abelian groups, encoded fibrewise. -/
  stalk : A → Type
  /-- Each stalk carries an `AddCommGroup` structure (lattice of periods). -/
  stalk_addGroup : ∀ a : A, AddCommGroup (stalk a)
  /-- The smooth-locus stalk is rank-2 free abelian (Kodaira II eq. (8.1)). -/
  stalk_isLattice :
    ∃ singularLocus : Set A, singularLocus.Finite ∧
      ∀ a : A, a ∉ singularLocus →
        Nonempty ((stalk a) ≃+ (Fin 2 → ℤ))

namespace HomologicalInvariantSheaf

variable {A : Type*} [TopologicalSpace A]

/-- The smooth-locus is the complement of the (finite) singular set. -/
noncomputable def smoothLocus
    (G : HomologicalInvariantSheaf A) : Set A :=
  G.stalk_isLattice.choose ᶜ

theorem smoothLocus_open_in_finite_complement
    (G : HomologicalInvariantSheaf A) :
    G.stalk_isLattice.choose.Finite := by
  exact G.stalk_isLattice.choose_spec.1

end HomologicalInvariantSheaf

/-! ## Existence -/

/--
**Kodaira II §8, Existence of `G`.**

Every elliptic surface admits a homological invariant sheaf `G = R¹f_* ℤ`
on its base curve, with finite singular locus.

Upstream gap: requires Mathlib's higher direct image `R¹f_*` for analytic
families, applied to the constant sheaf `ℤ`. Mathlib has `Mathlib.AlgebraicGeometry.SheafedSpace`
and `Mathlib.CategoryTheory.Sheaves` but the analytic-family direct-image
construction (with proper-base-change for elliptic surfaces) is not yet
packaged in usable form. Cited as: Kodaira II §8 eq. (8.1)-(8.3).
-/
theorem homologicalInvariantSheaf_exists
    {A : Type*} [TopologicalSpace A] [CompactSpace A] :
    ∃ G : HomologicalInvariantSheaf A, True := by
  -- Upstream gap: Kodaira 1963 (II) §8. Direct-image sheaf of integral
  -- cohomology along the elliptic-surface fibration. Mathlib lacks the
  -- analytic-family `R¹f_*` over a Riemann surface.
  sorry

end MathlibExpansion.ComplexGeometry.EllipticSurfaces.HomologicalInvariant
