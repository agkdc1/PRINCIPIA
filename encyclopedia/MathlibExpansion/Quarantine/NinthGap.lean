/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.EighthGap
import MathlibExpansion.FirstGap

/-!
# Galois deformation theory interface

This file supplies the ninth FLT-chain interface: the deformation-theory
boundary used by the Wiles/Taylor-Wiles modularity proof. Mathlib does not
currently expose universal Galois deformation rings, so this module records
the smallest reusable interface: residual representations, deformation
conditions, lifts to coefficient rings, the associated functor of
deformations, and a universal ring package representing that functor.
-/

universe u v w

namespace NumberTheory

/--
A residual Galois representation over a coefficient field or residue ring.
The representation itself reuses the GaloisRepresentation interface from the
first FLT-chain gap.
-/
structure ResidualGaloisRepresentation (G : Type u) (k : Type v) (V : Type w)
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)] where
  representation : GaloisRepresentation G k V

/--
A deformation condition on lifts of a fixed residual representation.
The predicate is intentionally bundled as data: later files can instantiate it
with local ramification, determinant, minimality, flatness, or ordinary
conditions once those theories exist in Mathlib.
-/
structure GaloisDeformationCondition {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    (ρbar : ResidualGaloisRepresentation G k V) where
  condition : Prop

/--
A lift of a residual Galois representation to a coefficient ring A, together
with a residue map back to k and a proposition asserting compatibility with
the residual representation.
-/
structure GaloisDeformation {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    (ρbar : ResidualGaloisRepresentation G k V)
    (A : Type*) (M : Type*) [TopologicalSpace A] [Semiring A]
    [TopologicalSpace M] [AddCommMonoid M] [Module A M]
    [TopologicalSpace (M ≃ₗ[A] M)] where
  lift : GaloisRepresentation G A M
  residue : A →+* k
  residualCompatibility : Prop
  compatible : residualCompatibility

/--
Recover the residual compatibility condition for a deformation.
-/
theorem GaloisDeformation.compatible_condition {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {A : Type*} {M : Type*} [TopologicalSpace A] [Semiring A]
    [TopologicalSpace M] [AddCommMonoid M] [Module A M]
    [TopologicalSpace (M ≃ₗ[A] M)]
    (D : GaloisDeformation ρbar A M) : D.residualCompatibility :=
  D.compatible

/--
A deformation of ρbar satisfying a chosen deformation condition.
-/
structure ConditionedGaloisDeformation {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    (C : GaloisDeformationCondition ρbar)
    (A : Type*) (M : Type*) [TopologicalSpace A] [Semiring A]
    [TopologicalSpace M] [AddCommMonoid M] [Module A M]
    [TopologicalSpace (M ≃ₗ[A] M)] where
  deformation : GaloisDeformation ρbar A M
  satisfies : C.condition

/--
The deformation functor interface assigning to each coefficient ring the type
of deformations it carries.
-/
structure GaloisDeformationFunctor {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    (ρbar : ResidualGaloisRepresentation G k V) where
  obj : Type* → Type*

/--
A universal deformation ring for a residual representation and deformation
functor. The field represents packages the universal property as a proposition
so future Mathlib representability infrastructure can replace it by an
isomorphism with a hom-functor.
-/
structure UniversalDeformationRing {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    (ρbar : ResidualGaloisRepresentation G k V)
    (F : GaloisDeformationFunctor ρbar) where
  ring : Type*
  topologicalSpace : TopologicalSpace ring
  commRing : CommRing ring
  isLocal : IsLocalRing ring
  universalDeformation : F.obj ring
  represents : Prop
  universalProperty : represents

attribute [instance] UniversalDeformationRing.topologicalSpace
attribute [instance] UniversalDeformationRing.commRing
attribute [instance] UniversalDeformationRing.isLocal

/--
Recover the universal property from a universal deformation ring package.
-/
theorem UniversalDeformationRing.represents_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    (R : UniversalDeformationRing ρbar F) : R.represents :=
  R.universalProperty

end NumberTheory
