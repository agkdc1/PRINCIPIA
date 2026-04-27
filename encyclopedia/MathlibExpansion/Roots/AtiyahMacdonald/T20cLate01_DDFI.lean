import Mathlib.RingTheory.DedekindDomain.Ideal

/-!
# T20c_late_01 DDFI — Dedekind domain: primary ideal ↔ prime power (B1R reserve)

**Classification.** `substrate_gap` / `B1R` (thin reserve lane) per Step 5
verdict. Dedekind infrastructure is upstream (`IsDedekindDomain`,
`IsDedekindDomain.HeightOneSpectrum`). The only textbook theorem wrapper
still genuinely missing under the Atiyah-Macdonald phrasing is
"primary ideal in a Dedekind domain is a prime power".

**Citation.** Atiyah & Macdonald (1969), Ch. 9 Prop. 9.1, p. 94. Historical
parent: Dedekind, "Sur la théorie des nombres entiers algébriques",
Bull. Sci. Math. (1876), Supplement XI to Dirichlet-Dedekind
*Vorlesungen über Zahlentheorie*.
-/

namespace MathlibExpansion
namespace Roots
namespace AtiyahMacdonald
namespace T20cLate01_DDFI

/-- **DDFI_05** (B1R reserve, 2026-04-24). In a Dedekind domain, every
primary ideal is a prime power. The proof is upstream-narrow — uses
`IsDedekindDomain.isPrime_of_isPrimary` and the unique factorization of
ideals into primes — but not yet packaged under this name. Filed as a
sharp axiom with textbook-faithful signature; will be discharged by
packaging sweep over `IsDedekindDomain` + `UniqueFactorizationMonoid (Ideal R)`.

Citation: Atiyah-Macdonald Ch. 9 Prop. 9.1, p. 94. -/
axiom primary_ideal_is_prime_power_in_dedekind
    (R : Type*) [CommRing R] [IsDedekindDomain R] (Q : Ideal R)
    (hQ : Q.IsPrimary) (hne : Q ≠ ⊤) :
    ∃ (P : Ideal R) (n : ℕ), P.IsPrime ∧ 1 ≤ n ∧ Q = P ^ n

end T20cLate01_DDFI
end AtiyahMacdonald
end Roots
end MathlibExpansion
