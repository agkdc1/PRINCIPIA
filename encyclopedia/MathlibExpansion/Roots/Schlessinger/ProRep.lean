import MathlibExpansion.Roots.Schlessinger.ProRepCore
import MathlibExpansion.Roots.Mazur1989.Schlessinger

/-!
# Pro-Representability for Deformation Functors

Schlessinger's pro-representability theorem on the original `Art_k`
surface. This file re-exports the core representing-object API from
`ProRepCore.lean` and routes the former boundary axiom through the
Mazur / Chapter 3 bridge.
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u

variable {k : Type u} [Field k]

/-- **Schlessinger's pro-representability theorem** on `Art_k`.

If a deformation functor `D` satisfies `H1`, `H2`, `H3`, and `H4`, then it is
pro-representable by a complete local Noetherian `k`-algebra. -/
theorem schlessinger_prorepresentable
    [IsArtinianRing (DualNumber k)]
    (D : DeformationFunctor k)
    [AddCommGroup (D.F.obj (dualNumberObj k))]
    [Module k (D.F.obj (dualNumberObj k))]
    (h1 : H1 D) (h2 : H2 D) (h3 : H3 D (dualNumberObj k)) (h4 : H4 D) :
    IsProRepresentable D :=
  MathlibExpansion.Roots.Mazur1989.schlessinger_prorepresentable_theorem D h1 h2 h3 h4

end MathlibExpansion.Roots.Schlessinger
