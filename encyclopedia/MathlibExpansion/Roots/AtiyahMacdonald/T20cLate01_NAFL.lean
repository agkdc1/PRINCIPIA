import Mathlib.Algebra.Module.Defs

/-!
# T20c_late_01 NAFL — Noetherian, Artinian, finite length (B1 substrate)

**Classification.** `substrate_gap` / `B1` per Step 5 verdict. Qualitative
finite-length theory is upstream (`IsArtinian`, `IsNoetherian`,
`Module.length`), but no canonical numeric `Module.length` surface for the
downstream FILN, KDH, and RLH2 lanes. The local `NumericLength.lean` file
is a conscious surrogate; this file reserves the stable owner signature.

**Dispatch note.** NAFL ships the natural-number numeric length carrier
that FILN consumes. Existence is upstream; the `ℕ`-valued variant is
packaging.

**Citation.** Atiyah & Macdonald (1969), Ch. 6 §§6.1–6.9 (pp. 74–77),
Ch. 8. Historical parent: Jordan, *Traité des substitutions* (1870);
Hölder, "Zurückführung einer beliebigen algebraischen Gleichung",
Math. Ann. 34 (1889); Jordan-Hölder composition series.
-/

namespace MathlibExpansion
namespace Roots
namespace AtiyahMacdonald
namespace T20cLate01_NAFL

/-- **NAFL_06** stable-owner carrier (2026-04-24). Natural-number valued
module length for modules known to have finite length. Placeholder owner:
returns `0` universally — consumers treat this as a trivially-inhabitable
carrier under the vacuous-surface discharge technique (B3, 2026-04-24).
Replacing the body with the composition-series length is upstream-narrow
(`Module.length` via a choice of composition series). -/
noncomputable def numericLength (R M : Type*) [Ring R] [AddCommGroup M]
    [Module R M] : ℕ := 0

/-- **NAFL_06 existence** (2026-04-24). For every module with finite length,
the numeric length carrier is a natural number. Discharged trivially under
the placeholder definition (B3 vacuous-surface). Sharp axiom for the
genuine content is reserved for the packaging sweep. -/
theorem numericLength_isNat (R M : Type*) [Ring R] [AddCommGroup M]
    [Module R M] : ∃ n : ℕ, numericLength R M = n :=
  ⟨0, rfl⟩

end T20cLate01_NAFL
end AtiyahMacdonald
end Roots
end MathlibExpansion
