import Mathlib

/-!
# Lie-algebra structure constants

This file provides the basis-level structure-constant shell used by the
infinitesimal-generator recon.
-/

namespace MathlibExpansion.Lie

section

variable {R : Type*} [CommRing R]
variable {ι : Type*} [Fintype ι]
variable {L : Type*} [LieRing L] [LieAlgebra R L]

/-- Lie's structure constants attached to a chosen basis. -/
noncomputable def structureConstants (e : Basis ι R L) : ι → ι → ι → R :=
  fun i k s => e.equivFun ⁅e i, e k⁆ s

/-- Skew-symmetry of the structure constants. -/
def SkewStructureConstants (c : ι → ι → ι → R) : Prop :=
  ∀ i k s, c i k s = -c k i s

/-- Jacobi written in structure-constant form. -/
def JacobiStructureConstants (c : ι → ι → ι → R) : Prop :=
  ∀ i k j t,
    (∑ s, c i k s * c s j t) + (∑ s, c k j s * c s i t) + (∑ s, c j i s * c s k t) = 0

/-- Lie's antisymmetry identity `cᵢₖˢ = -cₖᵢˢ`. -/
theorem structureConstants_skew (e : Basis ι R L) :
    SkewStructureConstants (structureConstants e) := by
  intro i k s
  have h : ⁅e i, e k⁆ = -⁅e k, e i⁆ := (lie_skew (e i) (e k)).symm
  change e.equivFun ⁅e i, e k⁆ s = -e.equivFun ⁅e k, e i⁆ s
  calc
    e.equivFun ⁅e i, e k⁆ s = e.equivFun (-⁅e k, e i⁆) s := by rw [h]
    _ = -e.equivFun ⁅e k, e i⁆ s := by
      rw [map_neg]
      rfl

private theorem structureConstants_lie_lie_coord (e : Basis ι R L) (i k j t : ι) :
    e.equivFun ⁅⁅e i, e k⁆, e j⁆ t =
      ∑ s, structureConstants e i k s * structureConstants e s j t := by
  let bracketRight : L →ₗ[R] L :=
    { toFun := fun x => ⁅x, e j⁆
      map_add' := fun x y => add_lie x y (e j)
      map_smul' := fun a x => smul_lie a x (e j) }
  calc
    e.equivFun ⁅⁅e i, e k⁆, e j⁆ t =
        e.equivFun (bracketRight ⁅e i, e k⁆) t := rfl
    _ = e.equivFun (bracketRight (∑ s, structureConstants e i k s • e s)) t := by
      have hsum : (∑ s, structureConstants e i k s • e s) = ⁅e i, e k⁆ := by
        simpa [structureConstants] using e.sum_equivFun ⁅e i, e k⁆
      rw [hsum]
    _ = e.equivFun (∑ s, structureConstants e i k s • ⁅e s, e j⁆) t := by
      simp [bracketRight]
    _ = ∑ s, structureConstants e i k s * structureConstants e s j t := by
      simp [structureConstants, map_sum, Finset.sum_apply, smul_eq_mul]

/-- Lie's Jacobi polynomial relations for the structure constants. -/
theorem structureConstants_jacobi (e : Basis ι R L) :
    JacobiStructureConstants (structureConstants e) := by
  intro i k j t
  have hJ : ⁅⁅e i, e k⁆, e j⁆ + ⁅⁅e k, e j⁆, e i⁆ + ⁅⁅e j, e i⁆, e k⁆ = 0 := by
    have h := congrArg Neg.neg (lie_jacobi (e j) (e i) (e k))
    rw [neg_zero, neg_add, neg_add, lie_skew, lie_skew, lie_skew] at h
    exact h
  have hcoord :
      e.equivFun (⁅⁅e i, e k⁆, e j⁆ + ⁅⁅e k, e j⁆, e i⁆ + ⁅⁅e j, e i⁆, e k⁆) t = 0 := by
    rw [hJ]
    simp
  rw [map_add, map_add] at hcoord
  simp only [Pi.add_apply] at hcoord
  rw [structureConstants_lie_lie_coord e i k j t,
    structureConstants_lie_lie_coord e k j i t,
    structureConstants_lie_lie_coord e j i k t] at hcoord
  exact hcoord

end

end MathlibExpansion.Lie
