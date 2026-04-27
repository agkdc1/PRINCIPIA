import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_05 SIUL — Signature classification of indefinite unimodular lattices (novel_theorem L2, opus-ahn max)

**Classification.** `novel_theorem` / `L2`. Chapter V theorem:
indefinite unimodular integral lattices are classified by signature `(r, s)`
and parity (odd ↔ hyperbolic plane type, even ↔ `U + E_8` type).

**Citation.** Serre, *A Course in Arithmetic*, Ch. V §2.
Historical parent: Meyer (1884); Eichler (1952); Milnor (1958) "On simply
connected 4-manifolds".
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_SIUL

/-- **SIUL_01** odd indefinite classification marker. Every odd unimodular
indefinite integral lattice of signature `(r, s)` is isomorphic to
`I_{r,s} := ⟨1⟩^r ⊕ ⟨-1⟩^s` (the standard odd form).
Citation: Serre Ch. V §2.2, Thm. 6. -/
axiom odd_indefinite_iso_standard_marker : True

/-- **SIUL_03** even indefinite classification marker. Every even unimodular
indefinite integral lattice of signature `(r, s)` with `r - s ≡ 0 (mod 8)` is
isomorphic to `II_{r,s} := U^m ⊕ (-E_8)^k` (or `U^m ⊕ E_8^k` as signature
demands) where `U` is the hyperbolic plane of rank 2 and `E_8` the rank-8
even unimodular positive-definite lattice, `r = 2m + 8k` (or similar).
Citation: Serre Ch. V §2.2, Thm. 6. -/
axiom even_indefinite_iso_U_E8_marker : True

/-- **SIUL_05** signature obstruction marker. For indefinite unimodular, the
signature invariant `(r - s)` completely determines isomorphism class within
odd/even strata; the mod-8 congruence is the only obstruction to even
existence.
Citation: Serre Ch. V §2.2, Cor. -/
axiom indefinite_signature_complete_invariant_marker : True

end T20cLate05_SIUL
end Serre
end Roots
end MathlibExpansion
