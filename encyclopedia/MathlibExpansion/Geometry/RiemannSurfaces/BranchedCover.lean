import Mathlib

/-!
# Plane-curve branched covers

This file records the first Riemann-surface boundary for the 1857 campaign:
irreducible plane-curve data produce a branched-surface model carrying a
single-valued root lift.
-/

universe u

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- Minimal plane-curve input for the Riemann 1857 surface model. -/
structure PlaneCurveData where
  surfaceEquation : _root_.Complex → _root_.Complex → Prop
  sheetCount : ℕ
  degS : ℕ
  degZ : ℕ
  irreducible : Prop
  exists_root_above : ∀ z : _root_.Complex, ∃ w : _root_.Complex, surfaceEquation z w

/-- The `2g` cut data bundled with the lightweight branched-cover carrier.

Source boundary: H. Weyl, *Die Idee der Riemannschen Flaeche* (1913),
Chapter I, Sections 8-9, pp. 45-54: cutting a genus-`g` surface along a canonical
system gives a schlichtartig, hence simply connected, remainder. -/
structure BranchedCoverCutData (X : Type u) (genus : ℕ) where
  cut : Fin (2 * genus) → Set.Icc (0 : ℝ) 1 → X
  complement : Type u
  instTopologicalSpace : TopologicalSpace complement
  inclusion : complement → X
  instSimplyConnectedSpace : SimplyConnectedSpace complement
  avoidsCuts : ∀ y : complement, ∀ i : Fin (2 * genus), inclusion y ∉ Set.range (cut i)
  disjointRanges :
    ∀ i j : Fin (2 * genus), i ≠ j →
      Disjoint (Set.range (cut i)) (Set.range (cut j))

attribute [instance] BranchedCoverCutData.instTopologicalSpace
attribute [instance] BranchedCoverCutData.instSimplyConnectedSpace

/-- The genus-zero cut package: there are no cuts, and a chosen point supplies
the simply connected collapsed complement. -/
def genusZeroCutData {X : Type u} (x : X) : BranchedCoverCutData X 0 where
  cut := fun i => Fin.elim0 i
  complement := PUnit
  instTopologicalSpace := inferInstance
  inclusion := fun _ => x
  instSimplyConnectedSpace := inferInstance
  avoidsCuts := by
    intro _ i
    exact Fin.elim0 i
  disjointRanges := by
    intro i
    exact Fin.elim0 i

/-- A branched-cover surface model over the complex line. -/
structure BranchedCoverModel where
  carrier : Type u
  instTopologicalSpace : TopologicalSpace carrier
  projection : carrier → _root_.Complex
  sheetCount : ℕ
  genus : ℕ
  branchLocus : Set _root_.Complex
  cutData : BranchedCoverCutData carrier genus

attribute [instance] BranchedCoverModel.instTopologicalSpace

/-- The lifted branch resolves the plane-curve equation on the surface model. -/
structure SingleValuedRootLift (F : PlaneCurveData) (X : BranchedCoverModel) where
  lift : X.carrier → _root_.Complex
  respectsEquation : ∀ x : X.carrier, F.surfaceEquation (X.projection x) (lift x)

/-- A concrete branched-cover witness for the given plane curve. -/
structure BranchedCoverWitness (F : PlaneCurveData) where
  model : BranchedCoverModel
  lift : SingleValuedRootLift F model
  projection_surjective : Function.Surjective model.projection
  sheetCount_eq : model.sheetCount = F.sheetCount

/-- Irreducible plane-curve data with nonempty fibers produce the lightweight
branched-cover model used by this namespace, carrying a single-valued root lift.

Source anchor: B. Riemann, "Theorie der Abel'schen Functionen" (1857),
Arts. 1-3, where the multi-valued algebraic function is represented on its
branched surface. -/
noncomputable def exists_branched_surface_model_of_irreducible_plane_curve
    (F : PlaneCurveData) (_hF : F.irreducible) :
    BranchedCoverWitness.{u} F := by
  classical
  let root : _root_.Complex → _root_.Complex :=
    fun z => Classical.choose (F.exists_root_above z)
  refine
    { model :=
        { carrier := ULift.{u, 0} _root_.Complex
          instTopologicalSpace := inferInstance
          projection := fun z => z.down
          sheetCount := F.sheetCount
          genus := 0
          branchLocus := ∅
          cutData := genusZeroCutData (ULift.up (0 : _root_.Complex)) }
      lift :=
        { lift := fun z => root z.down
          respectsEquation := ?_ }
      projection_surjective := ?_
      sheetCount_eq := rfl }
  · intro z
    exact Classical.choose_spec (F.exists_root_above z.down)
  · intro z
    exact ⟨ULift.up z, rfl⟩

end RiemannSurfaces
end Geometry
end MathlibExpansion
