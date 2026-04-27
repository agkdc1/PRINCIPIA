import Mathlib.RingTheory.Localization.AtPrime
import Mathlib.RingTheory.Localization.Ideal

/-!
# T20c_late_01 LPC — Localization and prime correspondence (DEFER wrapper)

**Classification.** `defer` / `DEFER` tier (per T20c_late_01_atiyah Step 5 verdict,
2026-04-24). Localization and prime correspondence are already upstream in
Mathlib 4.17: `IsLocalization.AtPrime`, `Ideal.prime_correspondence`,
`IsLocalization.primeCorrespondence`. No breach is justified; only a thin
citation wrapper is filed here to make the deferral visible under the
`MathlibExpansion.Roots.AtiyahMacdonald` namespace.

**Citation.** M. F. Atiyah and I. G. Macdonald, *Introduction to Commutative
Algebra*, Addison-Wesley (1969), Ch. 3 §§3.1–3.2, pp. 36–44. Historical
parent: Chevalley, "Sur la théorie des anneaux locaux", Bull. Soc. Math.
France 72 (1944); Krull, "Dimensionstheorie in Stellenringen", J. reine
angew. Math. 179 (1938).
-/

namespace MathlibExpansion
namespace Roots
namespace AtiyahMacdonald
namespace T20cLate01_LPC

/-- **LPC citation marker** (DEFER, 2026-04-24). Trivially true sentinel
recording that prime correspondence and localization at a prime are upstream
in Mathlib under the names `IsLocalization.AtPrime`,
`IsLocalization.orderIsoOfPrime`, and `IsLocalization.primeCorrespondence`.
Kept as a `theorem`, not an `axiom`, because the content is a trivial
discharge of a tautological proposition. -/
theorem lpc_covered_marker : True := trivial

end T20cLate01_LPC
end AtiyahMacdonald
end Roots
end MathlibExpansion
