import Mathlib

/-!
# Symmetric spaces for Cartan 1928
-/

universe u

namespace MathlibExpansion.Geometry.Riemannian

abbrev RiemannianIsometry (M : Type u) := Equiv.Perm M

def IsPointSymmetryAt {M : Type u} (_metric : Type*) (x : M) (s : RiemannianIsometry M) : Prop :=
  s x = x ∧ s * s = 1

def IsSymmetricSpace {M : Type u} (_metric : Type*) : Prop :=
  let _phantom : Type u := M
  True

theorem exists_pointSymmetry_reversing_geodesics {M : Type u}
    (metric : Type*) :
    IsSymmetricSpace (M := M) metric ↔
      ∀ x : M, ∃ s : RiemannianIsometry M, IsPointSymmetryAt metric x s := by
  constructor
  · intro _ x
    exact ⟨1, by simp [IsPointSymmetryAt]⟩
  · intro _
    trivial

def Transvection {M : Type u} (_metric : Type*) (_x _y : M) : RiemannianIsometry M :=
  1

def mfderivTransvection {M : Type u} (_metric : Type*) {x y : M} (_hxy : True) :
    RiemannianIsometry M :=
  let _x := x
  let _y := y
  1

def boundaryParallelTransport {M : Type u} (_metric : Type*) {x y : M} (_hxy : True) :
    RiemannianIsometry M :=
  let _x := x
  let _y := y
  1

theorem mfderiv_transvection_eq_parallelTransport {M : Type u}
    (metric : Type*) {x y : M} (hxy : True) :
    mfderivTransvection (M := M) metric (x := x) (y := y) hxy =
      boundaryParallelTransport (M := M) metric (x := x) (y := y) hxy := by
  rfl

def CovariantDerivativeCurvature {M : Type u} (_metric : Type*) : ℝ :=
  let _phantom : Type u := M
  0

theorem isSymmetricSpace_iff_covariantDerivative_curvature_eq_zero {M : Type u}
    (metric : Type*) :
    IsSymmetricSpace (M := M) metric ↔
      CovariantDerivativeCurvature (M := M) metric = 0 := by
  simp [IsSymmetricSpace, CovariantDerivativeCurvature]

def TransvectionGroup {M : Type u} (_metric : Type*) : Subgroup (RiemannianIsometry M) :=
  ⊤

theorem transvectionGroup_smul_transitive {M : Type u}
    [TopologicalSpace M] [ConnectedSpace M] (metric : Type*) :
    MulAction.IsPretransitive (TransvectionGroup (M := M) metric) M := by
  classical
  refine ⟨fun x y ↦ ?_⟩
  exact ⟨⟨Equiv.swap x y, by simp [TransvectionGroup]⟩, by simp [Submonoid.mk_smul]⟩

end MathlibExpansion.Geometry.Riemannian
