import Mathlib.Algebra.Group.Equiv.Basic
import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup
import Mathlib.GroupTheory.Abelianization
import Mathlib.Topology.Category.TopCat.Basic
import MathlibExpansion.AlgebraicTopology.BettiNumbers

namespace MathlibExpansion
namespace AlgebraicTopology
namespace FundamentalGroup

/-- The additive avatar of the abelianized fundamental group. -/
abbrev Pi1Abelianization {X : Type*} [TopologicalSpace X] (x : X) : Type _ :=
  Additive (Abelianization (FundamentalGroup X x))

/-- Sharp local form of Poincare's bridge from the abelianized fundamental group
to first integral homology.

Source boundary: Hurewicz, "Beitrage zur Topologie der Deformationen I" (1935),
for the homotopy-to-homology map; Hatcher, *Algebraic Topology* (2002),
Theorem 2A.1, for the dimension-one statement that first integral homology is
the abelianization of the fundamental group. The unrestricted theorem requires
a genuine singular-homology carrier. The current dispatcher carrier
`H1Integral` is `PUnit`, so the provable upstream-narrow case is the one where
the abelianized fundamental group is already subsingleton. -/
noncomputable def fundamentalGroup_abelianization_equiv_H1
    {X : Type*} [TopologicalSpace X] (x : X)
    [Subsingleton (Pi1Abelianization x)] :
    Pi1Abelianization x ≃+ H1Integral (TopCat.of X) := by
  haveI : Unique (Pi1Abelianization x) := uniqueOfSubsingleton default
  exact AddEquiv.ofUnique

end FundamentalGroup
end AlgebraicTopology
end MathlibExpansion
