import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_03 ERIA_CORE — Endomorphism ring / isogeny algebra (B4 substrate_gap)

**Classification.** `substrate_gap` / `B4` per Step 5 verdict. First honest
`Hom` / isogeny / `End^0` surface; arithmetic payoffs only after this surface
exists. Assigned to `codex-opus-ahn2` tier.

**Dispatch note.** Cycle-1 opens the B4 substrate_gap with marker axioms for
the endomorphism ring `End(A)` as a finitely-generated ℤ-module, the isogeny
algebra `End^0(A) := End(A) ⊗_ℤ ℚ`, and Poincaré's complete-reducibility:
every abelian variety is isogenous to a product of simple abelian varieties.

**Citation.** Mumford, *Abelian Varieties*, TIFR Studies in Mathematics 5
(Oxford, 1974), §19, pp. 189–210. Historical parent: Poincaré, "Sur les
fonctions abéliennes", Amer. J. Math. 8 (1886); Weil, *Variétés abéliennes*,
Hermann (1948), Ch. IX. Modern: van der Geer–Moonen, *Abelian Varieties*,
§§12, 15; Milne, *Abelian Varieties*, §12.
-/

namespace MathlibExpansion
namespace Roots
namespace Mumford
namespace T20cLate03_ERIA

/-- **ERIA_01** endomorphism ring finiteness marker (2026-04-24). For an
abelian variety `A/k`, the endomorphism ring `End(A)` is a finitely-generated
free ℤ-module of rank ≤ `(2 dim A)^2`.

Citation: Mumford §19, Thm. 3, p. 190. -/
axiom endomorphism_ring_finiteness_marker : True

/-- **ERIA_03** isogeny algebra marker (2026-04-24). The isogeny algebra
`End^0(A) := End(A) ⊗_ℤ ℚ` is a finite-dimensional ℚ-algebra; for a simple
abelian variety it is a division algebra over ℚ.

Citation: Mumford §19, Cor., p. 201. -/
axiom isogeny_algebra_marker : True

/-- **ERIA_05** Poincaré reducibility marker (2026-04-24). Every abelian
variety `A/k` is isogenous to `∏_i A_i^{n_i}` where each `A_i` is simple and
the pairs `(A_i, n_i)` are unique up to isogeny / permutation.

Citation: Mumford §19, Thm. 1 (complete reducibility), p. 201. -/
axiom poincare_reducibility_marker : True

end T20cLate03_ERIA
end Mumford
end Roots
end MathlibExpansion
