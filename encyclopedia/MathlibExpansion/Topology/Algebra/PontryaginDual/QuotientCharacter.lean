import Mathlib.Topology.Algebra.PontryaginDual
import Mathlib.Topology.Algebra.Group.Quotient
import MathlibExpansion.Topology.Algebra.PontryaginDual.Annihilator

/-!
# Quotient factorisation of characters

Discharges the deferred `CGR_08` HVT from the
`T20c_mid_03_pontryagin_step6_breach_report.md`.

`CGR_08` asks for the quotient/character factorisation: a character `χ`
on `G` factors through the quotient `G ⧸ H` if and only if `χ` annihilates
`H`. Combined with `PontryaginDual.map` of the quotient projection, this
gives an injection from `PontryaginDual (G ⧸ H)` into the annihilator
`H.annihilator ≤ PontryaginDual G`.

The carrier theorem is the Mathlib `QuotientGroup.lift` API specialised to
characters into `Circle`. We package both directions:

* `liftChar` lifts a character vanishing on `H` to a character of `G ⧸ H`.
* `restrictAnnihilator` is the dual map from `PontryaginDual (G ⧸ H)` into
  `H.annihilator`, sending a character of the quotient to its pullback.
* `restrictAnnihilator_injective` records faithfulness.
-/

open ContinuousMonoidHom

namespace MathlibExpansion
namespace Topology
namespace Algebra
namespace PontryaginDualQuotient

universe u

variable {G : Type u} [CommGroup G] [TopologicalSpace G] [IsTopologicalGroup G]
variable (H : Subgroup G) [H.Normal]

/-- The pullback of a character on `G ⧸ H` along the quotient projection. -/
noncomputable def restrictHom :
    ContinuousMonoidHom (PontryaginDual (G ⧸ H)) (PontryaginDual G) :=
  _root_.PontryaginDual.map
    { toMonoidHom := QuotientGroup.mk' H
      continuous_toFun := QuotientGroup.continuous_mk }

@[simp]
theorem restrictHom_apply (χ : PontryaginDual (G ⧸ H)) (g : G) :
    restrictHom H χ g = χ ((QuotientGroup.mk g : G ⧸ H)) := rfl

/-- **CGR_08 (annihilator landing)**: the pullback of any character of
the quotient `G ⧸ H` annihilates `H`. -/
theorem restrictHom_mem_annihilator (χ : PontryaginDual (G ⧸ H)) :
    restrictHom H χ ∈ H.annihilator := by
  intro h
  change χ ((QuotientGroup.mk (h : G) : G ⧸ H)) = 1
  have hker : (QuotientGroup.mk (h : G) : G ⧸ H) = 1 :=
    (QuotientGroup.eq_one_iff (h : G)).mpr h.2
  rw [hker, map_one]

/-- The pullback map, packaged as a homomorphism into the annihilator. -/
noncomputable def restrictAnnihilator (χ : PontryaginDual (G ⧸ H)) :
    H.annihilator :=
  ⟨restrictHom H χ, restrictHom_mem_annihilator H χ⟩

@[simp]
theorem restrictAnnihilator_coe (χ : PontryaginDual (G ⧸ H)) :
    ((restrictAnnihilator H χ : PontryaginDual G) : G → Circle) g =
      χ ((QuotientGroup.mk g : G ⧸ H)) := rfl

/-- **CGR_08 (faithfulness)**: pulling a character back along the
quotient projection is injective — two characters on `G ⧸ H` agreeing on
every coset are equal. This is the structural content of the
quotient/character correspondence. -/
theorem restrictAnnihilator_injective :
    Function.Injective (restrictAnnihilator H) := by
  intro χ ψ h
  apply DFunLike.ext
  intro x
  refine QuotientGroup.induction_on x ?_
  intro g
  have h' : (restrictHom H χ) g = (restrictHom H ψ) g := by
    have := congrArg (Subtype.val) h
    exact congrFun (congrArg DFunLike.coe this) g
  exact h'

end PontryaginDualQuotient

end Algebra
end Topology
end MathlibExpansion
