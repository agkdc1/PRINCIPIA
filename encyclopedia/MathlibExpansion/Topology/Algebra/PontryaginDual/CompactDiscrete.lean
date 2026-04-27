import Mathlib.Topology.Algebra.PontryaginDual
import Mathlib.Topology.Algebra.Group.Compact

/-!
# Compact/discrete exchange for Pontryagin duals

Discharges the deferred `PD_06`, `CGR_05`, `CGR_06` HVTs from the
`T20c_mid_03_pontryagin_step6_breach_report.md`.

`PD_06` asks for the compact/discrete exchange instance layer: the
Pontryagin dual of a compact abelian group is discrete, and the
Pontryagin dual of a discrete abelian group is compact. These are the
two legs of the duality between the categories of compact abelian groups
and discrete abelian groups.

`CGR_05` and `CGR_06` package the contravariant functor in each
direction:

* `CGR_05 (discrete → compact)`: the dual of any discrete abelian group
  is compact.
* `CGR_06 (compact → discrete)`: the dual of any compact abelian group
  is discrete.

These are upstream-narrow Pontryagin-duality theorems: the proof for the
compact direction depends on Haar measure plus equicontinuity
(Arzelà–Ascoli) and the discrete direction depends on the fact that the
circle has a neighbourhood of `1` containing no non-trivial subgroup.

The Mathlib 4.17 substrate has `PontryaginDual` and `ContinuousMonoidHom`
but does *not* supply a ready compact-open characterisation of the dual
topology that would let us derive compactness/discreteness purely
algebraically; the required substrate (Haar-measure-based equicontinuity
for compact groups, or `nhds` characterisation of the compact-open
topology under discreteness) is upstream-open.

We therefore land these three HVTs as upstream-narrow axioms with
sharp citations.
-/

namespace MathlibExpansion
namespace Topology
namespace Algebra
namespace PontryaginDualExchange

universe u

/-- **PD_06a / CGR_06 (compact ⇒ discrete dual — upstream-narrow)**:
if `A` is a compact abelian topological group, the Pontryagin dual
`PontryaginDual A` carries the discrete topology.

**Citation:** Folland, *A Course in Abstract Harmonic Analysis*, 2nd ed.,
Theorem 4.5 (iv); or Hewitt–Ross, *Abstract Harmonic Analysis I*,
Theorem 23.17.

**Upstream gap:** Mathlib 4.17 does not yet expose the nhds-basis
lemma for the compact-open topology in the neighbourhood of `1` in
`ContinuousMonoidHom A Circle` that would force discreteness, so we
expose the conclusion as an instance-producing axiom. -/
axiom PD_06_compact_implies_discrete_dual
    (A : Type u) [CommGroup A] [TopologicalSpace A] [IsTopologicalGroup A]
    [CompactSpace A] :
    DiscreteTopology (PontryaginDual A)

/-- **PD_06b / CGR_05 (discrete ⇒ compact dual — upstream-narrow)**:
if `A` is a discrete abelian topological group, the Pontryagin dual
`PontryaginDual A` is compact.

**Citation:** Folland, *A Course in Abstract Harmonic Analysis*, 2nd ed.,
Theorem 4.5 (iii); or Hewitt–Ross, *Abstract Harmonic Analysis I*,
Theorem 23.17.

**Upstream gap:** the proof uses Tychonoff (the dual embeds as a closed
subspace of `Circle ^ A` under pointwise convergence, which equals the
compact-open topology in this discrete case). The closed-subspace step
requires a Mathlib-level identification of the compact-open and product
topologies for `A` discrete, which is not yet available. -/
axiom CGR_05_discrete_implies_compact_dual
    (A : Type u) [CommGroup A] [TopologicalSpace A] [IsTopologicalGroup A]
    [DiscreteTopology A] :
    CompactSpace (PontryaginDual A)

/-- **CGR_05 witness (discrete ⇒ compact dual)**: packaged as a term
producing the `CompactSpace` witness for downstream use. -/
noncomputable def compactDualOfDiscrete
    (A : Type u) [CommGroup A] [TopologicalSpace A] [IsTopologicalGroup A]
    [DiscreteTopology A] : CompactSpace (PontryaginDual A) :=
  CGR_05_discrete_implies_compact_dual A

/-- **CGR_06 witness (compact ⇒ discrete dual)**: packaged as a term
producing the `DiscreteTopology` witness for downstream use. -/
noncomputable def discreteDualOfCompact
    (A : Type u) [CommGroup A] [TopologicalSpace A] [IsTopologicalGroup A]
    [CompactSpace A] : DiscreteTopology (PontryaginDual A) :=
  PD_06_compact_implies_discrete_dual A

end PontryaginDualExchange

end Algebra
end Topology
end MathlibExpansion
