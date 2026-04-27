import Mathlib.Data.ZMod.QuotientGroup
import Mathlib.GroupTheory.GroupAction.Quotient
import Mathlib.GroupTheory.SpecificGroups.Alternating
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Tactic

/-!
# Icosahedral rotation-group package

This file isolates the smallest honest boundary needed for Klein's icosahedral
group in the current Mathlib snapshot.

What is missing upstream is not the abstract finite-group theory around `A₅`,
but the concrete regular-icosahedron object together with its rotation action.
We therefore package exactly that local boundary:

- an abstract finite type of icosahedron vertices;
- a finite rotation group acting faithfully on those vertices;
- the classical cardinalities `12` for vertices and `60` for rotations.

The bridge to `alternatingGroup (Fin 5)` lives in
`MathlibExpansion/GroupTheory/Icosahedral/A5Bridge.lean`.
-/

noncomputable section

namespace MathlibExpansion.Geometry.Polyhedron

/-- The concrete order-`60` group used for the rotation package: `A₅`. -/
abbrev IcosahedralA5 : Type := alternatingGroup (Fin 5)

/-- A five-cycle in `A₅`.  Its generated subgroup has index `12`. -/
def icosahedralFiveCycle : IcosahedralA5 :=
  ⟨finRotate 5, by
    simpa using Equiv.Perm.finRotate_bit1_mem_alternatingGroup (n := 2)⟩

/-- The order-`5` subgroup whose left cosets model the twelve vertices. -/
def icosahedralVertexStabilizer : Subgroup IcosahedralA5 :=
  Subgroup.zpowers icosahedralFiveCycle

noncomputable instance instFintypeIcosahedralVertexStabilizer :
    Fintype icosahedralVertexStabilizer :=
  Fintype.ofFinite _

/-- The twelve cosets of a five-cycle subgroup in `A₅`. -/
abbrev IcosahedralCosetVertex : Type :=
  IcosahedralA5 ⧸ icosahedralVertexStabilizer

noncomputable instance instFintypeIcosahedralCosetVertex :
    Fintype IcosahedralCosetVertex :=
  Fintype.ofFinite _

theorem fintype_card_icosahedralA5 : Fintype.card IcosahedralA5 = 60 := by
  have h := two_mul_card_alternatingGroup (α := Fin 5)
  rw [Fintype.card_perm, Fintype.card_fin] at h
  change 2 * Fintype.card (alternatingGroup (Fin 5)) = 120 at h
  change Fintype.card (alternatingGroup (Fin 5)) = 60
  omega

theorem nat_card_icosahedralA5 : Nat.card IcosahedralA5 = 60 := by
  rw [Nat.card_eq_fintype_card]
  exact fintype_card_icosahedralA5

theorem nat_card_icosahedralVertexStabilizer :
    Nat.card icosahedralVertexStabilizer = 5 := by
  change Nat.card (Subgroup.zpowers icosahedralFiveCycle) = 5
  rw [Nat.card_zpowers]
  rw [← Subgroup.orderOf_coe icosahedralFiveCycle]
  change orderOf (finRotate 5 : Equiv.Perm (Fin 5)) = 5
  have hcycle : Equiv.Perm.IsCycle (finRotate 5 : Equiv.Perm (Fin 5)) :=
    isCycle_finRotate_of_le (by norm_num)
  rw [hcycle.orderOf, support_finRotate_of_le (by norm_num)]
  simp

theorem fintype_card_icosahedralVertexStabilizer :
    Fintype.card icosahedralVertexStabilizer = 5 := by
  rw [← Nat.card_eq_fintype_card]
  exact nat_card_icosahedralVertexStabilizer

theorem normalCore_icosahedralVertexStabilizer :
    icosahedralVertexStabilizer.normalCore = ⊥ := by
  rcases (Subgroup.normalCore_normal icosahedralVertexStabilizer).eq_bot_or_eq_top with hbot | htop
  · exact hbot
  · exfalso
    have hStabilizerTop : icosahedralVertexStabilizer = ⊤ := by
      refine le_antisymm le_top ?_
      simpa [htop] using Subgroup.normalCore_le icosahedralVertexStabilizer
    have hcard : Nat.card icosahedralVertexStabilizer = Nat.card IcosahedralA5 := by
      rw [hStabilizerTop, Subgroup.card_top]
    rw [nat_card_icosahedralVertexStabilizer, nat_card_icosahedralA5] at hcard
    norm_num at hcard

theorem fintype_card_icosahedralCosetVertex :
    Fintype.card IcosahedralCosetVertex = 12 := by
  have hprod := Subgroup.card_eq_card_quotient_mul_card_subgroup icosahedralVertexStabilizer
  rw [nat_card_icosahedralA5, nat_card_icosahedralVertexStabilizer] at hprod
  have hnat : Nat.card IcosahedralCosetVertex = 12 := by
    apply Nat.mul_right_cancel (by norm_num : 0 < 5)
    calc
      Nat.card IcosahedralCosetVertex * 5 = 60 := hprod.symm
      _ = 12 * 5 := by norm_num
  rw [← Nat.card_eq_fintype_card]
  exact hnat

instance instFaithfulSMulIcosahedralA5CosetVertex :
    FaithfulSMul IcosahedralA5 IcosahedralCosetVertex where
  eq_of_smul_eq_smul := by
    intro g1 g2 h
    have hker :
        g2⁻¹ * g1 ∈ (MulAction.toPermHom IcosahedralA5 IcosahedralCosetVertex).ker := by
      rw [MonoidHom.mem_ker]
      ext q
      calc
        ((MulAction.toPermHom IcosahedralA5 IcosahedralCosetVertex) (g2⁻¹ * g1)) q
            = (g2⁻¹ * g1) • q := rfl
        _ = g2⁻¹ • (g1 • q) := by rw [mul_smul]
        _ = g2⁻¹ • (g2 • q) := by rw [h q]
        _ = q := inv_smul_smul g2 q
    have hcore : g2⁻¹ * g1 ∈ icosahedralVertexStabilizer.normalCore := by
      simpa [Subgroup.normalCore_eq_ker] using hker
    have hone : g2⁻¹ * g1 = 1 := by
      have : g2⁻¹ * g1 ∈ (⊥ : Subgroup IcosahedralA5) := by
        simpa [normalCore_icosahedralVertexStabilizer] using hcore
      simpa using this
    exact (inv_mul_eq_one.mp hone).symm

/-- Upstream-narrow boundary package for the regular icosahedron and its
rotation group. -/
class IcosahedronRotationPackage where
  Vertex : Type
  instFintypeVertex : Fintype Vertex
  instDecidableEqVertex : DecidableEq Vertex
  rotation : Type
  instGroupRotation : Group rotation
  instFintypeRotation : Fintype rotation
  instMulAction : MulAction rotation Vertex
  instFaithfulSMul : FaithfulSMul rotation Vertex
  card_vertex : Fintype.card Vertex = 12
  card_rotation : Fintype.card rotation = 60

attribute [instance] IcosahedronRotationPackage.instFintypeVertex
attribute [instance] IcosahedronRotationPackage.instDecidableEqVertex
attribute [instance] IcosahedronRotationPackage.instGroupRotation
attribute [instance] IcosahedronRotationPackage.instFintypeRotation
attribute [instance] IcosahedronRotationPackage.instMulAction
attribute [instance] IcosahedronRotationPackage.instFaithfulSMul

/-- Concrete coset model for the classical icosahedron rotation package.

Klein's icosahedral model identifies the rotation group with `A₅`; the twelve
vertices are represented here by the left cosets of a five-cycle subgroup. -/
def icosahedronRotationPackage : IcosahedronRotationPackage where
  Vertex := IcosahedralCosetVertex
  instFintypeVertex := instFintypeIcosahedralCosetVertex
  instDecidableEqVertex := Classical.decEq _
  rotation := IcosahedralA5
  instGroupRotation := inferInstance
  instFintypeRotation := inferInstance
  instMulAction := inferInstance
  instFaithfulSMul := instFaithfulSMulIcosahedralA5CosetVertex
  card_vertex := fintype_card_icosahedralCosetVertex
  card_rotation := fintype_card_icosahedralA5

/-- The abstract finite vertex set of the regular icosahedron. -/
abbrev IcosahedronVertex : Type := icosahedronRotationPackage.Vertex

/-- The abstract rotation group of the regular icosahedron. -/
abbrev IcosahedralRotationGroup : Type := icosahedronRotationPackage.rotation

instance : Fintype IcosahedronVertex := icosahedronRotationPackage.instFintypeVertex

instance : DecidableEq IcosahedronVertex := icosahedronRotationPackage.instDecidableEqVertex

instance : Group IcosahedralRotationGroup := icosahedronRotationPackage.instGroupRotation

instance : Fintype IcosahedralRotationGroup := icosahedronRotationPackage.instFintypeRotation

instance : MulAction IcosahedralRotationGroup IcosahedronVertex :=
  icosahedronRotationPackage.instMulAction

instance : FaithfulSMul IcosahedralRotationGroup IcosahedronVertex :=
  icosahedronRotationPackage.instFaithfulSMul

/-- The regular icosahedron has `12` vertices. -/
theorem card_icosahedronVertex : Fintype.card IcosahedronVertex = 12 :=
  icosahedronRotationPackage.card_vertex

/-- The rotation group of the regular icosahedron has `60` elements. -/
theorem fintype_card_icosahedralRotationGroup :
    Fintype.card IcosahedralRotationGroup = 60 :=
  icosahedronRotationPackage.card_rotation

/-- The rotation group of the regular icosahedron has cardinality `60`. -/
theorem card_icosahedralRotationGroup : Nat.card IcosahedralRotationGroup = 60 := by
  rw [Nat.card_eq_fintype_card]
  exact fintype_card_icosahedralRotationGroup

end MathlibExpansion.Geometry.Polyhedron
