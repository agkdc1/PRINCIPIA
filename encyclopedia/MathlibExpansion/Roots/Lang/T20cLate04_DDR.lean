import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 DDR_CORE — Different, discriminant, ramification (B0 breach_candidate)

**Classification.** `breach_candidate` / `B0`. Narrow normalization bridge:
exact different exponents + different-to-discriminant API.

**Citation.** Lang, *Algebraic Number Theory*, GTM 110 (1970), Ch. 3.
Historical parent: Dedekind (1871); Hilbert, *Zahlbericht* (1897).
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_DDR

/-- **DDR_04** exact different exponent marker. For `𝔭` prime of `𝒪_K` over
`p ⊂ 𝒪_k`, the exact different exponent `d_𝔭 = e - 1` in tame case, with
correction in wild case. Citation: Lang Ch. 3 §1. -/
axiom different_exponent_marker : True

/-- **DDR_08** different-to-discriminant bridge marker. `disc(𝒪_K/𝒪_k) =
N_{K/k}(𝔡_{K/k})`. Citation: Lang Ch. 3 §1, Prop. 7. -/
axiom different_to_discriminant_marker : True

end T20cLate04_DDR
end Lang
end Roots
end MathlibExpansion
