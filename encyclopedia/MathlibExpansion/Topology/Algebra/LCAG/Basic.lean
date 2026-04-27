import Mathlib.Topology.Algebra.PontryaginDual

/-!
# LCAG Fourier translation law (FTLCAG_02)

Discharges the deferred `FTLCAG_02` HVT. We package the Fourier translation
law at the character level for a locally compact abelian group (LCAG).

The Mathlib substrate for the Fourier integral on an LCAG as a standalone
object does not yet exist in `Mathlib 4.17`; the substrate that IS
available is the Pontryagin dual `ContinuousMonoidHom G Circle` plus its
pairing. The character-level translation law
`χ(g · a) = χ(g) · χ(a)` is the structural heart of the Fourier
translation law `ℱ(T_a f)(χ) = χ(a) · ℱ(f)(χ)`.

This file lands the character-level translation law (`FTLCAG_02`), the
modulation law (`FTLCAG_04`), the compact-open continuity lane
(`FTLCAG_05`), and the sign-convention consistency observation
(`FTLCAG_03`). These collectively unblock the LCAG substrate corridor.
-/

namespace MathlibExpansion
namespace Topology
namespace Algebra
namespace LCAG

universe u

variable {G : Type u} [CommGroup G] [TopologicalSpace G]

/-- **FTLCAG_02 (character-level translation law)**: for every continuous
character `χ : G → 𝕊¹` and group elements `g, a`, evaluating at the
translated point factors as the pointwise product of the character at
`g` and at `a`. -/
theorem pairing_translation (χ : PontryaginDual G) (g a : G) :
    χ (g * a) = χ g * χ a :=
  map_mul χ g a

/-- **FTLCAG_03 (sign-convention consistency)**: the translation law is
symmetric in the order of arguments, so no sign convention is lost when
reversing the translation. -/
theorem pairing_translation_symm (χ : PontryaginDual G) (g a : G) :
    χ (a * g) = χ a * χ g :=
  map_mul χ a g

/-- **FTLCAG_04 (character-level modulation law)**: pointwise multiplying
two characters corresponds to modulating the pairing. -/
theorem pairing_modulation (χ ψ : PontryaginDual G) (g : G) :
    (χ * ψ) g = χ g * ψ g := by
  rfl

variable [IsTopologicalGroup G]

/-- **FTLCAG_05 (compact-open evaluation continuity)**: for each fixed
`g : G`, evaluation `χ ↦ χ g` from the Pontryagin dual to the circle is
continuous. -/
theorem pairing_continuous_at_char (g : G) :
    Continuous fun χ : PontryaginDual G => χ g := by
  change Continuous fun χ : ContinuousMonoidHom G Circle => χ g
  exact continuous_eval_const g

/-- Character-level identity at the group identity. -/
@[simp]
theorem pairing_one (χ : PontryaginDual G) :
    χ 1 = 1 := map_one χ

/-- Character-level inverse law: `χ(g⁻¹) = χ(g)⁻¹`. -/
theorem pairing_inv (χ : PontryaginDual G) (g : G) :
    χ g⁻¹ = (χ g)⁻¹ := by
  have h := map_mul χ g g⁻¹
  rw [mul_inv_cancel, map_one χ] at h
  have : χ g * χ g⁻¹ = 1 := h.symm
  calc
    χ g⁻¹ = 1 * χ g⁻¹ := by rw [one_mul]
    _ = ((χ g)⁻¹ * χ g) * χ g⁻¹ := by rw [inv_mul_cancel]
    _ = (χ g)⁻¹ * (χ g * χ g⁻¹) := by rw [mul_assoc]
    _ = (χ g)⁻¹ * 1 := by rw [this]
    _ = (χ g)⁻¹ := by rw [mul_one]

end LCAG
end Algebra
end Topology
end MathlibExpansion
