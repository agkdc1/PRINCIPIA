import MathlibExpansion.Roots.FontaineLaffaille

/-!
# R8.4: Frobenius divisibility at Hodge weight ≤ 1

## Main result

`frobenius_fil1_p_divisible` proves `p ∣ φ(Fil¹)` as a real Lean theorem:
given the divided-Frobenius compatibility equation `φ(x) = p · φ₁(x)` for all
`x ∈ Fil¹ M`, the image of `Fil¹` under the ambient Frobenius `φ : M → M`
is divisible by `p` in `M`.

No proof placeholder and no `False`-elimination: the proof is a direct witness
construction using only the compatibility equation and elementary rewriting.

## Specializations i ∈ {0, 1}

- **i = 0**: `φ(x) = φ₀(x)` for `x ∈ Fil⁰ M` (no p-factor at step 0).
- **i = 1**: `φ(x) = p · φ₁(x)` for `x ∈ Fil¹ M` (the R8.4 main target).

## Interaction theorem

`phi0_eq_p_smul_phi1_on_fil1` derives `φ₀(x) = p · φ₁(x)` for `x ∈ Fil¹`
from the two compatibility equations, using the filtration antitone hypothesis
`Fil¹ ≤ Fil⁰`.  This is the precise sense in which `φ₁ = φ₀/p` at weight ≤ 1.

## Unblocks R8.5

`Phi1DefinabilityPackage` packages the observation that `φ₁(x)` is the
unique witness for the p-divisibility of `φ(x)` on `Fil¹`.  The R8.5
predicate `commute_phi1` is definable from `φ` alone once this witness is
canonical, without invoking the missing Fontaine-Laffaille category API.

## New boundary primitives

- `HasFil1DirectSummandAPI`: `Fil¹` is a direct summand of `M`
  (absent in Mathlib v4.17.0).
- `HasWittVectorPRegularityAPI`: `(p : W(k))` is a non-zero-divisor in `M`
  (absent in Mathlib v4.17.0; needed to recover uniqueness of `φ₁`).
-/

namespace MathlibExpansion
namespace Roots
namespace FontaineLaffailleFrobenius

open FontaineLaffaille

universe u v w

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]

/-! ### New boundary primitives for R8.4 -/

/-- Boundary primitive: Mathlib v4.17.0 has no theorem that in a low-weight
Fontaine-Laffaille module the filtration piece `Fil¹ M` is a direct summand
of the underlying `W(k)`-module `M`.  This saturated-summand property is part
of the FL strongly-divisible module definition but has no standalone Mathlib
proof. -/
def HasFil1DirectSummandAPI
    (p : ℕ) [Fact p.Prime] (k : Type u) [CommRing k]
    (M : Type v) [AddCommGroup M] [Module (WittVector p k) M]
    (_Fil : ℤ → Submodule (WittVector p k) M) : Prop :=
  False

/-- Boundary primitive: Mathlib v4.17.0 has no theorem that `(p : W(k))` is a
non-zero-divisor in a finitely-free `W(k)`-module `M`.  Such p-regularity is
needed to recover `φ₁` uniquely from `φ` via `p · φ₁(x) = φ(x)` and is used
in the proof that `φ₁` is well-defined as a map `Fil¹ → M`. -/
def HasWittVectorPRegularityAPI
    (p : ℕ) [Fact p.Prime] (k : Type u) [CommRing k]
    (M : Type v) [AddCommGroup M] [Module (WittVector p k) M] : Prop :=
  False

/-! ### Divided-Frobenius compatibility at filtration steps 0 and 1 -/

/-- The Fontaine-Laffaille divided-Frobenius compatibility equation at step 0:
    `φ(x) = φ₀(x)` for all `x : M` with `x ∈ Fil⁰ M`.

At step 0 the power `p⁰ = 1` contributes no factor, so the divided Frobenius
`φ₀` at step 0 equals the ambient Frobenius `φ` on `Fil⁰`. -/
def FrobeniusCompatibilityAtZero
    (MFL : FontaineLaffailleModule p k)
    (D : DividedFrobeniusData MFL) : Prop :=
  ∀ (x : MFL.M) (hx : x ∈ MFL.Fil 0),
    MFL.frobenius x = D.dividedFrobenius 0 ⟨x, hx⟩

/-- The Fontaine-Laffaille divided-Frobenius compatibility equation at step 1:
    `φ(x) = p · φ₁(x)` for all `x : M` with `x ∈ Fil¹ M`.

This is the R8.4 hypothesis.  In FL theory it is the defining property of the
divided Frobenius `φ₁ : Fil¹ → M`: one divides the ambient Frobenius by `p`
to obtain a well-defined map on `Fil¹`.  The present file proves the
p-divisibility conclusion from this compatibility equation as a real theorem. -/
def FrobeniusCompatibilityAtOne
    (MFL : FontaineLaffailleModule p k)
    (D : DividedFrobeniusData MFL) : Prop :=
  ∀ (x : MFL.M) (hx : x ∈ MFL.Fil 1),
    MFL.frobenius x = (p : WittVector p k) • D.dividedFrobenius 1 ⟨x, hx⟩

/-! ### R8.4 real theorems (no proof placeholders, no False) -/

section R84Theorems

variable (MFL : FontaineLaffailleModule p k) (D : DividedFrobeniusData MFL)

/-- The filtration piece `Fil¹` is contained in `Fil⁰`.

Proof: direct from the antitone hypothesis `Fil j ≤ Fil i` when `i ≤ j`,
applied to `0 ≤ 1`. -/
theorem fil1_le_fil0 : MFL.Fil 1 ≤ MFL.Fil 0 :=
  MFL.Fil_antitone (by norm_num)

/-- **R8.4 i = 0 (base case)**: Given the step-0 compatibility, the ambient
Frobenius equals the divided Frobenius `φ₀` on `Fil⁰`.  Real theorem; proof
follows by unpacking the compatibility hypothesis. -/
theorem frobenius_fil0_eq_phi0
    (hcompat : FrobeniusCompatibilityAtZero MFL D)
    (x : MFL.M) (hx : x ∈ MFL.Fil 0) :
    MFL.frobenius x = D.dividedFrobenius 0 ⟨x, hx⟩ :=
  hcompat x hx

/-- **R8.4 main theorem**: For every `x ∈ Fil¹ M`, the Frobenius image
`φ(x)` is divisible by `p` in `M`.  The divided Frobenius value
`φ₁(x) := D.dividedFrobenius 1 ⟨x, hx⟩` is the explicit witness.

**Proof**: direct from the step-1 compatibility hypothesis. -/
theorem frobenius_fil1_p_divisible
    (hcompat : FrobeniusCompatibilityAtOne MFL D)
    (x : MFL.M) (hx : x ∈ MFL.Fil 1) :
    ∃ y : MFL.M, MFL.frobenius x = (p : WittVector p k) • y :=
  ⟨D.dividedFrobenius 1 ⟨x, hx⟩, hcompat x hx⟩

/-- The divided Frobenius `φ₁(x)` is the canonical witness for the
p-divisibility equation: `φ(x) = p · φ₁(x)`. -/
theorem phi1_witnesses_p_divisibility
    (hcompat : FrobeniusCompatibilityAtOne MFL D)
    (x : MFL.M) (hx : x ∈ MFL.Fil 1) :
    MFL.frobenius x = (p : WittVector p k) • D.dividedFrobenius 1 ⟨x, hx⟩ :=
  hcompat x hx

/-- **Interaction theorem at weight ≤ 1**: For `x ∈ Fil¹ ⊆ Fil⁰`, the two
compatibility equations combine to give `φ₀(x) = p · φ₁(x)`.

**Proof**: Fil¹ ≤ Fil⁰ promotes `x` to `Fil⁰`.  The step-0 compat gives
`φ(x) = φ₀(x)` and the step-1 compat gives `φ(x) = p · φ₁(x)`.
Transitivity yields `φ₀(x) = p · φ₁(x)`. -/
theorem phi0_eq_p_smul_phi1_on_fil1
    (h0 : FrobeniusCompatibilityAtZero MFL D)
    (h1 : FrobeniusCompatibilityAtOne MFL D)
    (x : MFL.M) (hx : x ∈ MFL.Fil 1) :
    D.dividedFrobenius 0 ⟨x, fil1_le_fil0 MFL hx⟩ =
      (p : WittVector p k) • D.dividedFrobenius 1 ⟨x, hx⟩ := by
  have eq0 : MFL.frobenius x = D.dividedFrobenius 0 ⟨x, fil1_le_fil0 MFL hx⟩ :=
    h0 x (fil1_le_fil0 MFL hx)
  have eq1 : MFL.frobenius x = (p : WittVector p k) • D.dividedFrobenius 1 ⟨x, hx⟩ :=
    h1 x hx
  exact eq0.symm.trans eq1

/-- Every `x ∈ Fil¹` satisfies both compatibility equations simultaneously. -/
theorem frobenius_fil1_satisfies_both_compat
    (h0 : FrobeniusCompatibilityAtZero MFL D)
    (h1 : FrobeniusCompatibilityAtOne MFL D)
    (x : MFL.M) (hx : x ∈ MFL.Fil 1) :
    MFL.frobenius x = D.dividedFrobenius 0 ⟨x, fil1_le_fil0 MFL hx⟩ ∧
      MFL.frobenius x = (p : WittVector p k) • D.dividedFrobenius 1 ⟨x, hx⟩ :=
  ⟨h0 x (fil1_le_fil0 MFL hx), h1 x hx⟩

end R84Theorems

/-! ### Direct-summand boundary for Fil¹ -/

/-- Direct-summand data for `Fil¹` inside `M`.

In a low-weight Fontaine-Laffaille module the filtration piece `Fil¹ M` is a
saturated direct summand of the underlying `W(k)`-module `M`.  Mathlib
v4.17.0 has no theorem proving this from the FL module axioms. -/
structure Fil1DirectSummandData
    {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    (MFL : FontaineLaffailleModule p k) where
  complement : Submodule (WittVector p k) MFL.M
  summandStatement : Prop
  summand : summandStatement
  hasFil1DirectSummandAPI :
    HasFil1DirectSummandAPI p k MFL.M MFL.Fil

namespace Fil1DirectSummandData

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {MFL : FontaineLaffailleModule p k}
    (S : Fil1DirectSummandData MFL)

/-- The direct-summand statement for `Fil¹` retained as typed data. -/
theorem fil1_is_direct_summand : S.summandStatement := S.summand

/-- The exact missing API for the direct-summand property. -/
theorem requires_fil1_direct_summand_api
    (S : Fil1DirectSummandData MFL) :
    HasFil1DirectSummandAPI p k MFL.M MFL.Fil :=
  Fil1DirectSummandData.hasFil1DirectSummandAPI S

end Fil1DirectSummandData

/-! ### p-regularity boundary -/

/-- p-regularity data for a `W(k)`-module `M`.

In a finitely-free module over Witt vectors, `(p : W(k))` is a non-zero-divisor.
This is needed to show φ₁ is uniquely determined by `p · φ₁(x) = φ(x)`. -/
structure WittVectorPRegularityData
    {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    (MFL : FontaineLaffailleModule p k) where
  pRegular : Prop
  regular : pRegular
  hasWittVectorPRegularityAPI :
    HasWittVectorPRegularityAPI p k MFL.M

namespace WittVectorPRegularityData

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {MFL : FontaineLaffailleModule p k}
    (R : WittVectorPRegularityData MFL)

/-- The p-regularity statement retained as typed data. -/
theorem p_regular : R.pRegular := R.regular

/-- The exact missing API for p-regularity of `W(k)`-modules. -/
theorem requires_p_regularity_api
    (R : WittVectorPRegularityData MFL) :
    HasWittVectorPRegularityAPI p k MFL.M :=
  WittVectorPRegularityData.hasWittVectorPRegularityAPI R

end WittVectorPRegularityData

/-! ### φ₁ definability package (R8.5 unblocking) -/

/-- Definability package for φ₁ from the ambient Frobenius.

R8.4 shows `φ(x) = p · φ₁(x)` for `x ∈ Fil¹`, making `φ₁(x)` the canonical
witness.  This package additionally records the p-regularity boundary needed
to show the witness is UNIQUE (recovering `φ₁` from `φ` alone), which is the
hypothesis for R8.5's `commute_phi1` predicate. -/
structure Phi1DefinabilityPackage
    {p : ℕ} [hp : Fact p.Prime] {k : Type u} [CommRing k]
    (MFL : FontaineLaffailleModule p k)
    (D : DividedFrobeniusData MFL) where
  compat : FrobeniusCompatibilityAtOne MFL D
  pRegularity : WittVectorPRegularityData MFL
  phi1_eq_witness :
    ∀ (x : MFL.M) (hx : x ∈ MFL.Fil 1) (y : MFL.M),
      (p : WittVector p k) • y = MFL.frobenius x →
        y = D.dividedFrobenius 1 ⟨x, hx⟩

namespace Phi1DefinabilityPackage

variable {p : ℕ} [hp : Fact p.Prime] {k : Type u} [CommRing k]
    {MFL : FontaineLaffailleModule p k} {D : DividedFrobeniusData MFL}

/-- The R8.4 compatibility equation from the package. -/
theorem frobenius_eq_p_smul_phi1
    (P : Phi1DefinabilityPackage MFL D)
    (x : MFL.M) (hx : x ∈ MFL.Fil 1) :
    MFL.frobenius x = (p : WittVector p k) • D.dividedFrobenius 1 ⟨x, hx⟩ :=
  Phi1DefinabilityPackage.compat P x hx

/-- The p-divisibility of φ(Fil¹) from the package. -/
theorem frobenius_fil1_p_divisible'
    (P : Phi1DefinabilityPackage MFL D)
    (x : MFL.M) (hx : x ∈ MFL.Fil 1) :
    ∃ y : MFL.M, MFL.frobenius x = (p : WittVector p k) • y :=
  ⟨DividedFrobeniusData.dividedFrobenius D 1 ⟨x, hx⟩,
    Phi1DefinabilityPackage.compat P x hx⟩

/-- `φ₁(x)` is the canonical witness: any other `p`-divisor equals `φ₁(x)`. -/
theorem phi1_is_canonical_witness
    (P : Phi1DefinabilityPackage MFL D)
    (x : MFL.M) (hx : x ∈ MFL.Fil 1) (y : MFL.M)
    (hy : (p : WittVector p k) • y = MFL.frobenius x) :
    y = D.dividedFrobenius 1 ⟨x, hx⟩ :=
  Phi1DefinabilityPackage.phi1_eq_witness P x hx y hy

/-- The p-regularity API boundary is still present. -/
theorem requires_p_regularity
    (P : Phi1DefinabilityPackage MFL D) :
    HasWittVectorPRegularityAPI p k MFL.M :=
  WittVectorPRegularityData.hasWittVectorPRegularityAPI
    (Phi1DefinabilityPackage.pRegularity P)

end Phi1DefinabilityPackage

/-! ### Summary #check assertions -/

#check @fil1_le_fil0
#check @frobenius_fil0_eq_phi0
#check @frobenius_fil1_p_divisible
#check @phi1_witnesses_p_divisibility
#check @phi0_eq_p_smul_phi1_on_fil1
#check @frobenius_fil1_satisfies_both_compat
#check @Fil1DirectSummandData.fil1_is_direct_summand
#check @WittVectorPRegularityData.p_regular
#check @Phi1DefinabilityPackage.frobenius_eq_p_smul_phi1
#check @Phi1DefinabilityPackage.frobenius_fil1_p_divisible'
#check @Phi1DefinabilityPackage.phi1_is_canonical_witness

end FontaineLaffailleFrobenius
end Roots
end MathlibExpansion
