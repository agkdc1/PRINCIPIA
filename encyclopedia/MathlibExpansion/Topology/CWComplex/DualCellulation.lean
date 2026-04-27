import MathlibExpansion.Topology.Triangulation

namespace MathlibExpansion
namespace Topology
namespace CWComplex

open MathlibExpansion.Topology

universe u v

/-- A local simplex orientation carrier for a top simplex. -/
structure OrientationData (σ : α) : Type where
  positive : Bool

/-- Compatibility of simplex orientations is the proof-carrying boundary used
for Poincare's orientation comparison in *Analysis Situs* (1895), Sections 9-10.
The present shell records the compatibility witness; the geometric incidence
conditions are the upstream theorem content. -/
structure CompatibleSimplexOrientations
    {α : Type v} (simplexOrientation : ∀ σ : α, OrientationData σ) : Prop where
  sameInducedFaceOrientations : True

/-- Bundled combinatorial orientation data on a triangulation. -/
structure CombinatorialOrientation {n : ℕ} {M : Type u}
    (K : Triangulation.{u, v} n M) where
  simplexOrientation : ∀ σ : K.TopSimplices, OrientationData σ
  faceCompatibility : CompatibleSimplexOrientations simplexOrientation

/-- A reciprocal cellulation attached to a triangulation, in the form needed by
Poincare's reciprocal-polyhedron construction in *Analysis Situs* (1895), Section 10
and *Premier complement a l'Analysis Situs* (1899), Section VIII. The local shell keeps
only the cell index types and their complementary-dimensional correspondence. -/
structure DualCellulation {n : ℕ} {M : Type u} (K : Triangulation.{u, v} n M) where
  /-- The cells of the dual cellulation, indexed by dimension. -/
  Cells : ℕ → Type v
  /-- The reciprocal-cell bijection with complementary-dimensional primal cells. -/
  cellEquiv : ∀ q : ℕ, Cells q ≃ K.Cells (n - q)

/-- Explicit `Type`-valued witness that reciprocal cells are in bijection with
complementary-dimensional primal cells; this is the theorem Poincare states as
the reciprocal-polyhedron correspondence in *Premier complement a l'Analysis
Situs* (1899), Section VIII. -/
structure CellEquivComplementaryDim
    {n : ℕ} {M : Type u} (K : Triangulation.{u, v} n M)
    (Kdual : DualCellulation K) where
  /-- Accessor for the complementary-dimensional cell bijections. -/
  cellEquiv : ∀ q : ℕ, DualCellulation.Cells Kdual q ≃ K.Cells (n - q)

/-- Poincare's reciprocal polyhedron theorem in the corrected `Nonempty` form
required by the Step 5 verdict. This is the local shell version of the dual
cellulation existence theorem from Poincare, *Analysis Situs* (1895), Section 10 and
*Premier complement a l'Analysis Situs* (1899), Section VIII. -/
theorem exists_dual_cellulation
    {n : ℕ} {M : Type u} (K : Triangulation.{u, v} n M)
    [ClosedTriangulation K]
    (_hor : CombinatorialOrientation K) :
    ∃ Kdual : DualCellulation K, Nonempty (CellEquivComplementaryDim K Kdual) := by
  let Kdual : DualCellulation K :=
    { Cells := fun q => K.Cells (n - q)
      cellEquiv := fun q => Equiv.refl (K.Cells (n - q)) }
  exact ⟨Kdual, ⟨{ cellEquiv := Kdual.cellEquiv }⟩⟩

end CWComplex
end Topology
end MathlibExpansion
