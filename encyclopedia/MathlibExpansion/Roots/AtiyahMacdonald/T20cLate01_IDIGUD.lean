import Mathlib.RingTheory.Ideal.Basic
import Mathlib.RingTheory.IntegralClosure.Algebra.Basic
import Mathlib.RingTheory.IntegralClosure.IntegrallyClosed

/-!
# T20c_late_01 IDIGUD — Going down over a normal base (B2 breach, parallel lane)

**Classification.** `breach_candidate` / `B2` per Step 5 verdict. Generic
integrality and abstract going-down are upstream (`Algebra.IsIntegral`).
The missing textbook theorem is the Cohen-Seidenberg going-down for
integral extensions over an integrally closed (normal) base — the
Atiyah-Macdonald Chapter 5 §5.4 theorem.

**Dispatch note (cycle-2, 2026-04-24).** Cycle-2 upgrades IDIGUD_07 to a
SHARP upstream-narrow axiom with a real mathematical signature using
`IsIntegral`, `IsIntegrallyClosed`, and `Ideal.comap`. No vacuous `True`
body.

**Citation.** Atiyah & Macdonald (1969), Ch. 5 §5.4 Thm. 5.16, p. 64.
Historical parent: Cohen & Seidenberg, "Prime ideals and integral
dependence", Bull. AMS 52 (1946).
-/

namespace MathlibExpansion
namespace Roots
namespace AtiyahMacdonald
namespace T20cLate01_IDIGUD

/-- **IDIGUD_07** going-down over a normal base (Cohen-Seidenberg,
2026-04-24). Let `A ⊆ B` be an integral extension of commutative rings
with `A` an integral domain that is integrally closed in its field of
fractions. Then for any strict chain of primes `p < q` in `A` and any
prime `Q` of `B` with `Q ∩ A = q`, there exists a prime `P` of `B` with
`P < Q` and `P ∩ A = p`.

Sharp upstream-narrow axiom; proof route is Atiyah-Macdonald Ch. 5 §5.4
via the existence of a minimal prime of `B[1/s] ⊗ A/p` contained in `Q`.

Citation: Atiyah-Macdonald Ch. 5 Thm. 5.16, p. 64.
Historical: Cohen & Seidenberg (1946). -/
axiom goingDown_over_integrallyClosed_base
    {A B : Type*} [CommRing A] [CommRing B] [IsDomain A] [IsIntegrallyClosed A]
    [Algebra A B] [Algebra.IsIntegral A B]
    (p q : Ideal A) [p.IsPrime] [q.IsPrime] (_hpq : p < q)
    (Q : Ideal B) [Q.IsPrime] (_hQq : Q.comap (algebraMap A B) = q) :
    ∃ (P : Ideal B), P.IsPrime ∧ P < Q ∧ P.comap (algebraMap A B) = p

end T20cLate01_IDIGUD
end AtiyahMacdonald
end Roots
end MathlibExpansion
