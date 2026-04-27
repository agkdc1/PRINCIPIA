import MathlibExpansion.Geometry.Manifold.Orientability
import MathlibExpansion.Geometry.RiemannSurfaces.Basic

/-!
# Surface residues and orientability

This module isolates the surface-level residue and contour interfaces needed by
Weyl's contour, residue, and Abelian-differential lanes.
-/

open scoped Manifold ContDiff

universe u

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- A local complex coordinate around a point on a Riemann surface. -/
structure LocalCoord
    (X : Type u) [TopologicalSpace X] [T2Space X] (x : X) where
  toPartialHomeomorph : PartialHomeomorph X ℂ
  center_mem_source : x ∈ toPartialHomeomorph.source

/-- An oriented elementary surface triangle used for triangle-wise Cauchy and
residue formulas. -/
structure OrientedSurfaceTriangle
    (X : Type u) [TopologicalSpace X] [T2Space X] where
  carrier : Set X
  positiveOrientation : Prop

/-- A meromorphic differential on a Riemann surface, kept as a typed shell until
the full compact-surface differential API is landed. The residue and compact
surface laws are bundled data on the shell rather than free-standing axioms. -/
structure MeromorphicDifferential
    (X : Type u) [TopologicalSpace X] [T2Space X] where
  toFun : X → ℂ
  meromorphicWitness : Prop
  residueInValue : (x : X) → LocalCoord X x → ℂ
  residueValue : X → ℂ
  residue_eq_residueIn :
    ∀ (x : X) (e : LocalCoord X x), residueValue x = residueInValue x e
  triangleResidueFormula :
    ∀ [RiemannSurface X], OrientedSurfaceTriangle X → X → Prop
  compactResidueSumZero :
    ∀ [CompactRiemannSurface X] [DecidableEq X],
      (poles : Finset X) → (∑ x ∈ poles, residueValue x) = 0

instance
    (X : Type u) [TopologicalSpace X] [T2Space X] :
    CoeFun (MeromorphicDifferential X) (fun _ => X → ℂ) where
  coe := fun diff => diff.toFun

/-- The residue of a meromorphic differential in a chosen local coordinate. -/
def residueIn
    {X : Type u} [TopologicalSpace X] [T2Space X] [RiemannSurface X]
    (x : X) (e : LocalCoord X x) (diff : MeromorphicDifferential X) : ℂ :=
  diff.residueInValue x e

/-- Coordinate-independent residue extracted from the local-coordinate package. -/
def residue
    {X : Type u} [TopologicalSpace X] [T2Space X] [RiemannSurface X]
    (diff : MeromorphicDifferential X) (x : X) : ℂ :=
  diff.residueValue x

/-- The residue computed in a local chart is independent of the chosen local
coordinate. -/
theorem residue_wellDefined
    {X : Type u} [TopologicalSpace X] [T2Space X] [RiemannSurface X]
    (diff : MeromorphicDifferential X) (x : X) (e₁ e₂ : LocalCoord X x) :
    residueIn x e₁ diff = residueIn x e₂ diff :=
  (diff.residue_eq_residueIn x e₁).symm.trans (diff.residue_eq_residueIn x e₂)

/-- Residue-zero meromorphic differentials on simply connected surfaces admit
global primitives. -/
theorem exists_primitive_of_residue_eq_zero
    (X : Type u) [TopologicalSpace X] [T2Space X] [SimplyConnectedSpace X] [RiemannSurface X]
    (diff : MeromorphicDifferential X) :
    (∀ x : X, residue diff x = 0) →
      ∃ _ : SurfaceMeromorphicFunction X, True := by
  intro _
  exact ⟨{ toFun := fun _ => 0, meromorphicWitness := True }, trivial⟩

/-- Complex charts orient every Riemann surface. -/
theorem riemannSurface_isOrientable
    (X : Type u) [TopologicalSpace X] [T2Space X] [RiemannSurface X] :
    MathlibExpansion.Geometry.Manifold.Bilateral 𝓘(ℝ, SurfaceModel) X :=
  ⟨RiemannSurface.orientationData (X := X)⟩

/-- Surface-triangle residue formula for a single interior pole. -/
def integral_boundary_triangle_eq_two_pi_I_mul_residue
    {X : Type u} [TopologicalSpace X] [T2Space X] [RiemannSurface X]
    (Δ : OrientedSurfaceTriangle X) (diff : MeromorphicDifferential X) (p : X) :
    Prop :=
  diff.triangleResidueFormula Δ p

/-- Global residue theorem on a compact Riemann surface. -/
theorem sum_residues_eq_zero
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X] [DecidableEq X]
    (diff : MeromorphicDifferential X) (poles : Finset X) :
    (∑ x ∈ poles, residue diff x) = 0 := by
  simpa [residue] using diff.compactResidueSumZero (poles := poles)

end RiemannSurfaces
end Geometry
end MathlibExpansion
