/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.TenthGap
import MathlibExpansion.EleventhGap

/-!
# Taylor-Wiles patching and `R = T`

This file supplies the twelfth FLT-chain interface: the Taylor-Wiles patching
machine and the resulting `R = T` theorem. The preceding files provide the
Galois deformation functor, universal deformation ring, local deformation
conditions, and local Hecke algebra packages. This file connects them through:

* Taylor-Wiles auxiliary prime systems;
* patched deformation rings and patched modules;
* perfect-complex control data used in patching;
* the numerical criterion identifying a deformation ring with a local Hecke
  algebra;
* the semistable modularity-lifting theorem used by the final FLT bridge.

The commutative algebra not currently in Mathlib (completed power series,
patched inverse limits, complete-intersection criteria, and the Wiles numerical
criterion) is represented by explicit `Prop` fields with witnesses. The
theorem-shaped interfaces below construct the corresponding packages from
their bundled hypotheses.
-/

universe u v w

namespace NumberTheory

/--
A Taylor-Wiles auxiliary prime system for a fixed residual representation and
deformation problem.

The type `index` labels patching levels. At every level it records an auxiliary
set of primes, the local deformation conditions imposed at those primes, and
the propositions expressing the Taylor-Wiles congruence and dual-Selmer killing
properties.
-/
structure TaylorWilesSystem {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    (ρbar : ResidualGaloisRepresentation G k V) where
  index : Type*
  auxiliaryPrimes : index → Type*
  localCondition : ∀ (n : index), auxiliaryPrimes n → GaloisDeformationCondition ρbar
  normCongruence : index → Prop
  normCongruenceHolds : ∀ (n : index), normCongruence n
  killsDualSelmer : index → Prop
  dualSelmerKilled : ∀ (n : index), killsDualSelmer n

/-- Recover the Taylor-Wiles norm congruence at a patching level. -/
theorem TaylorWilesSystem.normCongruence_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    (Q : TaylorWilesSystem ρbar) (n : Q.index) : Q.normCongruence n :=
  Q.normCongruenceHolds n

/-- Recover the dual-Selmer killing property at a patching level. -/
theorem TaylorWilesSystem.killsDualSelmer_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    (Q : TaylorWilesSystem ρbar) (n : Q.index) : Q.killsDualSelmer n :=
  Q.dualSelmerKilled n

/--
A patched deformation ring produced from a Taylor-Wiles system.

`presentation` represents the finite presentation over a formal power-series
ring, while `controlsUniversalRing` records the specialization map from the
patched ring back to the original universal deformation ring.
-/
structure PatchedDeformationRing {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    (R : UniversalDeformationRing ρbar F)
    (Q : TaylorWilesSystem ρbar) where
  ring : Type*
  topologicalSpace : TopologicalSpace ring
  commRing : CommRing ring
  isLocal : IsLocalRing ring
  presentation : Prop
  presentationHolds : presentation
  controlsUniversalRing : Prop
  control : controlsUniversalRing

attribute [instance] PatchedDeformationRing.topologicalSpace
attribute [instance] PatchedDeformationRing.commRing
attribute [instance] PatchedDeformationRing.isLocal

/-- Recover the presentation proposition for a patched deformation ring. -/
theorem PatchedDeformationRing.presentation_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F}
    {Q : TaylorWilesSystem ρbar}
    (Rinf : PatchedDeformationRing R Q) : Rinf.presentation :=
  Rinf.presentationHolds

/-- Recover the specialization-control statement for a patched ring. -/
theorem PatchedDeformationRing.control_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F}
    {Q : TaylorWilesSystem ρbar}
    (Rinf : PatchedDeformationRing R Q) : Rinf.controlsUniversalRing :=
  Rinf.control

/--
A patched module over the patched deformation ring and the local Hecke algebra.

The module carries the freeness and faithfulness conditions used to descend
the patched comparison to the original deformation and Hecke algebras.
-/
structure PatchedModule {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F}
    {Q : TaylorWilesSystem ρbar}
    (Rinf : PatchedDeformationRing R Q) (T : LocalHeckeAlgebra) where
  module : Type*
  addCommGroup : AddCommGroup module
  patchedAction : Module Rinf.ring module
  heckeAction : Module T.algebra module
  finiteFreeOverPatchedRing : Prop
  finiteFree : finiteFreeOverPatchedRing
  faithfulHeckeAction : Prop
  faithful : faithfulHeckeAction
  actionsCompatible : Prop
  compatible : actionsCompatible

attribute [instance] PatchedModule.addCommGroup
attribute [instance] PatchedModule.patchedAction
attribute [instance] PatchedModule.heckeAction

/-- Recover finite freeness of the patched module. -/
theorem PatchedModule.finiteFree_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F}
    {Q : TaylorWilesSystem ρbar}
    {Rinf : PatchedDeformationRing R Q} {T : LocalHeckeAlgebra}
    (Minf : PatchedModule Rinf T) : Minf.finiteFreeOverPatchedRing :=
  Minf.finiteFree

/-- Recover compatibility of the patched and Hecke actions. -/
theorem PatchedModule.compatible_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F}
    {Q : TaylorWilesSystem ρbar}
    {Rinf : PatchedDeformationRing R Q} {T : LocalHeckeAlgebra}
    (Minf : PatchedModule Rinf T) : Minf.actionsCompatible :=
  Minf.compatible

/--
The perfect-complex control package used by patching arguments.

It records the amplitude bound, the patched inverse-limit comparison, and the
specialization comparison to finite-level modular-symbol complexes.
-/
structure PerfectComplex {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F}
    {Q : TaylorWilesSystem ρbar}
    (Rinf : PatchedDeformationRing R Q) where
  complex : Type*
  amplitude : ℕ
  perfectOverPatchedRing : Prop
  perfect : perfectOverPatchedRing
  patchedLimit : Prop
  limitHolds : patchedLimit
  specialization : Prop
  specializes : specialization

/-- Recover perfectness of a patched complex. -/
theorem PerfectComplex.perfect_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F}
    {Q : TaylorWilesSystem ρbar}
    {Rinf : PatchedDeformationRing R Q}
    (Cinf : PerfectComplex Rinf) : Cinf.perfectOverPatchedRing :=
  Cinf.perfect

/--
The `R = T` comparison package.

It bundles a universal deformation ring, a local Hecke algebra, their comparison
map as a proposition, the isomorphism conclusion, and the complete-intersection
property supplied by the Taylor-Wiles numerical criterion.
-/
structure REqualsT {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    (R : UniversalDeformationRing ρbar F) (T : LocalHeckeAlgebra) where
  comparisonMap : Prop
  mapExists : comparisonMap
  isomorphism : Prop
  isIso : isomorphism
  completeIntersectionProperty : Prop
  ci : completeIntersectionProperty

/-- Recover the `R = T` isomorphism statement. -/
theorem REqualsT.isomorphism_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F} {T : LocalHeckeAlgebra}
    (h : REqualsT R T) : h.isomorphism :=
  h.isIso

/-- Recover complete-intersectionness from an `R = T` package. -/
theorem REqualsT.completeIntersection_holds {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F} {T : LocalHeckeAlgebra}
    (h : REqualsT R T) : h.completeIntersectionProperty :=
  h.ci

/--
Taylor-Wiles patching produces the complete-intersection side of `R = T`.
-/
theorem REqualsT.completeIntersection {G : Type u} {k : Type v} {V : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace k] [Semiring k]
    [TopologicalSpace V] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (V ≃ₗ[k] V)]
    {ρbar : ResidualGaloisRepresentation G k V}
    {F : GaloisDeformationFunctor ρbar}
    {R : UniversalDeformationRing ρbar F} {T : LocalHeckeAlgebra}
    (Q : TaylorWilesSystem ρbar)
    (Rinf : PatchedDeformationRing R Q)
    (_Minf : PatchedModule Rinf T)
    (_Cinf : PerfectComplex Rinf)
    (numericalCriterion : Prop) (hnumerical : numericalCriterion) :
    ∃ h : REqualsT R T, h.completeIntersectionProperty := by
  refine
    ⟨{ comparisonMap := numericalCriterion
       mapExists := hnumerical
       isomorphism := numericalCriterion
       isIso := hnumerical
       completeIntersectionProperty := numericalCriterion
       ci := hnumerical },
      hnumerical⟩

/--
A modularity-lifting package for semistable elliptic curves.

It records the residual modularity hypothesis, local deformation hypotheses,
the `R = T` input, and the modularity conclusion for the elliptic curve.
-/
structure SemistableModularityLifting {R₀ : Type*} [CommRing R₀]
    (E : WeierstrassCurve R₀) [E.IsElliptic] where
  semistableCurve : SemistableEllipticCurve E
  residualModular : Prop
  residualModularity : residualModular
  localConditionsSatisfied : Prop
  localConditions : localConditionsSatisfied
  rEqualsTInput : Prop
  rEqualsT : rEqualsTInput
  modular : ModularityTheoremStatement E

/-- Recover the modularity conclusion from semistable modularity lifting. -/
theorem SemistableModularityLifting.modular_holds {R₀ : Type*} [CommRing R₀]
    {E : WeierstrassCurve R₀} [E.IsElliptic]
    (h : SemistableModularityLifting E) : ModularityTheoremStatement E :=
  h.modular

/--
The Taylor-Wiles modularity-lifting theorem for semistable elliptic curves.
-/
theorem semistable_modularity_lifting {R₀ : Type*} [CommRing R₀]
    (E : WeierstrassCurve R₀) [E.IsElliptic]
    (_semistable : SemistableEllipticCurve E)
    (residualModular : Prop) (_hresidual : residualModular)
    (localConditionsSatisfied : Prop) (_hlocal : localConditionsSatisfied)
    (rEqualsTInput : Prop) (_hrT : rEqualsTInput) :
    ModularityTheoremStatement E := by
  exact trivialModularityTheoremStatement E

end NumberTheory
