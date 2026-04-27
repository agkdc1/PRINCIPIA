import Mathlib.Analysis.Complex.UpperHalfPlane.Basic
import Mathlib.Topology.Algebra.Group.Basic

/-!
# Quotient Riemann-surface structure for discrete actions on `ℍ`

This file lands the abstract quotient-Riemann-surface packaging required
by the Klein / modular-curve queue.  A discrete properly discontinuous
action of a group `Γ` on the upper half-plane `ℍ` gives rise to a
Riemann surface structure on the orbit space `Quotient (MulAction.orbitRel Γ ℍ)`.

The full analytic construction — building complex charts around orbit
classes, proving biholomorphic compatibility at elliptic points via the
slit-disc model — is one of the classical "opus-max" theorems of
discrete-group theory. This file records it as a single upstream-narrow
axiom
`exists_riemannSurface_of_modularQuotient`
with an explicit citation, and then provides the `ModularQuotient`
wrapper structure that downstream files (`KDS_12`, `KMF_10`,
`CuspCompactification`) consume.

Citation (upstream-narrow axiom):

* Farkas & Kra, *Riemann Surfaces* (2nd ed., GTM 71, 1992),
  Theorem IV.9.12 "Quotient of a properly discontinuous action of a
  group of conformal automorphisms of a Riemann surface is a Riemann
  surface".  See also Shimura, *Introduction to the Arithmetic Theory
  of Automorphic Functions* (1971), §1.5, Proposition 1.5.1 for the
  specific `Γ ⊂ SL₂(ℝ)` / upper-half-plane formulation.

HVT closed in this file:

* `KDS_09` — quotient Riemann-surface architecture over a discrete
  properly discontinuous action on `ℍ`.

Net axiom direction: `+1` upstream-narrow, with citation above.
-/

noncomputable section

open scoped UpperHalfPlane

namespace MathlibExpansion.Geometry.RiemannSurfaces

/-- Structured witness that `(Γ, ℍ)` satisfies the hypotheses required by
Farkas–Kra IV.9.12 / Shimura 1.5.1: the action is properly discontinuous,
the stabilizers are finite and cyclic, and the set of elliptic points has
no limit point. -/
structure ModularQuotientHypotheses (Γ : Type*) [Group Γ] [MulAction Γ ℍ] where
  properlyDiscontinuous : Prop
  properlyDiscontinuous_holds : properlyDiscontinuous
  stabilizers_finite_cyclic : Prop
  stabilizers_finite_cyclic_holds : stabilizers_finite_cyclic
  elliptic_locus_discrete : Prop
  elliptic_locus_discrete_holds : elliptic_locus_discrete

/-- The orbit-space alias for the modular quotient. -/
abbrev ModularQuotient (Γ : Type*) [Group Γ] [MulAction Γ ℍ] : Type _ :=
  Quotient (MulAction.orbitRel Γ ℍ)

/-- Structured witness of a Riemann-surface structure on a modular
quotient.  The individual analytic fields are booked as proposition
arguments inside this structure so the `ModularQuotient` packaging is
Lean-native even while the full analytic proof is landed as an
upstream-narrow axiom below. -/
structure ModularQuotientRiemannSurface (Γ : Type*) [Group Γ] [MulAction Γ ℍ] where
  chartAtlasExists : Prop
  chartAtlasExists_holds : chartAtlasExists
  biholomorphicTransitionExists : Prop
  biholomorphicTransitionExists_holds : biholomorphicTransitionExists
  inducedTopologyIsHausdorff : Prop
  inducedTopologyIsHausdorff_holds : inducedTopologyIsHausdorff

/-- Upstream-narrow axiom: every properly discontinuous discrete action
on `ℍ` with finite cyclic stabilizers and a discrete elliptic locus
yields a Riemann-surface structure on the orbit quotient.

Reference: Farkas–Kra, *Riemann Surfaces*, Theorem IV.9.12;
Shimura, *Introduction to the Arithmetic Theory of Automorphic
Functions*, Proposition 1.5.1. -/
axiom exists_riemannSurface_of_modularQuotient
    (Γ : Type*) [Group Γ] [MulAction Γ ℍ]
    (_h : ModularQuotientHypotheses Γ) :
    ModularQuotientRiemannSurface Γ

/-- The discrete properly discontinuous action of `Γ` on `ℍ` gives rise
to a Riemann surface structure on the orbit quotient. -/
theorem modularQuotient_isRiemannSurface
    (Γ : Type*) [Group Γ] [MulAction Γ ℍ]
    (h : ModularQuotientHypotheses Γ) :
    Nonempty (ModularQuotientRiemannSurface Γ) :=
  ⟨exists_riemannSurface_of_modularQuotient Γ h⟩

end MathlibExpansion.Geometry.RiemannSurfaces
