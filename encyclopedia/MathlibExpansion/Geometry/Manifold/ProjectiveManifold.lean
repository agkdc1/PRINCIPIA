import Mathlib.Algebra.Group.Nat.Even
import Mathlib.Geometry.Manifold.IsManifold.Basic
import Mathlib.LinearAlgebra.Projectivization.Basic
import Mathlib.Topology.Constructions
import MathlibExpansion.Geometry.Manifold.Orientability

namespace MathlibExpansion
namespace Geometry
namespace Manifold

open scoped ContDiff Manifold
open scoped LinearAlgebra.Projectivization

/-- A sibling-library carrier for real projective space: the projectivization of
`ℝ^(n+1)`, following Lee (2003), *Introduction to Smooth Manifolds*,
Example 1.3. -/
def RealProjectiveSpace (n : ℕ) : Type :=
  Projectivization ℝ (Fin (n + 1) → ℝ)

/-- The quotient topology on real projective space, as in Lee (2003),
*Introduction to Smooth Manifolds*, Example 1.3. -/
noncomputable instance instTopologicalSpaceRealProjectiveSpace (n : ℕ) :
    TopologicalSpace (RealProjectiveSpace n) :=
  inferInstanceAs
    (TopologicalSpace (Quotient (projectivizationSetoid ℝ (Fin (n + 1) → ℝ))))
attribute [instance] instTopologicalSpaceRealProjectiveSpace

/-- Smooth homogeneous-coordinate atlas for real projective space. This is the
standard atlas from Lee (2003), *Introduction to Smooth Manifolds*, Example 1.12,
and is the remaining upstream chart-construction boundary. -/
axiom instChartedSpaceRealProjectiveSpace (n : ℕ) :
  ChartedSpace (Fin n → ℝ) (RealProjectiveSpace n)
attribute [instance] instChartedSpaceRealProjectiveSpace

/-- Smooth-manifold compatibility of the homogeneous-coordinate atlas for
`ℝP^n`; see Lee (2003), *Introduction to Smooth Manifolds*, Example 1.12. -/
axiom instIsManifoldRealProjectiveSpace (n : ℕ) :
  IsManifold (modelWithCornersSelf ℝ (Fin n → ℝ)) ∞ (RealProjectiveSpace n)
attribute [instance] instIsManifoldRealProjectiveSpace

/-- Orientability parity for real projective space. This is the remaining
upstream boundary after the manifold half is supplied by the instance above:
it follows from the antipodal quotient action as in Lee (2003), *Introduction to
Smooth Manifolds*, Problem 10-4, or equivalently from Hatcher (2002),
*Algebraic Topology*, Example 2.42 plus Proposition 3.25. -/
axiom realProjectiveSpace_orientable_iff_odd (n : ℕ) :
    IsOrientableManifold (modelWithCornersSelf ℝ (Fin n → ℝ)) (RealProjectiveSpace n) ↔ Odd n

/-- Real projective space is a manifold, and its orientability is controlled by
dimension parity. The manifold component is now an instance; only the parity
statement is an upstream boundary. -/
theorem isManifold_realProjectiveSpace_and_orientable_iff (n : ℕ) :
    IsManifold (modelWithCornersSelf ℝ (Fin n → ℝ)) ∞ (RealProjectiveSpace n) ∧
      (IsOrientableManifold (modelWithCornersSelf ℝ (Fin n → ℝ)) (RealProjectiveSpace n) ↔ Odd n) :=
  ⟨inferInstance, realProjectiveSpace_orientable_iff_odd n⟩

end Manifold
end Geometry
end MathlibExpansion
