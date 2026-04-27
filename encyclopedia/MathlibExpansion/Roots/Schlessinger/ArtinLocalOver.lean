import MathlibExpansion.Roots.Schlessinger.ArtinLocal

/-!
# Artinian Local Λ-Algebras (parallel substrate)

Bundled category `ArtinLocalAlgOver Λ k` of Artinian local `Λ`-algebras with
residue field canonically identified with `k`, together with a `Λ`-linear
augmentation. Sits in parallel to the existing `ArtinLocalAlg k`; morphisms
are `→ₐ[Λ]` (not `→ₐ[k]`).

This is the load-bearing Mazur replacement: Mazur 1989 operates over a
coefficient ring `Λ` (typically `W(k)` or `𝒪`) while the residue field stays
at `k`. The existing `ArtinLocalAlg k` category is `k`-linear end-to-end;
this file introduces the parallel `Λ`-linear category.
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u

open CategoryTheory IsLocalRing

/-- A bundled Artinian local `Λ`-algebra with a chosen identification of its
residue field with `k`. `Λ` is an auxiliary coefficient ring (no algebra
structure assumed between `Λ` and `k` at the type level — only that the
carrier is a `Λ`-algebra whose residue field is `k`). -/
structure ArtinLocalAlgOver (Λ k : Type u) [CommRing Λ] [Field k] where
  carrier     : Type u
  instCommRing  : CommRing carrier
  instAlgebra   : Algebra Λ carrier
  instIsArtinian : IsArtinianRing carrier
  instIsLocal   : IsLocalRing carrier
  residueEquiv  : IsLocalRing.ResidueField carrier ≃+* k

namespace ArtinLocalAlgOver

variable {Λ k : Type u} [CommRing Λ] [Field k]

attribute [instance] ArtinLocalAlgOver.instCommRing ArtinLocalAlgOver.instAlgebra
                     ArtinLocalAlgOver.instIsArtinian ArtinLocalAlgOver.instIsLocal

/-- Art_Λ (k-residue): morphisms are `Λ`-algebra homomorphisms between carriers.
Defined directly (not via `InducedCategory`) so that `f : A ⟶ B` is
definitionally `A.carrier →ₐ[Λ] B.carrier` in all downstream files. -/
noncomputable instance instCategory : Category (ArtinLocalAlgOver Λ k) where
  Hom A B := A.carrier →ₐ[Λ] B.carrier
  id A    := AlgHom.id Λ A.carrier
  comp {A B C} f g := g.comp f

/-- For a field, the maximal ideal is ⊥ (every nonzero element is a unit). -/
private lemma field_maximalIdeal_eq_bot (k : Type u) [Field k] :
    IsLocalRing.maximalIdeal k = ⊥ := by
  ext x
  simp only [IsLocalRing.mem_maximalIdeal, Submodule.mem_bot]
  exact ⟨fun h => by_contra fun hne => h (isUnit_iff_ne_zero.mpr hne),
         fun h => h ▸ not_isUnit_zero⟩

/-- `k` itself as the residue-field object of `ArtinLocalAlgOver Λ k`,
provided `k` is a `Λ`-algebra. The residue equivalence is the canonical
isomorphism `k ⧸ ⊥ ≃+* k`. -/
noncomputable def residueFieldObject
    (Λ k : Type u) [CommRing Λ] [Field k] [Algebra Λ k] :
    ArtinLocalAlgOver Λ k where
  carrier       := k
  instCommRing  := inferInstance
  instAlgebra   := inferInstance
  instIsArtinian := inferInstance
  instIsLocal   := inferInstance
  residueEquiv  := by
    -- ResidueField k = k ⧸ maximalIdeal k = k ⧸ ⊥ ≃+* k.
    have hmx : IsLocalRing.maximalIdeal k = ⊥ := field_maximalIdeal_eq_bot k
    refine RingEquiv.symm (RingEquiv.ofBijective
      ((Ideal.Quotient.mk (IsLocalRing.maximalIdeal k)).comp
        (RingHom.id k)) ⟨?_, ?_⟩)
    · -- Injective: a - b ∈ maximalIdeal = ⊥ → a = b
      intro a b h
      have hmem : a - b ∈ IsLocalRing.maximalIdeal k := Ideal.Quotient.eq.mp h
      rw [hmx, Submodule.mem_bot] at hmem
      exact sub_eq_zero.mp hmem
    · -- Surjective: quotient map is always surjective
      intro x
      obtain ⟨a, ha⟩ := Ideal.Quotient.mk_surjective x
      exact ⟨a, ha⟩

end ArtinLocalAlgOver

end MathlibExpansion.Roots.Schlessinger
