import MathlibExpansion.Roots.Schlessinger.ArtinLocal

/-!
# Small Extensions in Art_k

A small extension is a surjective morphism f : A ⟶ B in Art_k whose kernel
is a square-zero k-vector space of dimension 1.

R9-03 confirmed: the full expression
  `Function.Surjective f ∧ (RingHom.ker f.toRingHom)^2 = ⊥ ∧
   Module.finrank k ↥(RingHom.ker f.toRingHom) = 1`
elaborates as a Prop under the standard algebra hypotheses.
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u

open IsLocalRing CategoryTheory

variable {k : Type u} [Field k]

/-- The kernel ideal of a morphism in Art_k, viewed inside the source ring.
With the direct category (`Hom A B := A.carrier →ₐ[k] B.carrier`), `f` is
already an AlgHom and `.toRingHom` applies directly. -/
def artinKer {A B : ArtinLocalAlg k} (f : A ⟶ B) : Ideal A.carrier :=
  RingHom.ker f.toRingHom

/-- A morphism f : A ⟶ B in Art_k is a **small extension** if it is
surjective, its kernel squares to zero, and the kernel is a
1-dimensional k-vector space.

These are the building blocks of the inductive hull construction in
Schlessinger's theorem. -/
def SmallExtension {A B : ArtinLocalAlg k} (f : A ⟶ B) : Prop :=
  Function.Surjective f.toFun ∧
  (artinKer f) ^ 2 = ⊥ ∧
  Module.finrank k ↥(artinKer f) = 1

/-- A morphism in Art_k is a **surjection** (weaker than small extension). -/
def IsSurjectionInArt {A B : ArtinLocalAlg k} (f : A ⟶ B) : Prop :=
  Function.Surjective f.toFun

/-- Every small extension is a surjection. -/
theorem SmallExtension.surjective {A B : ArtinLocalAlg k} {f : A ⟶ B}
    (h : SmallExtension f) : IsSurjectionInArt f :=
  h.1

/-- The kernel of a small extension has finrank 1. -/
theorem SmallExtension.ker_finrank {A B : ArtinLocalAlg k} {f : A ⟶ B}
    (h : SmallExtension f) : Module.finrank k ↥(artinKer f) = 1 :=
  h.2.2

/-- The kernel of a small extension is square-zero. -/
theorem SmallExtension.ker_sq_zero {A B : ArtinLocalAlg k} {f : A ⟶ B}
    (h : SmallExtension f) : (artinKer f) ^ 2 = ⊥ :=
  h.2.1

end MathlibExpansion.Roots.Schlessinger
