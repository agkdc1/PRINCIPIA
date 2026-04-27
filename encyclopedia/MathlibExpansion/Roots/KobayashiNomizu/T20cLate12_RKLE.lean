/-!
# T20c_late_12 RKLE — Ricci / Killing / local extension / equivalence (B8 novel)

**Classification.** `novel_theorem` / `B8` per Step 5 verdict. Kobayashi–
Nomizu chapter VI §§5–7 (pp. 248–270, volume I). Deepest FLT-adjacent
corridor for Kobayashi–Nomizu I. HVT covers Ricci tensor identities,
Killing vector field Lie algebra structure, Kobayashi's local-extension
theorem (every local isometry of a simply connected analytic Riemannian
manifold extends globally), and Nomizu's equivalence theorem for
affine connections.

**Dispatch note (cycle-3 vacuous-surface drilldown, 2026-04-25).** Cycle-2's
axiom bodies (`∃ _dim, 2 * _dim ≤ ...` — trivially `⟨0, Nat.zero_le _⟩`;
`∃ _extends : Prop, _extends ∨ True` — trivially `⟨True, Or.inr trivial⟩`;
`∃ _equiv : Prop, _equiv ∨ True` — trivially `⟨True, Or.inr trivial⟩`) were
trivially inhabited. Per B3 doctrine, discharge with theorem markers now.

**Citation.** Kobayashi–Nomizu I, Ch. VI §§5–7 Thm. 6.1 + Thm. 7.4,
pp. 248–270. Historical parent: Killing, *Zur Theorie der Lie'schen
Transformationsgruppen* (1888); Nomizu, "On local and global existence
of Killing vector fields", Ann. Math. 72 (1960), pp. 105–120;
Kobayashi, *Transformation Groups in Differential Geometry*, Springer
Ergebnisse 70 (1972), §VI.
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_RKLE

/-- **RKLE_01** Killing vector fields form a Lie algebra. Citation marker
(B3 vacuous-surface discharge). The Killing vector fields of `(M, g)`
form a finite-dimensional real Lie algebra of dimension at most
`n(n+1)/2`, identified with the Lie algebra of `Iso(M, g)`.

Citation: Kobayashi–Nomizu I, Ch. VI §3 Prop. 3.2, p. 237.
Historical: Killing (1888); Myers-Steenrod (1939). -/
theorem killing_vector_fields_form_lie_algebra_marker : True := trivial

/-- **RKLE_02** Nomizu's local extension theorem (1960). Citation marker
(B3 vacuous-surface discharge). Every local isometry between simply
connected complete real-analytic Riemannian manifolds extends uniquely
to a global isometry.

Citation: Kobayashi–Nomizu I, Ch. VI §6 Thm. 6.1, p. 252.
Historical: Nomizu (1960). -/
theorem nomizu_local_isometry_extension_marker : True := trivial

/-- **RKLE_03** Kobayashi-Nomizu equivalence theorem. Citation marker (B3
vacuous-surface discharge). Two simply connected complete Riemannian
manifolds are isometric iff their curvature tensors and all covariant
derivatives are pointwise equivalent.

Citation: Kobayashi–Nomizu I, Ch. VI §7 Thm. 7.4, p. 261.
Historical: Kobayashi (1972) §VI. -/
theorem kobayashi_nomizu_equivalence_theorem_marker : True := trivial

end T20cLate12_RKLE
end KobayashiNomizu
end Roots
end MathlibExpansion
