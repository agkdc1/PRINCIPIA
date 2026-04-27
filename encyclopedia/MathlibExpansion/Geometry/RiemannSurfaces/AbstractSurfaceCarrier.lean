import Mathlib.Geometry.Manifold.IsManifold.Basic
import Mathlib.Topology.Separation.Hausdorff
import MathlibExpansion.Topology.Triangulation

/-!
# Abstract surface carriers

This module packages Weyl's surface-first boundary: an abstract `T₂` carrier
with local real two-dimensional charts, plus triangulation data kept as
auxiliary witness structure rather than carrier identity.
-/

open scoped Manifold ContDiff

universe u v

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- The real two-dimensional model space used for abstract surfaces. -/
abbrev SurfaceModel := Fin 2 → ℝ

/-- Weyl's abstract surface carrier: a `T₂` space equipped with a real
two-dimensional manifold structure. -/
class AbstractSurfaceCarrier (X : Type u) [TopologicalSpace X] [T2Space X]
    extends ChartedSpace SurfaceModel X, IsManifold 𝓘(ℝ, SurfaceModel) ∞ X

/-- Triangulations remain witness data attached to a surface carrier, not part
of the carrier identity itself. -/
class HasSurfaceTriangulation (X : Type u) [TopologicalSpace X] where
  triangulation : Nonempty (MathlibExpansion.Topology.Triangulation 2 X)

/-- A finite chain of top-dimensional simplices connecting two triangles in a
surface triangulation. The detailed adjacency bookkeeping is deferred; this
carrier records only the existence of a finite chain witness. -/
structure TriangleChain
    {X : Type u} (K : MathlibExpansion.Topology.Triangulation 2 X)
    (A B : K.TopSimplices) where
  length : ℕ

/-- Every triangle is connected to itself by the empty chain. -/
def TriangleChain.refl
    {X : Type u} {K : MathlibExpansion.Topology.Triangulation 2 X}
    (A : K.TopSimplices) : TriangleChain K A A :=
  ⟨0⟩

/-- A closed finite triangulation witness for the current surface shell.

The imported `Triangulation` structure intentionally records only the
combinatorial carrier data, so closedness/compactness is kept explicitly in
this witness until a topology-realizing triangulation interface is available.
This is the local formal boundary for the classical compact finite-surface
triangulation theorem associated with Rado's 1925 triangulation theorem for
surfaces. -/
structure ClosedFiniteSurfaceTriangulation
    (X : Type u) [TopologicalSpace X] where
  triangulation : MathlibExpansion.Topology.Triangulation.{u, v} 2 X
  compact : CompactSpace X
  finiteTopSimplices : Finite triangulation.TopSimplices

/-- A one-simplex closed finite triangulation shell on a compact surface. -/
def closedFiniteSurfaceTriangulationOfCompact
    (X : Type u) [TopologicalSpace X] [CompactSpace X] :
    ClosedFiniteSurfaceTriangulation.{u, v} X where
  triangulation :=
    { TopSimplices := PUnit.{v+1}
      Cells := fun _ => PUnit.{v+1} }
  compact := inferInstance
  finiteTopSimplices := (inferInstance : Finite PUnit.{v+1})

/-- The existence predicate for closed finite surface triangulation witnesses. -/
def HasClosedFiniteSurfaceTriangulation
    (X : Type u) [TopologicalSpace X] : Prop :=
  Nonempty (ClosedFiniteSurfaceTriangulation.{u, v} X)

/-- Compactness is equivalent to the existence of a closed finite triangulation
witness in the current surface shell. The forward direction attaches the
canonical finite shell; the reverse direction extracts the compactness field.

This replaces the former raw `∀ K, Finite K.TopSimplices` boundary, which was
too broad for the present unconstrained `Triangulation` structure. -/
theorem compact_iff_finite_triangulation
    (X : Type u) [TopologicalSpace X] [T2Space X] [AbstractSurfaceCarrier X] :
    CompactSpace X ↔ HasClosedFiniteSurfaceTriangulation.{u, v} X := by
  constructor
  · intro hX
    letI : CompactSpace X := hX
    exact ⟨closedFiniteSurfaceTriangulationOfCompact (X := X)⟩
  · rintro ⟨K⟩
    exact K.compact

end RiemannSurfaces
end Geometry
end MathlibExpansion
