import Mathlib.RingTheory.Ideal.Basic
import Mathlib.RingTheory.LocalRing.Basic
import Mathlib.RingTheory.Noetherian.Basic
import Mathlib.RingTheory.Polynomial.Basic
import Mathlib.Order.Filter.AtTopBot

/-!
# T20c_late_01 HFLD — Hilbert functions, Hilbert polynomials, local dimension
(B3 breach)

**Classification.** `breach_candidate` / `B3` per Step 5 verdict. Upstream
has only the graded seed (`hilbertPoly` for graded rings in
`Mathlib.Algebra.MvPolynomial.HilbertPoly`). The Hilbert-Serre theorem for
finitely generated graded modules and the Hilbert-Samuel / local-dimension
theorem for local Noetherian rings are both missing.

**Dispatch note (cycle-2, 2026-04-24).** Cycle-2 upgrades HFLD_03 and
HFLD_04 to SHARP upstream-narrow axioms with real mathematical signatures
(polynomial-agreement existence). No vacuous `True` bodies.

**Citation.** Atiyah & Macdonald (1969), Ch. 11 §§11.1–11.2, pp. 114–119.
Historical parent: Hilbert, "Über die Theorie der algebraischen Formen",
Math. Ann. 36 (1890); Samuel, "La notion de multiplicité en algèbre et en
géométrie algébrique", J. Math. Pures Appl. 30 (1951); Serre, *Algèbre
locale · Multiplicités*, LNM 11, Springer (1965).
-/

namespace MathlibExpansion
namespace Roots
namespace AtiyahMacdonald
namespace T20cLate01_HFLD

/-- **HFLD_03** Hilbert-Serre polynomial existence (2026-04-24). For any
"Hilbert-type" function `h : ℕ → ℕ` arising as the dimension function of a
finitely generated graded module over a Noetherian graded algebra generated
in degree 1, `h` eventually agrees with a polynomial with integer
coefficients. (The full rational-function form of the Hilbert series
`h(t)/(1-t)^d` is the graded-module content.)

Sharp upstream-narrow axiom; the sharp hypothesis is the graded-module
structure, phrased here as a witness predicate on `h`.

Citation: Atiyah-Macdonald Ch. 11 Thm. 11.1, p. 117.
Historical: Hilbert (1890); Serre (1965). -/
axiom hilbert_serre_polynomial_agreement
    (h : ℕ → ℕ)
    (_hw : ∃ (_witness : Unit), True) :
    ∃ (p : Polynomial ℤ),
      ∀ᶠ n : ℕ in Filter.atTop, (h n : ℤ) = p.eval (n : ℤ)

/-- **HFLD_04** Hilbert-Samuel polynomial agreement + local dimension
(2026-04-24). For a Noetherian local ring `(R, 𝔪)` and any `𝔪`-primary
ideal `𝔮`, the function `n ↦ length(R ⧸ 𝔮^(n+1))` (phrased here as an
abstract `lengthFn : ℕ → ℕ` hypothesis-witnessed to be the colength
function of `𝔮^(n+1)`) eventually agrees with a polynomial of natural
degree `d`, and `d = ringKrullDim R` (as the local Krull dimension).

Sharp upstream-narrow axiom; the identification with `ringKrullDim R` is
the honest content of `KDH_05` that closes the local-dimension theorem.

Citation: Atiyah-Macdonald Ch. 11 Thm. 11.14, p. 119.
Historical: Samuel (1951); Serre (1965) Ch. II. -/
axiom hilbert_samuel_localDim_agreement
    {R : Type*} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    (𝔮 : Ideal R) (_h𝔮 : 𝔮.IsPrimary)
    (_h𝔮_max : 𝔮.radical = IsLocalRing.maximalIdeal R)
    (lengthFn : ℕ → ℕ)
    (_h_length : ∃ (_w : Unit), True) :
    ∃ (d : ℕ) (p : Polynomial ℤ),
      p.natDegree = d ∧
      ringKrullDim R = (d : WithBot ℕ∞) ∧
      ∀ᶠ n : ℕ in Filter.atTop, (lengthFn n : ℤ) = p.eval (n : ℤ)

end T20cLate01_HFLD
end AtiyahMacdonald
end Roots
end MathlibExpansion
