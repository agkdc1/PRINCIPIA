import MathlibExpansion.Textbooks.Schlessinger1968.Chapter3.HullConstruction

/-!
# Schlessinger's Pro-Representability Theorem (Textbooks presentation)

**Theorem** (Schlessinger 1968, Theorem 2.11): A deformation functor
`D : C_Λ(k) → Set` is pro-representable by a complete local Noetherian
`Λ`-algebra if and only if it satisfies conditions H1–H4.

## Hull construction (boundary)

The proof proceeds by:
1. **Existence of the hull**: Inductively construct the pro-representing
   object `R̂` as an inverse limit of successive small extensions
   `Rₙ₊₁ = Rₙ ×_{Rₙ/mₙ²} (Rₙ ⊕ T^∨)` where `T = D(k[ε])` is the
   tangent space.
2. **Universality**: Use the comparison maps (H1/H4) to show `Hom(R̂, −) → D`
   is bijective on all Artinian quotients.

The hull construction is the load-bearing step requiring the full
pro-Artinian machinery: formal Nakayama, lifting of small extensions, and
the adic topology on `R̂`. In this file it is proved from the upstream
chapter boundary axioms in `HullConstruction`.

## Axiom budget

- This file has no local axiom declarations.
- The remaining cited boundary is split upstream into hull existence
  (H1-H3) and H4 effectiveness in `HullConstruction`.
-/

namespace MathlibExpansion.Textbooks.Schlessinger1968.Chapter3

universe u

open MathlibExpansion.Roots.Schlessinger IsLocalRing

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-! ### The hull construction theorem -/

/-- **Hull Construction** (Schlessinger 1968, Theorem 2.11).

If a `Λ`-coefficient deformation functor `D` satisfies H1, H2, H3, and H4,
then `D` is pro-represented by a complete local Noetherian `Λ`-algebra.

**Proof sketch**: Construct the hull `R̂ = lim Rₙ` inductively by killing
successive generators of the cotangent space. Each step is a small extension
`Rₙ₊₁ → Rₙ` with kernel isomorphic to a copy of `T^∨ = Hom_k(D(k[ε]), k)`.
Condition H1 ensures lifts exist; H2 ensures they are unique; H4 ensures the
induced comparison `Hom(R̂, A) → D(A)` is bijective.

**Boundary**: The formal Nakayama argument and adic completeness of `lim Rₙ`
are factored into the cited upstream hull-existence and H4-effectiveness
axioms in `HullConstruction`. -/
theorem hull_construction
    (D : DeformationFunctorOver.{u, u} Λ k)
    [AddCommGroup (D.F.obj (dualNumberObjOver Λ k))]
    [Module k (D.F.obj (dualNumberObjOver Λ k))]
    (h1 : H1 D) (h2 : H2 D)
    (h3 : H3 D (dualNumberObjOver Λ k))
    (h4 : H4 D) :
    IsProRepresentableOver D :=
  prorepresentable_of_schlessinger_hull_H4 D
    (exists_schlessinger_hull_of_H1_H2_H3 D h1 h2 h3) h4

/-! ### Main theorem: H1 + H2 + H3 + H4 ⟹ pro-representable -/

/-- **Schlessinger's pro-representability theorem** (Λ-linear version).

A deformation functor over `Λ` satisfying conditions H1–H4 is
pro-representable by a complete local Noetherian `Λ`-algebra.

This is the definitive statement of Schlessinger (1968), Theorem 2.11,
in the `Λ`-coefficient setting of Mazur (1989). -/
theorem schlessinger_theorem
    (D : DeformationFunctorOver.{u, u} Λ k)
    [AddCommGroup (D.F.obj (dualNumberObjOver Λ k))]
    [Module k (D.F.obj (dualNumberObjOver Λ k))]
    (h1 : H1 D) (h2 : H2 D)
    (h3 : H3 D (dualNumberObjOver Λ k))
    (h4 : H4 D) :
    IsProRepresentableOver D :=
  hull_construction D h1 h2 h3 h4

/-- Corollary: H4 subsumes H1, so the three-condition interface suffices. -/
theorem schlessinger_of_H4_H2_H3
    (D : DeformationFunctorOver.{u, u} Λ k)
    [AddCommGroup (D.F.obj (dualNumberObjOver Λ k))]
    [Module k (D.F.obj (dualNumberObjOver Λ k))]
    (h4 : H4 D) (h2 : H2 D)
    (h3 : H3 D (dualNumberObjOver Λ k)) :
    IsProRepresentableOver D :=
  hull_construction D h4.imp_H1 h2 h3 h4

end MathlibExpansion.Textbooks.Schlessinger1968.Chapter3
