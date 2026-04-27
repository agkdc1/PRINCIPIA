import Mathlib.RingTheory.Ideal.Basic
import Mathlib.RingTheory.KrullDimension.Basic
import Mathlib.RingTheory.LocalRing.Basic
import Mathlib.RingTheory.Noetherian.Basic
import Mathlib.RingTheory.PowerSeries.Basic
import Mathlib.NumberTheory.Padics.PadicIntegers

/-!
# T20c_late_01 RLH2 — Regular local rings and height-2 local algebra
(B4 hard closure front)

**Classification.** `breach_candidate` / `B4` per Step 5 verdict. This is
the real FLT-facing frontier: no reusable `RegularLocal` owner surface,
no dim-2 finite-length / height bridge, and no honest `Λ = Z_p[[T]]`
package under the Atiyah-Macdonald Ch. 11 §11.3 phrasing. Opening this
front before KDH + HFLD stabilize would recreate the axiom-ridden
`Roots/Iwasawa/Pseudo.lean` pattern Step 1 quarantined.

**Dispatch note (cycle-2, 2026-04-24).** Cycle-2 upgrades RLH2_03, RLH2_04,
RLH2_07 to SHARP upstream-narrow axioms with real mathematical signatures.
No vacuous `True` bodies.

**Citation.** Atiyah & Macdonald (1969), Ch. 11 §11.3, pp. 121–123.
Historical parent: Cohen, "On the structure and ideal theory of complete
local rings", Trans. AMS 59 (1946); Auslander & Buchsbaum, "Homological
dimension in local rings", Trans. AMS 85 (1957); Serre (1965) Ch. IV.
Modern canonical: Matsumura, *Commutative Ring Theory*, Cambridge (1986),
§14. Iwasawa lane: Washington, GTM 83 (1982), §§13.2–13.4, pp. 277–300.
-/

namespace MathlibExpansion
namespace Roots
namespace AtiyahMacdonald
namespace T20cLate01_RLH2

/-- **RLH2_03** regular-local characterization (2026-04-24). A Noetherian
local ring `(R, 𝔪)` is regular iff the minimal number of generators of `𝔪`
equals `ringKrullDim R`. This axiom states the implication: given a
generating set of `𝔪` with cardinality equal to `ringKrullDim R`, such a
generating set is *minimal* (no smaller generating set exists). Combined
with `KDH_07` (dim ≤ embedding dim) this gives the full characterization.

Sharp upstream-narrow axiom; prerequisite `KDH_07`.

Citation: Atiyah-Macdonald Ch. 11 Thm. 11.22, p. 121; Matsumura (1986)
Thm. 14.2. -/
axiom regularLocal_generator_minimality
    {R : Type*} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    (n : ℕ) (s : Finset R)
    (_hs_card : s.card = n)
    (_hs_span : Ideal.span (↑s : Set R) = IsLocalRing.maximalIdeal R)
    (_hs_dim : ringKrullDim R = (n : WithBot ℕ∞)) :
    ∀ (s' : Finset R),
      Ideal.span (↑s' : Set R) = IsLocalRing.maximalIdeal R →
      n ≤ s'.card

/-- **RLH2_04** finite-length / height-2 bridge (2026-04-24). For a
Noetherian local ring `(R, 𝔪)` with `ringKrullDim R ≥ 2`, every
`𝔪`-primary ideal contains two elements whose ideal has `𝔪` as radical
(i.e., a "system of parameters" of height 2).

Sharp upstream-narrow axiom; prerequisites `KDH_05`, `HFLD_04`.

Citation: Atiyah-Macdonald Ch. 11 Cor. 11.18, p. 120; Serre (1965) Ch. IV
§D. -/
axiom finiteLength_height_two_sop
    {R : Type*} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    (_hdim : (2 : WithBot ℕ∞) ≤ ringKrullDim R)
    (𝔮 : Ideal R) (_h𝔮 : 𝔮.IsPrimary)
    (_h𝔮_max : 𝔮.radical = IsLocalRing.maximalIdeal R) :
    ∃ (a b : R), a ∈ 𝔮 ∧ b ∈ 𝔮 ∧
      (Ideal.span ({a, b} : Set R)).radical = IsLocalRing.maximalIdeal R

/-- **RLH2_07** Iwasawa algebra regular-local closure (2026-04-24). The
Iwasawa algebra `Λ := ℤ_p[[T]] = PowerSeries (PadicInt p)` is a
2-dimensional Noetherian local commutative ring (regular local with
dimension exactly 2). This is the sharp axiom consumed by
`Roots/Iwasawa/Pseudo.lean` that Step 1 quarantined as poison if
axiomatized without the KDH + HFLD + RLH2_03 substrate.

Sharp upstream-narrow axiom; prerequisites `RLH2_03`, `RLH2_04`,
`ACCT_08` Washington seam.

Citation: Washington (1982) §§13.2–13.4, Thm. 13.12, p. 289;
Atiyah-Macdonald Ch. 11 §11.3. -/
axiom iwasawa_algebra_krullDim_eq_two
    (p : ℕ) [Fact p.Prime] :
    ringKrullDim (PowerSeries (PadicInt p)) = (2 : WithBot ℕ∞)

end T20cLate01_RLH2
end AtiyahMacdonald
end Roots
end MathlibExpansion
