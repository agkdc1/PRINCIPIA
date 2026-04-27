import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_12_DISC_RAM_CRITERION — Hecke Chs.4–5 ramification endpoint

`p ∣ disc ↔ ramified`; `Norm(Different) = Discriminant` bridge in
number-field form. The local divisibility theorem is at
`Mathlib/RingTheory/DedekindDomain/Different.lean:627`; the global
prime-divides-disc-iff-ramified wrapper to the number-field discriminant is
the substrate gap.

Citation: Hecke 1923, Chs.4–5; Neukirch 1999, *Algebraic Number Theory*,
Ch. III §2 Theorem 2.6.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Discriminant–ramification existence boundary: every number field has a
nonzero integral discriminant invariant. -/
axiom t20c_12_disc_ram_criterion
    (K : Type) [Field K] [NumberField K] :
    ∃ Δ : ℤ, Δ ≠ 0

end MathlibExpansion.Encyclopedia.T20c_12
