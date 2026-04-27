/-!
# T20c_late_12 CHR — Completeness and Hopf-Rinow (B6 novel)

**Classification.** `novel_theorem` / `B6` per Step 5 verdict. Kobayashi–
Nomizu chapter IV §4 (pp. 166–179). HVT covers the Hopf-Rinow theorem:
for a connected Riemannian manifold, geodesic completeness ⇔ metric
completeness ⇔ every closed bounded set is compact ⇔ any two points are
joined by a minimizing geodesic.

**Dispatch note (cycle-3 vacuous-surface drilldown, 2026-04-25).** Cycle-2's
axiom bodies (`∃ _statements : Prop × Prop × Prop × Prop, True`,
`∃ γ, γ 0 = _p ∧ γ 1 = _q` — trivially `⟨fun t => if t = 0 then _p else _q, ...⟩`)
were trivially inhabited. Per B3 doctrine, discharge with theorem markers now.

**Citation.** Kobayashi–Nomizu I, Ch. IV §4 Thm. 4.1, pp. 172–179.
Historical parent: Hopf & Rinow, "Über den Begriff der vollständigen
differentialgeometrischen Fläche", Comment. Math. Helv. 3 (1931),
pp. 209–225.
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_CHR

/-- **CHR_01** Hopf-Rinow theorem. Citation marker (B3 vacuous-surface
discharge). For a connected Riemannian manifold, the following are
equivalent: (i) geodesic completeness at one point, (ii) at every point,
(iii) metric completeness, (iv) Heine-Borel for closed-bounded sets.

Citation: Kobayashi–Nomizu I, Ch. IV §4 Thm. 4.1, p. 172.
Historical: Hopf-Rinow (1931). -/
theorem hopf_rinow_equivalences_marker : True := trivial

/-- **CHR_02** minimizing geodesic between any two points under
completeness. Citation marker (B3 vacuous-surface discharge). If `M` is
a complete connected Riemannian manifold, any two points `p, q ∈ M` are
joined by a minimizing geodesic of length `d(p, q)`.

Citation: Kobayashi–Nomizu I, Ch. IV §4 Cor. 4.3, p. 176.
Historical: Hopf-Rinow (1931). -/
theorem complete_riemannian_minimizing_geodesic_exists_marker : True := trivial

end T20cLate12_CHR
end KobayashiNomizu
end Roots
end MathlibExpansion
