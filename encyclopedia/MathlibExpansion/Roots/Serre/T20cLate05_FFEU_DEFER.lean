import Mathlib.FieldTheory.Finite.Basic

/-!
# T20c_late_05 FFEU_DEFER — Finite field existence & uniqueness (defer)

**Classification.** `defer` / Chapter I. Fully covered upstream by
`Mathlib.FieldTheory.Finite.{Basic,GaloisField}` and `ZMod` infrastructure:
existence of `F_{p^n}` for every prime power, uniqueness up to isomorphism,
and the Frobenius generator of `Gal(F_{p^n}/F_p)`.

**Citation.** Serre, *A Course in Arithmetic*, Ch. I §1.
Historical parent: Galois (1830) "Sur la théorie des nombres"; Moore (1896).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_FFEU

/-- **FFEU_01** citation marker. Finite fields exist uniquely for each prime
power order and Frobenius generates the Galois group. Fully upstream via
`GaloisField`, `ZMod p`, `FiniteField.card`.
Citation: Serre Ch. I §1. -/
axiom finite_field_existence_uniqueness_marker : True

end T20cLate05_FFEU
end Serre
end Roots
end MathlibExpansion
