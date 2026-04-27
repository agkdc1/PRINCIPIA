/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.NinthGap

/-!
# Local deformation conditions and obstruction theory

This file supplies the tenth FLT-chain interface: the local conditions used to
cut out the deformation problem studied by Wiles, plus the obstruction-theoretic
package that underlies the "R = T" theorem of Taylor-Wiles. The previous gap
(Ninth) built the generic functor-of-deformations package. This gap specialises
that package with:

* ordinary, crystalline, and finite-flat local conditions at primes above `p`;
* an unobstructedness interface (formal smoothness of the functor from the
  vanishing of `H²(G_S, ad⁰ ρ̄)`);
* the cotangent-to-Selmer duality used to identify the reduced tangent space of
  the universal deformation ring with a dual Selmer group.

Every deep theorem of the theory (Mazur's unobstructedness criterion, the
Greenberg-Wiles duality, the Fontaine-Laffaille comparison) is intentionally
bundled as a `Prop` carried by the relevant structure. No free content is
asserted.
-/

universe u v w

namespace NumberTheory

/--
The ordinary local condition at a prime above `p`.

Upstream Mathlib has neither the decomposition group at a prime nor the
upper-triangular-with-unramified-quotient predicate. We therefore bundle the
condition as a proposition `ordinaryCondition`, the witness of that proposition,
and the bridging `toCondition` back into `GaloisDeformationCondition`.
-/
structure OrdinaryLocalCondition {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    (ρbar : ResidualGaloisRepresentation G k V) where
  ordinaryCondition : Prop
  ordinary : ordinaryCondition
  toCondition : GaloisDeformationCondition ρbar

/--
Recover the ordinary witness from an `OrdinaryLocalCondition`.
-/
theorem OrdinaryLocalCondition.ordinary_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    (h : OrdinaryLocalCondition ρbar) : h.ordinaryCondition :=
  h.ordinary

/--
The crystalline local condition at a prime above `p`.

Bundled around a `Prop` `crystallineCondition` supplied by downstream Fontaine-
Laffaille / integral p-adic Hodge theory infrastructure. The bridge
`toCondition` hands back the condition in the generic `GaloisDeformationCondition`
language used by the ninth gap.
-/
structure CrystallineLocalCondition {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    (ρbar : ResidualGaloisRepresentation G k V) where
  crystallineCondition : Prop
  crystalline : crystallineCondition
  toCondition : GaloisDeformationCondition ρbar

/--
Recover the crystalline witness.
-/
theorem CrystallineLocalCondition.crystalline_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    (h : CrystallineLocalCondition ρbar) : h.crystallineCondition :=
  h.crystalline

/--
The finite-flat local condition: deformations admitting a finite flat group
scheme model at `p`. Bundled as a proposition until the finite-flat theory is
formalised in Mathlib.
-/
structure FiniteFlatLocalCondition {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    (ρbar : ResidualGaloisRepresentation G k V) where
  finiteFlatCondition : Prop
  finiteFlat : finiteFlatCondition
  toCondition : GaloisDeformationCondition ρbar

/--
Recover the finite-flat witness.
-/
theorem FiniteFlatLocalCondition.finiteFlat_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    (h : FiniteFlatLocalCondition ρbar) : h.finiteFlatCondition :=
  h.finiteFlat

/--
An unobstructedness package for a deformation functor: a `Prop` recording
formal smoothness, together with its witness. Downstream, this is instantiated
by the vanishing of the second adjoint Galois cohomology group.
-/
structure UnobstructedDeformation {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    (F : GaloisDeformationFunctor ρbar) where
  formallySmooth : Prop
  obstructionsVanish : formallySmooth

/--
Recover the formal-smoothness statement from an unobstructedness package.
-/
theorem UnobstructedDeformation.formallySmooth_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    (U : UnobstructedDeformation F) : U.formallySmooth :=
  U.obstructionsVanish

/--
Mazur's unobstructedness theorem (1989, *Deforming Galois representations*).

If a `Prop` representing the vanishing of the adjoint cohomology group
`H²(G_S, ad⁰ ρ̄)` holds, then the deformation functor is formally smooth.
At the present interface level, formal smoothness is the proposition supplied
by the vanishing input.
-/
noncomputable def unobstructed_from_H2_vanishing {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    (F : GaloisDeformationFunctor ρbar)
    (H2Vanishing : Prop) (hvanish : H2Vanishing) :
    UnobstructedDeformation F := by
  exact
    { formallySmooth := H2Vanishing
      obstructionsVanish := hvanish }

/--
The cotangent-to-Selmer duality package used in Taylor-Wiles patching.

Bundles the universal deformation ring with a `Prop` expressing the
reduced-tangent-space equivalence
`m_R / (m_R² + p) ≃ H¹_Sel(G_S, ad⁰ ρ̄)^∨`
between the cotangent space of the universal ring at its maximal ideal and the
dual Selmer group. The equivalence itself is bundled as a proposition pending
formalisation of Selmer groups in Mathlib.
-/
structure CotangentSelmerDuality {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    (R : UniversalDeformationRing ρbar F) where
  cotangentSpace : Type*
  selmerGroup : Type*
  duality : Prop
  dualityHolds : duality

/--
Recover the cotangent-Selmer duality statement.
-/
theorem CotangentSelmerDuality.duality_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F}
    (D : CotangentSelmerDuality R) : D.duality :=
  D.dualityHolds

end NumberTheory
