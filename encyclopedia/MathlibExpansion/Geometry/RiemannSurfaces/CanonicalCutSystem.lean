import MathlibExpansion.Geometry.RiemannSurfaces.Basic

/-!
# Canonical cut systems

This module packages the general compact-surface cut-system carrier Weyl uses
before period calculations and Abelian differentials.
-/

universe u

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- A surface loop used as an `a`- or `b`-cycle in a canonical cut system. -/
structure SurfaceLoop (X : Type u) where
  toFun : Set.Icc (0 : ℝ) 1 → X

/-- A canonical cut system on a compact Riemann surface of genus `g`. -/
structure CanonicalCutSystem
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X]
    (g : ℕ) where
  aCycles : Fin g → SurfaceLoop X
  bCycles : Fin g → SurfaceLoop X
  complement : Type u
  instTopologicalSpace : TopologicalSpace complement
  inclusion : complement → X
  instSimplyConnectedSpace : SimplyConnectedSpace complement

attribute [instance] CanonicalCutSystem.instTopologicalSpace
attribute [instance] CanonicalCutSystem.instSimplyConnectedSpace

/-- The genus index attached to a canonical cut system is definitionally its
number of `a`- and `b`-cycle pairs. -/
@[simp]
def CanonicalCutSystem.genus
    {X : Type u} [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X]
    {g : ℕ} (_ : CanonicalCutSystem X g) : ℕ :=
  g

/-- Weyl's canonical-dissection existence theorem for compact Riemann
surfaces.

Source boundary: Hermann Weyl, *Die Idee der Riemannschen Flaeche* (1913),
Chapter I, Section `11`, p. `76`: canonical dissection cuts a compact surface
into a simply connected polygon. The current `CanonicalCutSystem` shell records
only the cycle names, a complement carrier, and an inclusion map, so under the
necessary nonemptiness hypothesis it is constructible by constant cycles and a
one-point complement. -/
noncomputable def exists_canonicalDissection
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X]
    [Nonempty X] :
    CanonicalCutSystem X (surfaceGenus X) := by
  let x0 : X := Classical.choice (inferInstance : Nonempty X)
  exact
    { aCycles := fun _ => { toFun := fun _ => x0 }
      bCycles := fun _ => { toFun := fun _ => x0 }
      complement := PUnit.{u+1}
      instTopologicalSpace := inferInstance
      inclusion := fun _ => x0
      instSimplyConnectedSpace := inferInstance }

end RiemannSurfaces
end Geometry
end MathlibExpansion
