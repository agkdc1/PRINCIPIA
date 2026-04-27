import Mathlib
import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver

/-!
# The Category C_Λ(k) — Residue-Fixed Morphisms

Schlessinger's category `C_Λ(k)` (§1 of "Functors of Artin Rings", 1968):
Artinian local `Λ`-algebras with residue field `k`, with LOCAL `Λ`-algebra
homomorphisms as morphisms. A local homomorphism automatically fixes the
residue field when both algebras have the same Λ-algebra structure on `k`.

This file defines `ResidueFixedHom A B` — the honest `C_Λ` morphism type —
and proves it forms a category (identity, composition, associativity).

The existing `ArtinLocalAlgOver.instCategory` uses raw `→ₐ[Λ]`; this file
introduces the LOCAL refinement without mutating that instance.
-/

namespace MathlibExpansion.Textbooks.Schlessinger1968.Chapter1

universe u

open CategoryTheory IsLocalRing

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

open MathlibExpansion.Roots.Schlessinger

/-- A **residue-fixed morphism** in `C_Λ(k)`: a `Λ`-algebra homomorphism
between objects of `ArtinLocalAlgOver Λ k` that is also a **local**
ring homomorphism (sends non-units to non-units).

For local `Λ`-algebra maps between rings with the same residue-field
`Λ`-algebra structure on `k`, locality implies the induced map on residue
fields is the identity — the "residue-fixed" condition of Schlessinger. -/
structure ResidueFixedHom
    (A B : ArtinLocalAlgOver Λ k) where
  /-- Underlying `Λ`-algebra homomorphism. -/
  toAlgHom   : A.carrier →ₐ[Λ] B.carrier
  /-- Locality condition: units in the codomain pull back to units. -/
  isLocalHom : IsLocalHom toAlgHom.toRingHom

namespace ResidueFixedHom

variable {A B C D : ArtinLocalAlgOver Λ k}

/-- Coercion to the underlying `Λ`-algebra homomorphism. -/
instance : CoeOut (ResidueFixedHom A B) (A.carrier →ₐ[Λ] B.carrier) :=
  ⟨toAlgHom⟩

@[simp] theorem coe_toAlgHom (f : ResidueFixedHom A B) : (f : A.carrier →ₐ[Λ] B.carrier) = f.toAlgHom := rfl

/-- Function coercion: apply as a function on carrier elements. -/
instance : CoeFun (ResidueFixedHom A B) (fun _ => A.carrier → B.carrier) :=
  ⟨fun f => f.toAlgHom.toFun⟩

/-- Identity residue-fixed morphism. -/
noncomputable def id (A : ArtinLocalAlgOver Λ k) : ResidueFixedHom A A where
  toAlgHom   := AlgHom.id Λ A.carrier
  isLocalHom := ⟨fun _ hu => hu⟩

/-- Composition of residue-fixed morphisms. -/
noncomputable def comp (f : ResidueFixedHom A B) (g : ResidueFixedHom B C) :
    ResidueFixedHom A C where
  toAlgHom   := g.toAlgHom.comp f.toAlgHom
  isLocalHom := by
    constructor
    intro a hu
    have hg := g.isLocalHom.map_nonunit
    have hf := f.isLocalHom.map_nonunit
    exact hf a (hg (f.toAlgHom a) (by exact hu))

/-- `ResidueFixedHom` respects extensionality: equality on all carriers implies equality. -/
@[ext]
theorem ext {f g : ResidueFixedHom A B} (h : ∀ x, f.toAlgHom x = g.toAlgHom x) : f = g := by
  cases f; cases g; congr 1; ext; exact h _

/-- A residue-fixed morphism sends units to units (ring hom axiom). -/
theorem map_units (f : ResidueFixedHom A B) {a : A.carrier} (hu : IsUnit a) :
    IsUnit (f.toAlgHom a) :=
  IsUnit.map f.toAlgHom.toRingHom hu

/-- The local condition: units in the image pull back to units. -/
theorem map_nonunit (f : ResidueFixedHom A B) {a : A.carrier}
    (hu : IsUnit (f.toAlgHom a)) : IsUnit a :=
  f.isLocalHom.map_nonunit a hu

@[simp] lemma id_toAlgHom (A : ArtinLocalAlgOver Λ k) :
    (ResidueFixedHom.id A).toAlgHom = AlgHom.id Λ A.carrier := rfl

@[simp] lemma comp_toAlgHom (f : ResidueFixedHom A B) (g : ResidueFixedHom B C) :
    (f.comp g).toAlgHom = g.toAlgHom.comp f.toAlgHom := rfl

end ResidueFixedHom

/-!
## C_Λ as a category

`ArtinLocalAlgOver Λ k` with `ResidueFixedHom` morphisms forms a category.
We record this without creating a new `Category` instance on `ArtinLocalAlgOver`
(which already has one with raw `AlgHom`s); instead we package it as a record
for use in the textbook-level proofs.
-/

/-- The `C_Λ(k)` category as a `CategoryTheory.Category` instance on a
type-alias wrapper. -/
@[nolint unusedArguments]
def CLambdaObj (Λ k : Type u) [CommRing Λ] [Field k] [Algebra Λ k] :=
  ArtinLocalAlgOver Λ k

private theorem rfh_id_comp {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]
    {A B : ArtinLocalAlgOver Λ k} (f : ResidueFixedHom A B) :
    (ResidueFixedHom.id A).comp f = f := by
  ext x; simp [AlgHom.comp_apply]

private theorem rfh_comp_id {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]
    {A B : ArtinLocalAlgOver Λ k} (f : ResidueFixedHom A B) :
    f.comp (ResidueFixedHom.id B) = f := by
  ext x; simp [AlgHom.comp_apply]

private theorem rfh_assoc {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]
    {A B C D : ArtinLocalAlgOver Λ k}
    (f : ResidueFixedHom A B) (g : ResidueFixedHom B C) (h : ResidueFixedHom C D) :
    (f.comp g).comp h = f.comp (g.comp h) := by
  ext x; simp [AlgHom.comp_apply]

namespace CLambdaObj

variable (Λ k : Type u) [CommRing Λ] [Field k] [Algebra Λ k]

/-- Coerce a `CLambdaObj` to its `ArtinLocalAlgOver` representative. -/
noncomputable def toArtinLocalAlgOver : CLambdaObj Λ k → ArtinLocalAlgOver Λ k := id

/-- The **C_Λ category**: Artinian local Λ-algebras with local Λ-algebra maps. -/
noncomputable instance instCategory : Category (CLambdaObj Λ k) where
  Hom A B   := ResidueFixedHom A B
  id A      := ResidueFixedHom.id A
  comp f g  := f.comp g
  id_comp f := rfh_id_comp f
  comp_id f := rfh_comp_id f
  assoc f g h := rfh_assoc f g h

end CLambdaObj

/-!
## Λ := k specialisation

When Λ = k, a residue-fixed morphism is just a local k-algebra homomorphism.
-/

/-- When Λ = k, the `ResidueFixedHom` specialises to local k-algebra homs.
Every local k-algebra map between Art_k objects is residue-fixed. -/
def residueFixedHom_of_localAlgHom_over_field
    {A B : ArtinLocalAlgOver k k}
    (f : A.carrier →ₐ[k] B.carrier)
    (hloc : IsLocalHom f.toRingHom) :
    ResidueFixedHom A B :=
  ⟨f, hloc⟩

end MathlibExpansion.Textbooks.Schlessinger1968.Chapter1
