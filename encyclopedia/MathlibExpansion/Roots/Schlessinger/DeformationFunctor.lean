import MathlibExpansion.Roots.Schlessinger.DualNumbers

/-!
# Deformation Functors and Schlessinger's Criteria H1–H4

A deformation functor is a set-valued functor on Art_k with a canonical
basepoint over the residue field object k.

The four Schlessinger criteria H1–H4 are stated as explicit Lean Props.
These are the necessary and sufficient conditions for pro-representability
(Schlessinger 1968).

This is the k-parallel substrate, mirroring `DeformationFunctorOver.lean`
in the Λ-parallel substrate introduced by the Mazur1989 opus-Delta breach
(2026-04-21). H3 is exposed as a typed predicate on an explicit tangent
object so that downstream callers choose how to provide the `AddCommGroup`
/ `Module k` structure on `D.F.obj tangentObj`.
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u v

open CategoryTheory IsLocalRing

variable {k : Type u} [Field k]

/-- A **deformation functor** on Art_k: a covariant set-valued functor F
with a distinguished basepoint over the residue field k, and the condition
that the basepoint is the unique element of F(k) (the rigidity condition). -/
structure DeformationFunctor (k : Type u) [Field k] where
  F          : ArtinLocalAlg k ⥤ Type v
  base       : F.obj (ArtinLocalAlg.residueFieldObject k)
  base_unique : Subsingleton (F.obj (ArtinLocalAlg.residueFieldObject k))

/-- An **Artinian fiber product**: a chosen pullback square in Art_k.

We carry the square as explicit data (commutative square object + two
projections + commutativity witness). Downstream H1–H4 predicates are
stated over any such square; the actual limit-cone witness is deferred
to the caller when it matters (e.g. in concrete instantiations). -/
structure ArtinPullback {A B C : ArtinLocalAlg k}
    (f : A ⟶ C) (g : B ⟶ C) where
  /-- The pullback object in Art_k. -/
  P   : ArtinLocalAlg k
  /-- First projection P → A. -/
  fst : P ⟶ A
  /-- Second projection P → B. -/
  snd : P ⟶ B
  /-- The commutativity square. -/
  w   : fst ≫ f = snd ≫ g

/-- The comparison map from F(P) to the fiber product of F(A) × F(B)
over F(C), for a pullback square P in Art_k. -/
def fiberComparison (D : DeformationFunctor k) {A B C : ArtinLocalAlg k}
    {f : A ⟶ C} {g : B ⟶ C} (pb : ArtinPullback f g) :
    D.F.obj pb.P →
    {x : D.F.obj A × D.F.obj B // D.F.map f x.1 = D.F.map g x.2} :=
  fun p => ⟨(D.F.map pb.fst p, D.F.map pb.snd p), by
    have := congr_arg (D.F.map · p) pb.w
    simp [Functor.map_comp] at this
    exact this⟩

/-!
## Schlessinger's Criteria H1–H4

These are the four conditions on a deformation functor D : Art_k → Set
that together characterize pro-representability. Each is stated as an
explicit Lean Prop over `ArtinPullback` witnesses.

Reference: M. Schlessinger, "Functors of Artin Rings", Trans. AMS 1968.
-/

/-- **H1**: For any pullback square P = A ×_C B in Art_k where g : B → C
is a small extension, the comparison map F(P) → F(A) ×_{F(C)} F(B)
is surjective. -/
def H1 (D : DeformationFunctor k) : Prop :=
  ∀ {A B C : ArtinLocalAlg k} (f : A ⟶ C) (g : B ⟶ C),
    SmallExtension g →
    ∀ (pb : ArtinPullback f g),
      Function.Surjective (fiberComparison D pb)

/-- **H2**: When both maps are small extensions of k (C = residue field),
the comparison map is bijective. This gives the k-vector space structure
on the tangent space F(k[ε]). -/
def H2 (D : DeformationFunctor k) : Prop :=
  ∀ {A B : ArtinLocalAlg k}
    (f : A ⟶ ArtinLocalAlg.residueFieldObject k)
    (g : B ⟶ ArtinLocalAlg.residueFieldObject k),
    SmallExtension f → SmallExtension g →
    ∀ (pb : ArtinPullback f g),
      Function.Bijective (fiberComparison D pb)

/-- **H2'** (variant): The special symmetric case of H2 where both maps
coincide. Used in some formulations to separate surjectivity from
bijectivity in the tangent-space argument. -/
def H2' (D : DeformationFunctor k) : Prop :=
  ∀ {A : ArtinLocalAlg k} (f : A ⟶ ArtinLocalAlg.residueFieldObject k),
    SmallExtension f →
    ∀ (pb : ArtinPullback f f),
      Function.Bijective (fiberComparison D pb)

/-- **H3**: The tangent space — value of `F` on an explicit tangent object
`tangentObj` — is a finite-dimensional `k`-module. The tangent object is a
parameter so that callers can pass `dualNumberObj k` (once an
`IsArtinianRing (DualNumber k)` instance is in scope) while H3 itself
stays agnostic to the Artinian hypothesis on the dual numbers. -/
def H3 (D : DeformationFunctor k)
    (tangentObj : ArtinLocalAlg k)
    [AddCommGroup (D.F.obj tangentObj)] [Module k (D.F.obj tangentObj)] :
    Prop :=
  Module.Finite k (D.F.obj tangentObj)

/-- **H4**: Bijectivity of the comparison map for all fiber products over
small extensions. H4 = H1 + injectivity; together with H1, H2, H3 this
is sufficient for pro-representability. -/
def H4 (D : DeformationFunctor k) : Prop :=
  ∀ {A B C : ArtinLocalAlg k} (f : A ⟶ C) (g : B ⟶ C),
    SmallExtension g →
    ∀ (pb : ArtinPullback f g),
      Function.Bijective (fiberComparison D pb)

/-- H4 implies H1. -/
theorem H4.imp_H1 {D : DeformationFunctor k} (h : H4 D) : H1 D :=
  fun f g hg pb => (h f g hg pb).2

/-- H2 implies H2'. -/
theorem H2.imp_H2' {D : DeformationFunctor k} (h : H2 D) : H2' D :=
  fun f hf pb => h f f hf hf pb

end MathlibExpansion.Roots.Schlessinger
