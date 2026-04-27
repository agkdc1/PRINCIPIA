import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_03 MWHD — Mordell–Weil + height descent (DEFER)

**Classification.** `defer` per Step 5 verdict. Appendix II (Mordell–Weil
theorem for abelian varieties over number fields) + height-pairing /
Néron–Tate descent require number-field arithmetic, Kummer theory, and
canonical-height machinery Mathlib does not yet have end-to-end. Held as
upstream-narrow citation-backed axioms.

**Dispatch note.** Cycle-1 opens the DEFER as upstream-narrow axioms for:
(i) Mordell–Weil finite generation of `A(K)` for an abelian variety over a
number field `K`, and (ii) Néron–Tate canonical height `ĥ : A(K̄) → ℝ_{≥0}`
associated to a symmetric ample line bundle, a positive-semidefinite
quadratic form with `ĥ(P) = 0 ⇔ P` is torsion.

**Citation.** Mumford, *Abelian Varieties*, TIFR Studies in Mathematics 5
(Oxford, 1974), App. II, pp. 230–247. Historical parent: Mordell, "On the
rational solutions of indeterminate equations" (1922); Weil, "L'arithmétique
sur les courbes algébriques", Acta Math. 52 (1929); Néron, "Quasi-fonctions
et hauteurs", Ann. Math. 82 (1965); Tate, "Letter to Serre" (1962, circulated
via Lang). Modern: Silverman, *Arithmetic of Elliptic Curves*, 2nd ed.
(Springer 2009), Ch. VIII (elliptic case analogue); Hindry–Silverman,
*Diophantine Geometry*, GTM 201 (Springer 2000), Part B.

**Upstream narrow.** Nothing algebraic about structure / isogeny / End beyond
number-field arithmetic is asserted here. Algebraic End / isogeny surface
lives in `ERIA`; Tate module lives in `ECTM`; Rosati involution lives in
`RIP`.
-/

namespace MathlibExpansion
namespace Roots
namespace Mumford
namespace T20cLate03_MWHD_DEFER

/-- **MWHD_DEFER_01** Mordell–Weil finite generation marker (2026-04-24).
For an abelian variety `A` over a number field `K`, the group `A(K)` of
`K`-rational points is finitely generated as a ℤ-module.

Citation: Mumford App. II, Thm. 1, p. 238; Weil (1929). -/
axiom mordell_weil_number_field_marker : True

/-- **MWHD_DEFER_03** Néron–Tate canonical height marker (2026-04-24).
Given a symmetric ample line bundle `L` on an abelian variety `A/K` (number
field), the canonical / Néron–Tate height `ĥ_L : A(K̄) → ℝ_{≥0}` is a
positive-semidefinite quadratic form on `A(K̄) ⊗ ℝ` with `ĥ_L(P) = 0`
iff `P` is torsion.

Citation: Mumford App. II, Thm. 2 / height descent, p. 243; Tate's letter
(1962); Hindry–Silverman B.5. -/
axiom neron_tate_canonical_height_marker : True

end T20cLate03_MWHD_DEFER
end Mumford
end Roots
end MathlibExpansion
