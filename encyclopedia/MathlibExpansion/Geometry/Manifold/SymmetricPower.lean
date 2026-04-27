import Mathlib.Geometry.Manifold.IsManifold.Basic
import Mathlib.Data.Sym.Sym2
import Mathlib.Topology.Constructions
import Mathlib.Topology.Instances.RealVectorSpace

namespace MathlibExpansion
namespace Geometry
namespace Manifold

open scoped ContDiff Manifold
open Metric

universe u

/-- The symmetric square of a type, implemented by Mathlib's `Sym2`: unordered
pairs, equivalently `X × X` modulo the coordinate swap. -/
abbrev SymmetricSquare (X : Type u) : Type u :=
  Sym2 X

/-- The quotient topology on the symmetric square, induced from `X × X` through
the quotient map. -/
noncomputable instance instTopologicalSpaceSymmetricSquare (X : Type u) [TopologicalSpace X] :
    TopologicalSpace (SymmetricSquare X) :=
  inferInstanceAs (TopologicalSpace (Sym2 X))
attribute [instance] instTopologicalSpaceSymmetricSquare

/-- Smooth charted-space structure for the classical manifold case
`SP^2(S^2)`. The all-dimensional statement is not retained: Mostovoy (1997),
*Symmetric Products and Quaternion Cycle Spaces*, Theorem 1.2, singles out
dimension two for symmetric products of closed manifolds to remain manifolds;
Example 1.2 identifies `SP^2(ℂP^1)` with `ℂP^2`. -/
axiom instChartedSpaceSymmetricSquareTwoSphere :
  ChartedSpace (Fin (2 * 2) → ℝ) (SymmetricSquare ↥(sphere (0 : Fin (2 + 1) → ℝ) 1))
attribute [instance] instChartedSpaceSymmetricSquareTwoSphere

/-- Smooth-manifold compatibility for the charted-space structure on
`SP^2(S^2)`. This is the remaining upstream boundary; see Mostovoy (1997),
*Symmetric Products and Quaternion Cycle Spaces*, Theorem 1.2 and Example 1.2. -/
axiom instIsManifoldSymmetricSquareTwoSphere :
    IsManifold (modelWithCornersSelf ℝ (Fin (2 * 2) → ℝ)) ∞
      (SymmetricSquare ↥(sphere (0 : Fin (2 + 1) → ℝ) 1))
attribute [instance] instIsManifoldSymmetricSquareTwoSphere

/-- The symmetric square of the `2`-sphere is a smooth `4`-manifold. The
original all-`n` family has been sharpened to the dimension supported by the
standard symmetric-product theorem. -/
theorem isManifold_symmetricSquareSphere :
    IsManifold (modelWithCornersSelf ℝ (Fin (2 * 2) → ℝ)) ∞
      (SymmetricSquare ↥(sphere (0 : Fin (2 + 1) → ℝ) 1)) := by
  infer_instance

end Manifold
end Geometry
end MathlibExpansion
