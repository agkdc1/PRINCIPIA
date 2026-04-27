import MathlibExpansion.MazurWiles1984.MainConjecture

/-!
# MazurWiles1984.WilesConsumer

Forward-facing module reserving the namespace for future Wiles-1995 and
Kolyvagin consumers. Today no consumer exists, so this module is a
re-exporter / doc stub.

## Available corollary shapes

* `mazurWilesMainConjecture` — direct equality of principal ideals:
  `char(X∞ p d) = (Lp p d)`.

* `charIdeal_dvd_Lp` — generator-of-char-ideal divides `Lp` (membership form):
  `f ∈ char(X∞ p d) → f ∈ (Lp p d)`.

* `charIdeal_eq_unit_mul_Lp` — unit-multiple form: any generator of the
  char-ideal is `u • Lp` for some `u : (PowerSeries ℤ_[p])ˣ`.

## Future consumers

Wiles-1995 deformation-ring / Hecke-ring machinery needs:
1. The unit-multiple form to transfer generators between the two ideals.
2. The membership form to verify divisibility at each prime.
3. Direct equality to close the *R = T* argument via the Gorenstein criterion.

Future consumers should import this module, not `MainConjecture` directly,
so the corollary-surface remains stable as the formalization evolves.
-/

namespace MazurWiles1984.WilesConsumer

-- intentionally empty: all exports live in MainConjecture; import that module
-- transitively via this one.

end MazurWiles1984.WilesConsumer
