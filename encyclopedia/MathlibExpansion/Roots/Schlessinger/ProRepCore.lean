import MathlibExpansion.Roots.Schlessinger.TangentFunctor

/-!
# Pro-Representability Core Surface

Core data for Schlessinger pro-representability on `Art_k`:

- `CompleteLocalNoetherianAlg`
- `HomFunctor`
- `ProRepresentedBy`
- `IsProRepresentable`

The theorem surface lives in `ProRep.lean`, which routes the former
boundary axiom through the Mazur/Chapter 3 bridge.
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u v

open CategoryTheory IsLocalRing

variable {k : Type u} [Field k]

/-- A **complete local Noetherian k-algebra**: a bundled k-algebra `R` that
is local, Noetherian, adic-complete with respect to its maximal ideal,
and has residue field identified with `k` as a ring. -/
structure CompleteLocalNoetherianAlg (k : Type u) [Field k] where
  carrier       : Type u
  instCommRing  : CommRing carrier
  instAlgebra   : Algebra k carrier
  instIsLocal   : IsLocalRing carrier
  instIsNoeth   : IsNoetherianRing carrier
  isAdicComplete : IsAdicComplete (IsLocalRing.maximalIdeal carrier) carrier
  residueEquiv  : IsLocalRing.ResidueField carrier ≃+* k

namespace CompleteLocalNoetherianAlg

variable {k : Type u} [Field k]

attribute [instance] CompleteLocalNoetherianAlg.instCommRing
                     CompleteLocalNoetherianAlg.instAlgebra
                     CompleteLocalNoetherianAlg.instIsLocal
                     CompleteLocalNoetherianAlg.instIsNoeth

end CompleteLocalNoetherianAlg

/-- The **restricted functor of points** of a complete local Noetherian
k-algebra `R`, restricted to `Art_k`. -/
noncomputable def HomFunctor (R : CompleteLocalNoetherianAlg k) :
    ArtinLocalAlg k ⥤ Type u where
  obj A := R.carrier →ₐ[k] A.carrier
  map {A B} f φ := f.comp φ
  map_id := by
    intro A
    funext φ
    apply AlgHom.ext
    intro x
    rfl
  map_comp := by
    intro A B C f g
    funext φ
    apply AlgHom.ext
    intro x
    rfl

/-- `D` is **pro-represented** by `R` if there is a natural transformation
`η : HomFunctor R ⟶ D.F` that is componentwise bijective. -/
def ProRepresentedBy (D : DeformationFunctor k)
    (R : CompleteLocalNoetherianAlg k) : Prop :=
  ∃ η : HomFunctor R ⟶ D.F,
    ∀ (A : ArtinLocalAlg k), Function.Bijective (η.app A)

/-- `D` is **pro-representable** if some complete local Noetherian k-algebra
represents it. -/
def IsProRepresentable (D : DeformationFunctor k) : Prop :=
  ∃ R : CompleteLocalNoetherianAlg k, ProRepresentedBy D R

end MathlibExpansion.Roots.Schlessinger
