import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 HRFF — Rational maps and function fields (B0 defer, Ch. I)

**Classification.** `defer` / `B0` per Step 5 verdict. Core Hartshorne I.4 is
already upstream via `AlgebraicGeometry.RationalMap` and
`AlgebraicGeometry.FunctionField`. No standalone Step 6 front; consume the
upstream carriers and reopen only small wrappers if a downstream consumer
truly needs them.

**Dispatch note.** Cycle-1 lands a single defer citation marker — the
upstream Mathlib carriers cover the theorem surface, so the HRFF shelf is
reserved as a pointer only.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. I §4,
pp. 24–31. Historical parent: Zariski, "Generalized semi-local rings",
Summa Bras. Math. 1 (1946); Serre, "Espaces fibrés algébriques", Sém.
Chevalley (1957). Modern: EGA IV §20.
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_HRFF

/-- **HRFF_01** rational map / function field upstream defer marker
(2026-04-24). `AlgebraicGeometry.RationalMap` and
`AlgebraicGeometry.FunctionField` already provide the Hartshorne I.4
carriers. Marker reserves the defer slot — do not reopen without a
downstream-consumer justification.

Citation: Hartshorne Ch. I §4 Thm. 4.4, p. 27. -/
axiom rational_maps_function_fields_defer_marker : True

end T20cLate02_HRFF
end Hartshorne
end Roots
end MathlibExpansion
