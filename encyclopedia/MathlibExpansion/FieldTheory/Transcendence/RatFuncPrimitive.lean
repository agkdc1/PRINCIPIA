import Mathlib.FieldTheory.RatFunc.Degree
import Mathlib.FieldTheory.RatFunc.AsPolynomial
import Mathlib.FieldTheory.IntermediateField.Adjoin.Algebra

/-!
# Primitive elements of rational function fields

Mathlib already has the rational-function carrier and the integer degree
invariant. The earlier facade used `RatFunc.intDegree y = 1` as a proxy for
degree-one rational maps. That proxy is not sound: `RatFunc.X⁻¹` also
generates `F(X)`, but its integer degree is `-1`.

This file keeps the Steinitz primitive-generator boundary honest by proving
the currently available substrate: the coordinate `X` generates `F(X)`, its
inverse also generates `F(X)`, and the inverse-coordinate example refutes the
old `intDegree = 1` facade.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 5`, item `7`,
  p. 190.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.Transcendence

private theorem ratfunc_polynomial_mem_adjoin_X (F : Type*) [Field F] (p : Polynomial F) :
    algebraMap (Polynomial F) (RatFunc F) p ∈
      IntermediateField.adjoin F ({RatFunc.X} : Set (RatFunc F)) := by
  let K : IntermediateField F (RatFunc F) :=
    IntermediateField.adjoin F ({RatFunc.X} : Set (RatFunc F))
  have hp_alg :
      Polynomial.aeval (RatFunc.X : RatFunc F) p ∈
        Algebra.adjoin F ({RatFunc.X} : Set (RatFunc F)) := by
    exact Polynomial.aeval_mem_adjoin_singleton
      (R := F) (x := (RatFunc.X : RatFunc F)) (p := p)
  have hle :
      Algebra.adjoin F ({RatFunc.X} : Set (RatFunc F)) ≤ K.toSubalgebra :=
    IntermediateField.algebra_adjoin_le_adjoin F ({RatFunc.X} : Set (RatFunc F))
  have hpK : Polynomial.aeval (RatFunc.X : RatFunc F) p ∈ K := hle hp_alg
  rwa [show Polynomial.aeval (RatFunc.X : RatFunc F) p =
      algebraMap (Polynomial F) (RatFunc F) p by
    rw [Polynomial.aeval_def]
    exact Polynomial.eval₂_algebraMap_X p
      (IsScalarTower.toAlgHom F (Polynomial F) (RatFunc F))] at hpK

/-- The coordinate rational function `X` generates the rational function field `F(X)`. -/
theorem ratfunc_X_adjoin_eq_top (F : Type*) [Field F] :
    IntermediateField.adjoin F ({RatFunc.X} : Set (RatFunc F)) = ⊤ := by
  let K : IntermediateField F (RatFunc F) :=
    IntermediateField.adjoin F ({RatFunc.X} : Set (RatFunc F))
  rw [eq_top_iff]
  intro z _hz
  induction z using RatFunc.induction_on with
  | f p q hq =>
      exact K.div_mem (ratfunc_polynomial_mem_adjoin_X F p)
        (ratfunc_polynomial_mem_adjoin_X F q)

/-- The coordinate rational function is primitive and has integer degree one. -/
theorem ratfunc_X_primitive_and_intDegree_eq_one (F : Type*) [Field F] :
    IntermediateField.adjoin F ({RatFunc.X} : Set (RatFunc F)) = ⊤ ∧
      RatFunc.intDegree (RatFunc.X : RatFunc F) = 1 := by
  exact ⟨ratfunc_X_adjoin_eq_top F, RatFunc.intDegree_X⟩

/-- The inverse coordinate also generates the rational function field `F(X)`. -/
theorem ratfunc_inv_X_adjoin_eq_top (F : Type*) [Field F] :
    IntermediateField.adjoin F ({((RatFunc.X : RatFunc F)⁻¹)} : Set (RatFunc F)) = ⊤ := by
  let K : IntermediateField F (RatFunc F) :=
    IntermediateField.adjoin F ({((RatFunc.X : RatFunc F)⁻¹)} : Set (RatFunc F))
  have hXinv : ((RatFunc.X : RatFunc F)⁻¹) ∈ K :=
    IntermediateField.subset_adjoin F _ (Set.mem_singleton _)
  have hX : RatFunc.X ∈ K := by
    simpa using K.inv_mem hXinv
  rw [eq_top_iff]
  intro z hz
  rw [← ratfunc_X_adjoin_eq_top F] at hz
  exact (IntermediateField.adjoin_le_iff.mpr (Set.singleton_subset_iff.mpr hX)) hz

/-- `RatFunc.intDegree` records pole order at infinity, so the inverse coordinate has degree `-1`. -/
theorem ratfunc_intDegree_inv_X (F : Type*) [Field F] :
    RatFunc.intDegree ((RatFunc.X : RatFunc F)⁻¹) = -1 := by
  have hmul :=
    RatFunc.intDegree_mul (K := F) (x := (RatFunc.X : RatFunc F))
      (y := (RatFunc.X : RatFunc F)⁻¹) RatFunc.X_ne_zero
      (inv_ne_zero RatFunc.X_ne_zero)
  rw [mul_inv_cancel₀ RatFunc.X_ne_zero, RatFunc.intDegree_one, RatFunc.intDegree_X] at hmul
  omega

/-- The inverse-coordinate example refutes the old `intDegree = 1` primitive facade. -/
theorem ratfunc_inv_X_refutes_intDegree_eq_one_facade (F : Type*) [Field F] :
    ¬ (IntermediateField.adjoin F ({((RatFunc.X : RatFunc F)⁻¹)} : Set (RatFunc F)) = ⊤ ↔
      RatFunc.intDegree ((RatFunc.X : RatFunc F)⁻¹) = 1) := by
  intro h
  have hdeg := h.mp (ratfunc_inv_X_adjoin_eq_top F)
  rw [ratfunc_intDegree_inv_X] at hdeg
  norm_num at hdeg

end MathlibExpansion.FieldTheory.Transcendence
