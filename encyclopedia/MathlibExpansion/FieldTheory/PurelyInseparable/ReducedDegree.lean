import MathlibExpansion.FieldTheory.PurelyInseparable.Exponent
import Mathlib.FieldTheory.SeparableClosure

/-!
# Reduced degree package boundary

This chapter lands the numerical `SPI_REDUCED` surface. Mathlib already has
the global product formula `finSepDegree * finInsepDegree = finrank`; the
textbook-facing `n * p^f` package is recovered here by induction over finite
intermediate fields and Mathlib's separable-contraction theorem for irreducible
polynomials.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 14`,
  theorem `6`, pp. 239-242 (`SPI_10`).

Formal substrate:
- `Polynomial.HasSeparableContraction.dvd_degree'`, Mathlib's formalization
  that an irreducible minimal polynomial has degree equal to its separable
  contraction degree times a power of the exponential characteristic.
- `IntermediateField.induction_on_adjoin`, Mathlib's finite-intermediate-field
  induction principle.
- `Field.finSepDegree_mul_finSepDegree_of_isAlgebraic` and
  `Module.finrank_mul_finrank`, Mathlib's tower laws for separable degree and
  finite rank.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.PurelyInseparable

open IntermediateField

private theorem exists_minpoly_natSepDegree_mul_pow_eq_natDegree
    {F E : Type*} [Field F] [Field E] [Algebra F E]
    (q : ℕ) [ExpChar F q] {x : E} (hx : IsIntegral F x) :
    ∃ e : ℕ, (minpoly F x).natSepDegree * q ^ e =
      (minpoly F x).natDegree := by
  classical
  let hcontraction := (minpoly.irreducible hx).hasSeparableContraction q
  rcases hcontraction.dvd_degree' with ⟨e, he⟩
  refine ⟨e, ?_⟩
  simpa [hcontraction.natSepDegree_eq] using he

private theorem exists_finrank_adjoin_simple_eq_finSepDegree_mul_pow
    {F E : Type*} [Field F] [Field E] [Algebra F E]
    (q : ℕ) [ExpChar F q] (x : E) (hx : IsIntegral F x) :
    ∃ e : ℕ, Module.finrank F F⟮x⟯ =
      Field.finSepDegree F F⟮x⟯ * q ^ e := by
  rcases exists_minpoly_natSepDegree_mul_pow_eq_natDegree (F := F) (E := E) q hx with
    ⟨e, he⟩
  refine ⟨e, ?_⟩
  rw [IntermediateField.adjoin.finrank hx,
    IntermediateField.finSepDegree_adjoin_simple_eq_natSepDegree F E hx.isAlgebraic,
    he]

private theorem exists_finrank_eq_finSepDegree_mul_pow
    (F E : Type*) [Field F] [Field E] [Algebra F E]
    (q : ℕ) [Fact q.Prime] [CharP F q] [FiniteDimensional F E] :
    ∃ e : ℕ, Module.finrank F E = Field.finSepDegree F E * q ^ e := by
  classical
  letI : ExpChar F q := ExpChar.prime Fact.out
  have htop :
      ∃ e : ℕ, Module.finrank F (⊤ : IntermediateField F E) =
        Field.finSepDegree F (⊤ : IntermediateField F E) * q ^ e := by
    refine IntermediateField.induction_on_adjoin
      (F := F) (E := E)
      (P := fun K : IntermediateField F E =>
        ∃ e : ℕ, Module.finrank F K = Field.finSepDegree F K * q ^ e)
      ?base ?step ⊤
    · refine ⟨0, ?_⟩
      simp
    · intro L x hL
      rcases hL with ⟨eL, hL⟩
      haveI : ExpChar L q := IntermediateField.expChar L q
      let M : IntermediateField L E := L⟮x⟯
      have hx : IsIntegral L x := (IsAlgebraic.of_finite L x).isIntegral
      rcases exists_finrank_adjoin_simple_eq_finSepDegree_mul_pow
          (F := L) (E := E) q x hx with ⟨eM, hM⟩
      refine ⟨eL + eM, ?_⟩
      change Module.finrank F M =
        Field.finSepDegree F M * q ^ (eL + eM)
      calc
        Module.finrank F M =
            Module.finrank F L * Module.finrank L M := by
          rw [Module.finrank_mul_finrank F L M]
        _ = (Field.finSepDegree F L * q ^ eL) *
            (Field.finSepDegree L M * q ^ eM) := by
          rw [hL, hM]
        _ = (Field.finSepDegree F L * Field.finSepDegree L M) *
            q ^ (eL + eM) := by
          rw [pow_add]
          ac_rfl
        _ = Field.finSepDegree F M * q ^ (eL + eM) := by
          haveI : Algebra.IsAlgebraic F L := Algebra.IsAlgebraic.of_finite F L
          rw [Field.finSepDegree_mul_finSepDegree_of_isAlgebraic F L M]
  simpa using htop

/-- The extension-level exponent obtained from Steinitz's reduced-degree
formula: the natural number `e` such that `[E:F] = [E:F]_s * q^e`.

This is the finite-extension degree exponent, not the element-level exponent
`insepExponent` from `Exponent.lean`. It is chosen from the proof above, whose
historical source is E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 14`, theorem `6`, pp. 239-242 (`SPI_10`). -/
noncomputable def extensionInsepExponent
    (F E : Type*) [Field F] [Field E] [Algebra F E]
    (q : ℕ) [Fact q.Prime] [CharP F q] [FiniteDimensional F E] :
    ℕ :=
  Classical.choose
    (exists_finrank_eq_finSepDegree_mul_pow (F := F) (E := E) q)

/-- Steinitz's reduced-degree product formula.

Historical source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 14`, theorem `6`, pp. 239-242 (`SPI_10`). The Lean proof reduces the
finite extension to simple adjunctions and uses Mathlib's separable-contraction
degree theorem for irreducible minimal polynomials. -/
theorem finrank_eq_finSepDegree_mul_pow_extensionInsepExponent
    (F E : Type*) [Field F] [Field E] [Algebra F E]
    (q : ℕ) [Fact q.Prime] [CharP F q] [FiniteDimensional F E] :
    Module.finrank F E =
      Field.finSepDegree F E * q ^ extensionInsepExponent F E q := by
  classical
  exact Classical.choose_spec
    (exists_finrank_eq_finSepDegree_mul_pow (F := F) (E := E) q)

end MathlibExpansion.FieldTheory.PurelyInseparable
