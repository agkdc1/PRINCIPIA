import Mathlib.Geometry.Manifold.PoincareConjecture

namespace MathlibExpansion
namespace Topology
namespace ThreeManifold

open scoped Manifold ContDiff
open Metric (sphere)

/-- Wrapper theorem in the sibling library namespace for the topological
Poincare conjecture in dimension three.

Citation boundary: John W. Morgan and Gang Tian, *Ricci Flow and the
Poincare Conjecture* (2007), Introduction Theorem 0.1 and Corollary 0.2;
Grisha Perelman, *Finite extinction time for the solutions to the Ricci flow
on certain three-manifolds* (2003), Theorem 1.1 and Remark 1.4. Mathlib
currently records the parallel statement as a `proof_wanted` marker in
`Mathlib.Geometry.Manifold.PoincareConjecture`, but no exported theorem
constant discharges this Lean statement. -/
axiom simplyConnected_closed_three_manifold_homeomorphic_sphere
    (M : Type*) [TopologicalSpace M] [T2Space M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M] [SimplyConnectedSpace M] [CompactSpace M] :
    Nonempty (M ≃ₜ sphere (0 : EuclideanSpace ℝ (Fin (3 + 1))) 1)

end ThreeManifold
end Topology
end MathlibExpansion
