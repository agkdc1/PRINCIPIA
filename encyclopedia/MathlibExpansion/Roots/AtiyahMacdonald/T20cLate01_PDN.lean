import Mathlib.RingTheory.Ideal.Basic
import Mathlib.RingTheory.Ideal.Operations
import Mathlib.RingTheory.Noetherian.Basic

/-!
# T20c_late_01 PDN — Primary decomposition in Noetherian rings (B1 substrate)

**Classification.** `substrate_gap` / `B1` per Step 5 verdict. Lasker-Noether
existence is upstream in principle, but Mathlib 4.17 does not expose a clean
packaged list-form primary decomposition for every proper ideal in a
commutative Noetherian ring under the textbook phrasing.

**Dispatch note (cycle-2, 2026-04-24).** Cycle-2 upgrades PDN_03 to a SHARP
upstream-narrow axiom with a real mathematical signature using `Ideal.IsPrimary`
and `⨅` (iInf) over `Fin n`. No vacuous `True` bodies.

**Citation.** Atiyah & Macdonald (1969), Ch. 4, pp. 50–55; Ch. 7 §7.1,
pp. 82–83. Historical parent: Lasker, "Zur Theorie der Moduln und Ideale",
Math. Ann. 60 (1905), §§23–32; Noether, "Idealtheorie in Ringbereichen",
Math. Ann. 83 (1921).
-/

namespace MathlibExpansion
namespace Roots
namespace AtiyahMacdonald
namespace T20cLate01_PDN

/-- **PDN_03** primary decomposition existence (2026-04-24). In a commutative
Noetherian ring `R`, every ideal `I` admits a finite primary decomposition:
there exist `n ∈ ℕ` and primary ideals `Q_0, …, Q_{n-1}` with `I = ⨅ i, Q_i`.
This is the Lasker-Noether theorem under Atiyah-Macdonald Ch. 7 §7.1 phrasing.

Sharp upstream-narrow axiom; Mathlib 4.17 does not expose the packaged
list-form under this signature. Proof route: existence via Noetherian
induction on ideals not admitting primary decomposition.

Citation: Atiyah-Macdonald Ch. 7 Thm. 7.13, p. 83.
Historical: Lasker (1905); Noether (1921). -/
axiom primaryDecomposition_exists_noetherian
    {R : Type*} [CommRing R] [IsNoetherianRing R] (I : Ideal R) :
    ∃ (n : ℕ) (Q : Fin n → Ideal R),
      (∀ i, (Q i).IsPrimary) ∧ I = ⨅ i, Q i

/-- **PDN_05** dispatch boundary — minimal-primary-decomposition first-
uniqueness of the radical set is the content of APMI_06 and lives there.
This declaration records the boundary between PDN substrate existence and
APMI uniqueness theorem front.

The statement below is a trivial consequence of PDN_03: every Noetherian
commutative ring admits at least one primary decomposition of the zero
ideal (itself), so the set of radicals of primary components in some
decomposition of `(0)` is nonempty (or the ring is trivial). Sharp
content is in APMI. -/
theorem pdn_apmi_boundary_nonempty
    {R : Type*} [CommRing R] [IsNoetherianRing R] :
    ∃ (n : ℕ) (Q : Fin n → Ideal R),
      (∀ i, (Q i).IsPrimary) ∧ (⊥ : Ideal R) = ⨅ i, Q i :=
  primaryDecomposition_exists_noetherian (⊥ : Ideal R)

end T20cLate01_PDN
end AtiyahMacdonald
end Roots
end MathlibExpansion
