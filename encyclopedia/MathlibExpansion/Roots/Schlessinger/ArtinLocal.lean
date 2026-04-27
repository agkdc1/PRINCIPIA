import Mathlib

/-!
# Artinian Local k-Algebras

Bundled category Art_k of Artinian local k-algebras with residue field
identified with k. This is the test category for Schlessinger deformation
functors in Mazur–Wiles deformation theory.

R9-04 confirmed: `HasPullbacks (AlgebraCat k)` via inferInstance.
R9-02 confirmed: `IsLocalRing.ResidueField`, `.algebra`, `.mapEquiv` exist.
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u

open CategoryTheory IsLocalRing

/-- A bundled Artinian local k-algebra with a chosen identification of its
residue field with k. This is the object type of the category Art_k used
in Schlessinger's deformation theory. -/
structure ArtinLocalAlg (k : Type u) [Field k] where
  carrier     : Type u
  instCommRing  : CommRing carrier
  instAlgebra   : Algebra k carrier
  instIsArtinian : IsArtinianRing carrier
  instIsLocal   : IsLocalRing carrier
  residueEquiv  : IsLocalRing.ResidueField carrier ≃+* k

namespace ArtinLocalAlg

variable {k : Type u} [Field k]

attribute [instance] ArtinLocalAlg.instCommRing ArtinLocalAlg.instAlgebra
                     ArtinLocalAlg.instIsArtinian ArtinLocalAlg.instIsLocal

/-- Underlying object in AlgebraCat k. -/
noncomputable def toAlgCatObj (A : ArtinLocalAlg k) : AlgebraCat k :=
  AlgebraCat.of k A.carrier

/-- Art_k: morphisms are k-algebra homomorphisms between carriers.
Defined directly (not via InducedCategory) so that `f : A ⟶ B` is
definitionally `A.carrier →ₐ[k] B.carrier` in all downstream files. -/
noncomputable instance instCategory : Category (ArtinLocalAlg k) where
  Hom A B := A.carrier →ₐ[k] B.carrier
  id A    := AlgHom.id k A.carrier
  comp {A B C} f g := g.comp f

/-- Forgetful functor Art_k ⥤ AlgebraCat k. -/
noncomputable def toAlgebraCat : ArtinLocalAlg k ⥤ AlgebraCat k where
  obj A          := AlgebraCat.of k A.carrier
  map {A B} f    := AlgebraCat.ofHom f
  map_id A       := rfl
  map_comp f g   := rfl

/-- For a field, the maximal ideal is ⊥ (every nonzero element is a unit). -/
private lemma field_maximalIdeal_eq_bot (k : Type u) [Field k] :
    IsLocalRing.maximalIdeal k = ⊥ := by
  ext x
  simp only [IsLocalRing.mem_maximalIdeal, Submodule.mem_bot]
  exact ⟨fun h => by_contra fun hne => h (isUnit_iff_ne_zero.mpr hne),
         fun h => h ▸ not_isUnit_zero⟩

/-- k itself as the residue-field object in Art_k. The residue
equivalence is the canonical isomorphism k ⧸ ⊥ ≃+* k. -/
noncomputable def residueFieldObject (k : Type u) [Field k] : ArtinLocalAlg k where
  carrier       := k
  instCommRing  := inferInstance
  instAlgebra   := inferInstance
  instIsArtinian := inferInstance
  instIsLocal   := inferInstance
  residueEquiv  := by
    -- Build ResidueField k ≃ₐ[k] k as the symm of AlgEquiv.ofBijective on the quotient map.
    -- mkₐ k I : k →ₐ[k] k ⧸ maximalIdeal k = ResidueField k is bijective:
    --   injective because ker = maximalIdeal = ⊥ (field), surjective always.
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

end ArtinLocalAlg

end MathlibExpansion.Roots.Schlessinger
