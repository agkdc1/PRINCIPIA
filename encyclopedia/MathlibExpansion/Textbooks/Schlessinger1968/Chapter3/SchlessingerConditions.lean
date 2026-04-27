import MathlibExpansion.Roots.Schlessinger.DeformationFunctorOver
import MathlibExpansion.Textbooks.Schlessinger1968.Chapter2.FiberProducts

/-!
# Schlessinger's Conditions H1–H4 (Textbooks presentation)

Following Schlessinger (1968, §2), a deformation functor `D : C_Λ(k) → Set`
is pro-representable if and only if it satisfies four conditions H1–H4 on
fiber products (pullbacks) in the category.

This file re-exports the conditions from the Roots substrate in the Textbooks
namespace and provides the concrete fiber-product interpretation using the
explicit `FPCarrier` construction from `Chapter2.FiberProducts`.

## Summary of conditions

| Condition | Statement |
|-----------|-----------|
| H1 | Surjectivity of comparison map when `g` is a small extension |
| H2 | Bijectivity of comparison map in the symmetric case `C = k` |
| H3 | Finite-dimensionality of the tangent space `D(k[ε])` |
| H4 | Bijectivity for ALL pullbacks over small extensions (implies H1) |
-/

namespace MathlibExpansion.Textbooks.Schlessinger1968.Chapter3

universe u

open MathlibExpansion.Roots.Schlessinger IsLocalRing

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-! ### Re-export of H1–H4 from the Roots substrate -/

/-- **H1**: For every pullback square with `g : B → C` a surjective small
extension, the comparison map `D(P) → D(A) ×_{D(C)} D(B)` is surjective.

This ensures that deformation data over `A` and `B` that agree over `C` can
be lifted to a deformation over the pullback `P = A ×_C B`. -/
def H1 (D : DeformationFunctorOver Λ k) : Prop := H1Over D

/-- **H2**: In the symmetric case where `C = k` (the residue field object)
and both `f : A → k`, `g : B → k` are surjective small extensions, the
comparison map is bijective.

H2 + H1 together imply that the tangent space `D(k[ε])` has a natural
`k`-vector space structure (Schlessinger's original Proposition 2.3). -/
def H2 (D : DeformationFunctorOver Λ k) : Prop := H2Over D

/-- **H3**: The tangent space `D(k[ε])` is a finite-dimensional `k`-vector
space. Combined with H2, this ensures the hull has finite embedding dimension.

The tangent object is `dualNumberObjOver Λ k` (the dual numbers `k[ε]`
packaged as an object of `ArtinLocalAlgOver Λ k`). -/
def H3 (D : DeformationFunctorOver Λ k)
    (tangentObj : ArtinLocalAlgOver Λ k)
    [AddCommGroup (D.F.obj tangentObj)]
    [Module k (D.F.obj tangentObj)] : Prop :=
  H3Over D tangentObj

/-- **H4**: Bijectivity of the comparison map for ALL pullbacks over
small extensions.

H4 is the strengthening of H1 that ensures pro-representability (not just a
hull). H4 implies H1 (Lemma `H4Over.imp_H1Over`). -/
def H4 (D : DeformationFunctorOver Λ k) : Prop := H4Over D

/-! ### Key implications -/

/-- H4 implies H1. -/
theorem H4.imp_H1 {D : DeformationFunctorOver Λ k} (h : H4 D) : H1 D :=
  H4Over.imp_H1Over h

/-! ### Fiber product comparison map -/

/-- The **comparison map** `D(P) → D(A) ×_{D(C)} D(B)` for a chosen
pullback `P`. This is the map whose surjectivity (H1) or bijectivity (H2, H4)
is asserted by Schlessinger's conditions. -/
def comparisonMap (D : DeformationFunctorOver Λ k)
    {A B C : ArtinLocalAlgOver Λ k} {f : A ⟶ C} {g : B ⟶ C}
    (pb : ArtinPullbackOver f g) :
    D.F.obj pb.P →
    {x : D.F.obj A × D.F.obj B // D.F.map f x.1 = D.F.map g x.2} :=
  fiberComparisonOver D pb

/-- H1 asserts surjectivity of `comparisonMap` when `g` is a small extension. -/
theorem H1.comparisonMap_surjective {D : DeformationFunctorOver Λ k}
    (h1 : H1 D)
    {A B C : ArtinLocalAlgOver Λ k} {f : A ⟶ C} {g : B ⟶ C}
    (hg : SmallExtensionOver g)
    (pb : ArtinPullbackOver f g) :
    Function.Surjective (comparisonMap D pb) :=
  h1 f g hg pb

/-- H4 asserts bijectivity of `comparisonMap` for all such pullbacks. -/
theorem H4.comparisonMap_bijective {D : DeformationFunctorOver Λ k}
    (h4 : H4 D)
    {A B C : ArtinLocalAlgOver Λ k} {f : A ⟶ C} {g : B ⟶ C}
    (hg : SmallExtensionOver g)
    (pb : ArtinPullbackOver f g) :
    Function.Bijective (comparisonMap D pb) :=
  h4 f g hg pb

end MathlibExpansion.Textbooks.Schlessinger1968.Chapter3
