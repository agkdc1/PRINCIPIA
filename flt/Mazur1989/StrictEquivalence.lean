import Mathlib
import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver
import MathlibExpansion.Roots.Mazur1989.ResidualRep

/-!
# Strict Equivalence of Lifts (Mazur 1989)

Two lifts `ρ₁, ρ₂ : G → GL₂(A)` of a residual representation `ρ̄ : G → GL₂(k)`
are **strictly equivalent** if there exists `M` in the kernel of the reduction
map `GL₂(A) → GL₂(k)` (the *congruence-one subgroup*) such that
`ρ₂ = M ρ₁ M⁻¹`.

This file constructs:

1. `congruenceOneSubgroup A` — the kernel of `GL₂(A) → GL₂(A/m_A)`.
2. The explicit `MulAction` of the congruence-one subgroup on `GL₂(A)` by
   conjugation (construction, not typeclass-only).
3. The `Setoid` via `MulAction.orbitRel` on any `Lift` type equipped with
   such an action.
-/

namespace MathlibExpansion.Roots.Mazur1989

universe u

open Matrix

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-- The **congruence-one subgroup** of `GL₂(A.carrier)`: the kernel of the
reduction map `GL₂(A.carrier) → GL₂(A.carrier / m_{A.carrier})`. -/
noncomputable def congruenceOneSubgroup
    (A : MathlibExpansion.Roots.Schlessinger.ArtinLocalAlgOver Λ k) :
    Subgroup (GL (Fin 2) A.carrier) :=
  MonoidHom.ker
    (Units.map
      ((Ideal.Quotient.mk
        (IsLocalRing.maximalIdeal A.carrier)).mapMatrix.toMonoidHom))

/-- **Explicit conjugation action** of the congruence-one subgroup on
`GL₂(A.carrier)`. Constructed directly (not typeclass-only) so that
downstream strict-equivalence machinery has a concrete `MulAction` witness
to cite. -/
noncomputable instance congruenceOneActsByConj
    (A : MathlibExpansion.Roots.Schlessinger.ArtinLocalAlgOver Λ k) :
    MulAction (congruenceOneSubgroup A) (GL (Fin 2) A.carrier) where
  smul h g := h.val * g * h.val⁻¹
  one_smul g := by
    show (1 : congruenceOneSubgroup A).val * g *
         ((1 : congruenceOneSubgroup A).val)⁻¹ = g
    simp
  mul_smul h₁ h₂ g := by
    show ((h₁ * h₂).val) * g * ((h₁ * h₂).val)⁻¹ =
         h₁.val * (h₂.val * g * h₂.val⁻¹) * h₁.val⁻¹
    simp only [Subgroup.coe_mul, _root_.mul_inv_rev]
    group

/-- **Strict-equivalence setoid** on any `Lift` type equipped with a
`MulAction` of the congruence-one subgroup: two lifts are equivalent iff
they lie in the same orbit. -/
noncomputable def strictEquivSetoid
    (A : MathlibExpansion.Roots.Schlessinger.ArtinLocalAlgOver Λ k)
    (Lift : Type u) [MulAction (congruenceOneSubgroup A) Lift] :
    Setoid Lift :=
  MulAction.orbitRel (congruenceOneSubgroup A) Lift

/-- The quotient of a `Lift` type by strict equivalence. -/
abbrev StrictEquivQuotient
    (A : MathlibExpansion.Roots.Schlessinger.ArtinLocalAlgOver Λ k)
    (Lift : Type u) [MulAction (congruenceOneSubgroup A) Lift] : Type u :=
  Quotient (strictEquivSetoid A Lift)

end MathlibExpansion.Roots.Mazur1989
