import MathlibExpansion.Roots.Schlessinger.DeformationFunctorOver
import MathlibExpansion.Roots.Schlessinger.DualNumberArtinian
import MathlibExpansion.Roots.Schlessinger.DualNumbers

/-!
# Pro-Representability over Λ (core definitions)

This file contains the representing-object surface for Schlessinger's
`Λ`-coefficient deformation theory:

- `CompleteLocalNoetherianAlgOver`
- `HomFunctorOver`
- `ProRepresentedByOver`
- `IsProRepresentableOver`
- `dualNumberObjOver`

The actual pro-representability theorem lives in `ProRepOver.lean`, which
re-exports these definitions and routes the former axiom through the
Chapter 3 / Mazur bridge.
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u

open CategoryTheory IsLocalRing

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-- A **complete local Noetherian `Λ`-algebra**: the target-side
representing object for pro-representability over `Λ`. -/
structure CompleteLocalNoetherianAlgOver (Λ k : Type u)
    [CommRing Λ] [Field k] [Algebra Λ k] where
  carrier       : Type u
  instCommRing  : CommRing carrier
  instAlgebra   : Algebra Λ carrier
  instIsLocal   : IsLocalRing carrier
  instIsNoeth   : IsNoetherianRing carrier
  isAdicComplete : IsAdicComplete (IsLocalRing.maximalIdeal carrier) carrier
  residueEquiv  : IsLocalRing.ResidueField carrier ≃+* k

namespace CompleteLocalNoetherianAlgOver

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

attribute [instance] CompleteLocalNoetherianAlgOver.instCommRing
                     CompleteLocalNoetherianAlgOver.instAlgebra
                     CompleteLocalNoetherianAlgOver.instIsLocal
                     CompleteLocalNoetherianAlgOver.instIsNoeth

end CompleteLocalNoetherianAlgOver

/-- The restricted functor of points of a complete local Noetherian
`Λ`-algebra `R`, restricted to `ArtinLocalAlgOver Λ k`. -/
noncomputable def HomFunctorOver (R : CompleteLocalNoetherianAlgOver Λ k) :
    ArtinLocalAlgOver Λ k ⥤ Type u where
  obj A := R.carrier →ₐ[Λ] A.carrier
  map {A B} f φ := f.comp φ
  map_id := by
    intro A
    ext x
    rfl
  map_comp := by
    intro A B C f g
    ext x
    rfl

/-- `D` is **pro-represented over Λ** by `R` if there is a natural
transformation `η : HomFunctorOver R ⟶ D.F` that is componentwise
bijective. -/
def ProRepresentedByOver (D : DeformationFunctorOver Λ k)
    (R : CompleteLocalNoetherianAlgOver Λ k) : Prop :=
  ∃ η : HomFunctorOver R ⟶ D.F,
    ∀ (A : ArtinLocalAlgOver Λ k), Function.Bijective (η.app A)

/-- `D` is **pro-representable over Λ** if some complete local Noetherian
`Λ`-algebra represents it. -/
def IsProRepresentableOver (D : DeformationFunctorOver Λ k) : Prop :=
  ∃ R : CompleteLocalNoetherianAlgOver Λ k, ProRepresentedByOver D R

/-- `DualNumber k` packaged as an object of `ArtinLocalAlgOver Λ k`. -/
noncomputable def dualNumberObjOver
    (Λ k : Type u) [CommRing Λ] [Field k] [Algebra Λ k] :
    ArtinLocalAlgOver Λ k where
  carrier       := DualNumber k
  instCommRing  := inferInstance
  instAlgebra   := Algebra.compHom (DualNumber k) (algebraMap Λ k)
  instIsArtinian := dualNumber_isArtinianRing k
  instIsLocal   := inferInstance
  residueEquiv  := (dualNumberResidueEquiv k).toRingEquiv

end MathlibExpansion.Roots.Schlessinger
