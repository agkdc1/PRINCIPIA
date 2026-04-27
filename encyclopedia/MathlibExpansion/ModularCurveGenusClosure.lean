import MathlibExpansion.RiemannRochBridge

/-!
# Unproved-declaration replacement closure for the Riemann–Roch bridge at `(N,k) = (2,2)`

The former unproved declaration `cuspform_dim_eq_genus_weight_two` of statement
`(Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℚ) =
x0GenusData_two.genusQ`, formerly stated in `MathlibExpansion.ModularCurveGenus`,
has been replaced by a real theorem consuming the precisely-named analytic
primitive
`MathlibExpansion.RiemannRochBridge.Gamma0TwoCuspFormValenceIdentityPrimitive`
(the width-weighted weight-two valence identity at the cusp `0` of `Γ₀(2)`,
Diamond–Shurman §3.1; Mathlib 4.17 gap: cusp-function slash-action identity
at non-`∞` cusps).

Because the analytic primitive and the conditional proof
`cuspform_dim_eq_genus_weight_two_from_identity_primitive` live in
`RiemannRochBridge.lean`, which already imports `ModularCurveGenus.lean`,
the replacement theorem cannot live inside `ModularCurveGenus.lean` itself
without a circular import.  Instead we place it downstream in this closure
module and **re-open the `MathlibExpansion.ModularCurveGenus` namespace**, so
that the fully-qualified name
`MathlibExpansion.ModularCurveGenus.cuspform_dim_eq_genus_weight_two`
is preserved and every existing consumer (notably
`NumberTheory.weight_two_level_two_empty` in `ThirteenthGap.lean`) keeps
working with only a hypothesis threading through.

This module also exports the former
`MathlibExpansion.ModularCurveGenus.dim_S2_Gamma0_two_eq_zero` downstream of
the bridge, now likewise hypothesis-threaded.
-/

namespace MathlibExpansion
namespace ModularCurveGenus

open MathlibExpansion.RiemannRochBridge

/-- Riemann–Roch bridge at weight 2, level 2, as a **real theorem** (no
`axiom`, no `sorry`) consuming the weight-two width-weighted valence identity
primitive for `Γ₀(2)`. Preserves the fully-qualified name
`MathlibExpansion.ModularCurveGenus.cuspform_dim_eq_genus_weight_two` through
namespace re-opening. -/
theorem cuspform_dim_eq_genus_weight_two
    (h : Gamma0TwoCuspFormValenceIdentityPrimitive) :
    (Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℚ)
      = x0GenusData_two.genusQ :=
  cuspform_dim_eq_genus_weight_two_from_identity_primitive h

/-- Vanishing of the weight-two level-two cusp-form space, now derived from
`cuspform_dim_eq_genus_weight_two` (a theorem) plus the combinatorial genus
computation `x0GenusData_two_genusQ`. Preserves the fully-qualified name
`MathlibExpansion.ModularCurveGenus.dim_S2_Gamma0_two_eq_zero` through
namespace re-opening. -/
theorem dim_S2_Gamma0_two_eq_zero
    (h : Gamma0TwoCuspFormValenceIdentityPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 := by
  have hb := cuspform_dim_eq_genus_weight_two h
  rw [x0GenusData_two_genusQ] at hb
  exact_mod_cast hb

#check @cuspform_dim_eq_genus_weight_two
#check @dim_S2_Gamma0_two_eq_zero

end ModularCurveGenus
end MathlibExpansion
