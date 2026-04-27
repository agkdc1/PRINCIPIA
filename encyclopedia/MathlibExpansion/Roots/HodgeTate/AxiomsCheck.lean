import MathlibExpansion.Roots.HodgeTate.TateTwist
import MathlibExpansion.Roots.HodgeTate.AxSenTate
import MathlibExpansion.Roots.HodgeTate.Weights

/-!
# HodgeTate axiom ledger check (A2 Pass 3, 2026-04-21)

Emits `#print axioms` for the Phase-1 discharge sites so the ledger can be
verified from the build log. The target after Pass 3 is that none of these
rely on the old `tateTwistAddCommGroup` / `tateTwistRepresentation` axioms;
each should depend only on the Mathlib kernel trio plus (for the
Ax-Sen-Tate consumers) the single analytic primitive
`axSenTate_invariant_vanishing`.
-/

namespace MathlibExpansion.Roots.HodgeTate.AxiomsCheck

-- The AddCommGroup instance on TateTwist — previously an axiom, now derived.
#print axioms MathlibExpansion.Roots.HodgeTate.TateTwist.instAddCommGroup

-- The concrete Tate-twist representation — previously an axiom, now a def.
#print axioms MathlibExpansion.Roots.HodgeTate.tateTwistRepresentation

-- The induced topology on TateTwist — no axiom.
#print axioms MathlibExpansion.Roots.HodgeTate.TateTwist.instTopSpace

-- The one analytic primitive of the Hodge-Tate theory.
#print axioms MathlibExpansion.Roots.HodgeTate.axSenTate_invariant_vanishing

-- The derived disjointness theorem (consumes the analytic primitive).
#print axioms MathlibExpansion.Roots.HodgeTate.weight_space_disjoint

-- The downstream Weights.lean consumer.
#print axioms MathlibExpansion.Roots.HodgeTate.distinct_weights_disjoint_invariants

-- The Hodge-Tate trivial-witness constructor (no axiom).
#print axioms MathlibExpansion.Roots.HodgeTate.isHodgeTate_trivial

end MathlibExpansion.Roots.HodgeTate.AxiomsCheck
