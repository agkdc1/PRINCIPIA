import Mathlib
import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver
import MathlibExpansion.Textbooks.Schlessinger1968.Chapter2.SmallExtensions

/-!
# Fiber Products in C_Λ(k)

The **fiber product** (pullback) of two `Λ`-algebra maps `f : A → C` and
`g : B → C` in `ArtinLocalAlgOver Λ k` is the subalgebra
`{(a, b) ∈ A × B | f(a) = g(b)}`.

When `g` is a surjective local hom (e.g., a small extension), the fiber
product is again Artinian local, completing the category under pullbacks along
small extensions — the key ingredient for Schlessinger's hull construction.
-/

namespace MathlibExpansion.Textbooks.Schlessinger1968.Chapter2

universe u

open MathlibExpansion.Roots.Schlessinger IsLocalRing

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-! ### Algebraic fiber product -/

/-- The fiber product of `f : A → C` and `g : B → C` as a `Λ`-subalgebra
of `A × B`. -/
def fpSubalgebra {A B C : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] C.carrier) (g : B.carrier →ₐ[Λ] C.carrier) :
    Subalgebra Λ (A.carrier × B.carrier) where
  carrier   := {p | f p.1 = g p.2}
  add_mem' {p q} hp hq := by
    simp only [Set.mem_setOf_eq] at hp hq ⊢
    simp only [Prod.fst_add, Prod.snd_add, map_add, hp, hq]
  zero_mem' := by simp
  mul_mem' {p q} hp hq := by
    simp only [Set.mem_setOf_eq] at hp hq ⊢
    simp only [Prod.fst_mul, Prod.snd_mul, map_mul, hp, hq]
  one_mem' := by simp
  algebraMap_mem' r := by
    simp only [Set.mem_setOf_eq]
    simp [AlgHom.commutes]

/-- The fiber product carrier type: `{(a, b) ∈ A × B | f(a) = g(b)}`. -/
abbrev FPCarrier {A B C : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] C.carrier) (g : B.carrier →ₐ[Λ] C.carrier) : Type u :=
  ↥(fpSubalgebra f g)

/-! ### Projections -/

/-- First projection `FPCarrier f g → A.carrier`. -/
def fpFst {A B C : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] C.carrier) (g : B.carrier →ₐ[Λ] C.carrier) :
    FPCarrier f g →ₐ[Λ] A.carrier :=
  AlgHom.comp (AlgHom.fst Λ A.carrier B.carrier) (Subalgebra.val _)

/-- Second projection `FPCarrier f g → B.carrier`. -/
def fpSnd {A B C : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] C.carrier) (g : B.carrier →ₐ[Λ] C.carrier) :
    FPCarrier f g →ₐ[Λ] B.carrier :=
  AlgHom.comp (AlgHom.snd Λ A.carrier B.carrier) (Subalgebra.val _)

/-- The fiber product square commutes: `f ∘ fpFst = g ∘ fpSnd`. -/
theorem fp_comm {A B C : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] C.carrier) (g : B.carrier →ₐ[Λ] C.carrier) :
    f.comp (fpFst f g) = g.comp (fpSnd f g) := by
  ext ⟨⟨a, b⟩, hab⟩; exact hab

/-! ### Universal property -/

/-- Universal property: a pair of maps to `A` and `B` agreeing on `C`
factors uniquely through the fiber product. -/
def fpLift {A B C D : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] C.carrier) (g : B.carrier →ₐ[Λ] C.carrier)
    (α : D.carrier →ₐ[Λ] A.carrier) (β : D.carrier →ₐ[Λ] B.carrier)
    (h : f.comp α = g.comp β) :
    D.carrier →ₐ[Λ] FPCarrier f g :=
  { toFun    := fun d => ⟨(α d, β d), AlgHom.congr_fun h d⟩
    map_one'  := Subtype.ext (Prod.ext (map_one α) (map_one β))
    map_mul'  := fun d₁ d₂ => Subtype.ext (Prod.ext (map_mul α d₁ d₂) (map_mul β d₁ d₂))
    map_zero' := Subtype.ext (Prod.ext (map_zero α) (map_zero β))
    map_add'  := fun d₁ d₂ => Subtype.ext (Prod.ext (map_add α d₁ d₂) (map_add β d₁ d₂))
    commutes' := fun r => Subtype.ext (Prod.ext (α.commutes r) (β.commutes r)) }

/-! ### Local ring structure -/

/-- When `g` is surjective, `fpFst` is surjective. -/
theorem fpFst_surjective {A B C : ArtinLocalAlgOver Λ k}
    {f : A.carrier →ₐ[Λ] C.carrier} {g : B.carrier →ₐ[Λ] C.carrier}
    (hg : Function.Surjective g.toFun) :
    Function.Surjective (fpFst f g).toFun := by
  intro a
  obtain ⟨b, hb⟩ := hg (f a)
  exact ⟨⟨(a, b), hb.symm⟩, rfl⟩

/-- Units in `FPCarrier f g` correspond to units in the first component. -/
theorem fp_isUnit_iff {A B C : ArtinLocalAlgOver Λ k}
    {f : A.carrier →ₐ[Λ] C.carrier} {g : B.carrier →ₐ[Λ] C.carrier}
    [IsLocalHom g.toRingHom]
    {p : FPCarrier f g} :
    IsUnit p ↔ IsUnit p.1.1 := by
  constructor
  · intro hu
    exact hu.map (fpFst f g).toRingHom
  · intro ha
    have hab : f p.1.1 = g p.1.2 := p.2
    have hb : IsUnit p.1.2 := by
      have h : IsUnit (f p.1.1) := ha.map f.toRingHom
      rw [hab] at h
      -- Ascribe to RingHom form so map_nonunit can synthesize IsLocalHom g.toRingHom
      have h' : IsUnit (g.toRingHom p.1.2) := h
      exact IsLocalHom.map_nonunit p.1.2 h'
    obtain ⟨ua, hua⟩ := ha
    obtain ⟨ub, hub⟩ := hb
    have hfu : f ↑ua = g ↑ub := by rw [hua, hub]; exact hab
    have hinv_mem : f (↑ua⁻¹ : A.carrier) = g (↑ub⁻¹ : B.carrier) := by
      have hfu_unit : IsUnit (f ↑ua) := ua.isUnit.map f.toRingHom
      have h1 : f ↑ua * f (↑ua⁻¹ : A.carrier) = 1 :=
        calc f ↑ua * f (↑ua⁻¹ : A.carrier)
            = f ((↑ua : A.carrier) * ↑ua⁻¹) := (map_mul f _ _).symm
          _ = f 1 := by rw [Units.mul_inv]
          _ = 1   := map_one f
      have h2 : g ↑ub * g (↑ub⁻¹ : B.carrier) = 1 :=
        calc g ↑ub * g (↑ub⁻¹ : B.carrier)
            = g ((↑ub : B.carrier) * ↑ub⁻¹) := (map_mul g _ _).symm
          _ = g 1 := by rw [Units.mul_inv]
          _ = 1   := map_one g
      exact hfu_unit.mul_left_cancel (h1.trans (by rw [hfu]; exact h2.symm))
    exact ⟨⟨⟨(↑ua, ↑ub), by rw [hua, hub]; exact hab⟩,
            ⟨(↑ua⁻¹, ↑ub⁻¹), hinv_mem⟩,
            Subtype.ext (Prod.ext (Units.mul_inv ua) (Units.mul_inv ub)),
            Subtype.ext (Prod.ext (Units.inv_mul ua) (Units.inv_mul ub))⟩,
           Subtype.ext (Prod.ext hua hub)⟩

instance fpCarrier_nontrivial {A B C : ArtinLocalAlgOver Λ k}
    {f : A.carrier →ₐ[Λ] C.carrier} {g : B.carrier →ₐ[Λ] C.carrier} :
    Nontrivial (FPCarrier f g) :=
  ⟨1, 0, fun h => one_ne_zero (congr_arg (fun x => x.1.1) h)⟩

/-- The fiber product of Artinian local `Λ`-algebras along a local hom is
again a local ring. -/
instance fpCarrier_isLocalRing {A B C : ArtinLocalAlgOver Λ k}
    {f : A.carrier →ₐ[Λ] C.carrier} {g : B.carrier →ₐ[Λ] C.carrier}
    [IsLocalHom g.toRingHom] :
    IsLocalRing (FPCarrier f g) where
  isUnit_or_isUnit_of_add_one := fun {a b} hab => by
    have h : a.1.1 + b.1.1 = 1 :=
      calc a.1.1 + b.1.1 = (a + b).1.1 := rfl
        _ = (1 : FPCarrier f g).1.1 := by rw [hab]
        _ = 1 := rfl
    rcases IsLocalRing.isUnit_or_isUnit_of_add_one h with h' | h'
    · exact Or.inl (fp_isUnit_iff.mpr h')
    · exact Or.inr (fp_isUnit_iff.mpr h')

/-! ### Artinian structure -/

private noncomputable def fpLinearMap {A B C : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] C.carrier) (g : B.carrier →ₐ[Λ] C.carrier) :
    FPCarrier f g →ₗ[Λ] A.carrier × B.carrier :=
  (Subalgebra.val (fpSubalgebra f g)).toLinearMap

private theorem fpLinearMap_injective {A B C : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] C.carrier) (g : B.carrier →ₐ[Λ] C.carrier) :
    Function.Injective (fpLinearMap f g) :=
  Subtype.val_injective

/-- `FPCarrier f g` is Artinian as a `Λ`-module.
Boundary: `IsArtinianRing A.carrier` does not automatically give
`IsArtinian Λ A.carrier` without a `Module.Finite Λ A.carrier` hypothesis.
Accepted as sorry pending enrichment of `ArtinLocalAlgOver` with finiteness. -/
instance fpCarrier_isArtinian_mod {A B C : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] C.carrier) (g : B.carrier →ₐ[Λ] C.carrier) :
    IsArtinian Λ (FPCarrier f g) := by
  sorry

/-- `FPCarrier f g` is an Artinian ring.
Accepted as sorry pending tower lemma resolution. -/
instance fpCarrier_isArtinianRing {A B C : ArtinLocalAlgOver Λ k}
    (f : A.carrier →ₐ[Λ] C.carrier) (g : B.carrier →ₐ[Λ] C.carrier) :
    IsArtinianRing (FPCarrier f g) := by
  sorry

end MathlibExpansion.Textbooks.Schlessinger1968.Chapter2
