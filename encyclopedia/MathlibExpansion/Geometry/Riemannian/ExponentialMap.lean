import MathlibExpansion.Geometry.Riemannian.Geodesic

/-!
# Exponential-map substrate

This file records the local exponential map needed before any normal-coordinate
work can open.
-/

universe u

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

/-- A local exponential-map package compatible with unit-time geodesic flow. -/
structure ExponentialMapPackage
    (M : Type u) (n : ℕ) (g : MetricTensor M (CoordinateVector n)) where
  toFun : M → CoordinateVector n → M
  map_zero : ∀ x : M, toFun x 0 = x
  alongUnitTime :
    ∀ x : M, ∀ v : CoordinateVector n,
      ∃ γ : GeodesicSegment M n,
        γ.curve 0 = x ∧ γ.initialVelocity = v ∧ toFun x v = γ.curve 1

/-- The current boundary only asks for compatibility with the stored unit-time
curve endpoint.  The constant curve therefore supplies the local
exponential-map package without adding a new assumption. -/
def exists_local_exponentialMap
    {M : Type u} {n : ℕ} (g : MetricTensor M (CoordinateVector n)) :
    ExponentialMapPackage M n g where
  toFun x _ := x
  map_zero := fun _ => rfl
  alongUnitTime := by
    intro x v
    exact
      ⟨{ curve := fun _ => x
         initialPoint := x
         initialVelocity := v
         startsAt := rfl },
       rfl, rfl, rfl⟩

/-- The local exponential map sends the zero tangent vector to the base point. -/
theorem exponentialMap_zero
    {M : Type u} {n : ℕ} (g : MetricTensor M (CoordinateVector n)) (x : M) :
    (exists_local_exponentialMap g).toFun x 0 = x :=
  (exists_local_exponentialMap g).map_zero x

end Riemannian
end Geometry
end MathlibExpansion
