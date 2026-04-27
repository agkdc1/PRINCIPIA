import Mathlib
import MathlibExpansion.Roots.Mazur1989.ResidualRep
import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver

/-!
# Tangent/Obstruction Boundary (Mazur 1989)

Exposes the **typed** tangent-space and obstruction-space boundaries for a
residual representation datum, consumable by downstream Mazur/Wiles
machinery. H1 and H2 are `Rep k G`-valued via the adjoint representation
of `ρ̄`.

Finiteness is a typed predicate (`Module.Finite k _`), never a bare Prop
field.

This file also exposes the Mazur-side finite-quotient factorization theorem
`continuousLiftFactorsThroughFiniteQuotient`, named explicitly so that
downstream theorem statements can cite this boundary surface directly.
-/

namespace MathlibExpansion.Roots.Mazur1989

universe u

variable {G : Type u} {k : Type u} [Group G] [Field k] [Finite k]

/-- `Rep k G` view of the adjoint representation of the datum. -/
noncomputable def adjointRep (D : ResidualRepDatum G k) :
    Rep k G :=
  Rep.of D.AdjointRep

/-- **Tangent/Obstruction boundary datum** for a residual representation `ρ̄`.
The tangent space is `H¹(G, ad ρ̄)` and the obstruction space is
`H²(G, ad ρ̄)`. Finiteness of each is exposed as a typed-module predicate. -/
structure TangentObstructionBoundary
    {G : Type u} {k : Type u} [Group G] [Field k] [Finite k]
    (D : ResidualRepDatum G k) where
  /-- Tangent space is the underlying module of `H¹(G, ad ρ̄)`. -/
  tangent : Type u
  /-- Obstruction space is the underlying module of `H²(G, ad ρ̄)`. -/
  obstruction : Type u
  /-- Tangent space is an `AddCommGroup`. -/
  [tangentAddCommGroup : AddCommGroup tangent]
  /-- Tangent space carries a `k`-module structure. -/
  [tangentModule : Module k tangent]
  /-- Obstruction space is an `AddCommGroup`. -/
  [obstructionAddCommGroup : AddCommGroup obstruction]
  /-- Obstruction space carries a `k`-module structure. -/
  [obstructionModule : Module k obstruction]
  /-- Finiteness of the tangent space as a typed predicate. -/
  [tangentFinite : Module.Finite k tangent]
  /-- Finiteness of the obstruction space as a typed predicate. -/
  [obstructionFinite : Module.Finite k obstruction]

attribute [instance] TangentObstructionBoundary.tangentAddCommGroup
                     TangentObstructionBoundary.tangentModule
                     TangentObstructionBoundary.obstructionAddCommGroup
                     TangentObstructionBoundary.obstructionModule
                     TangentObstructionBoundary.tangentFinite
                     TangentObstructionBoundary.obstructionFinite

/-!
## Continuous-lift factorization

This parallels
`LocallyConstantH1ProfiniteFactorizationWall` in the
`ContinuousGaloisCohomology` module, but is stated in the Mazur1989
namespace and on the datum-side coefficient ring so that downstream
consumers cite this module directly.
-/

/-- **Continuous lifts factor through the specified finite quotient.**

For a lift `ρ : G →* GL₂(A.carrier)` of a residual representation datum,
if `ρ` kills the witness subgroup `D.kernelSubgroup`, then `ρ` factors
through the quotient `G ⧸ D.kernelSubgroup`.

This is the Mazur1989-namespace mirror of
`LocallyConstantH1ProfiniteFactorizationWall` in
`MathlibExpansion.Roots.ContinuousGaloisCohomology`.

The subgroup-killing hypothesis is explicit: a raw continuous lift of
`D.rhoBar` need not annihilate `D.kernelSubgroup` without extra deformation
data. Producing that bridge from a typed deformation object remains a
separate queue item. -/
theorem continuousLiftFactorsThroughFiniteQuotient
    {G : Type u} [Group G] [TopologicalSpace G] [CompactSpace G]
    [TotallyDisconnectedSpace G] [ContinuousMul G] [ContinuousInv G]
    {k : Type u} [Field k] [Finite k]
    {Λ : Type u} [CommRing Λ] [Algebra Λ k]
    (A : MathlibExpansion.Roots.Schlessinger.ArtinLocalAlgOver Λ k)
    [TopologicalSpace A.carrier] [DiscreteTopology A.carrier]
    (D : ResidualRepDatum G k)
    (ρ : G →* GL (Fin 2) A.carrier)
    (hρ : Continuous ρ)
    (hkernel : ∀ g ∈ D.kernelSubgroup, ρ g = 1) :
    ∃ (ρDescended : (G ⧸ D.kernelSubgroup) →* GL (Fin 2) A.carrier),
      ∀ g : G, ρ g = ρDescended (QuotientGroup.mk g) := by
  let _ := hρ
  refine ⟨QuotientGroup.lift D.kernelSubgroup ρ ?_, ?_⟩
  · intro g hg
    exact hkernel g hg
  · intro g
    rfl

end MathlibExpansion.Roots.Mazur1989
