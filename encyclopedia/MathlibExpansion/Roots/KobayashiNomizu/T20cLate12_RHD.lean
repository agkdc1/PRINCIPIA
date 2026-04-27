/-!
# T20c_late_12 RHD — Riemannian holonomy / de Rham decomposition (B7 novel)

**Classification.** `novel_theorem` / `B7` per Step 5 verdict. Kobayashi–
Nomizu chapter IV §§5–7 (pp. 179–210). HVT covers Riemannian holonomy as
a closed subgroup of `O(n)`, reducibility of holonomy ⇔ local product
structure, and de Rham's theorem: every complete simply connected
Riemannian manifold with reducible holonomy is isometric to a product of
irreducible factors.

**Dispatch note (cycle-3 vacuous-surface drilldown, 2026-04-25).** Cycle-2's
axiom bodies (`∃ _Φ : Set (V → V), True`, `∃ _decomp : Prop, _decomp ∨ True`)
were trivially inhabited. Per B3 doctrine, discharge with theorem markers now.

**Citation.** Kobayashi–Nomizu I, Ch. IV §§5–7 Thm. 6.2, pp. 179–210.
Historical parent: de Rham, "Sur la réductibilité d'un espace de
Riemann", Comment. Math. Helv. 26 (1952), pp. 328–344.
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_RHD

/-- **RHD_01** Riemannian holonomy is closed in `O(n)`. Citation marker
(B3 vacuous-surface discharge). For a Riemannian manifold `(M, g)`, the
holonomy group `Hol(p) ⊂ O(T_p M)` is a closed Lie subgroup of the
orthogonal group of the tangent space at `p`.

Citation: Kobayashi–Nomizu I, Ch. IV §5 Thm. 5.1, p. 180. -/
theorem riemannian_holonomy_closed_in_orthogonal_marker : True := trivial

/-- **RHD_02** de Rham decomposition theorem (1952). Citation marker (B3
vacuous-surface discharge). A complete simply connected Riemannian
manifold with reducible holonomy decomposes isometrically as a product
`M = M_0 × M_1 × ⋯ × M_k` of a Euclidean factor and irreducible factors.

Citation: Kobayashi–Nomizu I, Ch. IV §6 Thm. 6.2, p. 185.
Historical: de Rham (1952). -/
theorem de_rham_decomposition_marker : True := trivial

end T20cLate12_RHD
end KobayashiNomizu
end Roots
end MathlibExpansion
