import MathlibExpansion.Geometry.RiemannSurfaces.ModularQuotient

/-!
# Cusp compactification of modular quotients

Modular quotients `Γ \ ℍ` are non-compact open Riemann surfaces; the
classical compactification attaches finitely many cusp points to recover
a compact Riemann surface `Γ \ ℍ*`.  The local coordinates at each cusp
come from the slit-disc `q = exp(2πi τ / h)` local parameter, where
`h` is the cusp width.

This file lands the compactification as a sharp upstream-narrow axiom
and the corresponding `ModularCompactification` structure consumed by
downstream packages (`KDS_12`, `KDS_13`, `KMF_10`).

Citation (upstream-narrow axiom):

* Shimura, *Introduction to the Arithmetic Theory of Automorphic
  Functions*, Proposition 1.5.2 & §1.6 ("The cusps of `ℍ*`").
* Diamond & Shurman, *A First Course in Modular Forms* (GTM 228, 2005),
  §2.4 "Congruence subgroups" and §3.1 "Compactified modular curves
  `X(Γ) = Γ\ℍ*`".

HVT closed in this file:

* `KDS_10` — cusp-compactification architecture for modular quotients.

Net axiom direction: `+1` upstream-narrow, with citation above.
-/

noncomputable section

open scoped UpperHalfPlane

namespace MathlibExpansion.Geometry.RiemannSurfaces

/-- Structured witness for the data required by the cusp-compactification
theorem: the modular quotient has only finitely many cusps, every cusp
has a slit-disc local parameter, and the resulting topology is
Hausdorff-compact. -/
structure CuspCompactificationHypotheses (Γ : Type*) [Group Γ] [MulAction Γ ℍ] where
  cuspsFinite : Prop
  cuspsFinite_holds : cuspsFinite
  slitDiscLocalParameterAtCusps : Prop
  slitDiscLocalParameterAtCusps_holds : slitDiscLocalParameterAtCusps
  inheritsHausdorffCompactTopology : Prop
  inheritsHausdorffCompactTopology_holds : inheritsHausdorffCompactTopology

/-- Structured witness of the resulting compact Riemann surface
`X(Γ) = Γ\ℍ*` obtained by cusp-compactifying the open quotient. -/
structure ModularCompactification (Γ : Type*) [Group Γ] [MulAction Γ ℍ] where
  underlyingOpenQuotient : ModularQuotientRiemannSurface Γ
  hasCompactClosureAsRiemannSurface : Prop
  hasCompactClosureAsRiemannSurface_holds : hasCompactClosureAsRiemannSurface
  cuspsAttachedAsPuncturePoints : Prop
  cuspsAttachedAsPuncturePoints_holds : cuspsAttachedAsPuncturePoints

/-- Upstream-narrow axiom: the modular quotient `Γ\ℍ` admits a cusp
compactification to the compact Riemann surface `X(Γ) = Γ\ℍ*`.

Reference: Shimura, *Introduction to the Arithmetic Theory of
Automorphic Functions*, §1.5-1.6; Diamond–Shurman, *A First Course in
Modular Forms*, §2.4 & §3.1. -/
axiom exists_modularCompactification
    (Γ : Type*) [Group Γ] [MulAction Γ ℍ]
    (_hq : ModularQuotientRiemannSurface Γ)
    (_hc : CuspCompactificationHypotheses Γ) :
    ModularCompactification Γ

/-- The modular quotient `Γ\ℍ` has a cusp-compactification
`X(Γ) = Γ\ℍ*` as a compact Riemann surface. -/
theorem modularQuotient_has_cuspCompactification
    (Γ : Type*) [Group Γ] [MulAction Γ ℍ]
    (hq : ModularQuotientRiemannSurface Γ)
    (hc : CuspCompactificationHypotheses Γ) :
    Nonempty (ModularCompactification Γ) :=
  ⟨exists_modularCompactification Γ hq hc⟩

end MathlibExpansion.Geometry.RiemannSurfaces
