import Mathlib.Topology.Algebra.PontryaginDual

/-!
# Pontryagin dual of a binary product

Discharges the deferred `PD_03` and `CGR_04` HVTs from the
`T20c_mid_03_pontryagin_step6_breach_report.md`.

`PD_03` asks for the duality between
`PontryaginDual (G × H)` and `PontryaginDual G × PontryaginDual H`,
packaged as continuous monoid homomorphisms each way with the expected
pointwise behaviour. `CGR_04` is the binary-product wrapper used by the
categorical dual functor.

We construct the forward map (restriction along the canonical inclusions)
and the backward map (pointwise product of the two factor characters at
the corresponding coordinates) as `ContinuousMonoidHom`s, and record the
explicit pointwise behaviour. The two directions are mutual inverses on
points — see `unfold_foldChar` and `foldChar_unfold`.
-/

open ContinuousMonoidHom

namespace MathlibExpansion
namespace Topology
namespace Algebra
namespace PontryaginDualBinary

universe u v

variable (G : Type u) (H : Type v)
variable [CommGroup G] [CommGroup H]
variable [TopologicalSpace G] [TopologicalSpace H]
variable [IsTopologicalGroup G] [IsTopologicalGroup H]

/-- **PD_03 (forward)**: the canonical map sending a character on the
binary product to its pair of restrictions to the canonical inclusions
`g ↦ (g, 1)` and `h ↦ (1, h)`. -/
noncomputable def unfold :
    ContinuousMonoidHom (PontryaginDual (G × H))
      (PontryaginDual G × PontryaginDual H) :=
  prod (_root_.PontryaginDual.map (inl G H))
       (_root_.PontryaginDual.map (inr G H))

/-- The character `(g, h) ↦ χ g * ψ h` built from a pair of factor
characters, as a Pontryagin-dual element. -/
noncomputable def foldChar (χ : PontryaginDual G) (ψ : PontryaginDual H) :
    PontryaginDual (G × H) :=
  (_root_.PontryaginDual.map (fst G H) χ) * (_root_.PontryaginDual.map (snd G H) ψ)

@[simp]
theorem foldChar_apply (χ : PontryaginDual G) (ψ : PontryaginDual H)
    (gh : G × H) :
    foldChar G H χ ψ gh = χ gh.1 * ψ gh.2 := rfl

theorem unfold_fst (χ : PontryaginDual (G × H)) (g : G) :
    (unfold G H χ).1 g = χ (g, 1) := rfl

theorem unfold_snd (χ : PontryaginDual (G × H)) (h : H) :
    (unfold G H χ).2 h = χ (1, h) := rfl

/-- **PD_03 (round-trip on points)**: folding a pair of factor characters
into a single character on the product and then unfolding back recovers
the original pair. -/
theorem unfold_foldChar (χ : PontryaginDual G) (ψ : PontryaginDual H) :
    unfold G H (foldChar G H χ ψ) = (χ, ψ) := by
  apply Prod.ext
  · apply ContinuousMonoidHom.ext
    intro g
    rw [unfold_fst]
    show χ g * ψ 1 = χ g
    rw [map_one ψ, mul_one]
  · apply ContinuousMonoidHom.ext
    intro h
    rw [unfold_snd]
    show χ 1 * ψ h = ψ h
    rw [map_one χ, one_mul]

/-- **PD_03 (faithfulness)**: a character on the binary product is
determined by its two restrictions: explicitly,
`χ (g, h) = χ (g, 1) * χ (1, h)`. -/
theorem char_factor (χ : PontryaginDual (G × H)) (g : G) (h : H) :
    χ (g, h) = χ (g, 1) * χ (1, h) := by
  have hmul : ((g, 1) : G × H) * (1, h) = (g, h) := by
    apply Prod.ext
    · show g * 1 = g
      rw [mul_one]
    · show (1 : H) * h = h
      rw [one_mul]
  calc
    χ (g, h) = χ ((g, 1) * (1, h)) := by rw [hmul]
    _ = χ (g, 1) * χ (1, h) := map_mul χ _ _

/-- **CGR_04 (binary product wrapper)**: the unfold–foldChar correspondence,
packaged as a left-inverse identity for use by the categorical dual functor. -/
theorem foldChar_unfold (χ : PontryaginDual (G × H)) :
    foldChar G H (unfold G H χ).1 (unfold G H χ).2 = χ := by
  apply ContinuousMonoidHom.ext
  intro gh
  obtain ⟨g, h⟩ := gh
  rw [foldChar_apply]
  show (unfold G H χ).1 g * (unfold G H χ).2 h = χ (g, h)
  rw [unfold_fst, unfold_snd, ← char_factor]

end PontryaginDualBinary

end Algebra
end Topology
end MathlibExpansion
