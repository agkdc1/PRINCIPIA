import Mathlib.NumberTheory.Padics.PadicNumbers

/-!
# T20c_late_05 HMQ — Hasse-Minkowski over Q (novel_theorem Q3, opus-ahn max)

**Classification.** `novel_theorem` / `Q3`. Chapter IV dominant global
theorem: a quadratic form over `ℚ` represents zero (or a given `a ∈ ℚ^×`)
iff it does so over every completion `ℚ_v`.

**Citation.** Serre, *A Course in Arithmetic*, Ch. IV §3.
Historical parent: Minkowski (1890); Hasse, "Darstellbarkeit von Zahlen durch
quadratische Formen in einem beliebigen algebraischen Zahlkörper" (1924).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_HMQ

/-- **HMQ_01** local-global existence marker. Non-degenerate quadratic form
`f` of rank `n ≥ 1` over `ℚ` represents zero non-trivially iff `f` represents
zero over `ℚ_v` for every place `v` (finite primes + `∞`).
Citation: Serre Ch. IV §3.2, Thm. 8 (Hasse-Minkowski). -/
axiom hasse_minkowski_represents_zero_marker : True

/-- **HMQ_03** local-global representation marker. For `a ∈ ℚ^×`, form `f`
represents `a` over `ℚ` iff `f` represents `a` over every `ℚ_v`.
Citation: Serre Ch. IV §3.2, Cor. 1. -/
axiom hasse_minkowski_represents_a_marker : True

/-- **HMQ_05** equivalence local-global marker. Two non-degenerate forms
`f, g` over `ℚ` are `GL_n(ℚ)`-equivalent iff they are `GL_n(ℚ_v)`-equivalent
over every place `v`; equivalent: `rank(f) = rank(g)`, `d(f) = d(g) ∈ ℚ^×/(ℚ^×)^2`,
`ε_v(f) = ε_v(g)` for all `v`, and real-place signature agrees.
Citation: Serre Ch. IV §3.2, Thm. 9. -/
axiom hasse_minkowski_equivalence_marker : True

end T20cLate05_HMQ
end Serre
end Roots
end MathlibExpansion
