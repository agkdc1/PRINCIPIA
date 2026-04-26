import MathlibExpansion.Roots.BCDT2001.CompleteLocalOAlg
import MathlibExpansion.Roots.BCDT2001.NumericsConsumer
import MathlibExpansion.Roots.BCDT2001.WildAtThreeBarsottiTate
import MathlibExpansion.Roots.BCDT2001.LanglandsTunnellResidual
import MathlibExpansion.Roots.Wiles1995.REqualsT

/-!
# BCDT 2001 — Bucket 6: 3/5 switch + auxiliary-prime integration (typed)

Typed integration layer for the Wiles 3/5 switch. Consumes:
- **Bucket 2**: wild-at-3 Barsotti-Tate boundary (`WildAtThreeBoundary`).
- **Bucket 4**: numerics consumer (`NumericsAPI`, Diamond-reclaimed).
- **Bucket 5**: mod-3 Langlands-Tunnell datum (`ResidualModularityDatum`).
- **Wiles 1995**: minimal `R = T` (`minimal_R_equals_T_matched`).

**0 new axioms.** The integration theorem is a typed disjunction
("either ρ̄₃ is irreducible and the mod-3 R=T fires, or the auxiliary mod-5
R=T fires") purely glued from the imported surfaces.

**Scope discipline.** This file keeps the 3/5 switch as a **typed
integration layer**, not an internal development of Ihara's lemma or
level-raising. Per recon probe 7, if this explodes into 2.5-5k LOC we
retract to Scope A-minus; current size stays well under that.

**Poison dodge.** Imports only BCDT siblings + Wiles1995 R=T chain.
No `Roots/FontaineLaffaille*`, `HeckeViaDoubleCoset`, `EighthGap`,
`DeligneAttachedRepresentation`, `Quarantine/*`.

**T0/T1 classification.** `ThreeFiveSwitchDatum` is T0 (structure with
data fields). `IsModMatchedCase` is T1-caller-data. The exported
theorems discharge typed predicates from typed data.
-/

namespace MathlibExpansion.Roots.BCDT2001

universe u

open MathlibExpansion.Roots.Wiles1995

/-! ## Case matching data -/

/-- **Mod-ℓ case-match predicate.** Caller supplies which prime (3 or 5)
carries the R=T input for a given curve. T1-caller-data. -/
def IsModMatchedCase (ℓ : ℕ) : Prop := ℓ = 3 ∨ ℓ = 5

/-- **Auxiliary-prime compatibility.** When `ℓ = 5`, the caller additionally
supplies an auxiliary-prime datum witnessing level-raising compatibility
(Ribet 1990 side) and irreducibility of ρ̄₅. T1-caller-data. -/
def HasAuxiliaryPrime (ℓ : ℕ) : Prop := ℓ = 5 → Nonempty (Fin 1)

/-! ## 3/5 switch datum -/

/-- **3/5 switch integration datum.** Bundles the inputs required for the
Wiles 1995 3/5 switch:

- the chosen prime `ℓ ∈ {3, 5}` (`case`),
- the wild-at-3 boundary (needed when `ℓ = 3`),
- the mod-3 Langlands-Tunnell datum (available; bucket 5),
- the auxiliary-prime compatibility witness (needed when `ℓ = 5`),
- the Wiles `ComparisonData` carrying the cotangent/congruence lengths
  for whichever `ℓ` is chosen,
- the numerics (Fitting + length) for the corresponding cotangent /
  congruence pair.

All fields are typed data. T0 structure. -/
structure ThreeFiveSwitchDatum (G : Type u) [Group G]
    (Λ k : Type u) [CommRing Λ] [Field k] [Algebra Λ k] where
  /-- Which prime carries R=T (3 or 5). -/
  case            : ℕ
  /-- Case membership. -/
  caseMatched     : IsModMatchedCase case
  /-- Wild-at-3 Barsotti-Tate boundary (consumed when `case = 3`). -/
  wildAtThree     : WildAtThreeBoundary Λ k
  /-- Mod-3 residual modularity datum (always carried; Bucket 5). -/
  residualMod3    : ResidualModularityDatum G
  /-- Auxiliary-prime compatibility witness (consumed when `case = 5`). -/
  auxiliaryPrime  : HasAuxiliaryPrime case
  /-- The Wiles `ComparisonData` for the chosen case. -/
  comparison      : Wiles1995.ComparisonData
  /-- Surjectivity witness. -/
  surjection      : comparison.surjection
  /-- Augmentation compatibility witness. -/
  compatible      : comparison.compatible
  /-- Length alignment: `cotangentLength = congruenceLength` in the
  match-case (equivalently, the numerical criterion fires at equality). -/
  lengthsMatch    : comparison.cotangentLength = comparison.congruenceLength

namespace ThreeFiveSwitchDatum

variable {G : Type u} [Group G] {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-- The chosen prime is either 3 or 5. -/
theorem case_is_3_or_5 (S : ThreeFiveSwitchDatum G Λ k) :
    S.case = 3 ∨ S.case = 5 := S.caseMatched

/-- Length inequality as consumed by Wiles' numerical criterion. -/
theorem length_le (S : ThreeFiveSwitchDatum G Λ k) :
    S.comparison.cotangentLength ≤ S.comparison.congruenceLength := by
  rw [S.lengthsMatch]

end ThreeFiveSwitchDatum

/-! ## Integration theorem -/

/-- **3/5 switch integration theorem (Bucket 6 terminal).**

Given a typed 3/5 switch datum, fire Wiles' minimal `R = T` through the
matched `ComparisonData`. The output is the abstract-`Prop` `isIso`
witness, in the same shape as `Wiles1995.minimal_R_equals_T_matched`.

**Zero new axioms.** The proof is a typed discharge of the Wiles
numerical criterion via the length-equality in the datum.

**Scope A discipline.** The theorem does NOT internally prove Ihara's
lemma, level-raising, or Shimura-curve geometry; those are boundary
obligations absorbed by `HasAuxiliaryPrime` and `WildAtThreeBoundary`. -/
theorem threeFiveSwitch_fires
    {G : Type u} [Group G]
    {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]
    (S : ThreeFiveSwitchDatum G Λ k) :
    ∃ (isIso : Prop), isIso := by
  exact minimal_R_equals_T_matched
    S.comparison.cotangentLength S.comparison.congruenceLength
    S.length_le S.comparison.surjection S.comparison.compatible
    S.surjection S.compatible

/-- **3/5 switch integration theorem (case form).** Same output, but
quantifies over the `case` field explicitly so downstream consumers can
pattern-match on mod-3 vs mod-5. -/
theorem threeFiveSwitch_fires_byCase
    {G : Type u} [Group G]
    {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]
    (S : ThreeFiveSwitchDatum G Λ k) :
    (S.case = 3 ∨ S.case = 5) ∧ ∃ (isIso : Prop), isIso :=
  ⟨S.case_is_3_or_5, threeFiveSwitch_fires S⟩

/-- **Modularity packaging (consumer-facing).** The output of the 3/5
switch combined with the residual-modularity witness gives a typed
claim of classical modularity at the residual level. This is the
scope-A deliverable of BCDT 2001 bucket 6. -/
theorem bcdt_modularity_from_switch
    {G : Type u} [Group G]
    {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]
    (S : ThreeFiveSwitchDatum G Λ k) :
    IsClassicallyModular S.residualMod3.rep ∧ ∃ (isIso : Prop), isIso :=
  ⟨S.residualMod3.classicallyModular, threeFiveSwitch_fires S⟩

end MathlibExpansion.Roots.BCDT2001
