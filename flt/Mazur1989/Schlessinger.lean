import MathlibExpansion.Roots.Schlessinger.ProRepCore
import MathlibExpansion.Textbooks.Schlessinger1968.Chapter3.Prorepresentability

/-!
# Schlessinger 1968 — Mazur-Facing Bridge

This file routes both Schlessinger theorem surfaces through the textbook
Chapter 3 boundary axiom `hull_construction`:

- the `Λ`-coefficient surface `schlessinger_prorepresentable_over_residue`
- the original plain `Art_k` surface `schlessinger_prorepresentable`

The plain theorem is obtained by transporting deformation functors and
pro-representability witnesses across the now-aligned `Art_k` and
`ArtinLocalAlgOver k k` surfaces.
-/

namespace MathlibExpansion.Roots.Mazur1989

open MathlibExpansion.Roots.Schlessinger
open MathlibExpansion.Textbooks.Schlessinger1968.Chapter3

universe u

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-! ### Λ-general pro-representability -/

/-- **Theorem** (formerly `axiom schlessinger_prorepresentable_over_residue`).

A `Λ`-coefficient deformation functor satisfying H1–H4 is pro-representable
by a complete local Noetherian `Λ`-algebra. -/
theorem schlessinger_prorepresentable_over_residue_theorem
    (D : DeformationFunctorOver.{u, u} Λ k)
    [AddCommGroup (D.F.obj (dualNumberObjOver Λ k))]
    [Module k (D.F.obj (dualNumberObjOver Λ k))]
    (h1 : H1Over D) (h2 : H2Over D)
    (h3 : H3Over D (dualNumberObjOver Λ k))
    (h4 : H4Over D) :
    IsProRepresentableOver D :=
  schlessinger_theorem D h1 h2 h3 h4

/-- Corollary: H4 subsumes H1 — three-condition interface. -/
theorem prorepresentable_of_H4_H2_H3_theorem
    (D : DeformationFunctorOver.{u, u} Λ k)
    [AddCommGroup (D.F.obj (dualNumberObjOver Λ k))]
    [Module k (D.F.obj (dualNumberObjOver Λ k))]
    (h4 : H4Over D) (h2 : H2Over D)
    (h3 : H3Over D (dualNumberObjOver Λ k)) :
    IsProRepresentableOver D :=
  schlessinger_of_H4_H2_H3 D h4 h2 h3

/-! ### `Λ := k` over-surface specialisation -/

/-- **Theorem** (`Λ = k` specialisation on the over-surface). -/
theorem schlessinger_prorepresentable_k_theorem
    {k : Type u} [Field k]
    (D : DeformationFunctorOver.{u, u} k k)
    [AddCommGroup (D.F.obj (dualNumberObjOver k k))]
    [Module k (D.F.obj (dualNumberObjOver k k))]
    (h1 : H1Over D) (h2 : H2Over D)
    (h3 : H3Over D (dualNumberObjOver k k))
    (h4 : H4Over D) :
    IsProRepresentableOver D :=
  schlessinger_theorem D h1 h2 h3 h4

/-! ### Plain `Art_k` bridge -/

section PlainSurface

variable {k : Type u} [Field k]

namespace ArtinLocalAlg

/-- Forget the plain `Art_k` object to the `Λ := k` over-surface. -/
noncomputable def toOver (A : ArtinLocalAlg k) : ArtinLocalAlgOver k k where
  carrier := A.carrier
  instCommRing := A.instCommRing
  instAlgebra := A.instAlgebra
  instIsArtinian := A.instIsArtinian
  instIsLocal := A.instIsLocal
  residueEquiv := A.residueEquiv

end ArtinLocalAlg

namespace ArtinLocalAlgOver

/-- View a `Λ := k` over-surface object on the plain `Art_k` surface. -/
noncomputable def toPlain (A : ArtinLocalAlgOver k k) : ArtinLocalAlg k where
  carrier := A.carrier
  instCommRing := A.instCommRing
  instAlgebra := A.instAlgebra
  instIsArtinian := A.instIsArtinian
  instIsLocal := A.instIsLocal
  residueEquiv := A.residueEquiv

end ArtinLocalAlgOver

noncomputable def overToPlainFunctor :
    CategoryTheory.Functor (ArtinLocalAlgOver k k) (ArtinLocalAlg k) :=
  { obj := fun A => ArtinLocalAlgOver.toPlain A
    map := fun {A B} f => f
    map_id := by
      intro A
      rfl
    map_comp := by
      intro A B C f g
      rfl }

noncomputable def plainToOverFunctor :
    CategoryTheory.Functor (ArtinLocalAlg k) (ArtinLocalAlgOver k k) :=
  { obj := fun A => ArtinLocalAlg.toOver A
    map := fun {A B} f => f
    map_id := by
      intro A
      rfl
    map_comp := by
      intro A B C f g
      rfl }

namespace CompleteLocalNoetherianAlg

/-- Forget the plain complete local `k`-algebra to the `Λ := k` over-surface. -/
noncomputable def toOver (R : CompleteLocalNoetherianAlg k) :
    CompleteLocalNoetherianAlgOver k k where
  carrier := R.carrier
  instCommRing := R.instCommRing
  instAlgebra := R.instAlgebra
  instIsLocal := R.instIsLocal
  instIsNoeth := R.instIsNoeth
  isAdicComplete := R.isAdicComplete
  residueEquiv := R.residueEquiv

end CompleteLocalNoetherianAlg

namespace CompleteLocalNoetherianAlgOver

/-- View a `Λ := k` complete local Noetherian algebra on the plain surface. -/
noncomputable def toPlain (R : CompleteLocalNoetherianAlgOver k k) :
    CompleteLocalNoetherianAlg k where
  carrier := R.carrier
  instCommRing := R.instCommRing
  instAlgebra := R.instAlgebra
  instIsLocal := R.instIsLocal
  instIsNoeth := R.instIsNoeth
  isAdicComplete := R.isAdicComplete
  residueEquiv := R.residueEquiv

end CompleteLocalNoetherianAlgOver

namespace ArtinPullbackOver

/-- A pullback square on the `Λ := k` over-surface viewed in `Art_k`. -/
noncomputable def toPlain {A B C : ArtinLocalAlgOver k k} {f : A ⟶ C} {g : B ⟶ C}
    (pb : ArtinPullbackOver f g) :
    ArtinPullback
      (show ArtinLocalAlgOver.toPlain A ⟶ ArtinLocalAlgOver.toPlain C from f)
      (show ArtinLocalAlgOver.toPlain B ⟶ ArtinLocalAlgOver.toPlain C from g) where
  P := ArtinLocalAlgOver.toPlain pb.P
  fst := pb.fst
  snd := pb.snd
  w := pb.w

end ArtinPullbackOver

namespace DeformationFunctor

/-- Reinterpret a plain deformation functor on the `Λ := k` over-surface. -/
noncomputable def toOver (D : DeformationFunctor k) : DeformationFunctorOver k k where
  F := CategoryTheory.Functor.comp overToPlainFunctor D.F
  base := by
    simpa [overToPlainFunctor, ArtinLocalAlgOver.toPlain, ArtinLocalAlg.residueFieldObject]
      using D.base
  base_unique := by
    simpa [overToPlainFunctor, ArtinLocalAlgOver.toPlain, ArtinLocalAlg.residueFieldObject]
      using D.base_unique

end DeformationFunctor

private theorem smallExtensionOver_toPlain
    {A B : ArtinLocalAlgOver k k} {f : A ⟶ B}
    (h : MathlibExpansion.Roots.Schlessinger.SmallExtensionOver f) :
    SmallExtension
      (show ArtinLocalAlgOver.toPlain A ⟶ ArtinLocalAlgOver.toPlain B from f) := by
  rcases h with ⟨s, rfl⟩
  exact ⟨s.surj, s.ker_sqZero, by
    simpa [MathlibExpansion.Roots.Schlessinger.artinKer,
      MathlibExpansion.Textbooks.Schlessinger1968.Chapter2.algHomKer] using s.ker_rank_one⟩

private theorem smallExtension_toOver
    {A B : ArtinLocalAlg k} {f : A ⟶ B}
    (h : SmallExtension f) :
    MathlibExpansion.Roots.Schlessinger.SmallExtensionOver
      (show ArtinLocalAlg.toOver A ⟶ ArtinLocalAlg.toOver B from f) := by
  refine ⟨{ toAlgHom := f, surj := h.1, ker_sqZero := h.2.1, ker_rank_one := ?_ }, rfl⟩
  simpa [MathlibExpansion.Roots.Schlessinger.artinKer,
    MathlibExpansion.Textbooks.Schlessinger1968.Chapter2.algHomKer] using h.2.2

private theorem dualNumberObjOver_toPlain_eq (k : Type u) [Field k]
    [IsArtinianRing (DualNumber k)] :
    ArtinLocalAlgOver.toPlain (dualNumberObjOver k k) = dualNumberObj k := by
  rfl

private theorem H1_toOver {D : DeformationFunctor k}
    (h1 : H1 D) : H1Over (DeformationFunctor.toOver D) := by
  intro A B C f g hg pb
  simpa [DeformationFunctor.toOver, fiberComparisonOver, fiberComparison]
    using h1
      (show ArtinLocalAlgOver.toPlain A ⟶ ArtinLocalAlgOver.toPlain C from f)
      (show ArtinLocalAlgOver.toPlain B ⟶ ArtinLocalAlgOver.toPlain C from g)
      (smallExtensionOver_toPlain hg) (ArtinPullbackOver.toPlain pb)

private theorem H2_toOver {D : DeformationFunctor k}
    (h2 : H2 D) : H2Over (DeformationFunctor.toOver D) := by
  intro A B f g hf hg pb
  simpa [DeformationFunctor.toOver, fiberComparisonOver, fiberComparison]
    using h2
      (show ArtinLocalAlgOver.toPlain A ⟶ ArtinLocalAlg.residueFieldObject k from f)
      (show ArtinLocalAlgOver.toPlain B ⟶ ArtinLocalAlg.residueFieldObject k from g)
      (smallExtensionOver_toPlain hf) (smallExtensionOver_toPlain hg)
      (ArtinPullbackOver.toPlain pb)

private theorem H4_toOver {D : DeformationFunctor k}
    (h4 : H4 D) : H4Over (DeformationFunctor.toOver D) := by
  intro A B C f g hg pb
  simpa [DeformationFunctor.toOver, fiberComparisonOver, fiberComparison]
    using h4
      (show ArtinLocalAlgOver.toPlain A ⟶ ArtinLocalAlgOver.toPlain C from f)
      (show ArtinLocalAlgOver.toPlain B ⟶ ArtinLocalAlgOver.toPlain C from g)
      (smallExtensionOver_toPlain hg) (ArtinPullbackOver.toPlain pb)

private theorem isProRepresentableOver_toPlain {D : DeformationFunctor k}
    (h : IsProRepresentableOver (DeformationFunctor.toOver D)) :
    IsProRepresentable D := by
  rcases h with ⟨R, η, hη⟩
  refine ⟨CompleteLocalNoetherianAlgOver.toPlain R, ?_⟩
  let ηPlain : HomFunctor (CompleteLocalNoetherianAlgOver.toPlain R) ⟶ D.F :=
    { app := fun A =>
        show (HomFunctor (CompleteLocalNoetherianAlgOver.toPlain R)).obj A → D.F.obj A from
          η.app (ArtinLocalAlg.toOver A)
      naturality := by
        intro A B f
        simpa [HomFunctor, HomFunctorOver, DeformationFunctor.toOver] using
          η.naturality (show ArtinLocalAlg.toOver A ⟶ ArtinLocalAlg.toOver B from f) }
  refine ⟨ηPlain, ?_⟩
  intro A
  simpa [ηPlain, HomFunctor, HomFunctorOver, DeformationFunctor.toOver] using
    hη (ArtinLocalAlg.toOver A)

/-- **Theorem** (formerly `axiom schlessinger_prorepresentable`). -/
theorem schlessinger_prorepresentable_theorem
    (D : DeformationFunctor k)
    [IsArtinianRing (DualNumber k)]
    [AddCommGroup (D.F.obj (dualNumberObj k))]
    [Module k (D.F.obj (dualNumberObj k))]
    (h1 : H1 D) (h2 : H2 D)
    (h3 : H3 D (dualNumberObj k))
    (h4 : H4 D) :
    IsProRepresentable D := by
  letI : AddCommGroup ((DeformationFunctor.toOver D).F.obj (dualNumberObjOver k k)) := by
    simpa [DeformationFunctor.toOver, dualNumberObjOver_toPlain_eq]
      using (inferInstance : AddCommGroup (D.F.obj (dualNumberObj k)))
  letI : Module k ((DeformationFunctor.toOver D).F.obj (dualNumberObjOver k k)) := by
    simpa [DeformationFunctor.toOver, dualNumberObjOver_toPlain_eq]
      using (inferInstance : Module k (D.F.obj (dualNumberObj k)))
  exact isProRepresentableOver_toPlain <|
    schlessinger_prorepresentable_k_theorem (DeformationFunctor.toOver D)
      (H1_toOver h1) (H2_toOver h2)
      (by
        simpa [DeformationFunctor.toOver, dualNumberObjOver_toPlain_eq] using h3)
      (H4_toOver h4)

end PlainSurface

end MathlibExpansion.Roots.Mazur1989
