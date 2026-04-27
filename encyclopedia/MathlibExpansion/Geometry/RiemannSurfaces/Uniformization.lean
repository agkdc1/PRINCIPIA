import Mathlib.Analysis.Complex.UnitDisc.Basic
import Mathlib.Topology.Separation.Hausdorff
import Mathlib.Topology.Compactification.OnePoint
import MathlibExpansion.Geometry.RiemannSurfaces.Basic

/-!
# Uniformization

This deferred file records Weyl's normalized uniformization trichotomy as a
single upstream-narrow boundary.

Primary historical queue root named by Weyl:

- Paul Koebe, *Über die Uniformisierung beliebiger analytischer Kurven I. Das
  allgemeine Uniformisierungsprinzip*, *Journal für die reine und angewandte
  Mathematik* `138` (1910), pp. `192`-`253`

Weyl also points to Koebe's Göttingen notice (`1907`, pp. `209`-`210`) for the
same admissible-class realization principle.
-/

universe u

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- Concrete sphere carrier used for the normalized uniformization trichotomy:
the one-point compactification of the complex plane.

Citation queue: Weyl, *Die Idee der Riemannschen Fläche* (1913), §19
(`Typus` classification, pp. 147-148), following Koebe, *Über die
Uniformisierung beliebiger analytischer Kurven I*, J. reine angew. Math. 138
(1910), pp. 192-253. -/
abbrev RiemannSphere : Type u := ULift.{u, 0} (OnePoint ℂ)

instance instTopologicalSpaceRiemannSphere : TopologicalSpace RiemannSphere := inferInstance
instance instT2SpaceRiemannSphere : @T2Space RiemannSphere instTopologicalSpaceRiemannSphere :=
  inferInstance

/-- Remaining model-structure boundary for the spherical branch: the concrete
carrier `ULift (OnePoint ℂ)` carries the canonical complex atlas and orientation
needed by `RiemannSurface`.

Citation queue: Weyl, *Die Idee der Riemannschen Fläche* (1913), §19,
pp. 147-148; Koebe, *Über die Uniformisierung beliebiger analytischer Kurven I*,
J. reine angew. Math. 138 (1910), pp. 192-253. -/
axiom instRiemannSurfaceRiemannSphere :
    @RiemannSurface RiemannSphere instTopologicalSpaceRiemannSphere instT2SpaceRiemannSphere

attribute [instance] instRiemannSurfaceRiemannSphere

/-- Concrete unit-disc carrier used for the normalized hyperbolic branch of
uniformization.

Citation queue: Weyl, *Die Idee der Riemannschen Fläche* (1913), §19
(`Typus` classification, pp. 147-148), following Koebe, *Über die
Uniformisierung beliebiger analytischer Kurven I*, J. reine angew. Math. 138
(1910), pp. 192-253. -/
abbrev UnitDiscModel : Type u := ULift.{u, 0} Complex.UnitDisc

instance instTopologicalSpaceUnitDiscModel : TopologicalSpace UnitDiscModel := inferInstance
instance instT2SpaceUnitDiscModel : @T2Space UnitDiscModel instTopologicalSpaceUnitDiscModel := by
  letI : T2Space Complex.UnitDisc := by
    refine T2Space.of_injective_continuous Complex.UnitDisc.coe_injective ?_
    change Continuous (Subtype.val : Metric.ball (0 : ℂ) 1 → ℂ)
    exact continuous_subtype_val
  infer_instance

/-- Remaining model-structure boundary for the hyperbolic branch: the concrete
carrier `ULift Complex.UnitDisc` carries the canonical complex atlas and
orientation needed by `RiemannSurface`.

Citation queue: Weyl, *Die Idee der Riemannschen Fläche* (1913), §19,
pp. 147-148; Koebe, *Über die Uniformisierung beliebiger analytischer Kurven I*,
J. reine angew. Math. 138 (1910), pp. 192-253. -/
axiom instRiemannSurfaceUnitDiscModel :
    @RiemannSurface UnitDiscModel instTopologicalSpaceUnitDiscModel instT2SpaceUnitDiscModel

attribute [instance] instRiemannSurfaceUnitDiscModel

/-- Deferred HVT `UNI`: every simply connected Riemann surface is conformally
equivalent to exactly one normalized model: sphere, plane, or disc.

Citation queue: Weyl, *Die Idee der Riemannschen Fläche* (1913), §19,
pp. 147-148; Koebe, *Über die Uniformisierung beliebiger analytischer Kurven I*,
J. reine angew. Math. 138 (1910), pp. 192-253, and Koebe's Göttingen notice
(1907), pp. 209-210. -/
axiom simplyConnected_surface_uniformization_trichotomy
    (X : Type u) [TopologicalSpace X] [T2Space X] [ConnectedSpace X]
    [SimplyConnectedSpace X] [RiemannSurface X] :
    Nonempty (ConformalEquiv X RiemannSphere) ∨
      Nonempty (ConformalEquiv X ℂ) ∨
      Nonempty (ConformalEquiv X UnitDiscModel)

end RiemannSurfaces
end Geometry
end MathlibExpansion
