import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 FFS — Formal functions / semicontinuity (B4 breach_candidate, Ch. III)

**Classification.** `breach_candidate` / `B4` per Step 5 verdict. Real
family-geometry theorem lane after coherent higher direct images and a narrow
completion corridor exist.

**Dispatch note.** Cycle-1 opens the B4 breach with marker axioms for the
formal functions theorem, upper-semicontinuity of `h^i(X_y, F_y)` in a flat
projective family, and the constancy criterion. Sharp signatures deferred to
cycle-2 once HDIPC higher direct image coherence + QCP coherent + SSHC
derived carriers stabilize.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. III §§11–12,
pp. 276–290. Historical parent: Grothendieck, EGA III §§4–5, §§7.7–7.8;
Zariski, "Theorem on holomorphic functions", Amer. J. Math. 78 (1956).
Modern: Stacks Project Tag 02O1 (formal functions), Tag 0B8S (semicontinuity).
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_FFS

/-- **FFS_01** formal functions theorem marker (2026-04-24). For a projective
morphism `f : X → Y` of Noetherian schemes, a coherent sheaf `F` on `X`, and
a point `y ∈ Y`, the natural map `(R^i f_* F)_y^∧ → lim_n H^i(X_n, F_n)` is
an isomorphism, where `X_n = X ×_Y Spec(O_y/𝔪_y^{n+1})`. Marker reserves
the B4 owner slot.

Citation: Hartshorne Ch. III Thm. 11.1, p. 277. -/
axiom formal_functions_theorem_marker : True

/-- **FFS_04** upper semicontinuity marker (2026-04-24). For a flat projective
morphism `f : X → Y` with `Y` Noetherian and a coherent sheaf `F` on `X`, the
function `y ↦ dim_{k(y)} H^i(X_y, F_y)` is upper semicontinuous on `Y`.

Citation: Hartshorne Ch. III Thm. 12.8, p. 288. -/
axiom upper_semicontinuity_marker : True

/-- **FFS_06** constancy criterion marker (2026-04-24). If `f : X → Y` is
a flat projective morphism with `Y` reduced and connected, and `h^i(X_y, F_y)`
is constant, then `R^i f_* F` is locally free and its fiber equals `H^i(X_y, F_y)`.

Citation: Hartshorne Ch. III Cor. 12.9, p. 288. -/
axiom constancy_criterion_marker : True

end T20cLate02_FFS
end Hartshorne
end Roots
end MathlibExpansion
