import Mathlib

/-!
# Residual Galois representation datum (Mazur 1989)

The Mazur 1989 residual-representation datum is a 2-dimensional residual
Galois representation `ρ̄ : G → GL(Fin 2, k)` over a finite residue field
`k`, together with the standing property that `ρ̄` factors through a finite
quotient of `G` (the continuity/profinite-factoring predicate, stated as a
typed predicate — never a bare `Prop` parameter).

The adjoint representation `ad ρ̄` is an alias around
`Representation.linHom` applied to the `Rep k G` view of `ρ̄`.

Doctrine v2: no free-Prop parameters; every hypothesis on `ρ̄` is a typed
predicate attached to concrete data.
-/

namespace MathlibExpansion.Roots.Mazur1989

universe u v

open Matrix

/-- **Residual representation datum.** A 2-dimensional residual
representation over a finite field `k`, given as a monoid homomorphism
`ρ̄ : G → GL(Fin 2, k)`, together with the data of a factorization through
a finite quotient of `G`. -/
structure ResidualRepDatum (G : Type u) (k : Type v)
    [Group G] [Field k] [Finite k] where
  /-- The residual representation `ρ̄ : G → GL₂(k)`. -/
  rhoBar : G →* GL (Fin 2) k
  /-- Normal finite-index subgroup through which `ρ̄` factors. This is the
  typed-predicate replacement for the continuity hypothesis: rather than
  asserting `Continuous ρ̄` as a bare Prop, we carry the actual normal
  subgroup witness. -/
  kernelSubgroup : Subgroup G
  /-- The witness is a normal subgroup. -/
  kernelNormal : kernelSubgroup.Normal
  /-- The quotient by the witness is finite. -/
  kernelFiniteIndex : Finite (G ⧸ kernelSubgroup)
  /-- `ρ̄` sends the witness subgroup into the kernel of `GL(Fin 2, k)`
  (i.e. kills it). -/
  rhoBar_factorizes :
    ∀ g ∈ kernelSubgroup, rhoBar g = 1

attribute [instance] ResidualRepDatum.kernelNormal
                     ResidualRepDatum.kernelFiniteIndex

namespace ResidualRepDatum

variable {G : Type u} {k : Type v} [Group G] [Field k] [Finite k]

/-- The underlying representation on `Fin 2 → k` induced by `ρ̄`. -/
noncomputable def toRepresentation (D : ResidualRepDatum G k) :
    Representation k G (Fin 2 → k) := by
  refine { toFun := fun g => ?_, map_one' := ?_, map_mul' := ?_ }
  · exact Matrix.toLin' (D.rhoBar g : Matrix (Fin 2) (Fin 2) k)
  · simp only [_root_.map_one, Units.val_one]
    ext v i
    simp [Matrix.toLin'_apply, Matrix.one_apply, Finset.sum_ite_eq]
  · intro g h
    simp only [_root_.map_mul, Units.val_mul]
    ext v i
    simp [Matrix.toLin'_mul]

/-- **Adjoint representation** `ad ρ̄ := End(ρ̄)` as a `Representation k G`.

Mathematically: on `(Fin 2 → k) →ₗ[k] (Fin 2 → k)`, `g` acts by
conjugation `φ ↦ ρ̄(g) ∘ φ ∘ ρ̄(g)⁻¹`. This is `Representation.linHom`
applied with both arguments equal to `toRepresentation`. -/
noncomputable def AdjointRep (D : ResidualRepDatum G k) :
    Representation k G ((Fin 2 → k) →ₗ[k] (Fin 2 → k)) :=
  Representation.linHom D.toRepresentation D.toRepresentation

end ResidualRepDatum

end MathlibExpansion.Roots.Mazur1989
