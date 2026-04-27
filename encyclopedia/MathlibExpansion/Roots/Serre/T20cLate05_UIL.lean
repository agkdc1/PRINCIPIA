import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_05 UIL — Unimodular integral quadratic lattices (substrate_gap L1)

**Classification.** `substrate_gap` / `L1`. Chapter V carrier: integral
quadratic lattice `(L, q)` with `L ≅ ℤ^n`, `q : L → ℤ` non-degenerate;
unimodular iff `det(Gram matrix) = ±1`; parity (even iff `q(x) ∈ 2ℤ` ∀x).

**Citation.** Serre, *A Course in Arithmetic*, Ch. V §1.
Historical parent: Minkowski (1884); Eichler, *Quadratische Formen und
orthogonale Gruppen* (1952).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_UIL

/-- **UIL_01** unimodular criterion marker. Integral lattice `(L, q)` with
Gram matrix `A ∈ M_n(ℤ)` (relative to any `ℤ`-basis) is unimodular iff
`det(A) = ±1`, equivalently the dual lattice `L^# := {x ∈ L ⊗ ℚ : q(x,L) ⊆ ℤ}`
equals `L`.
Citation: Serre Ch. V §1.3, Def.–Prop. 1. -/
axiom lattice_unimodular_iff_det_one_marker : True

/-- **UIL_03** parity well-defined marker. For unimodular integral lattice `L`,
the property "every `x ∈ L` satisfies `q(x) ∈ 2ℤ`" is basis-independent;
equivalent conditions: the canonical quadratic form `q̄` on `L/2L` is zero,
Gram matrix has even diagonal in any basis.
Citation: Serre Ch. V §1.3.5, Prop. 2. -/
axiom lattice_parity_well_defined_marker : True

/-- **UIL_05** even unimodular rank-and-signature constraint marker. An even
unimodular lattice `(L, q)` of signature `(r, s)` satisfies `r - s ≡ 0 (mod 8)`;
equivalently such lattices exist iff rank ≥ 8 and rank ≡ 0 (mod 8) when
positive-definite.
Citation: Serre Ch. V §2.1, Thm. 5 (van der Blij). -/
axiom even_unimodular_signature_mod8_marker : True

end T20cLate05_UIL
end Serre
end Roots
end MathlibExpansion
