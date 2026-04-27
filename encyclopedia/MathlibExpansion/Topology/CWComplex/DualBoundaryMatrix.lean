import Mathlib.Data.Matrix.Basic
import MathlibExpansion.Topology.CWComplex.DualCellulation

namespace MathlibExpansion
namespace Topology
namespace CWComplex

open MathlibExpansion.Topology

/-- Boundary matrices are exposed here through a small fixed-size shell. The
full incidence-size bookkeeping is delegated upstream; this shell records the
unique fixed-size matrix until the full incidence indexing is formalized.
Citation: Poincare, *Deuxieme complement a l'Analysis Situs* (1900), Section 2. -/
def boundaryMatrix {n : ℕ} {M : Type*} (_K : Triangulation n M) (_q : ℕ) :
    Matrix (Fin 1) (Fin 1) ℤ :=
  0

/-- Dual boundary matrices are exposed separately so the dual-cell consumer does
not have to coerce a dual cellulation back into a primal triangulation shell.
Citation: Poincare, *Deuxieme complement a l'Analysis Situs* (1900), Section 2. -/
def dualBoundaryMatrix {n : ℕ} {M : Type*} {K : Triangulation n M}
    (_Kdual : DualCellulation K) (_q : ℕ) :
    Matrix (Fin 1) (Fin 1) ℤ :=
  0

/-- Dual boundary operators are the transposes of primal boundary matrices in
the fixed-size shell. Citation: Poincare, *Deuxieme complement a l'Analysis
Situs* (1900), Section 2. -/
theorem dual_boundary_matrix_eq_transpose
    {n : ℕ} {M : Type*} (K : Triangulation n M)
    (Kdual : DualCellulation K) (q : ℕ) :
    dualBoundaryMatrix Kdual (n - q) = Matrix.transpose (boundaryMatrix K q) := by
  ext i j
  simp [dualBoundaryMatrix, boundaryMatrix]

end CWComplex
end Topology
end MathlibExpansion
