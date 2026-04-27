import MathlibExpansion.Roots.Schlessinger.ProRepOverCore
import MathlibExpansion.Textbooks.Schlessinger1968.Chapter3.SchlessingerConditions

/-!
# Schlessinger Hull Construction Boundary

This file factors the Chapter 3 pro-representability boundary into the two
standard parts of Schlessinger's proof in "Functors of Artin Rings" (1968),
Theorem 2.11:

1. H1, H2, and H3 construct a hull.
2. H4 upgrades the hull to a pro-representing object.

The explicit inverse-limit construction of the complete local Noetherian
algebra is not present in the current substrate. The two remaining axioms are
therefore upstream of the textbook theorem and track the exact theorem where
the missing formal construction lives.
-/

namespace MathlibExpansion.Textbooks.Schlessinger1968.Chapter3

universe u

open CategoryTheory MathlibExpansion.Roots.Schlessinger IsLocalRing

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-- The lifting map expressing formal smoothness of a hull map along a small
extension `A -> B`: a map from `R` to `A` gives its restriction to `B` and its
image in `D(A)`, compatibly over `D(B)`. -/
noncomputable def hullLiftingMapOver
    (D : DeformationFunctorOver.{u, u} Λ k)
    (R : CompleteLocalNoetherianAlgOver Λ k)
    (eta : HomFunctorOver R ⟶ D.F)
    {A B : ArtinLocalAlgOver Λ k} (f : A ⟶ B) :
    (HomFunctorOver R).obj A →
      {x : (HomFunctorOver R).obj B × D.F.obj A //
        D.F.map f x.2 = eta.app B x.1} :=
  fun phi => ⟨((HomFunctorOver R).map f phi, eta.app A phi), by
    change D.F.map f (eta.app A phi) =
      eta.app B ((HomFunctorOver R).map f phi)
    simpa using congrFun (eta.naturality f).symm phi⟩

/-- A Schlessinger hull over `Λ`: a complete local Noetherian algebra with a
formally smooth natural map to `D` inducing a bijection on the tangent object.

This is the intermediate object constructed in Schlessinger (1968),
"Functors of Artin Rings", Theorem 2.11, before imposing H4 to obtain a
pro-representing object. -/
structure SchlessingerHullOver (D : DeformationFunctorOver.{u, u} Λ k) where
  R : CompleteLocalNoetherianAlgOver Λ k
  eta : HomFunctorOver R ⟶ D.F
  tangentBijective : Function.Bijective (eta.app (dualNumberObjOver Λ k))
  smallExtensionLifting :
    ∀ {A B : ArtinLocalAlgOver Λ k} (f : A ⟶ B),
      SmallExtensionOver f → Function.Surjective (hullLiftingMapOver D R eta f)

/-- **Hull existence** (Schlessinger 1968, "Functors of Artin Rings",
Theorem 2.11, hull-existence part).

If a `Λ`-coefficient deformation functor satisfies H1, H2, and H3, then it
has a Schlessinger hull. The missing proof is the inductive construction
of the complete local Noetherian algebra as an inverse limit of small
extensions, together with the finite tangent-space control supplied by H3. -/
axiom exists_schlessinger_hull_of_H1_H2_H3
    (D : DeformationFunctorOver.{u, u} Λ k)
    [AddCommGroup (D.F.obj (dualNumberObjOver Λ k))]
    [Module k (D.F.obj (dualNumberObjOver Λ k))]
    (h1 : H1 D) (h2 : H2 D)
    (h3 : H3 D (dualNumberObjOver Λ k)) :
    SchlessingerHullOver D

/-- **Hull effectiveness under H4** (Schlessinger 1968, "Functors of Artin
Rings", Theorem 2.11, H4/pro-representability part).

If a `Λ`-coefficient deformation functor has a Schlessinger hull and satisfies
H4, then the hull map is bijective on every Artinian quotient, so the functor
is pro-representable. -/
axiom prorepresentable_of_schlessinger_hull_H4
    (D : DeformationFunctorOver.{u, u} Λ k)
    (hull : SchlessingerHullOver D)
    (h4 : H4 D) :
    IsProRepresentableOver D

end MathlibExpansion.Textbooks.Schlessinger1968.Chapter3
