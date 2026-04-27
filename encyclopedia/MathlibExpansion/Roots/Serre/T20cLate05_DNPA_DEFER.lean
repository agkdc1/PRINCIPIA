import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_05 DNPA_DEFER — Dirichlet nonvanishing & primes in AP (defer)

**Classification.** `defer` / Chapter VI. Covered upstream:
`Mathlib.NumberTheory.DirichletCharacter.Orthogonality` +
`Mathlib.NumberTheory.LSeries.DirichletContinuation` close the modern
primes-in-AP theorem (`L(1, χ) ≠ 0` for `χ ≠ 1` + prime-density argument).

**Citation.** Serre, *A Course in Arithmetic*, Ch. VI §4.
Historical parent: Dirichlet, "Beweis des Satzes, dass jede unbegrenzte
arithmetische Progression..." (1837); Landau (1903) (refined proof).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_DNPA

/-- **DNPA_01** citation marker. `L(1, χ) ≠ 0` for every non-trivial Dirichlet
character `χ mod n` and the Dirichlet primes-in-AP theorem (each residue class
coprime to the modulus contains infinitely many primes), fully upstream.
Citation: Serre Ch. VI §4, Thm. 2. -/
axiom dirichlet_nonvanishing_primes_ap_marker : True

end T20cLate05_DNPA
end Serre
end Roots
end MathlibExpansion
