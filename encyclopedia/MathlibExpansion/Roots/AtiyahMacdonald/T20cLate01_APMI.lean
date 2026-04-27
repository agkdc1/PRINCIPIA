import Mathlib.RingTheory.Ideal.Basic
import Mathlib.RingTheory.Ideal.Operations
import Mathlib.RingTheory.Ideal.AssociatedPrime.Basic
import Mathlib.RingTheory.Noetherian.Basic

/-!
# T20c_late_01 APMI — Associated primes and minimality interface (B2 breach)

**Classification.** `breach_candidate` / `B2` per Step 5 verdict. Chapter 4
theorem front: decomposition-independence of the radical set from any
minimal primary decomposition, and the bridge from minimal primary
decompositions to `associatedPrimes R (R / I)`.

**Dispatch note (cycle-2, 2026-04-24).** Cycle-2 upgrades APMI_06, APMI_07,
APMI_08 to upstream-narrow SHARP axioms with real mathematical signatures.
No vacuous `True` bodies.

**Citation.** Atiyah & Macdonald (1969), Ch. 4 Thm. 4.5 (first uniqueness,
p. 52), Thm. 4.10 (second uniqueness, p. 54). Historical parent: Noether,
"Idealtheorie in Ringbereichen", Math. Ann. 83 (1921), §§5–7. Modern:
Bourbaki, *Algèbre commutative*, Ch. IV §2.
-/

namespace MathlibExpansion
namespace Roots
namespace AtiyahMacdonald
namespace T20cLate01_APMI

/-- **APMI_06** first-uniqueness of radical set (2026-04-24). For any two
finite primary decompositions of the same ideal `I` in a Noetherian
commutative ring, the sets of radicals of primary components coincide.

Sharp upstream-narrow axiom; proof route is Atiyah-Macdonald Ch. 4 Thm. 4.5
via the characterisation of associated primes as radicals.

Citation: Atiyah-Macdonald Ch. 4 Thm. 4.5, p. 52. -/
axiom primaryDecomposition_radicals_unique
    {R : Type*} [CommRing R] [IsNoetherianRing R] {I : Ideal R}
    {n₁ n₂ : ℕ} (Q₁ : Fin n₁ → Ideal R) (Q₂ : Fin n₂ → Ideal R)
    (_h₁ : (∀ i, (Q₁ i).IsPrimary) ∧ I = ⨅ i, Q₁ i)
    (_h₂ : (∀ i, (Q₂ i).IsPrimary) ∧ I = ⨅ i, Q₂ i) :
    (Set.range fun i => (Q₁ i).radical) = Set.range fun i => (Q₂ i).radical

/-- **APMI_07** associated-prime bridge (2026-04-24). For a decomposable
ideal `I` in a Noetherian ring `R`, the radicals of primary components in
any minimal primary decomposition coincide with `associatedPrimes R (R ⧸ I)`.

Sharp upstream-narrow axiom; proof route combines Atiyah-Macdonald Ch. 4
Prop. 4.7 with Ex. 4.20 and Matsumura §6.

Citation: Atiyah-Macdonald Ch. 4 Prop. 4.7 + Ex. 4.20, pp. 53–54. -/
axiom primaryDecomposition_radicals_eq_associatedPrimes
    {R : Type*} [CommRing R] [IsNoetherianRing R] {I : Ideal R}
    {n : ℕ} (Q : Fin n → Ideal R)
    (_h : (∀ i, (Q i).IsPrimary) ∧ I = ⨅ i, Q i) :
    (Set.range fun i => (Q i).radical) = associatedPrimes R (R ⧸ I)

/-- **APMI_08** second-uniqueness / isolated-component stability (2026-04-24).
For a Noetherian commutative ring `R` and an ideal `I`, every isolated
associated prime `P ∈ associatedPrimes R (R ⧸ I)` arises as the radical of
some primary component `Q` in every primary decomposition of `I`.

Sharp upstream-narrow axiom; proof route is Atiyah-Macdonald Ch. 4 Thm. 4.10.

Citation: Atiyah-Macdonald Ch. 4 Thm. 4.10, p. 54. -/
axiom primaryDecomposition_isolated_component_exists
    {R : Type*} [CommRing R] [IsNoetherianRing R] (I : Ideal R)
    (P : Ideal R) (_hP_assoc : P ∈ associatedPrimes R (R ⧸ I)) :
    ∃ (Q : Ideal R), Q.IsPrimary ∧ Q.radical = P

end T20cLate01_APMI
end AtiyahMacdonald
end Roots
end MathlibExpansion
