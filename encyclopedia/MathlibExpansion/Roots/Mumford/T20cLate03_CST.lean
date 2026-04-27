import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_03 CST_CORE — Cube and square theorems (B2 novel_theorem)

**Classification.** `novel_theorem` / `B2` per Step 5 verdict. First line-bundle
engine; do not bury `[n]^*L` inside later projectivity or cohomology packages.
Assigned to `codex-opus-ahn2` tier.

**Dispatch note.** Cycle-1 opens the B2 novel-theorem front with marker axioms
for the theorem of the cube (trivial-on-three-fibers ⇒ trivial) and the theorem
of the square (`t_{a+b}^* L ⊗ L ≅ t_a^* L ⊗ t_b^* L`), plus the `[n]^* L ≅
L^{⊗n(n+1)/2} ⊗ [-1]^* L^{⊗n(n-1)/2}` scaling formula.

**Citation.** Mumford, *Abelian Varieties*, TIFR Studies in Mathematics 5
(Oxford, 1974), §6, Thm. (cube), p. 55; §6, Cor. 2 (square), p. 59; §6, Cor. 3
(n^* L), p. 59. Historical parent: Weil, *Variétés abéliennes*, Hermann (1948),
Ch. VI; Mumford–Fogarty–Kirwan, *Geometric Invariant Theory*, 3rd ed. (1994),
Ch. 6. Modern: van der Geer–Moonen, *Abelian Varieties*, §2.
-/

namespace MathlibExpansion
namespace Roots
namespace Mumford
namespace T20cLate03_CST

/-- **CST_01** theorem of the cube marker (2026-04-24). Let `X`, `Y`, `Z` be
proper geometrically-integral varieties over `k` with base points, and let `L`
be a line bundle on `X × Y × Z`. If the restriction of `L` to each of
`{x_0} × Y × Z`, `X × {y_0} × Z`, `X × Y × {z_0}` is trivial, then `L` is
trivial on all of `X × Y × Z`.

Citation: Mumford §6, Thm. (cube), p. 55. -/
axiom theorem_of_cube_marker : True

/-- **CST_02** theorem of the square marker (2026-04-24). For a line bundle
`L` on an abelian variety `A` and points `a, b ∈ A`,
`t_{a+b}^* L ⊗ L ≅ t_a^* L ⊗ t_b^* L`.

Citation: Mumford §6, Cor. 2 (square), p. 59. -/
axiom theorem_of_square_marker : True

/-- **CST_04** n-th pullback formula marker (2026-04-24). For `L` a line bundle
on an abelian variety `A`,
`[n]^* L ≅ L^{⊗ n(n+1)/2} ⊗ [-1]^* L^{⊗ n(n-1)/2}`.
In particular if `L` is symmetric (`[-1]^* L ≅ L`), then `[n]^* L ≅ L^{⊗ n^2}`.

Citation: Mumford §6, Cor. 3, p. 59. -/
axiom n_pullback_formula_marker : True

end T20cLate03_CST
end Mumford
end Roots
end MathlibExpansion
