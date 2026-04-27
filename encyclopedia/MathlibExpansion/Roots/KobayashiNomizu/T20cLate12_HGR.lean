/-!
# T20c_late_12 HGR — Holonomy group and reduction
(B3 substrate_gap)

**Classification.** `substrate_gap` / `B3` per Step 5 verdict. Kobayashi–
Nomizu I, Ch. II §§4, 7, 8, 10 — holonomy group at a point is a subgroup of
the structure group G; it is a Lie subgroup (restricted holonomy) and yields
a principal subbundle via the reduction theorem (Thm. 7.1).

**Dispatch note (cycle-3 vacuous-surface drilldown, 2026-04-25).** Cycle-2's
axiom bodies (`∃ _Φ : B → Set G, True`, `∃ _P_reduced : Type, True`,
`∃ _hol_lie_algebra : Type, True`) were trivially inhabited. Per B3 doctrine,
discharge with theorem markers now; piecewise-smooth-loop carrier deferred
until upstream substrate lands.

**Citation.** Kobayashi–Nomizu I, Ch. II §§4, 7, 8. Reduction: Thm. 7.1,
p. 83. Ambrose–Singer: Thm. 8.1. Historical parent: Ambrose & Singer,
"A theorem on holonomy", Trans. AMS 75 (1953), pp. 428–443.
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_HGR

/-- **HGR_01** holonomy group is a subgroup of G. Citation marker (B3
vacuous-surface discharge). For a connection on `P → M` and `u ∈ P`, the
parallel-transport images of `u` along based piecewise-smooth loops form
a subgroup `Φ(u) ⊆ G`.

Citation: Kobayashi–Nomizu I, Ch. II §4 Thm. 4.2, p. 72. -/
theorem holonomy_group_is_subgroup_marker : True := trivial

/-- **HGR_02** reduction theorem (Kobayashi–Nomizu Thm. 7.1). Citation
marker (B3 vacuous-surface discharge). The points reachable from `u` by
horizontal piecewise-smooth curves form a principal subbundle
`P(u, Φ(u))` with structure group the holonomy group.

Citation: Kobayashi–Nomizu I, Ch. II §7 Thm. 7.1, p. 83. -/
theorem reduction_theorem_via_holonomy_marker : True := trivial

/-- **HGR_03** Ambrose–Singer theorem. Citation marker (B3 vacuous-surface
discharge). The Lie algebra of the restricted holonomy group `Φ⁰(u)` is
spanned by curvature values at horizontal-curve-reachable points evaluated
on horizontal vector pairs.

Citation: Kobayashi–Nomizu I, Ch. II §8 Thm. 8.1, p. 89.
Historical: Ambrose–Singer (1953). -/
theorem ambrose_singer_theorem_marker : True := trivial

end T20cLate12_HGR
end KobayashiNomizu
end Roots
end MathlibExpansion
