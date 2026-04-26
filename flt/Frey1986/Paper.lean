import Mathlib
import MathlibExpansion.Roots.FreySemistable
import MathlibExpansion.Roots.LanglandsTunnell.ResidualModularity
import MathlibExpansion.Roots.ValenceFormula
import MathlibExpansion.Roots.Wiles1995.REqualsT

/-!
# Frey 1986 consolidation package

This file gathers the clean ingredients needed by the FLT capstone without
importing the poisoned `EighthGap` / `Quarantine/*` route.

The central object is `FreyToLevelTwoResidualPackage`: a typed package carrying

1. a primitive Frey triple,
2. semistability data for a Frey model,
3. the mod-3 residual modularity input from Langlands-Tunnell,
4. the minimal `R = T` input data used by Wiles 1995,
5. a nonzero weight-2 level-2 cusp form.

The first four items are *synthesized* from the clean root files. The last item
is the Ribet-lowered contradiction witness: once a package reaches level `2`,
`Roots.ValenceFormula` forces the level-2 cusp space to vanish, so the package
itself is contradictory.

No new axioms are introduced here. The file only consumes previously-landed
root surfaces.
-/

namespace MathlibExpansion
namespace Roots
namespace Frey1986

open NumberTheory
open MathlibExpansion.Roots.BCDT2001
open MathlibExpansion.Roots.LanglandsTunnell
open MathlibExpansion.Roots.ValenceFormula
open MathlibExpansion.Roots.Wiles1995

universe u

/-- A primitive nonzero integer triple at prime exponent `l ≥ 5` satisfying the
Fermat equation in Frey-normalized form `A^l + B^l + C^l = 0`. -/
structure PrimitiveFreyTriple where
  A : ℤ
  B : ℤ
  C : ℤ
  l : ℕ
  prime_exponent : Nat.Prime l
  exponent_ge_five : 5 ≤ l
  equation : A ^ l + B ^ l + C ^ l = 0
  primitive : Int.gcd (Int.gcd A B) C = 1
  nonzero : A * B * C ≠ 0

namespace PrimitiveFreyTriple

/-- The classical Frey model attached to a primitive triple. -/
noncomputable def classicalModel (T : PrimitiveFreyTriple) : WeierstrassCurve ℤ :=
  classicalFreyModel T.A T.B T.C T.l

/-- The two-adic normalization witness from the existing Frey 1986 boundary. -/
theorem exists_twoAdicNormalization (T : PrimitiveFreyTriple) :
    ∃ E₂ : WeierstrassCurve ℤ,
      FreyTwoAdicNormalizationData T.classicalModel E₂ T.A T.B T.C T.l :=
  freyTwoAdicNormalization
    T.A T.B T.C T.l
    T.prime_exponent T.exponent_ge_five T.equation T.primitive T.nonzero

end PrimitiveFreyTriple

/-- Residual mod-3 input for the clean FLT route. The ambient Galois group may
vary with the package, so it is bundled here. -/
structure ResidualContext where
  G : Type u
  instGroup : Group G
  rep : ResidualRep G 3
  solvable : HasSolvableImage rep

attribute [instance] ResidualContext.instGroup

/-- A clean Frey-to-level-two contradiction package.

This object does **not** assert that the package can be constructed from every
Fermat counterexample inside Lean today. Instead, it gives the final typed
consumer surface demanded by the Phase 1 close:

`primitive Frey triple → semistable package → LT residual modularity →
 minimal R = T → nonzero level-2 cusp form → contradiction`.
-/
structure FreyToLevelTwoResidualPackage where
  triple : PrimitiveFreyTriple
  curve : WeierstrassCurve ℤ
  semistableData : FreySemistableData curve triple.A triple.B triple.C triple.l
  residual : ResidualContext
  selmer : SelmerAdZero
  congruence : CongruenceLength
  comparison : ComparisonData
  cotangentMatches : comparison.cotangentLength = selmer.length
  congruenceMatches : comparison.congruenceLength = congruence.length
  surjective : comparison.surjection
  compatible : comparison.compatible
  levelTwoForm : CuspForm (CongruenceSubgroup.Gamma0 2) 2
  levelTwoForm_ne_zero : levelTwoForm ≠ 0

namespace FreyToLevelTwoResidualPackage

/-- The semistability conclusion carried by the Frey semistable package. -/
theorem semistable (P : FreyToLevelTwoResidualPackage) :
    isSemistable P.curve :=
  freySemistableData_isSemistable
    P.curve P.triple.A P.triple.B P.triple.C P.triple.l P.semistableData

/-- The residual modularity datum discharged by Langlands-Tunnell. -/
noncomputable def residualModularity (P : FreyToLevelTwoResidualPackage) :
    ResidualModularityDatum P.residual.G :=
  langlandsTunnell_discharges_bcdt_axiom3 P.residual.rep P.residual.solvable

/-- The minimal `R = T` witness obtained from the Wiles 1995 clean surface. -/
theorem minimalREqualsT (P : FreyToLevelTwoResidualPackage) :
    ∃ (isIso : Prop), isIso :=
  minimal_R_equals_T
    P.selmer P.congruence P.comparison
    P.cotangentMatches P.congruenceMatches P.surjective P.compatible

/-- The level-2 weight-2 cusp space is zero by the valence-formula closure. -/
theorem levelTwoSpace_finrank_zero (_P : FreyToLevelTwoResidualPackage) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  finrank_zero_from_valence

/-- Any level-2 weight-2 cusp form vanishes. -/
theorem levelTwoForm_eq_zero (P : FreyToLevelTwoResidualPackage) :
    P.levelTwoForm = 0 :=
  valenceFormula_gamma0_two_vanish P.levelTwoForm

/-- A clean Frey-to-level-two package is contradictory. -/
theorem contradiction (P : FreyToLevelTwoResidualPackage) : False :=
  P.levelTwoForm_ne_zero (P.levelTwoForm_eq_zero)

end FreyToLevelTwoResidualPackage

end Frey1986
end Roots
end MathlibExpansion
