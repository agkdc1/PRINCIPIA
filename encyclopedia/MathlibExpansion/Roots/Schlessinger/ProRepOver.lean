import MathlibExpansion.Roots.Schlessinger.ProRepOverCore
import MathlibExpansion.Roots.Mazur1989.Schlessinger

/-!
# Pro-Representability over Λ

Schlessinger's pro-representability theorem stated on the `Λ`-parallel
category `ArtinLocalAlgOver Λ k`. The representing object is a complete
local Noetherian `Λ`-algebra with residue field `k`.

This file re-exports the core `Λ`-coefficient pro-representability
definitions from `ProRepOverCore.lean` and discharges the former
axiom `schlessinger_prorepresentable_over_residue` by routing to the
Chapter 3 theorem via `Roots.Mazur1989.Schlessinger`.
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-- **Schlessinger over Λ.**

If a `Λ`-coefficient deformation functor satisfies `H1Over`, `H2Over`,
`H3Over` (with tangent object `dualNumberObjOver Λ k`), and `H4Over`, then
it is pro-representable over `Λ`. -/
theorem schlessinger_prorepresentable_over_residue
    (D : DeformationFunctorOver.{u, u} Λ k)
    [AddCommGroup (D.F.obj (dualNumberObjOver Λ k))]
    [Module k (D.F.obj (dualNumberObjOver Λ k))]
    (h1 : H1Over D) (h2 : H2Over D)
    (h3 : H3Over D (dualNumberObjOver Λ k))
    (h4 : H4Over D) :
    IsProRepresentableOver D :=
  MathlibExpansion.Roots.Mazur1989.schlessinger_prorepresentable_over_residue_theorem
    D h1 h2 h3 h4

/-- Corollary: `H4Over` subsumes `H1Over`, so the three-hypothesis
interface suffices when `H4Over` is available. -/
theorem prorepresentable_of_H4_H2_H3
    (D : DeformationFunctorOver.{u, u} Λ k)
    [AddCommGroup (D.F.obj (dualNumberObjOver Λ k))]
    [Module k (D.F.obj (dualNumberObjOver Λ k))]
    (h4 : H4Over D) (h2 : H2Over D)
    (h3 : H3Over D (dualNumberObjOver Λ k)) :
    IsProRepresentableOver D :=
  MathlibExpansion.Roots.Mazur1989.prorepresentable_of_H4_H2_H3_theorem D h4 h2 h3

end MathlibExpansion.Roots.Schlessinger
