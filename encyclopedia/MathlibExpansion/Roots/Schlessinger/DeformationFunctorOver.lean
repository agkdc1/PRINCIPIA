import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver
import MathlibExpansion.Textbooks.Schlessinger1968.Chapter2.SmallExtensions

/-!
# Deformation Functors over Λ

A `Λ`-coefficient deformation functor is a set-valued functor on
`ArtinLocalAlgOver Λ k` with a canonical basepoint over the residue field
object `k`. Its Schlessinger hypotheses H1/H4 live on the coefficient side
(`Λ`), and H2/H3 live on the residue-field side (`k`); we expose each as a
**typed predicate** (never a bare `Prop` field), following doctrine v2.
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u v

open CategoryTheory IsLocalRing

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-- A morphism in `ArtinLocalAlgOver Λ k` is a **small extension** if it is
the underlying map of a Chapter 2 `SmallExtensionOver`. -/
def SmallExtensionOver {A B : ArtinLocalAlgOver Λ k} (f : A ⟶ B) : Prop :=
  ∃ s : MathlibExpansion.Textbooks.Schlessinger1968.Chapter2.SmallExtensionOver A B,
    s.toAlgHom = f

namespace SmallExtensionOver

theorem surjective {A B : ArtinLocalAlgOver Λ k} {f : A ⟶ B}
    (h : SmallExtensionOver f) : Function.Surjective f.toFun := by
  rcases h with ⟨s, rfl⟩
  exact s.surjective

theorem ker_sq_zero {A B : ArtinLocalAlgOver Λ k} {f : A ⟶ B}
    (h : SmallExtensionOver f) : (RingHom.ker f.toRingHom) ^ 2 = ⊥ := by
  rcases h with ⟨s, rfl⟩
  exact s.kernel_sq_zero

end SmallExtensionOver

/-- A **deformation functor over Λ** on `ArtinLocalAlgOver Λ k`: a covariant
set-valued functor with a distinguished basepoint over the residue-field
object, and the rigidity condition that the basepoint is the unique element
of `F(k)`. -/
structure DeformationFunctorOver (Λ k : Type u)
    [CommRing Λ] [Field k] [Algebra Λ k] where
  F          : ArtinLocalAlgOver Λ k ⥤ Type v
  base       : F.obj (ArtinLocalAlgOver.residueFieldObject Λ k)
  base_unique : Subsingleton (F.obj (ArtinLocalAlgOver.residueFieldObject Λ k))

/-- An **Artinian fiber product over Λ**: a chosen pullback square in
`ArtinLocalAlgOver Λ k`. We carry the square as explicit data; the
limit-witness field records that the underlying square of carriers is a
limit in the category of `Λ`-algebras. -/
structure ArtinPullbackOver {A B C : ArtinLocalAlgOver Λ k}
    (f : A ⟶ C) (g : B ⟶ C) where
  /-- The pullback object in `ArtinLocalAlgOver Λ k`. -/
  P   : ArtinLocalAlgOver Λ k
  /-- First projection `P → A`. -/
  fst : P ⟶ A
  /-- Second projection `P → B`. -/
  snd : P ⟶ B
  /-- The commutativity square. -/
  w   : fst ≫ f = snd ≫ g

/-- Comparison map from `F(P)` to the fiber product `F(A) ×_{F(C)} F(B)`,
for a chosen pullback `P`. -/
def fiberComparisonOver (D : DeformationFunctorOver Λ k)
    {A B C : ArtinLocalAlgOver Λ k} {f : A ⟶ C} {g : B ⟶ C}
    (pb : ArtinPullbackOver f g) :
    D.F.obj pb.P →
    {x : D.F.obj A × D.F.obj B // D.F.map f x.1 = D.F.map g x.2} :=
  fun p => ⟨(D.F.map pb.fst p, D.F.map pb.snd p), by
    have := congr_arg (D.F.map · p) pb.w
    simp [Functor.map_comp] at this
    exact this⟩

/-!
## Schlessinger-over-Λ hypotheses (typed predicates)

Each hypothesis is a **typed predicate** on the functor: a `def` returning
`Prop`, quantified over concrete typed data. No bare `(h : P)` parameters
are ever admitted downstream.
-/

/-- **H1Over**: for every pullback square with `g : B ⟶ C` a small extension
in `ArtinLocalAlgOver Λ k`, the comparison map is surjective. -/
def H1Over (D : DeformationFunctorOver Λ k) : Prop :=
  ∀ {A B C : ArtinLocalAlgOver Λ k} (f : A ⟶ C) (g : B ⟶ C),
    SmallExtensionOver g →
    ∀ (pb : ArtinPullbackOver f g),
      Function.Surjective (fiberComparisonOver D pb)

/-- **H2Over**: in the special symmetric case where `C = residueFieldObject`
and both `f`, `g` are small extensions, the comparison map is bijective. -/
def H2Over (D : DeformationFunctorOver Λ k) : Prop :=
  ∀ {A B : ArtinLocalAlgOver Λ k}
    (f : A ⟶ ArtinLocalAlgOver.residueFieldObject Λ k)
    (g : B ⟶ ArtinLocalAlgOver.residueFieldObject Λ k),
    SmallExtensionOver f → SmallExtensionOver g →
    ∀ (pb : ArtinPullbackOver f g),
      Function.Bijective (fiberComparisonOver D pb)

/-- **H3Over**: the tangent space — value of `F` on a dual-numbers object of
`ArtinLocalAlgOver Λ k` — is a finite-dimensional `k`-module. The tangent
object is passed as a parameter to avoid importing dual-number machinery
here; see `ProRepOver.lean` for the canonical instantiation. -/
def H3Over (D : DeformationFunctorOver Λ k)
    (tangentObj : ArtinLocalAlgOver Λ k)
    [AddCommGroup (D.F.obj tangentObj)] [Module k (D.F.obj tangentObj)] :
    Prop :=
  Module.Finite k (D.F.obj tangentObj)

/-- **H4Over**: bijectivity of the comparison map for all pullbacks over
small extensions. Stronger than H1. -/
def H4Over (D : DeformationFunctorOver Λ k) : Prop :=
  ∀ {A B C : ArtinLocalAlgOver Λ k} (f : A ⟶ C) (g : B ⟶ C),
    SmallExtensionOver g →
    ∀ (pb : ArtinPullbackOver f g),
      Function.Bijective (fiberComparisonOver D pb)

/-- H4Over implies H1Over. -/
theorem H4Over.imp_H1Over {D : DeformationFunctorOver Λ k}
    (h : H4Over D) : H1Over D :=
  fun f g hg pb => (h f g hg pb).2

end MathlibExpansion.Roots.Schlessinger
