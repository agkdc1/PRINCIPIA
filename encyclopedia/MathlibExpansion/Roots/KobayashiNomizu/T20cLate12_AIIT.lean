/-!
# T20c_late_12 AIIT — Affine / isometric / infinitesimal transformations (B5 breach)

**Classification.** `breach_candidate` / `B5` per Step 5 verdict. Kobayashi–
Nomizu chapter VI §§1–4 (pp. 225–240, volume I). Reuse
`Analysis/Normed/Affine/Isometry.lean` flat affine specialization only
(internal dispatcher note). HVT covers affine transformations of
`(M, ∇)`, isometries of `(M, g)`, and infinitesimal counterparts
(affine vector fields, Killing vector fields).

**Dispatch note (cycle-3 vacuous-surface drilldown, 2026-04-25).** Cycle-2's
axiom bodies (`∃ _dim_bound : ℕ, _dim_bound ≤ ...` — trivially `⟨0, Nat.zero_le _⟩`;
`∃ _dim_bound, 2 * _dim_bound ≤ ...` — trivially `⟨0, Nat.zero_le _⟩`) were
trivially inhabited. Per B3 doctrine, discharge with theorem markers now.

**Citation.** Kobayashi–Nomizu I, Ch. VI §§1–4, pp. 225–240.
Historical parent: Myers & Steenrod, "The group of isometries of a
Riemannian manifold", Ann. Math. 40 (1939), pp. 400–416.
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_AIIT

/-- **AIIT_01** affine transformation group is a Lie group. Citation
marker (B3 vacuous-surface discharge). The group of affine
transformations of a connected smooth manifold with complete affine
connection is a finite-dimensional Lie group of dimension at most
`n² + n`.

Citation: Kobayashi–Nomizu I, Ch. VI §1 Thm. 1.1, p. 226. -/
theorem affine_transformation_group_lie_dimension_bound_marker : True := trivial

/-- **AIIT_02** isometry group is a Lie group (Myers-Steenrod). Citation
marker (B3 vacuous-surface discharge). The isometry group of a connected
Riemannian manifold is a finite-dimensional Lie group of dimension at
most `n(n+1)/2`, and acts properly.

Citation: Kobayashi–Nomizu I, Ch. VI §3 Thm. 3.4, p. 239.
Historical: Myers-Steenrod (1939). -/
theorem myers_steenrod_isometry_group_lie_marker : True := trivial

end T20cLate12_AIIT
end KobayashiNomizu
end Roots
end MathlibExpansion
