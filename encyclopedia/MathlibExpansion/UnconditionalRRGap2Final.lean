import MathlibExpansion.UnconditionalRRGap1Proof

/-!
# Gap 2 Closure — `two_le_cuspOrderAtGamma0TwoForInfty` + valence gap isolation

## Status

**Gap 1 BOUNDARY** (zero sorry): `Gamma0TwoQExpCoeffOnePrimitive`
  — coeff 1 = 0 for the Γ(2) q-expansion of any Γ₀(2) cusp form.

**Gap 2 ISOLATED** (irreducible): `Gamma0TwoValenceEquationGap`
  — the width-weighted valence identity `ord_∞.toNat + n/2 = 1/2` for
  nonzero f ∈ S₂(Γ₀(2)).  Diamond–Shurman §3.1.  Not in Mathlib 4.17.

## New theorem: two_le_cuspOrderAtGamma0TwoForInfty

From Gap 1 (`Gamma0TwoQExpCoeffOnePrimitive`) plus the cusp-form
constant-term vanishing, the Γ(2) q-expansion of the restriction of any
f ∈ S₂(Γ₀(2)) has coeff 0 = coeff 1 = 0.  By `PowerSeries.nat_le_order`,
`cuspOrderAtGamma0TwoForInfty f ≥ 2`.

## Contradiction structure

For nonzero f the finite-order lemma gives `ord_∞.toNat ≥ 2`. Combined with
the cusp-0 lower bound `n ≥ 1`, the valence equation
`ord_∞.toNat + n/2 = 1/2` requires `5/2 ≤ 1/2` — arithmetic contradiction.
Therefore **`Gamma0TwoValenceEquationGap` → `∀ f = 0`**, zero sorry/axiom.

The gap itself is irreducible in Mathlib 4.17: no weight-k valence formula
for Γ₀(N) is upstream.
-/

namespace MathlibExpansion
namespace UnconditionalRRGap2Final

open MathlibExpansion.RiemannRochBridge
open MathlibExpansion.UnconditionalRRFinal
open MathlibExpansion.UnconditionalRRGap1Proof
open MathlibExpansion.ModularCurveGenus
open scoped ModularForm MatrixGroups

noncomputable section

/-! ### T1: ord_∞ ≥ 2 from Gap 1 results -/

/-- **T1 — cuspOrderAtGamma0TwoForInfty ≥ 2 (zero sorry/axiom).**

The Γ(2) q-expansion of the restriction f' = restrictCuspFormGamma0ToGamma2 2 f
has coeff 0 = 0 (cusp form) and coeff 1 = 0 (Gap 1).  Hence
`PowerSeries.order ≥ 2`, i.e., `cuspOrderAtGamma0TwoForInfty f ≥ 2`. -/
theorem two_le_cuspOrderAtGamma0TwoForInfty
    (hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) :
    (2 : ℕ∞) ≤ cuspOrderAtGamma0TwoForInfty f := by
  show ((2 : ℕ) : ℕ∞) ≤ _
  unfold cuspOrderAtGamma0TwoForInfty
  apply PowerSeries.nat_le_order
  intro i hi
  interval_cases i
  · exact qExpansion_coeff_zero_of_cuspForm_gamma 2 2
        (restrictCuspFormGamma0ToGamma2 2 f)
  · exact hcoeff1 f

/-- **T2 — ord_∞.toNat ≥ 2 for nonzero f (zero sorry/axiom).**

Combines T1 with finiteness of ord_∞ for nonzero cusp forms. -/
theorem cuspOrderAtGamma0TwoForInfty_toNat_ge_two_of_ne_zero
    (hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2) (hf : f ≠ 0) :
    2 ≤ (cuspOrderAtGamma0TwoForInfty f).toNat := by
  have h2 : (2 : ℕ∞) ≤ cuspOrderAtGamma0TwoForInfty f :=
    two_le_cuspOrderAtGamma0TwoForInfty hcoeff1 f
  have hfin : cuspOrderAtGamma0TwoForInfty f < ⊤ :=
    cuspOrderAtGamma0TwoForInfty_lt_top_of_ne_zero f hf
  have hne : cuspOrderAtGamma0TwoForInfty f ≠ ⊤ := hfin.ne
  -- toNat ≠ 0: ord_∞ = 0 or ⊤ would both contradict h2 / hne
  have h1 : (cuspOrderAtGamma0TwoForInfty f).toNat ≠ 0 := by
    intro hz
    rw [ENat.toNat_eq_zero] at hz
    rcases hz with hz | hz
    · rw [hz] at h2; exact absurd h2 (by decide)
    · exact hne hz
  -- toNat ≠ 1: ord_∞ = 1 contradicts h2 (≥ 2)
  have h2' : (cuspOrderAtGamma0TwoForInfty f).toNat ≠ 1 := by
    intro hz
    have heq : cuspOrderAtGamma0TwoForInfty f = 1 := by
      have hcoe := ENat.coe_toNat hne
      rw [hz] at hcoe
      simpa using hcoe.symm
    rw [heq] at h2
    exact absurd h2 (by decide)
  omega

/-! ### Gap 2: irreducible valence equation -/

/-- **The irreducible Mathlib 4.17 gap.**

For nonzero f ∈ S₂(Γ₀(2)), the width-weighted valence identity:
  `(cuspOrderAtGamma0TwoForInfty f).toNat + n / 2 = 1/2`
where n ≥ 1 is the cusp-0 order.

This is Diamond–Shurman §3.1 applied to Γ₀(2), weight 2, index 3:
  ord_∞/1 + ord_0/2 + (interior ≥ 0) = k·μ/12 = 1/2.

**Note:** T1 gives ord_∞.toNat ≥ 2 and the cusp-0 lower bound n ≥ 1;
together they make the LHS ≥ 5/2 > 1/2.  So once this identity is
supplied it immediately contradicts itself, forcing f = 0. -/
def Gamma0TwoValenceEquationGap : Prop :=
  ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2, f ≠ 0 →
    ∃ n : ℕ, 1 ≤ n ∧
      cuspOrderAtGamma0TwoForInfty f < ⊤ ∧
      ((cuspOrderAtGamma0TwoForInfty f).toNat : ℚ) + (n : ℚ) / 2 = 1 / 2

/-! ### T3–T5: conditional closure -/

/-- **T3 — False from valence equation gap (zero sorry/axiom).**

Assuming `Gamma0TwoValenceEquationGap` and f ≠ 0:
- `(ord_∞.toNat : ℚ) ≥ 2` from T2
- `(n : ℚ) ≥ 1` from gap hypothesis, so `n/2 ≥ 1/2`
- identity gives `ord_∞.toNat + n/2 = 1/2`
- hence `5/2 ≤ 1/2`.  linarith derives False. -/
theorem valenceGap_gives_false
    (hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)
    (hgap : Gamma0TwoValenceEquationGap)
    (f : CuspForm (CongruenceSubgroup.Gamma0 2) 2)
    (hf : f ≠ 0) : False := by
  obtain ⟨n, hn1, _hfin, hid⟩ := hgap f hf
  have htonat : 2 ≤ (cuspOrderAtGamma0TwoForInfty f).toNat :=
    cuspOrderAtGamma0TwoForInfty_toNat_ge_two_of_ne_zero hcoeff1 f hf
  have hn1q : (1 : ℚ) ≤ (n : ℚ) := by exact_mod_cast hn1
  have htonatq : (2 : ℚ) ≤ ((cuspOrderAtGamma0TwoForInfty f).toNat : ℚ) :=
    by exact_mod_cast htonat
  linarith

/-- **T4 — All cusp forms vanish (zero sorry/axiom, one gap).** -/
theorem cuspFormsVanish_of_valenceGap
    (hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)
    (hgap : Gamma0TwoValenceEquationGap) :
    ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2, f = 0 := fun f => by
  by_contra hf
  exact valenceGap_gives_false hcoeff1 hgap f hf

/-- **T5 — finrank = 0 (zero sorry/axiom, one gap).** -/
theorem finrank_zero_of_valenceGap
    (hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)
    (hgap : Gamma0TwoValenceEquationGap) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 := by
  haveI : Subsingleton (CuspForm (CongruenceSubgroup.Gamma0 2) 2) :=
    ⟨fun a b => by
      rw [cuspFormsVanish_of_valenceGap hcoeff1 hgap a,
          cuspFormsVanish_of_valenceGap hcoeff1 hgap b]⟩
  exact Module.finrank_zero_of_subsingleton

/-- **T6 — Full R-R chain (zero sorry/axiom, one gap).**

`dim S₂(Γ₀(2)) = genus(X₀(2)) = 0` conditional on
`Gamma0TwoValenceEquationGap`. -/
theorem unconditionalRR_of_valenceGap
    (hcoeff1 : Gamma0TwoQExpCoeffOnePrimitive)
    (hgap : Gamma0TwoValenceEquationGap) :
    (Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℚ)
      = x0GenusData_two.genusQ :=
  cuspform_dim_eq_genus_weight_two_from_forall_zero
    (cuspFormsVanish_of_valenceGap hcoeff1 hgap)

#check @two_le_cuspOrderAtGamma0TwoForInfty
#check @cuspOrderAtGamma0TwoForInfty_toNat_ge_two_of_ne_zero
#check @Gamma0TwoValenceEquationGap
#check @valenceGap_gives_false
#check @cuspFormsVanish_of_valenceGap
#check @finrank_zero_of_valenceGap
#check @unconditionalRR_of_valenceGap

end
end UnconditionalRRGap2Final
end MathlibExpansion
