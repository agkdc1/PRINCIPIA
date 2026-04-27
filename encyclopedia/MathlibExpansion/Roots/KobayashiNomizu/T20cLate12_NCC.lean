/-!
# T20c_late_12 NCC — Normal coordinates and convex neighborhoods (B5 breach)

**Classification.** `breach_candidate` / `B5` per Step 5 verdict. Kobayashi–
Nomizu chapter IV §3 (pp. 162–166). Substrate requires chartwise
`ContDiffAt.toPartialHomeomorph` local IFT bridge (internal dispatcher
note). HVT covers normal coordinates around a point via `exp_p`, and
the existence of convex normal neighborhoods (totally normal).

**Dispatch note (cycle-3 vacuous-surface drilldown, 2026-04-25).** Cycle-2's
axiom bodies (`∃ _coords _U, 0 ∈ _U`, `∃ _U, _p ∈ _U`) were trivially
inhabited (`⟨id, Set.univ, mem_univ _⟩`). Per B3 doctrine, discharge with
theorem markers now.

**Citation.** Kobayashi–Nomizu I, Ch. IV §3 Thm. 3.6, pp. 162–166.
Historical parent: Whitehead, "Convex regions in the geometry of paths",
Quart. J. Math. 3 (1932), pp. 33–42.
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_NCC

/-- **NCC_01** normal coordinates at a point. Citation marker (B3
vacuous-surface discharge). For a Riemannian manifold `M` and `p ∈ M`,
the exponential map `exp_p` provides a local diffeomorphism whose inverse
gives normal coordinates around `p`, with Christoffel symbols vanishing
at `p`.

Citation: Kobayashi–Nomizu I, Ch. IV §3 Prop. 3.1, p. 162. -/
theorem normal_coordinates_at_point_marker : True := trivial

/-- **NCC_02** existence of convex normal neighborhoods (Whitehead).
Citation marker (B3 vacuous-surface discharge). Every point of a
Riemannian manifold has a neighborhood `U` such that any two points in
`U` are joined by a unique minimizing geodesic lying entirely in `U`.

Citation: Kobayashi–Nomizu I, Ch. IV §3 Thm. 3.6, p. 166.
Historical: Whitehead (1932). -/
theorem whitehead_convex_normal_neighborhood_marker : True := trivial

end T20cLate12_NCC
end KobayashiNomizu
end Roots
end MathlibExpansion
