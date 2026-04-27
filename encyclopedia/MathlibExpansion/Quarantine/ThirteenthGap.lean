/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.TwelfthGap
import MathlibExpansion.ModularCurveGenus
import MathlibExpansion.ModularCurveGenusClosure

/-!
# Frey curves, level lowering, and the FLT finale

This file supplies the thirteenth FLT-chain interface: the final bridge from a
hypothetical Fermat solution to a contradiction. It records:

* primitive nonzero Fermat solutions of exponent `p`;
* the Frey curve attached to such a solution;
* semistability, conductor control, and irreducibility of the mod-`p`
  representation;
* Ribet level lowering to weight two and level two;
* emptiness of weight-two level-two cusp forms;
* the final contradiction proving Fermat's Last Theorem.

The missing arithmetic geometry is packaged as explicit propositions where the
current interfaces allow it. The final integrated contradiction remains marked
as a deep Mathlib obligation.
-/

namespace NumberTheory

/--
A primitive nonzero integer solution to Fermat's equation at exponent `p`.
-/
structure FermatSolution where
  a : ℤ
  b : ℤ
  c : ℤ
  p : ℕ
  exponentAtLeastThree : 3 ≤ p
  equation : a ^ p + b ^ p = c ^ p
  primitive : Int.gcd (Int.gcd a b) c = 1
  abcNonzero : a * b * c ≠ 0

/-- The exponent of a Fermat solution is nonzero. -/
theorem FermatSolution.exponent_ne_zero (s : FermatSolution) : s.p ≠ 0 :=
  Nat.ne_of_gt (lt_of_lt_of_le (by decide : 0 < 3) s.exponentAtLeastThree)

/-- The exponent of a Fermat solution is positive. -/
theorem FermatSolution.exponent_pos (s : FermatSolution) : 0 < s.p :=
  Nat.pos_of_ne_zero s.exponent_ne_zero

/--
The Frey curve associated to a Fermat solution.

The coefficients are recorded as integers so downstream files can connect this
to a concrete Weierstrass model when the necessary integral minimal-model API is
available. The curve itself is a Mathlib `WeierstrassCurve ℤ`.
-/
structure FreyCurve (s : FermatSolution) where
  curve : WeierstrassCurve ℤ
  isElliptic : curve.IsElliptic
  a₁ : ℤ
  a₂ : ℤ
  a₃ : ℤ
  a₄ : ℤ
  a₆ : ℤ
  coefficientsMatchSolution : Prop
  coefficients : coefficientsMatchSolution

attribute [instance] FreyCurve.isElliptic

/-- View a Frey curve as a semistable elliptic curve package. -/
def FreyCurve.semistable (s : FermatSolution) (F : FreyCurve s)
    (semistableCondition : Prop) (hsemistable : semistableCondition) :
    SemistableEllipticCurve F.curve where
  semistable := semistableCondition
  condition := hsemistable

/--
Conductor data for a Frey curve, including the divisibility statement needed
before level lowering.
-/
structure FreyConductor (s : FermatSolution) (F : FreyCurve s) where
  data : EllipticCurveConductorData F.curve
  dividesTwoRadicalABC : Prop
  divisibility : dividesTwoRadicalABC
  minimalOutsideTwo : Prop
  minimality : minimalOutsideTwo

/-- Recover the conductor divisibility statement for a Frey curve. -/
theorem FreyCurve.conductor (s : FermatSolution) (F : FreyCurve s)
    (N : FreyConductor s F) : N.dividesTwoRadicalABC :=
  N.divisibility

/--
Irreducibility of the mod-`p` representation attached to the Frey curve.
-/
structure FreyModPIrreducible (s : FermatSolution) (F : FreyCurve s) where
  representationType : Type*
  irreducible : Prop
  proof : irreducible

/-- Recover irreducibility of the Frey mod-`p` representation. -/
theorem FreyCurve.modPIrreducible (s : FermatSolution) (F : FreyCurve s)
    (ρ : FreyModPIrreducible s F) : ρ.irreducible :=
  ρ.proof

/--
Ribet level lowering for the Frey representation.

The proposition `loweredToLevelTwo` records the existence of the weight-two
level-two newform congruent to the Frey representation.
-/
structure RibetLevelLowering (s : FermatSolution) (F : FreyCurve s) where
  semistable : SemistableEllipticCurve F.curve
  conductor : FreyConductor s F
  irreducible : FreyModPIrreducible s F
  neronComponentGroup : NeronComponentGroup
  multiplicityOneInput : Prop
  multiplicityOne : multiplicityOneInput
  loweredToLevelTwo : Prop
  levelLowered : loweredToLevelTwo

/-- Recover the level-lowered form-existence statement. -/
theorem RibetLevelLowering.levelLowered_holds {s : FermatSolution} {F : FreyCurve s}
    (h : RibetLevelLowering s F) : h.loweredToLevelTwo :=
  h.levelLowered

/--
There are no weight-two level-two cusp forms giving the level-lowered Frey
representation.

This package is intentionally abstract: in Mathlib 4.17 the available
modular-form API defines `CuspForm (CongruenceSubgroup.Gamma0 2) 2`, but does
not yet provide the modular-curve genus/dimension theorem needed to prove that
actual space is zero.
-/
structure WeightTwoLevel2Empty where
  weightTwoLevelTwoForm : Type*
  empty : Prop
  noForms : empty

/-- Recover the level-two emptiness proposition. -/
theorem WeightTwoLevel2Empty.noForms_holds (h : WeightTwoLevel2Empty) : h.empty :=
  h.noForms

-- frey_curve_semistable DELETED (Ribet Breach F3): constructed ∃ h, h.semistable
--   via `semistable := True` / `condition := trivial` — vacuous witness (Recon #1 §1).
-- frey_curve_conductor DELETED (Ribet Breach F3): constructed ∃ N, N.dividesTwoRadicalABC ∧ N.minimalOutsideTwo
--   via `dividesTwoRadicalABC := True` / `minimalOutsideTwo := True` — vacuous (Recon #1 §2).
-- frey_curve_mod_p_irreducible DELETED (Ribet Breach F3): constructed ∃ ρ, ρ.irreducible
--   via `irreducible := True` / `proof := trivial` — vacuous (Recon #1 §3).
-- ribet_level_lowering DELETED (Ribet Breach F3): top-level theorem fabricating
--   `loweredToLevelTwo := True` internally while discarding both `_irreducible` and
--   `_componentGroup` hypotheses — highest-severity pathology (Recon #1 §4).
-- Honest replacements: MathlibExpansion.DeligneAttachedRepresentation (F6),
--   MathlibExpansion.RibetConductorDrop (F7), MathlibExpansion.LocalHeckeAlgebra (F5).

/--
The weight-two level-two space needed after Ribet level lowering is empty.

This now witnesses the concrete Mathlib dimension statement
`Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0`, which is
proven from `x0GenusData_two_genusQ` + the Riemann–Roch bridge **theorem**
`MathlibExpansion.ModularCurveGenus.cuspform_dim_eq_genus_weight_two`
(formerly an `axiom`; see `MathlibExpansion.ModularCurveGenusClosure`).
The remaining analytic hypothesis
`MathlibExpansion.RiemannRochBridge.Gamma0TwoCuspFormValenceIdentityPrimitive`
is threaded through.
-/
theorem weight_two_level_two_empty
    (h : MathlibExpansion.RiemannRochBridge.Gamma0TwoCuspFormValenceIdentityPrimitive) :
    ∃ e : WeightTwoLevel2Empty.{0}, e.empty := by
  refine ⟨{ weightTwoLevelTwoForm :=
              CuspForm (CongruenceSubgroup.Gamma0 2) 2
            empty :=
              Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0
            noForms :=
              MathlibExpansion.ModularCurveGenus.dim_S2_Gamma0_two_eq_zero h }, ?_⟩
  exact MathlibExpansion.ModularCurveGenus.dim_S2_Gamma0_two_eq_zero h

/--
The contradiction package combining Frey, modularity lifting, level lowering,
and level-two emptiness.
-/
structure FermatContradiction (s : FermatSolution) where
  frey : FreyCurve s
  semistable : SemistableEllipticCurve frey.curve
  modular : ModularityTheoremStatement frey.curve
  levelLowering : RibetLevelLowering s frey
  levelTwoEmpty : WeightTwoLevel2Empty
  contradiction : False

/-- Recover the contradiction from the final FLT package. -/
theorem FermatContradiction.false (s : FermatSolution) (h : FermatContradiction s) :
    False :=
  h.contradiction

/--
No primitive nonzero Fermat solution of exponent at least three exists.
-/
theorem fermat_solution_impossible (s : FermatSolution) : False := by
  -- DEEP_SORRY: final contradiction from a primitive nonzero Fermat solution
  -- [Frey 1986; Wiles 1995; Taylor-Wiles 1995; Ribet 1990] [Mathlib gap:
  -- integrated Frey curve construction, semistable modularity theorem,
  -- Ribet level lowering, and the actual theorem that the relevant level-two
  -- cusp-form space has no nonzero forms; this statement proves `False` from
  -- `s : FermatSolution`, so it cannot be closed by package construction]
  -- [estimated effort: HIGH]
  sorry

/--
Fermat's Last Theorem in integer form.
-/
theorem FermatLastTheorem (a b c : ℤ) (n : ℕ) :
    3 ≤ n → a * b * c ≠ 0 → Int.gcd (Int.gcd a b) c = 1 →
      a ^ n + b ^ n = c ^ n → False := by
  intro hn habc hprim heq
  exact fermat_solution_impossible
    { a := a
      b := b
      c := c
      p := n
      exponentAtLeastThree := hn
      equation := heq
      primitive := hprim
      abcNonzero := habc }

end NumberTheory
