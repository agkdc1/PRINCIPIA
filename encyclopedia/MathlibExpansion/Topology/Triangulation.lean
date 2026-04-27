import Mathlib.Topology.Homeomorph

namespace MathlibExpansion
namespace Topology

universe u v

/-- A textbook-facing triangulation shell for an `n`-dimensional space. -/
structure Triangulation (n : ℕ) (M : Type u) where
  TopSimplices : Type v
  Cells : ℕ → Type v

/-- Closed triangulations are the finite combinatorial objects used in the
Poincare-duality and Heegaard lanes. -/
class ClosedTriangulation {n : ℕ} {M : Type u} (K : Triangulation n M) : Prop where
  finiteTopSimplices : Finite K.TopSimplices

/-- A closed orientable triangulated manifold carries the three pieces of
textbook-facing structure used by the Poincare campaign. -/
class ClosedOrientableTriangulatedManifold (n : ℕ) (M : Type u) where
  closed_compact : Prop
  orientable : Prop
  triangulation : Nonempty (Triangulation n M)

/-- Shorthand matching the historical prose used in several recon reports. -/
class OrientableClosedManifold (M : Type u) (n : ℕ)
    extends ClosedOrientableTriangulatedManifold n M

/-- An oriented manifold is an orientable manifold equipped with a chosen
orientation datum. -/
class ClosedOrientedTriangulatedManifold (n : ℕ) (M : Type u)
    extends ClosedOrientableTriangulatedManifold n M where
  chosenOrientation : Prop

end Topology
end MathlibExpansion
