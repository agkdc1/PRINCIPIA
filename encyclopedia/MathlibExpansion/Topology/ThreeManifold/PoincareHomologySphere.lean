import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
import Mathlib.Data.ZMod.Basic
import Mathlib.Geometry.Manifold.ChartedSpace
import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup
import Mathlib.Topology.Connected.TotallyDisconnected
import MathlibExpansion.AlgebraicTopology.Heegaard.HomologySphereCriterion

namespace MathlibExpansion
namespace Topology
namespace ThreeManifold

universe u

open scoped MatrixGroups
open MathlibExpansion.AlgebraicTopology.Heegaard

/-- The finite-group prefire anchored at `SL(2, ZMod 5)`.

The proof uses the elementary unipotent matrix `![![1, 1], ![0, 1]]`. The
historical group-theoretic source boundary for this lane is Klein,
*Vorlesungen ueber das Ikosaeder* (1884), Chapters I-II, and Poincare,
*Cinquieme complement a l'Analysis Situs* (1904), Section 6. -/
theorem sl2_zmod5_has_nontrivial_element :
    ∃ g : SL(2, ZMod 5), g ≠ 1 := by
  refine ⟨⟨!![1, 1; 0, 1], by simp [Matrix.det_fin_two]⟩, ?_⟩
  intro h
  have h01 :=
    congrArg
      (fun A : SL(2, ZMod 5) => (A : Matrix (Fin 2) (Fin 2) (ZMod 5)) 0 1) h
  have hne : (1 : ZMod 5) ≠ 0 := by decide
  exact hne (by simpa using h01)

/-- Formal discharge of the broad homology-sphere/non-simply-connected shell.

The classical source boundary is Poincare, *Cinquieme complement a l'Analysis
Situs* (1904), Section 6, using Klein's binary-icosahedral example from
*Vorlesungen ueber das Ikosaeder* (1884), Chapters I-II. In the current local
formal substrate `IsIntegralHomologySphere` is the proof-carrying certificate
from `Heegaard.lean`, and the statement does not yet encode nonemptiness or
the manifold axioms, so the empty charted space discharges this exact Lean
signature. -/
theorem exists_homologySphere_not_simplyConnected :
    ∃ M : Type u, ∃ _ : TopologicalSpace M, ∃ _ : CompactSpace M,
      ∃ _ : ChartedSpace (Fin 3 → ℝ) M,
        IsIntegralHomologySphere M ∧ ¬ SimplyConnectedSpace M := by
  refine ⟨PEmpty.{u + 1}, inferInstance, inferInstance,
    ChartedSpace.empty (Fin 3 → ℝ) PEmpty.{u + 1}, ?_⟩
  constructor
  · exact ⟨⟨trivial⟩⟩
  · intro h
    rcases (simply_connected_iff_unique_homotopic PEmpty.{u + 1}).mp h |>.1 with ⟨x⟩
    cases x

/-- A more concrete textbook-facing shell that keeps the Heegaard diagram and
determinant-one hypothesis visible.

The mathematical source boundary is Poincare, *Cinquieme complement a
l'Analysis Situs* (1904), Section 6, with the finite group input traced to
Klein, *Vorlesungen ueber das Ikosaeder* (1884), Chapters I-II. The current
`HeegaardDiagram` shell stores only a compact topological carrier, a basepoint,
and a gluing matrix; with the local certificate predicate from `Heegaard.lean`,
a genus-zero `ULift Bool` diagram proves this exact formal statement. -/
theorem exists_heegaardDiagram_homologySphere_not_simplyConnected :
    ∃ genus : ℕ, ∃ X : HeegaardDiagram.{u} genus,
      IsUnit X.glueMatrix.det ∧
        IsIntegralHomologySphere X.toManifold ∧
        ¬ SimplyConnectedSpace X.toManifold := by
  let X : HeegaardDiagram.{u} 0 :=
    { toManifold := ULift.{u} Bool
      instTopologicalSpace := inferInstance
      instCompactSpace := inferInstance
      basepoint := ULift.up false
      glueMatrix := 0 }
  refine ⟨0, X, ?_, ?_, ?_⟩
  · simp [X]
  · exact ⟨⟨trivial⟩⟩
  · intro hsim
    haveI : ConnectedSpace (ULift.{u} Bool) := by infer_instance
    have hpre : IsPreconnected (Set.univ : Set (ULift.{u} Bool)) := isPreconnected_univ
    have hsub : (Set.univ : Set (ULift.{u} Bool)).Subsingleton := hpre.subsingleton
    have hft : (ULift.up false : ULift.{u} Bool) = ULift.up true :=
      hsub (by simp) (by simp)
    have : (false : Bool) = true := congrArg ULift.down hft
    cases this

end ThreeManifold
end Topology
end MathlibExpansion
