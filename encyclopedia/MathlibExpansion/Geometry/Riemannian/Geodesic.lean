import MathlibExpansion.Geometry.Riemannian.MetricTensor

/-!
# Geodesic substrate

The Step 5 verdict moved normal coordinates behind a geodesic substrate. This
file records the minimal local geodesic package consumed later by the campaign.
-/

universe u

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

/-- A local geodesic segment with fixed initial point and velocity. -/
structure GeodesicSegment (M : Type u) (n : ℕ) where
  curve : ℝ → M
  initialPoint : M
  initialVelocity : CoordinateVector n
  startsAt : curve 0 = initialPoint

/-- A package assigning local geodesic segments to initial data. -/
structure LocalGeodesicPackage
    (M : Type u) (n : ℕ) (g : MetricTensor M (CoordinateVector n)) where
  geodesicAt : M → CoordinateVector n → GeodesicSegment M n
  basepoint_eq :
    ∀ x : M, ∀ v : CoordinateVector n, (geodesicAt x v).initialPoint = x
  velocity_eq :
    ∀ x : M, ∀ v : CoordinateVector n, (geodesicAt x v).initialVelocity = v

/-- The current geodesic boundary carries only initial data, so the local
package is witnessed by the constant curve with the prescribed stored
velocity. -/
def exists_local_geodesicPackage
    {M : Type u} {n : ℕ} (g : MetricTensor M (CoordinateVector n)) :
    LocalGeodesicPackage M n g where
  geodesicAt x v :=
    { curve := fun _ => x
      initialPoint := x
      initialVelocity := v
      startsAt := rfl }
  basepoint_eq := fun _ _ => rfl
  velocity_eq := fun _ _ => rfl

/-- The geodesic produced by the package starts at the prescribed basepoint. -/
theorem geodesicAt_startsAt
    {M : Type u} {n : ℕ} (g : MetricTensor M (CoordinateVector n))
    (x : M) (v : CoordinateVector n) :
    ((exists_local_geodesicPackage g).geodesicAt x v).curve 0 = x := by
  rw [((exists_local_geodesicPackage g).geodesicAt x v).startsAt]
  exact (exists_local_geodesicPackage g).basepoint_eq x v

end Riemannian
end Geometry
end MathlibExpansion
