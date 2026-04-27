import Mathlib.Algebra.Group.Subgroup.Pointwise
import Mathlib.Topology.Algebra.ClosedSubgroup
import Mathlib.Topology.Algebra.PontryaginDual

/-!
# Annihilator and restriction API for Pontryagin duals

This file adds the basic subgroup-facing API around Pontryagin duals: restriction
of characters, subgroup annihilators, closed-subgroup annihilators, and the
expected annihilator/intersection identity for directed suprema.
-/

open scoped Pointwise

universe u v

namespace PontryaginDual

variable {G : Type u} [CommGroup G] [TopologicalSpace G] [IsTopologicalGroup G]

/-- Restriction of a character to a closed subgroup. -/
noncomputable def restrict (H : ClosedSubgroup G) :
    ContinuousMonoidHom (PontryaginDual G) (PontryaginDual H) :=
  ContinuousMonoidHom.compLeft (E := Circle)
    { toMonoidHom := H.toSubgroup.subtype
      continuous_toFun := continuous_subtype_val }

@[simp]
theorem restrict_apply (H : ClosedSubgroup G) (χ : PontryaginDual G) (h : H) :
    restrict H χ h = χ h := rfl

end PontryaginDual

namespace Subgroup

variable {G : Type u} [CommGroup G] [TopologicalSpace G] [IsTopologicalGroup G]

/-- The subgroup of characters that are trivial on a fixed subgroup. -/
def annihilator (H : Subgroup G) : Subgroup (PontryaginDual G) where
  carrier := {χ | ∀ h : H, χ h = 1}
  one_mem' := by
    intro h
    exact map_one (1 : PontryaginDual G)
  mul_mem' := by
    intro χ ψ hχ hψ h
    change χ h * ψ h = 1
    simp [hχ h, hψ h]
  inv_mem' := by
    intro χ hχ h
    change (χ h)⁻¹ = 1
    rw [hχ h, inv_one]

@[simp]
theorem mem_annihilator_iff {H : Subgroup G} {χ : PontryaginDual G} :
    χ ∈ H.annihilator ↔ ∀ g ∈ H, χ g = 1 := by
  constructor
  · intro hχ g hg
    exact hχ ⟨g, hg⟩
  · intro h g
    exact h g g.2

/-- Annihilators turn subgroup suprema into subgroup infima. -/
theorem annihilator_iSup {ι : Sort v} (H : ι → Subgroup G) :
    (iSup H).annihilator = iInf fun i => (H i).annihilator := by
  ext χ
  simp only [mem_annihilator_iff, Subgroup.mem_iInf]
  constructor
  · intro hχ i g hg
    exact hχ g (show g ∈ iSup H from le_iSup H i hg)
  · intro hχ g hg
    exact Subgroup.iSup_induction (S := H) (C := fun x => χ x = 1) hg
      (fun i x hx => hχ i x hx)
      (by simpa using map_one χ)
      (fun x y hx hy => by simp [map_mul, hx, hy])

end Subgroup

namespace ClosedSubgroup

variable {G : Type u} [CommGroup G] [TopologicalSpace G] [IsTopologicalGroup G]

/-- The closed subgroup of characters that are trivial on a closed subgroup. -/
def annihilator (H : ClosedSubgroup G) : ClosedSubgroup (PontryaginDual G) where
  toSubgroup := H.toSubgroup.annihilator
  isClosed' := by
    change IsClosed {χ : ContinuousMonoidHom G Circle | ∀ h : H, χ h = 1}
    rw [show {χ : ContinuousMonoidHom G Circle | ∀ h : H, χ h = 1} =
        ⋂ h : H, {χ : ContinuousMonoidHom G Circle | χ h = 1} by
          ext χ
          simp]
    exact isClosed_iInter fun h : H =>
      isClosed_eq (continuous_eval_const (x := (h : G)))
        (continuous_const : Continuous fun _ : ContinuousMonoidHom G Circle => (1 : Circle))

@[simp]
theorem mem_annihilator_iff {H : ClosedSubgroup G} {χ : PontryaginDual G} :
    χ ∈ H.annihilator ↔ ∀ h : H, χ h = 1 :=
  Iff.rfl

@[simp]
theorem annihilator_toSubgroup (H : ClosedSubgroup G) :
    H.annihilator.toSubgroup = H.toSubgroup.annihilator :=
  rfl

end ClosedSubgroup
