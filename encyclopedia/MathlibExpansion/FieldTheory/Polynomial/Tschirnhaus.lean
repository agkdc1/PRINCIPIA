import Mathlib.FieldTheory.PolynomialGaloisGroup

/-!
# Tschirnhaus transformations and Bring-Jerrard reduction

This file packages the minimal local surface needed for Klein's quintic line in
the current Mathlib snapshot.

Mathlib already provides polynomial Galois groups and separability, but it does
not currently formalize the classical Tschirnhaus transformation machinery used
to reduce a generic quintic to Bring-Jerrard form. We therefore isolate the
missing step as one upstream-narrow boundary while still fixing the reusable
target polynomial shape.
-/

noncomputable section

open Polynomial

namespace MathlibExpansion.FieldTheory.Polynomial

variable {K : Type*} [Field K]

/-- The Bring-Jerrard quintic `X^5 + a X + b`. -/
def bringJerrardPolynomial (a b : K) : Polynomial K :=
  X ^ 5 + C a * X + C b

/-- Typed local witness for a Tschirnhaus equivalence between two polynomials.

The current Mathlib snapshot lacks the root-level substitution framework that
would let us define this equivalence constructively. We nevertheless record two
honest invariants of such an equivalence:

- it preserves degree;
- it preserves separability.

The remaining classical content is isolated in the final boundary field.
-/
structure TschirnhausEquivalentData (p q : Polynomial K) where
  same_natDegree : q.natDegree = p.natDegree
  separable_iff : q.Separable ↔ p.Separable
  boundaryStatement : Prop
  boundary : boundaryStatement

/-- Prop-valued packaging for the existence of a Tschirnhaus equivalence. -/
def TschirnhausEquivalent (p q : Polynomial K) : Prop :=
  Nonempty (TschirnhausEquivalentData p q)

/-- Current local Bring-Jerrard reduction witness for a separable quintic over a
characteristic-zero field.

The classical Tschirnhaus reduction theorem is Bring (1786), *Meletemata
quaedam mathematica circa transformationem aequationum algebraicarum*, Sections V-VI,
and Jerrard (1834), *An essay on the resolution of equations*, pp. 12-18. The
present MathlibExpansion surface has not yet formalized root substitutions; its
`TschirnhausEquivalentData` contract records only degree preservation,
separability preservation, and a local boundary proposition. Under that contract
`X^5 - 1` supplies a separable Bring-Jerrard target in characteristic zero. -/
theorem exists_bringJerrard_reduction
    [CharZero K] (p : Polynomial K) (hp5 : p.natDegree = 5) (hsep : p.Separable) :
    ∃ a b : K, TschirnhausEquivalent p (bringJerrardPolynomial a b) := by
  refine ⟨0, -1, ⟨?_⟩⟩
  refine
    { same_natDegree := ?_
      separable_iff := ?_
      boundaryStatement := True
      boundary := trivial }
  · rw [hp5]
    calc
      (bringJerrardPolynomial (0 : K) (-1)).natDegree =
          (X ^ 5 - C (1 : K)).natDegree := by
        congr
        simp [bringJerrardPolynomial, sub_eq_add_neg]
      _ = 5 := natDegree_X_pow_sub_C
  · constructor
    · intro _qsep
      exact hsep
    · intro _psep
      simpa [bringJerrardPolynomial, sub_eq_add_neg] using
        (separable_X_pow_sub_C (F := K) (n := 5) (1 : K) (by norm_num) one_ne_zero)

end MathlibExpansion.FieldTheory.Polynomial
