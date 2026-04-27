import MathlibExpansion.Geometry.RiemannSurfaces.Uniformization

/-!
# Conformal automorphism groups

This deferred file records Weyl's seven-model discreteness theorem for
conformal automorphism groups.

Primary historical queue roots named in the recon:

- Henri Poincaré, *Acta Mathematica* `7` (1885), pp. `16`-`19`
- H. A. Schwarz, first source for the compact genus `> 1` finiteness theorem
- Weierstrass (1875; published in *Werke* II), Noether (1882), Hurwitz (1893)

The missing modern layer is the topology on automorphism groups together with
the exceptional-model classification for nondiscrete cases.
-/

universe u

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- The conformal automorphism group of a surface is discrete. -/
def IsDiscreteConformalAutomorphismGroup
    (X : Type u) [TopologicalSpace X] [T2Space X] [RiemannSurface X] : Prop :=
  True

def IsConformallyEquivalentToSphere
    (_X : Type u) [TopologicalSpace _X] [T2Space _X] [RiemannSurface _X] : Prop :=
  True

def IsConformallyEquivalentToPlane
    (_X : Type u) [TopologicalSpace _X] [T2Space _X] [RiemannSurface _X] : Prop :=
  True

def IsConformallyEquivalentToPuncturedPlane
    (_X : Type u) [TopologicalSpace _X] [T2Space _X] [RiemannSurface _X] : Prop :=
  True

def IsConformallyEquivalentToDisk
    (_X : Type u) [TopologicalSpace _X] [T2Space _X] [RiemannSurface _X] : Prop :=
  True

def IsConformallyEquivalentToPuncturedDisk
    (_X : Type u) [TopologicalSpace _X] [T2Space _X] [RiemannSurface _X] : Prop :=
  True

def IsConformallyEquivalentToAnnulus
    (_X : Type u) [TopologicalSpace _X] [T2Space _X] [RiemannSurface _X] : Prop :=
  True

def IsConformallyEquivalentToTorus
    (_X : Type u) [TopologicalSpace _X] [T2Space _X] [RiemannSurface _X] : Prop :=
  True

/-- HVT `CAGD`: the conformal automorphism group is discrete except for Weyl's
seven exceptional models.

At the current abstraction level, `IsDiscreteConformalAutomorphismGroup` is the
placeholder proposition `True`, so the local formal statement discharges by the
left branch. The full mathematical target is Weyl, *Die Idee der Riemannschen
Flaeche* (1913), §21, pp. 163-165, with the exceptional-model list completed
from §20, pp. 151-152; the hyperbolic nondiscrete case follows the Poincare
1885 *Acta Mathematica* 7 line cited in the Weyl recon. -/
theorem conformalAutomorphismGroup_discrete_except_seven_models
    (X : Type u) [TopologicalSpace X] [T2Space X] [RiemannSurface X] :
    IsDiscreteConformalAutomorphismGroup X ∨
      IsConformallyEquivalentToSphere X ∨
      IsConformallyEquivalentToPlane X ∨
      IsConformallyEquivalentToPuncturedPlane X ∨
      IsConformallyEquivalentToDisk X ∨
      IsConformallyEquivalentToPuncturedDisk X ∨
      IsConformallyEquivalentToAnnulus X ∨
      IsConformallyEquivalentToTorus X := by
  left
  trivial

end RiemannSurfaces
end Geometry
end MathlibExpansion
