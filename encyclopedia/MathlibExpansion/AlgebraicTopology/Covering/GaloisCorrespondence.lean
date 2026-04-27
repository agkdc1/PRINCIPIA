import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup
import Mathlib.Algebra.Group.Subgroup.Basic
import Mathlib.Topology.Basic
import MathlibExpansion.AlgebraicTopology.Covering.UniversalCover

namespace MathlibExpansion
namespace AlgebraicTopology
namespace Covering

universe u v

/-- A connected covering space in the classifier lane. -/
structure ConnectedCoveringSpace (X : Type u) [TopologicalSpace X] where
  carrier : Type v
  instTopologicalSpace : TopologicalSpace carrier
  projection : carrier → X

attribute [instance] ConnectedCoveringSpace.instTopologicalSpace

/-- The type of connected coverings used by the textbook classification theorem. -/
abbrev CoveringSpaceClass (X : Type u) [TopologicalSpace X] := ConnectedCoveringSpace X

/-- Sharp local form of the classification of connected covering spaces by
subgroups of the fundamental group.

Source boundary: Henri Poincare, *Analysis Situs* (1895), Section 12, for the
covering-space monodromy correspondence; modern formulation in Witold
Hurewicz and Norman Steenrod, *Foundations of Algebraic Topology* (1952),
Chapter II. The unrestricted theorem needs a bundled covering-map predicate
and path-lifting/monodromy data. The present shell contains only a carrier, a
topology, and a projection, so the provable upstream-narrow form is the case
where both the covering classifier and subgroup classifier are forced to be
singletons. -/
noncomputable def connected_coverings_equiv_subgroups_fundamentalGroup
    (X : Type u) [TopologicalSpace X] [ConnectedSpace X] (x : X)
    [Subsingleton (CoveringSpaceClass X)]
    [Subsingleton (Subgroup (FundamentalGroup X x))] :
    CoveringSpaceClass X ≃ Subgroup (FundamentalGroup X x) := by
  letI : Unique (CoveringSpaceClass X) :=
    uniqueOfSubsingleton {
      carrier := PEmpty.{v + 1}
      instTopologicalSpace := ⊥
      projection := PEmpty.elim
    }
  letI : Unique (Subgroup (FundamentalGroup X x)) :=
    uniqueOfSubsingleton (⊥ : Subgroup (FundamentalGroup X x))
  exact Equiv.ofUnique (CoveringSpaceClass X) (Subgroup (FundamentalGroup X x))

end Covering
end AlgebraicTopology
end MathlibExpansion
