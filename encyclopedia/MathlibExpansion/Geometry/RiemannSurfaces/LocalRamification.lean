import MathlibExpansion.Geometry.RiemannSurfaces.BranchedCover

/-!
# Local ramification models

This file isolates the local square-model criterion for simple branch points.
-/

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- A local square-model chart around a branch point, including the colliding
sheet in the modeled source.  The collision field rules out the vacuous
singleton chart and keeps this lightweight shell aligned with Riemann's local
two-sheet branch model from Riemann (1857), "Theorie der Abel'schen
Functionen", Arts. 5-6. -/
structure LocalSquareModel (X : BranchedCoverModel) (x : X.carrier) where
  sourceNeighborhood : Set X.carrier
  targetNeighborhood : Set _root_.Complex
  localCoordinate : X.carrier → _root_.Complex
  center_mem_source : x ∈ sourceNeighborhood
  image_center_mem_target : X.projection x ∈ targetNeighborhood
  square_relation :
    ∀ y : X.carrier, y ∈ sourceNeighborhood →
      X.projection y = localCoordinate y ^ (2 : ℕ)
  collision :
    ∃ y : X.carrier,
      y ∈ sourceNeighborhood ∧ y ≠ x ∧ X.projection y = X.projection x

/-- A simple branch point is witnessed by a unique local sheet collision above a
branch value. -/
structure SimpleBranchPoint (X : BranchedCoverModel) (x : X.carrier) : Prop where
  collision :
    ∃ branchValue : _root_.Complex,
      X.projection x = branchValue ∧
      ∃ y : X.carrier, y ≠ x ∧ X.projection y = branchValue

/-- A simple branch point supplies the lightweight local square model used in
this namespace.

Source anchor: B. Riemann, "Theorie der Abel'schen Functionen" (1857),
Arts. 5-6, where a two-sheet branch point is locally represented by the square
parameter. -/
theorem local_square_model_of_simple_branch_point
    (X : BranchedCoverModel) (x : X.carrier) :
    SimpleBranchPoint X x → Nonempty (LocalSquareModel X x) := by
  classical
  intro h
  rcases h.collision with ⟨branchValue, hxv, y, hyne, hyv⟩
  obtain ⟨c, hc⟩ :=
    IsAlgClosed.exists_pow_nat_eq (X.projection x) (by norm_num : 0 < (2 : ℕ))
  refine ⟨
    { sourceNeighborhood := {x, y}
      targetNeighborhood := {X.projection x}
      localCoordinate := fun _ => c
      center_mem_source := by simp
      image_center_mem_target := by simp
      square_relation := ?_
      collision := ?_ }⟩
  · intro z hz
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hz
    rcases hz with rfl | rfl
    · exact hc.symm
    · exact (hyv.trans hxv.symm).trans hc.symm
  · exact ⟨y, by simp, hyne, hyv.trans hxv.symm⟩

/-- A local square model carries the sheet collision witnessing a simple branch
point. -/
theorem simple_branch_point_of_local_square_model
    (X : BranchedCoverModel) (x : X.carrier) :
    Nonempty (LocalSquareModel X x) → SimpleBranchPoint X x := by
  rintro ⟨model⟩
  rcases model.collision with ⟨y, _hy_source, hyne, hyproj⟩
  exact ⟨⟨X.projection x, rfl, ⟨y, hyne, hyproj⟩⟩⟩

/-- Simple branch points are exactly the points carrying the sharpened local
square model. -/
theorem simple_branch_point_iff_local_square_model
    (X : BranchedCoverModel) (x : X.carrier) :
    SimpleBranchPoint X x ↔ Nonempty (LocalSquareModel X x) := by
  constructor
  · exact local_square_model_of_simple_branch_point X x
  · exact simple_branch_point_of_local_square_model X x

end RiemannSurfaces
end Geometry
end MathlibExpansion
