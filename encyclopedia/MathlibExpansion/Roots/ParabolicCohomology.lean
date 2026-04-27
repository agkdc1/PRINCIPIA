import Mathlib.Algebra.Group.Subgroup.Basic
import Mathlib.GroupTheory.FreeAbelianGroup
import Mathlib.GroupTheory.GroupAction.Basic
import Mathlib.GroupTheory.QuotientGroup.Basic
import Mathlib.GroupTheory.Torsion
import Mathlib.NumberTheory.ModularForms.Basic
import Mathlib.NumberTheory.ModularForms.CongruenceSubgroups
import Mathlib.RepresentationTheory.GroupCohomology.LowDegree
import Mathlib.MeasureTheory.Integral.Lebesgue
import Mathlib.MeasureTheory.Measure.WithDensity

set_option linter.dupNamespace false

/-!
# Parabolic cohomology boundary

This file records the part of the parabolic-subgroup and parabolic-cohomology
API that is available in Mathlib v4.17.0 without introducing unproved
declarations.

For any group action, a "cusp" can be represented abstractly by a point of the
acted-on type. Its stabilizer is already available as `MulAction.stabilizer`,
and Mathlib provides `Subgroup.normalizer`. We therefore define the parabolic
subgroup attached to such a point as the normalizer of its stabilizer.

For a `k`-linear representation `A` of a group `Γ` and a family of subgroups
`P : ι → Subgroup Γ`, `ParabolicCohomology A P` is the submodule of
`groupCohomology.H1 A` consisting of classes that have a one-cocycle
representative vanishing on every subgroup `P i`.

Mathlib v4.17.0 has modular forms, cusp forms, congruence subgroups, and
low-degree group cohomology, but it does not yet provide the geometric cusp
space of `Y(Γ)`, vector bundles on modular curves, Hecke operators on cusp
forms, Hecke operators on parabolic cohomology, or the comparison map required
to state the requested Hecke-compatibility theorem.
-/

noncomputable section

open CategoryTheory Representation
open MeasureTheory
open scoped ENNReal ModularForm MatrixGroups UpperHalfPlane
open CongruenceSubgroup

namespace MathlibExpansion
namespace Roots
namespace ParabolicCohomology

universe u v

section Normalizers

variable (G : Type*) {α : Type*} [Group G] [MulAction G α]

/-- The stabilizer of an abstract cusp for a group action. -/
abbrev cuspStabilizer (x : α) : Subgroup G :=
  MulAction.stabilizer G x

/-- The normalizer-based parabolic subgroup attached to an abstract cusp. -/
abbrev parabolicNormalizer (x : α) : Subgroup G :=
  (cuspStabilizer G x).normalizer

variable {G} {x : α}

/-- The cusp stabilizer is contained in the corresponding normalizer parabolic subgroup. -/
theorem cuspStabilizer_le_parabolicNormalizer :
    cuspStabilizer G x ≤ parabolicNormalizer G x :=
  Subgroup.le_normalizer

/-- An element fixing the cusp belongs to the normalizer-based parabolic subgroup. -/
theorem mem_parabolicNormalizer_of_smul_eq {g : G} (hg : g • x = x) :
    g ∈ parabolicNormalizer G x :=
  cuspStabilizer_le_parabolicNormalizer (G := G) (x := x)
    ((MulAction.mem_stabilizer_iff (G := G) (a := x)).mpr hg)

/-- A subgroup acting trivially on the cusp is contained in its parabolic normalizer. -/
theorem subgroup_le_parabolicNormalizer_of_smul_eq {H : Subgroup G}
    (hH : ∀ g ∈ H, g • x = x) :
    H ≤ parabolicNormalizer G x := by
  intro g hg
  exact mem_parabolicNormalizer_of_smul_eq (G := G) (x := x) (hH g hg)

/-- Stabilizers of cusps in the same orbit are conjugate, in membership form.

This is the group-theoretic core of the cusp-parabolic classification used
later for congruence subgroups: replacing a cusp `x` by `g • x` conjugates its
stabilizer by `g`. -/
theorem mem_cuspStabilizer_smul_iff (g h : G) (x : α) :
    h ∈ cuspStabilizer G (g • x) ↔ (g⁻¹ * h * g) ∈ cuspStabilizer G x := by
  simp only [cuspStabilizer, MulAction.mem_stabilizer_iff]
  constructor
  · intro hh
    calc
      (g⁻¹ * h * g) • x = g⁻¹ • (h • (g • x)) := by simp [mul_smul]
      _ = g⁻¹ • (g • x) := by rw [hh]
      _ = x := by simp [mul_smul]
  · intro hh
    have hcalc : g • ((g⁻¹ * h * g) • x) = g • x := by rw [hh]
    simpa [mul_smul, mul_assoc] using hcalc

/-- Normalizer-parabolics of cusps in the same orbit are conjugate, in one
direction.

This avoids any modular-curve/Jacobian input: it is a pure consequence of the
available action, stabilizer, and subgroup-normalizer APIs. -/
theorem mem_parabolicNormalizer_smul_of_mem (g h : G) (x : α)
    (hh : h ∈ parabolicNormalizer G x) :
    (g * h * g⁻¹) ∈ parabolicNormalizer G (g • x) := by
  rw [parabolicNormalizer, Subgroup.mem_normalizer_iff] at hh ⊢
  intro a
  constructor
  · intro ha
    rw [mem_cuspStabilizer_smul_iff g]
    have ha' : g⁻¹ * a * g ∈ cuspStabilizer G x :=
      (mem_cuspStabilizer_smul_iff (G := G) g a x).mp ha
    have hnorm := (hh (g⁻¹ * a * g)).mp ha'
    simpa [mul_assoc] using hnorm
  · intro ha
    rw [mem_cuspStabilizer_smul_iff g] at ha ⊢
    have hnorm := (hh (g⁻¹ * a * g)).mpr ?_
    · simpa using hnorm
    · simpa [mul_assoc] using ha

/-- Normalizer-parabolics of cusps in the same orbit are conjugate, in
membership-iff form. -/
theorem mem_parabolicNormalizer_smul_iff (g h : G) (x : α) :
    h ∈ parabolicNormalizer G (g • x) ↔
      (g⁻¹ * h * g) ∈ parabolicNormalizer G x := by
  constructor
  · intro hh
    have hconj :=
      mem_parabolicNormalizer_smul_of_mem (G := G) (α := α) g⁻¹ h (g • x) hh
    simpa [mul_smul, mul_assoc] using hconj
  · intro hh
    have hconj :=
      mem_parabolicNormalizer_smul_of_mem (G := G) (α := α) g (g⁻¹ * h * g) x hh
    simpa [mul_assoc] using hconj

/-- The stabilizer is normal inside its normalizer-based parabolic subgroup. -/
instance cuspStabilizer_normal_in_parabolicNormalizer :
    ((cuspStabilizer G x).subgroupOf (parabolicNormalizer G x)).Normal :=
  inferInstance

/-- A normalizer is self-normalizing whenever the reverse inclusion is available.

The unconditional statement `(parabolicNormalizer G x).normalizer =
parabolicNormalizer G x` is not a general group-theoretic theorem in Mathlib's
API. This lemma packages the exact order-theoretic closure step that remains
once the reverse inclusion has been proved in a concrete geometric setting. -/
theorem parabolicNormalizer_self_normalizing_of_normalizer_le
    (h : (parabolicNormalizer G x).normalizer ≤ parabolicNormalizer G x) :
    (parabolicNormalizer G x).normalizer = parabolicNormalizer G x :=
  le_antisymm h Subgroup.le_normalizer

/-- A finite family of normalizer-based parabolic subgroups attached to
selected abstract cusps. -/
def cuspParabolicFamily (xs : Finset α) : xs → Subgroup G :=
  fun i => parabolicNormalizer G (i : α)

/-- The stabilizer of a selected cusp is contained in its finite-family
parabolic subgroup. -/
theorem cuspStabilizer_le_cuspParabolicFamily (xs : Finset α) (i : xs) :
    cuspStabilizer G (i : α) ≤ cuspParabolicFamily (G := G) xs i :=
  cuspStabilizer_le_parabolicNormalizer (G := G) (x := (i : α))

/-- An element fixing a selected cusp belongs to the corresponding member of
the finite normalizer-parabolic family. -/
theorem mem_cuspParabolicFamily_of_smul_eq {xs : Finset α} (i : xs) {g : G}
    (hg : g • (i : α) = (i : α)) :
    g ∈ cuspParabolicFamily (G := G) xs i :=
  mem_parabolicNormalizer_of_smul_eq (G := G) (x := (i : α)) hg

end Normalizers

section GroupCohomology

variable {k Γ : Type u} [CommRing k] [Group Γ]

/-- A one-cocycle vanishes on every subgroup in a chosen family `P`.

For arithmetic applications, `P` is intended to enumerate stabilizers of cusps
or other parabolic subgroups. -/
def OneCocycleVanishesOn (A : Rep k Γ) {ι : Type v} (P : ι → Subgroup Γ)
    (z : groupCohomology.oneCocycles A) : Prop :=
  ∀ i (p : P i), z p.1 = 0

namespace OneCocycleVanishesOn

variable (A : Rep k Γ) {ι : Type v} (P : ι → Subgroup Γ)

@[simp]
theorem zero : OneCocycleVanishesOn A P (0 : groupCohomology.oneCocycles A) := by
  intro i p
  rfl

theorem add {z w : groupCohomology.oneCocycles A}
    (hz : OneCocycleVanishesOn A P z) (hw : OneCocycleVanishesOn A P w) :
    OneCocycleVanishesOn A P (z + w) := by
  intro i p
  change z p.1 + w p.1 = 0
  rw [hz i p, hw i p, zero_add]

theorem smul (c : k) {z : groupCohomology.oneCocycles A}
    (hz : OneCocycleVanishesOn A P z) :
    OneCocycleVanishesOn A P (c • z) := by
  intro i p
  change c • z p.1 = 0
  rw [hz i p, smul_zero]

/-- Vanishing on a family of larger subgroups implies vanishing after
restricting to a family of smaller subgroups. -/
theorem mono {κ : Type*} {P : ι → Subgroup Γ} {Q : κ → Subgroup Γ}
    (f : ι → κ) (hPQ : ∀ i, P i ≤ Q (f i))
    {z : groupCohomology.oneCocycles A} (hz : OneCocycleVanishesOn A Q z) :
    OneCocycleVanishesOn A P z := by
  intro i p
  exact hz (f i) ⟨p.1, hPQ i p.2⟩

end OneCocycleVanishesOn

/-- The parabolic part of first group cohomology.

A class is parabolic when it has a one-cocycle representative whose restriction
to each selected subgroup `P i` is zero. This definition is a submodule of
Mathlib's low-degree `H¹`; no new quotient construction is introduced here. -/
def ParabolicCohomology (A : Rep k Γ) {ι : Type v} (P : ι → Subgroup Γ) :
    Submodule k (groupCohomology.H1 A) where
  carrier :=
    {x | ∃ z : groupCohomology.oneCocycles A,
      groupCohomology.H1π A z = x ∧ OneCocycleVanishesOn A P z}
  zero_mem' := by
    refine ⟨0, ?_, OneCocycleVanishesOn.zero A P⟩
    simp
  add_mem' := by
    rintro x y ⟨zx, hx, hzx⟩ ⟨zy, hy, hzy⟩
    refine ⟨zx + zy, ?_, OneCocycleVanishesOn.add A P hzx hzy⟩
    rw [map_add, hx, hy]
  smul_mem' := by
    rintro c x ⟨z, hx, hz⟩
    refine ⟨c • z, ?_, OneCocycleVanishesOn.smul A P c hz⟩
    rw [map_smul, hx]

@[simp]
theorem mem_parabolicCohomology_iff (A : Rep k Γ) {ι : Type v} (P : ι → Subgroup Γ)
    (x : groupCohomology.H1 A) :
    x ∈ ParabolicCohomology A P ↔
      ∃ z : groupCohomology.oneCocycles A,
        groupCohomology.H1π A z = x ∧ OneCocycleVanishesOn A P z :=
  Iff.rfl

/-- A cocycle vanishing on the selected parabolic subgroups determines a
parabolic cohomology class. -/
theorem H1π_mem_parabolicCohomology (A : Rep k Γ) {ι : Type v} (P : ι → Subgroup Γ)
    (z : groupCohomology.oneCocycles A) (hz : OneCocycleVanishesOn A P z) :
    groupCohomology.H1π A z ∈ ParabolicCohomology A P :=
  ⟨z, rfl, hz⟩

section CuspSet

variable {Cusp : Type v} [MulAction Γ Cusp]

/-- Parabolic cohomology specialized to a finite selected set of cusps, using
the normalizer of each cusp stabilizer as the chosen parabolic subgroup. -/
def ParabolicCohomologyForCuspSet (A : Rep k Γ) (xs : Finset Cusp) :
    Submodule k (groupCohomology.H1 A) :=
  ParabolicCohomology A (cuspParabolicFamily (G := Γ) xs)

/-- A cocycle vanishing on all normalizer-parabolic subgroups from a finite
cusp set determines a class in the corresponding specialized parabolic
cohomology submodule. -/
theorem H1π_mem_parabolicCohomologyForCuspSet (A : Rep k Γ) (xs : Finset Cusp)
    (z : groupCohomology.oneCocycles A)
    (hz : OneCocycleVanishesOn A (cuspParabolicFamily (G := Γ) xs) z) :
    groupCohomology.H1π A z ∈ ParabolicCohomologyForCuspSet A xs :=
  H1π_mem_parabolicCohomology A (cuspParabolicFamily (G := Γ) xs) z hz

end CuspSet

/-- A cohomology class parabolic for larger selected subgroups is parabolic
for any indexed family of smaller selected subgroups. -/
theorem mem_parabolicCohomology_of_subgroup_le (A : Rep k Γ)
    {ι κ : Type v} {P : ι → Subgroup Γ} {Q : κ → Subgroup Γ}
    (f : ι → κ) (hPQ : ∀ i, P i ≤ Q (f i))
    {x : groupCohomology.H1 A} (hx : x ∈ ParabolicCohomology A Q) :
    x ∈ ParabolicCohomology A P := by
  rcases hx with ⟨z, rfl, hz⟩
  exact H1π_mem_parabolicCohomology A P z
    (OneCocycleVanishesOn.mono A f hPQ hz)

/-- Abstract restriction map from `H¹(Γ, A)` to a supplied boundary target.

For the Eichler-Shimura application the intended target is the product of the
restricted cohomologies of cusp stabilizer/parabolic subgroups. Mathlib does
not currently package those restriction maps for congruence subgroups, so this
structure isolates exactly the API needed to identify parabolic cohomology as a
kernel without committing to a premature geometry model. -/
structure ParabolicRestrictionData (A : Rep k Γ) {ι : Type v}
    (P : ι → Subgroup Γ) (R : Type*) [AddCommMonoid R] [Module k R] where
  /-- The boundary restriction map. -/
  restriction : groupCohomology.H1 A →ₗ[k] R
  /-- Its kernel is precisely the parabolic submodule. -/
  ker_eq_parabolic : LinearMap.ker restriction = ParabolicCohomology A P

namespace ParabolicRestrictionData

variable {A : Rep k Γ} {ι : Type v} {P : ι → Subgroup Γ}
variable {R : Type*} [AddCommMonoid R] [Module k R]

/-- Membership in parabolic cohomology is equivalent to vanishing under a
supplied boundary restriction map. -/
theorem mem_iff_restriction_eq_zero (D : ParabolicRestrictionData A P R)
    (x : groupCohomology.H1 A) :
    x ∈ ParabolicCohomology A P ↔ D.restriction x = 0 := by
  rw [← D.ker_eq_parabolic]
  exact LinearMap.mem_ker

/-- The forward direction of the kernel characterization. -/
theorem restriction_eq_zero_of_mem (D : ParabolicRestrictionData A P R)
    {x : groupCohomology.H1 A} (hx : x ∈ ParabolicCohomology A P) :
    D.restriction x = 0 :=
  (D.mem_iff_restriction_eq_zero x).mp hx

/-- The reverse direction of the kernel characterization. -/
theorem mem_of_restriction_eq_zero (D : ParabolicRestrictionData A P R)
    {x : groupCohomology.H1 A} (hx : D.restriction x = 0) :
    x ∈ ParabolicCohomology A P :=
  (D.mem_iff_restriction_eq_zero x).mpr hx

end ParabolicRestrictionData

/-- Named Mathlib gap for R2.6/R2.7: a concrete parabolic restriction map from
group cohomology to the family of cusp-stabilizer cohomologies whose kernel is
the parabolic cohomology submodule. -/
def ParabolicRestrictionKernelPrimitive (Γ : Type u) [Group Γ]
    (k : Type u) [CommRing k] : Prop :=
  ∀ (A : Rep k Γ) {ι : Type v} (P : ι → Subgroup Γ),
    ∃ (R : Type u) (_ : AddCommMonoid R) (_ : Module k R),
      Nonempty (ParabolicRestrictionData A P R)

/-- The zero cocycle gives a parabolic class. -/
@[simp]
theorem H1π_zero_mem_parabolicCohomology (A : Rep k Γ) {ι : Type v} (P : ι → Subgroup Γ) :
    groupCohomology.H1π A (0 : groupCohomology.oneCocycles A) ∈
      ParabolicCohomology A P :=
  H1π_mem_parabolicCohomology A P 0 (OneCocycleVanishesOn.zero A P)

/-- A linear endomorphism of `H¹(Γ, A)` that preserves the parabolic submodule.

This is the exact algebraic input a future Hecke operator on group cohomology
must provide before it can act on parabolic cohomology. -/
structure ParabolicPreservingEndomorphism (A : Rep k Γ) {ι : Type v}
    (P : ι → Subgroup Γ) where
  /-- The ambient linear endomorphism of first group cohomology. -/
  toLinearMap : groupCohomology.H1 A →ₗ[k] groupCohomology.H1 A
  /-- The endomorphism preserves the parabolic submodule. -/
  map_mem' :
    ∀ x : groupCohomology.H1 A, x ∈ ParabolicCohomology A P →
      toLinearMap x ∈ ParabolicCohomology A P

namespace ParabolicPreservingEndomorphism

variable {A : Rep k Γ} {ι : Type v} {P : ι → Subgroup Γ}

/-- Restrict a parabolic-preserving ambient endomorphism to parabolic cohomology. -/
def restrict (T : ParabolicPreservingEndomorphism A P) :
    ParabolicCohomology A P →ₗ[k] ParabolicCohomology A P where
  toFun x := ⟨T.toLinearMap x, T.map_mem' x x.2⟩
  map_add' x y := by
    ext
    exact T.toLinearMap.map_add x y
  map_smul' c x := by
    ext
    exact T.toLinearMap.map_smul c x

@[simp]
theorem restrict_apply (T : ParabolicPreservingEndomorphism A P)
    (x : ParabolicCohomology A P) :
    (T.restrict x : groupCohomology.H1 A) = T.toLinearMap x :=
  rfl

end ParabolicPreservingEndomorphism

/-- Abstract Hecke-compatibility data for a comparison from parabolic cohomology
to a supplied modular-form target.

This does not invent a Hecke operator. It isolates the theorem that becomes
available once Mathlib supplies both concrete Hecke endomorphisms and the
Eichler-Shimura comparison map. -/
structure HeckeCompatibilityData (A : Rep k Γ) {ι : Type v}
    (P : ι → Subgroup Γ) (S : Type*) [AddCommMonoid S] [Module k S] where
  /-- The comparison map from parabolic cohomology to the modular-form target. -/
  comparison : ParabolicCohomology A P →ₗ[k] S
  /-- The parabolic cohomology Hecke endomorphism, supplied abstractly. -/
  parabolicT : ParabolicPreservingEndomorphism A P
  /-- The modular-form-side Hecke endomorphism, supplied abstractly. -/
  modularT : S →ₗ[k] S
  /-- The supplied statement that the comparison map intertwines the two actions. -/
  intertwines : modularT.comp comparison = comparison.comp parabolicT.restrict

namespace HeckeCompatibilityData

variable {A : Rep k Γ} {ι : Type v} {P : ι → Subgroup Γ}
variable {S : Type*} [AddCommMonoid S] [Module k S]

/-- Pointwise form of abstract Hecke compatibility for supplied operators. -/
theorem apply (D : HeckeCompatibilityData A P S) (x : ParabolicCohomology A P) :
    D.modularT (D.comparison x) = D.comparison (D.parabolicT.restrict x) := by
  exact LinearMap.congr_fun D.intertwines x

/-- Indexed pointwise form of Hecke compatibility.

The index is explicit so this theorem can be used directly for a future
concrete `T_l` once Mathlib supplies the parabolic-cohomology and cusp-form
Hecke operators at that index. -/
theorem apply_at_index (D : HeckeCompatibilityData A P S) (_ell : ℕ)
    (x : ParabolicCohomology A P) :
    D.modularT (D.comparison x) = D.comparison (D.parabolicT.restrict x) := by
  exact D.apply x

end HeckeCompatibilityData

end GroupCohomology

section WeightTwo

/-- The available Mathlib type for holomorphic weight-two cusp forms on `Γ`. -/
abbrev WeightTwoCuspForms (Γ : Subgroup SL(2, ℤ)) : Type :=
  CuspForm Γ 2

/-- Current typed substitute for `S₂(Γ) ⊕ S̄₂(Γ)`.

Mathlib v4.17.0 has `CuspForm Γ 2`, but the scanned API does not package the
conjugate/anti-holomorphic cusp-form summand. The second factor is therefore
kept as another copy of the same Lean type while the missing conjugate structure
is named separately by `HasAntiholomorphicCuspSummand`. -/
abbrev WeightTwoEichlerShimuraTarget (Γ : Subgroup SL(2, ℤ)) : Type :=
  WeightTwoCuspForms Γ × WeightTwoCuspForms Γ

/-- The first projection from the typed weight-two target. -/
def weightTwoTargetFst (Γ : Subgroup SL(2, ℤ)) :
    WeightTwoEichlerShimuraTarget Γ → WeightTwoCuspForms Γ :=
  Prod.fst

/-- The second projection from the typed weight-two target. -/
def weightTwoTargetSnd (Γ : Subgroup SL(2, ℤ)) :
    WeightTwoEichlerShimuraTarget Γ → WeightTwoCuspForms Γ :=
  Prod.snd

@[simp]
theorem weightTwoTargetFst_mk (Γ : Subgroup SL(2, ℤ))
    (f g : WeightTwoCuspForms Γ) :
    weightTwoTargetFst Γ (f, g) = f :=
  rfl

@[simp]
theorem weightTwoTargetSnd_mk (Γ : Subgroup SL(2, ℤ))
    (f g : WeightTwoCuspForms Γ) :
    weightTwoTargetSnd Γ (f, g) = g :=
  rfl

@[simp]
theorem weightTwoTarget_eta (Γ : Subgroup SL(2, ℤ))
    (x : WeightTwoEichlerShimuraTarget Γ) :
    (weightTwoTargetFst Γ x, weightTwoTargetSnd Γ x) = x :=
  Prod.ext rfl rfl

/-- Gap marker for the actual cusp space of the open modular curve `Y(Γ)`.

Once Mathlib packages this cusp space with the natural `Γ`-action, the finite
normalizer family above can be instantiated by a selected cusp set. -/
def YGammaCuspSpacePrimitive (Γ : Subgroup SL(2, ℤ)) : Prop :=
  ∃ Cusp : Type, ∃ _ : MulAction Γ Cusp, Nonempty Cusp

-- HasParabolicCohomologyH1 DELETED (W7 R4 F1 opus breach, 2026-04-20):
--   `∃ (A : Rep ℂ Γ) (ι : Type) (_P : ι → Subgroup Γ),
--      Nonempty (Submodule ℂ (groupCohomology.H1 A))`
--   is vacuous: any Rep has a zero submodule of H1, so the witness carries no
--   cusp/normalizer data (Recon post-valence adversarial Gemini audit).
-- Downstream cascade: NormalizerParabolicOnYPrimitive, ModularFormsVectorBundleOnYPrimitive
--   also DELETED (same call) — they consumed the vacuous H1 witness.
-- Honest replacement: `groupCohomology.H1 A` directly, plus the arithmetic cusp
--   data that should reside in a future Mathlib modular-curve API.

-- HasAntiholomorphicCuspSummand DELETED (Ribet Breach F4):
--   `∃ Sbar : Type, Sbar = WeightTwoCuspForms Γ` only asserts existence of a
--   type equal to the cusp form space — vacuous, carries no anti-holomorphic structure.
-- TODO: replace with a typed conjugate-cusp-form summand once Mathlib exposes
--   a complex-conjugation involution on CuspForm.

-- WeightTwoEichlerShimuraPrimitive DELETED (W7 R4 F1 opus breach, 2026-04-20):
--   Reduced to the vacuous `HasParabolicCohomologyH1` above, hence itself vacuous.
-- Downstream cascade: HeckeCompatibilityPrimitive DELETED (consumed this primitive).
-- Honest replacement: the weight-two Eichler-Shimura comparison belongs in a
--   future `S₂(Γ) → H¹(Γ, · )` Mathlib bridge, not an existential wrapper.

-- HasWeightTwoCuspFormHeckeOperator DELETED (Ribet Breach F4):
--   `∃ _T : WeightTwoCuspForms Γ → WeightTwoCuspForms Γ, True` only asserts
--   existence of an arbitrary function — carries no double-coset Hecke content
--   (Recon #6 §Exact Findings). Honest replacement: MathlibExpansion.Roots.HeckeViaDoubleCoset (F8).
-- TODO: replace with CuspFormHeckeOperatorData carrying isDoubleCosetHecke.

-- HasParabolicCohomologyHeckeOperator DELETED (W7 R4 F1 opus breach, 2026-04-20):
--   `∃ (A : Rep ℂ Γ) (ι : Type) (P : ι → Subgroup Γ),
--      Nonempty (ParabolicPreservingEndomorphism A P)` is vacuous: the identity
--   endomorphism on any Rep trivially lies in `ParabolicPreservingEndomorphism`,
--   carrying no `T_ℓ` / double-coset / Hecke content.
-- Honest replacement: an explicit double-coset construction; see
--   MathlibExpansion.Roots.HeckeViaDoubleCoset (F8).

-- HeckeCompatibilityAtIndexPrimitive DELETED (W7 R4 F1 opus breach, 2026-04-20):
--   Reduced to the two vacuous primitives above (`HasParabolicCohomologyHeckeOperator`,
--   `WeightTwoEichlerShimuraPrimitive`), hence itself vacuous.
-- Honest replacement: specialize `HeckeCompatibilityData` directly to the
--   concrete double-coset operator of F8 once the Eichler-Shimura bridge lands.

end WeightTwo

section PeterssonMeasureSetup

/-- The pointwise Petersson kernel before quotienting by `Γ`. -/
def peterssonKernel (weight : ℕ) (f g : ℍ → ℂ) (z : ℍ) : ℂ :=
  star (f z) * g z * (z.im : ℂ) ^ weight

/-- Nonnegative Petersson `L²` density on the upper half-plane. -/
def peterssonDensity (weight : ℕ) (f : ℍ → ℂ) (z : ℍ) : ℝ≥0∞ :=
  ENNReal.ofReal (Complex.normSq (f z)) * ENNReal.ofReal (z.im ^ weight)

/-- The Petersson `L²` density attached to a bundled cusp form. -/
def cuspFormPeterssonDensity {Γ : Subgroup SL(2, ℤ)} (weight : ℕ)
    (f : CuspForm Γ ↑weight) (z : ℍ) : ℝ≥0∞ :=
  peterssonDensity weight (f : ℍ → ℂ) z

@[simp]
theorem peterssonDensity_zero (weight : ℕ) :
    peterssonDensity weight (fun _ : ℍ => 0) = fun _ : ℍ => 0 := by
  funext z
  simp [peterssonDensity]

@[simp]
theorem cuspFormPeterssonDensity_apply {Γ : Subgroup SL(2, ℤ)} (weight : ℕ)
    (f : CuspForm Γ ↑weight) (z : ℍ) :
    cuspFormPeterssonDensity weight f z = peterssonDensity weight (f : ℍ → ℂ) z :=
  rfl

variable [MeasurableSpace ℍ]

/-- A placeholder for the parabolic/cusp measure on the upper half-plane.

In the intended Eichler-Shimura application this measure should descend from
the noncompact quotient `Y(Γ)` and its cusp geometry. Mathlib v4.17.0 does not
yet package that quotient measure, so this attempt keeps the measure explicit. -/
abbrev ParabolicMeasure :=
  Measure ℍ

namespace ParabolicMeasure

/-- Package an explicit measure on `ℍ` as the parabolic measure input. -/
def ofMeasure (μ : Measure ℍ) : ParabolicMeasure :=
  μ

@[simp]
theorem ofMeasure_eq (μ : Measure ℍ) : ofMeasure μ = μ :=
  rfl

/-- Reweight a parabolic measure by an `ℝ≥0∞` density. -/
def withDensity (ν : ParabolicMeasure) (w : ℍ → ℝ≥0∞) : ParabolicMeasure :=
  Measure.withDensity ν w

@[simp]
theorem withDensity_eq (ν : ParabolicMeasure) (w : ℍ → ℝ≥0∞) :
    ν.withDensity w = Measure.withDensity ν w :=
  rfl

end ParabolicMeasure

/-- Integrate a nonnegative density against a chosen parabolic measure. -/
def peterssonLIntegral (ν : ParabolicMeasure) (F : ℍ → ℝ≥0∞) : ℝ≥0∞ :=
  ∫⁻ z, F z ∂ν

/-- Finiteness predicate for the Petersson `L²` density of a function. -/
def PeterssonFinite (ν : ParabolicMeasure) (weight : ℕ) (f : ℍ → ℂ) : Prop :=
  peterssonLIntegral ν (peterssonDensity weight f) ≠ ∞

/-- Finiteness predicate for the Petersson `L²` density of a bundled cusp form. -/
def CuspFormPeterssonFinite {Γ : Subgroup SL(2, ℤ)} (ν : ParabolicMeasure) (weight : ℕ)
    (f : CuspForm Γ ↑weight) : Prop :=
  peterssonLIntegral ν (cuspFormPeterssonDensity weight f) ≠ ∞

/-- Boundary object for the parabolic measure on `Y(Γ)`.

The current file can integrate against any explicit measure on `ℍ`. What
Mathlib does not yet provide is the quotient/parabolic measure descending from
the open modular curve. This structure names that missing package while keeping
the actual measure data available for `lintegral`. -/
structure PeterssonParabolicMeasurePrimitive (Γ : Subgroup SL(2, ℤ)) where
  /-- The explicit measure on `ℍ` used by the current Petersson setup. -/
  measure : ParabolicMeasure
  /-- Marker for the future proof that this measure is the descended
  parabolic measure on `Y(Γ)`. -/
  descendsToY : Prop

/-- Boundary object for a Petersson inner product built from a parabolic
measure.

This packages the measure input, the selected weight, a supplied sesquilinear
pairing, and the finiteness hypothesis needed by the `lintegral` setup already
available in this file. -/
structure PeterssonInnerProductPrimitive (Γ : Subgroup SL(2, ℤ)) where
  /-- The parabolic measure primitive used to integrate densities. -/
  parabolicMeasure : PeterssonParabolicMeasurePrimitive Γ
  /-- The modular-form weight of the packaged pairing. -/
  weight : ℕ
  /-- The supplied Petersson pairing on bundled cusp forms. -/
  inner : CuspForm Γ ↑weight → CuspForm Γ ↑weight → ℂ
  /-- The density attached to every bundled cusp form is finite for the
  packaged parabolic measure. -/
  finite' :
    ∀ f : CuspForm Γ ↑weight,
      CuspFormPeterssonFinite parabolicMeasure.measure weight f

/-- Current named boundary for descending the Petersson inner product to the
parabolic quotient. -/
def PeterssonInnerProductDescendsPrimitive (Γ : Subgroup SL(2, ℤ)) : Prop :=
  Nonempty (PeterssonInnerProductPrimitive Γ)

@[simp]
theorem peterssonFinite_iff_lintegral_ne_top (ν : ParabolicMeasure) (weight : ℕ)
    (f : ℍ → ℂ) :
    PeterssonFinite ν weight f ↔
      peterssonLIntegral ν (peterssonDensity weight f) ≠ ∞ :=
  Iff.rfl

@[simp]
theorem cuspFormPeterssonFinite_iff_lintegral_ne_top {Γ : Subgroup SL(2, ℤ)}
    (ν : ParabolicMeasure) (weight : ℕ) (f : CuspForm Γ ↑weight) :
    CuspFormPeterssonFinite ν weight f ↔
      peterssonLIntegral ν (cuspFormPeterssonDensity weight f) ≠ ∞ :=
  Iff.rfl

/-- A packaged Petersson inner product primitive supplies the required
`lintegral` finiteness statement for each cusp form. -/
theorem PeterssonInnerProductPrimitive.cuspFormPeterssonFinite
    {Γ : Subgroup SL(2, ℤ)} (P : PeterssonInnerProductPrimitive Γ)
    (f : CuspForm Γ ↑P.weight) :
    CuspFormPeterssonFinite P.parabolicMeasure.measure P.weight f :=
  P.finite' f

@[simp]
theorem peterssonLIntegral_zero (ν : ParabolicMeasure) :
    peterssonLIntegral ν (fun _ : ℍ => 0) = 0 := by
  simp [peterssonLIntegral]

theorem peterssonLIntegral_congr_ae {ν : ParabolicMeasure} {F G : ℍ → ℝ≥0∞}
    (hFG : F =ᶠ[ae ν] G) :
    peterssonLIntegral ν F = peterssonLIntegral ν G := by
  exact lintegral_congr_ae hFG

theorem peterssonLIntegral_mono {ν : ParabolicMeasure} {F G : ℍ → ℝ≥0∞}
    (hFG : F ≤ G) :
    peterssonLIntegral ν F ≤ peterssonLIntegral ν G := by
  exact lintegral_mono hFG

@[simp]
theorem peterssonLIntegral_cuspFormDensity {Γ : Subgroup SL(2, ℤ)} (ν : ParabolicMeasure)
    (weight : ℕ) (f : CuspForm Γ ↑weight) :
    peterssonLIntegral ν (cuspFormPeterssonDensity weight f) =
      peterssonLIntegral ν (peterssonDensity weight (f : ℍ → ℂ)) :=
  rfl

end PeterssonMeasureSetup

section ModularSymbols

variable (Cusp : Type u)

/-- An ordered pair of cusps, used as a generator for modular symbols. -/
structure CuspPair where
  /-- The initial cusp. -/
  left : Cusp
  /-- The terminal cusp. -/
  right : Cusp

/-- The free abelian group on ordered cusp pairs. -/
abbrev PreModularSymbol :=
  FreeAbelianGroup (CuspPair Cusp)

/-- The generator `{a, b}` in the free abelian group on ordered cusp pairs. -/
def modularSymbol (a b : Cusp) : PreModularSymbol Cusp :=
  FreeAbelianGroup.of ⟨a, b⟩

/-- The Manin antisymmetry generator `{a, b} + {b, a}`. -/
def maninAntisymmetryGenerator (a b : Cusp) : PreModularSymbol Cusp :=
  modularSymbol Cusp a b + modularSymbol Cusp b a

/-- The Manin triangle generator `{a, b} + {b, c} + {c, a}`. -/
def maninTriangleGenerator (a b c : Cusp) : PreModularSymbol Cusp :=
  modularSymbol Cusp a b + modularSymbol Cusp b c + modularSymbol Cusp c a

/-- Map an ordered cusp pair by a function on cusps. -/
def cuspPairMap (f : Cusp → Cusp) (p : CuspPair Cusp) : CuspPair Cusp :=
  ⟨f p.left, f p.right⟩

/-- The basic Manin generators whose additive subgroup is quotiented out. -/
inductive ManinGenerator : PreModularSymbol Cusp → Prop
  | antisymmetry (a b : Cusp) : ManinGenerator (maninAntisymmetryGenerator Cusp a b)
  | triangle (a b c : Cusp) : ManinGenerator (maninTriangleGenerator Cusp a b c)

/-- The subgroup generated by the Manin antisymmetry and triangle relations. -/
def ManinSubgroup : AddSubgroup (PreModularSymbol Cusp) :=
  AddSubgroup.closure {x | ManinGenerator Cusp x}

instance maninSubgroupNormal : (ManinSubgroup Cusp).Normal :=
  AddSubgroup.normal_of_comm (ManinSubgroup Cusp)

/-- The modular-symbol quotient by the Manin relations. -/
def ModularSymbolModule :=
  PreModularSymbol Cusp ⧸ ManinSubgroup Cusp

instance modularSymbolModuleAddCommGroup : AddCommGroup (ModularSymbolModule Cusp) := by
  dsimp [ModularSymbolModule]
  infer_instance

/-- The quotient map from the free abelian premodule to modular symbols. -/
def modularSymbolQuotientMap (x : PreModularSymbol Cusp) : ModularSymbolModule Cusp :=
  QuotientAddGroup.mk x

/-- The distinguished zero class in the modular-symbol quotient. -/
def modularSymbolZeroClass : ModularSymbolModule Cusp :=
  modularSymbolQuotientMap Cusp (0 : PreModularSymbol Cusp)

/-- Each basic Manin generator lies in the generated Manin subgroup. -/
theorem maninGenerator_mem {x : PreModularSymbol Cusp} (hx : ManinGenerator Cusp x) :
    x ∈ ManinSubgroup Cusp :=
  AddSubgroup.subset_closure hx

/-- The Manin antisymmetry relation belongs to the Manin subgroup. -/
theorem maninAntisymmetryGenerator_mem (a b : Cusp) :
    maninAntisymmetryGenerator Cusp a b ∈ ManinSubgroup Cusp :=
  maninGenerator_mem Cusp (ManinGenerator.antisymmetry a b)

/-- The Manin triangle relation belongs to the Manin subgroup. -/
theorem maninTriangleGenerator_mem (a b c : Cusp) :
    maninTriangleGenerator Cusp a b c ∈ ManinSubgroup Cusp :=
  maninGenerator_mem Cusp (ManinGenerator.triangle a b c)

/-- The diagonal modular symbol `{a, a}` belongs to the Manin subgroup.

This uses both Manin relations: antisymmetry gives `2 {a, a}`, while the
triangle relation gives `3 {a, a}`; their difference is `{a, a}`. -/
theorem modularSymbol_self_mem_ManinSubgroup (a : Cusp) :
    modularSymbol Cusp a a ∈ ManinSubgroup Cusp := by
  let x : PreModularSymbol Cusp := modularSymbol Cusp a a
  have h2 : x + x ∈ ManinSubgroup Cusp := by
    simpa [x, maninAntisymmetryGenerator] using
      maninAntisymmetryGenerator_mem Cusp a a
  have h3 : x + x + x ∈ ManinSubgroup Cusp := by
    simpa [x, maninTriangleGenerator] using
      maninTriangleGenerator_mem Cusp a a a
  have hsub : (x + x + x) - (x + x) ∈ ManinSubgroup Cusp :=
    (ManinSubgroup Cusp).sub_mem h3 h2
  simpa [x, sub_eq_add_neg, add_assoc, add_left_comm, add_comm] using hsub

/-- Any element of the Manin subgroup maps to the zero class in the quotient. -/
theorem modularSymbolQuotientMap_eq_zeroClass_of_mem {x : PreModularSymbol Cusp}
    (hx : x ∈ ManinSubgroup Cusp) :
    modularSymbolQuotientMap Cusp x = modularSymbolZeroClass Cusp := by
  rw [modularSymbolQuotientMap, modularSymbolZeroClass, modularSymbolQuotientMap]
  exact Quotient.sound' (by
    rw [QuotientAddGroup.leftRel_apply]
    simpa using (ManinSubgroup Cusp).neg_mem hx)

/-- The quotient map kills the Manin antisymmetry generators. -/
theorem modularSymbolQuotientMap_antisymmetry (a b : Cusp) :
    modularSymbolQuotientMap Cusp (maninAntisymmetryGenerator Cusp a b) =
      modularSymbolZeroClass Cusp :=
  modularSymbolQuotientMap_eq_zeroClass_of_mem Cusp
    (maninGenerator_mem Cusp (ManinGenerator.antisymmetry a b))

/-- The quotient map kills the Manin triangle generators. -/
theorem modularSymbolQuotientMap_triangle (a b c : Cusp) :
    modularSymbolQuotientMap Cusp (maninTriangleGenerator Cusp a b c) =
      modularSymbolZeroClass Cusp :=
  modularSymbolQuotientMap_eq_zeroClass_of_mem Cusp
    (maninTriangleGenerator_mem Cusp a b c)

/-- The diagonal modular symbol `{a, a}` is zero in the Manin quotient. -/
theorem modularSymbolQuotientMap_self (a : Cusp) :
    modularSymbolQuotientMap Cusp (modularSymbol Cusp a a) =
      modularSymbolZeroClass Cusp :=
  modularSymbolQuotientMap_eq_zeroClass_of_mem Cusp
    (modularSymbol_self_mem_ManinSubgroup Cusp a)

/-- Direct quotient form of Manin antisymmetry: `{a, b} = -{b, a}`. -/
theorem modularSymbolQuotientMap_eq_neg_swap (a b : Cusp) :
    modularSymbolQuotientMap Cusp (modularSymbol Cusp a b) =
      -modularSymbolQuotientMap Cusp (modularSymbol Cusp b a) := by
  have h := modularSymbolQuotientMap_antisymmetry Cusp a b
  rw [modularSymbolZeroClass, maninAntisymmetryGenerator, modularSymbolQuotientMap,
    QuotientAddGroup.mk_add] at h
  exact eq_neg_of_add_eq_zero_left h

/-- Direct quotient form of the Manin triangle relation. -/
theorem modularSymbolQuotientMap_add_eq_neg (a b c : Cusp) :
    modularSymbolQuotientMap Cusp (modularSymbol Cusp a b) +
        modularSymbolQuotientMap Cusp (modularSymbol Cusp b c) =
      -modularSymbolQuotientMap Cusp (modularSymbol Cusp c a) := by
  have h := modularSymbolQuotientMap_triangle Cusp a b c
  rw [modularSymbolZeroClass, maninTriangleGenerator, modularSymbolQuotientMap,
    QuotientAddGroup.mk_add, QuotientAddGroup.mk_add] at h
  exact eq_neg_of_add_eq_zero_left h

variable (Γ : Type v) [Group Γ] [MulAction Γ Cusp]

/-- The action of `γ : Γ` on ordered cusp pairs. -/
def gammaCuspPair (γ : Γ) : CuspPair Cusp → CuspPair Cusp :=
  cuspPairMap Cusp (fun a => γ • a)

/-- The Γ-coinvariant path generator `{γa, γb} - {a, b}`. -/
def gammaRelationGenerator (γ : Γ) (a b : Cusp) : PreModularSymbol Cusp :=
  modularSymbol Cusp (γ • a) (γ • b) - modularSymbol Cusp a b

/-- Generators for modular symbols with Manin and Γ-coinvariant relations. -/
inductive ModularSymbolRelationGenerator : PreModularSymbol Cusp → Prop
  | antisymmetry (a b : Cusp) :
      ModularSymbolRelationGenerator (maninAntisymmetryGenerator Cusp a b)
  | triangle (a b c : Cusp) :
      ModularSymbolRelationGenerator (maninTriangleGenerator Cusp a b c)
  | gamma (γ : Γ) (a b : Cusp) :
      ModularSymbolRelationGenerator (gammaRelationGenerator Cusp Γ γ a b)

/-- The subgroup generated by Manin relations and Γ-coinvariant path relations. -/
def ModularSymbolRelationSubgroup : AddSubgroup (PreModularSymbol Cusp) :=
  AddSubgroup.closure {x | ModularSymbolRelationGenerator Cusp Γ x}

instance modularSymbolRelationSubgroupNormal :
    (ModularSymbolRelationSubgroup Cusp Γ).Normal :=
  AddSubgroup.normal_of_comm (ModularSymbolRelationSubgroup Cusp Γ)

/-- Modular symbols for an abstract cusp space with Γ-action. -/
def ModularSymbol :=
  PreModularSymbol Cusp ⧸ ModularSymbolRelationSubgroup Cusp Γ

instance modularSymbolAddCommGroup : AddCommGroup (ModularSymbol Cusp Γ) := by
  dsimp [ModularSymbol]
  infer_instance

/-- The quotient map from the free abelian path module to Γ-modular symbols. -/
def modularSymbolRelationQuotientMap (x : PreModularSymbol Cusp) : ModularSymbol Cusp Γ :=
  QuotientAddGroup.mk x

/-- The zero class in the Γ-modular-symbol quotient. -/
def modularSymbolRelationZeroClass : ModularSymbol Cusp Γ :=
  modularSymbolRelationQuotientMap Cusp Γ (0 : PreModularSymbol Cusp)

/-- Each defining relation generator lies in the relation subgroup. -/
theorem modularSymbolRelationGenerator_mem {x : PreModularSymbol Cusp}
    (hx : ModularSymbolRelationGenerator Cusp Γ x) :
    x ∈ ModularSymbolRelationSubgroup Cusp Γ :=
  AddSubgroup.subset_closure hx

/-- The Manin antisymmetry relation belongs to the full Γ-relation subgroup. -/
theorem modularSymbolRelation_antisymmetry_mem (a b : Cusp) :
    maninAntisymmetryGenerator Cusp a b ∈ ModularSymbolRelationSubgroup Cusp Γ :=
  modularSymbolRelationGenerator_mem Cusp Γ
    (ModularSymbolRelationGenerator.antisymmetry a b)

/-- The Manin triangle relation belongs to the full Γ-relation subgroup. -/
theorem modularSymbolRelation_triangle_mem (a b c : Cusp) :
    maninTriangleGenerator Cusp a b c ∈ ModularSymbolRelationSubgroup Cusp Γ :=
  modularSymbolRelationGenerator_mem Cusp Γ
    (ModularSymbolRelationGenerator.triangle a b c)

/-- A Γ-coinvariant path relation belongs to the full relation subgroup. -/
theorem gammaRelationGenerator_mem (γ : Γ) (a b : Cusp) :
    gammaRelationGenerator Cusp Γ γ a b ∈ ModularSymbolRelationSubgroup Cusp Γ :=
  modularSymbolRelationGenerator_mem Cusp Γ
    (ModularSymbolRelationGenerator.gamma γ a b)

/-- The diagonal modular symbol `{a, a}` belongs to the full Γ-relation subgroup. -/
theorem modularSymbol_self_mem_relationSubgroup (a : Cusp) :
    modularSymbol Cusp a a ∈ ModularSymbolRelationSubgroup Cusp Γ := by
  let x : PreModularSymbol Cusp := modularSymbol Cusp a a
  have h2 : x + x ∈ ModularSymbolRelationSubgroup Cusp Γ := by
    simpa [x, maninAntisymmetryGenerator] using
      modularSymbolRelation_antisymmetry_mem Cusp Γ a a
  have h3 : x + x + x ∈ ModularSymbolRelationSubgroup Cusp Γ := by
    simpa [x, maninTriangleGenerator] using
      modularSymbolRelation_triangle_mem Cusp Γ a a a
  have hsub : (x + x + x) - (x + x) ∈ ModularSymbolRelationSubgroup Cusp Γ :=
    (ModularSymbolRelationSubgroup Cusp Γ).sub_mem h3 h2
  simpa [x, sub_eq_add_neg, add_assoc, add_left_comm, add_comm] using hsub

/-- Any element of the full relation subgroup maps to zero in the Γ quotient. -/
theorem modularSymbolRelationQuotientMap_eq_zeroClass_of_mem {x : PreModularSymbol Cusp}
    (hx : x ∈ ModularSymbolRelationSubgroup Cusp Γ) :
    modularSymbolRelationQuotientMap Cusp Γ x = modularSymbolRelationZeroClass Cusp Γ := by
  rw [modularSymbolRelationQuotientMap, modularSymbolRelationZeroClass,
    modularSymbolRelationQuotientMap]
  exact Quotient.sound' (by
    rw [QuotientAddGroup.leftRel_apply]
    simpa using (ModularSymbolRelationSubgroup Cusp Γ).neg_mem hx)

/-- The full Γ-modular-symbol quotient kills Manin antisymmetry generators. -/
theorem modularSymbolRelationQuotientMap_antisymmetry (a b : Cusp) :
    modularSymbolRelationQuotientMap Cusp Γ (maninAntisymmetryGenerator Cusp a b) =
      modularSymbolRelationZeroClass Cusp Γ :=
  modularSymbolRelationQuotientMap_eq_zeroClass_of_mem Cusp Γ
    (modularSymbolRelation_antisymmetry_mem Cusp Γ a b)

/-- The full Γ-modular-symbol quotient kills Manin triangle generators. -/
theorem modularSymbolRelationQuotientMap_triangle (a b c : Cusp) :
    modularSymbolRelationQuotientMap Cusp Γ (maninTriangleGenerator Cusp a b c) =
      modularSymbolRelationZeroClass Cusp Γ :=
  modularSymbolRelationQuotientMap_eq_zeroClass_of_mem Cusp Γ
    (modularSymbolRelation_triangle_mem Cusp Γ a b c)

/-- The full Γ-modular-symbol quotient kills Γ-coinvariant path generators. -/
theorem modularSymbolQuotientMap_gamma (γ : Γ) (a b : Cusp) :
    modularSymbolRelationQuotientMap Cusp Γ (gammaRelationGenerator Cusp Γ γ a b) =
      modularSymbolRelationZeroClass Cusp Γ :=
  modularSymbolRelationQuotientMap_eq_zeroClass_of_mem Cusp Γ
    (gammaRelationGenerator_mem Cusp Γ γ a b)

/-- Alias with the relation-qualified name for the Γ-coinvariant quotient relation. -/
theorem modularSymbolRelationQuotientMap_gamma (γ : Γ) (a b : Cusp) :
    modularSymbolRelationQuotientMap Cusp Γ (gammaRelationGenerator Cusp Γ γ a b) =
      modularSymbolRelationZeroClass Cusp Γ :=
  modularSymbolQuotientMap_gamma Cusp Γ γ a b

/-- The diagonal modular symbol `{a, a}` is zero in the full Γ-modular-symbol quotient. -/
theorem modularSymbolRelationQuotientMap_self (a : Cusp) :
    modularSymbolRelationQuotientMap Cusp Γ (modularSymbol Cusp a a) =
      modularSymbolRelationZeroClass Cusp Γ :=
  modularSymbolRelationQuotientMap_eq_zeroClass_of_mem Cusp Γ
    (modularSymbol_self_mem_relationSubgroup Cusp Γ a)

/-- Direct full-quotient form of Manin antisymmetry: `{a, b} = -{b, a}`. -/
theorem modularSymbolRelationQuotientMap_eq_neg_swap (a b : Cusp) :
    modularSymbolRelationQuotientMap Cusp Γ (modularSymbol Cusp a b) =
      -modularSymbolRelationQuotientMap Cusp Γ (modularSymbol Cusp b a) := by
  have h := modularSymbolRelationQuotientMap_antisymmetry Cusp Γ a b
  rw [modularSymbolRelationZeroClass, maninAntisymmetryGenerator,
    modularSymbolRelationQuotientMap, QuotientAddGroup.mk_add] at h
  exact eq_neg_of_add_eq_zero_left h

/-- Direct full-quotient form of the Manin triangle relation. -/
theorem modularSymbolRelationQuotientMap_add_eq_neg (a b c : Cusp) :
    modularSymbolRelationQuotientMap Cusp Γ (modularSymbol Cusp a b) +
        modularSymbolRelationQuotientMap Cusp Γ (modularSymbol Cusp b c) =
      -modularSymbolRelationQuotientMap Cusp Γ (modularSymbol Cusp c a) := by
  have h := modularSymbolRelationQuotientMap_triangle Cusp Γ a b c
  rw [modularSymbolRelationZeroClass, maninTriangleGenerator,
    modularSymbolRelationQuotientMap, QuotientAddGroup.mk_add, QuotientAddGroup.mk_add] at h
  exact eq_neg_of_add_eq_zero_left h

/-- Direct quotient form of Γ-coinvariance: `{γa, γb} = {a, b}`. -/
theorem modularSymbolRelationQuotientMap_gamma_eq (γ : Γ) (a b : Cusp) :
    modularSymbolRelationQuotientMap Cusp Γ (modularSymbol Cusp (γ • a) (γ • b)) =
      modularSymbolRelationQuotientMap Cusp Γ (modularSymbol Cusp a b) := by
  have h := modularSymbolRelationQuotientMap_gamma Cusp Γ γ a b
  rw [modularSymbolRelationZeroClass, gammaRelationGenerator,
    modularSymbolRelationQuotientMap, QuotientAddGroup.mk_sub] at h
  exact sub_eq_zero.mp h

instance : Inhabited (ModularSymbol Cusp Γ) :=
  ⟨modularSymbolRelationZeroClass Cusp Γ⟩

/-- The Γ-modular-symbol quotient is nonempty when the cusp type is inhabited. -/
theorem modularSymbol_nonempty [Inhabited Cusp] : Nonempty (ModularSymbol Cusp Γ) :=
  inferInstance

instance : Inhabited (ModularSymbolModule Cusp) :=
  ⟨modularSymbolZeroClass Cusp⟩

/-- The modular-symbol quotient is nonempty when the cusp type is inhabited. -/
theorem modularSymbolModule_nonempty [Inhabited Cusp] : Nonempty (ModularSymbolModule Cusp) :=
  inferInstance

end ModularSymbols

section ManinDrinfeldBoundary

/-- Primitive package for the modular curve `X_0(N)` and its Jacobian `J_0(N)`.

Mathlib v4.17.0 does not yet provide a modular-curve/Jacobian API for `X_0(N)`.
This structure names the missing objects while keeping the target Jacobian as a
genuine additive group, so downstream statements can use Mathlib's torsion
predicates without inventing a theorem. -/
structure ModularCurveJ0Primitive (N : ℕ) where
  /-- The compact modular curve `X_0(N)`, supplied by a future API. -/
  X0 : Type
  /-- The Jacobian `J_0(N)`, supplied by a future API. -/
  J0 : Type
  /-- The additive group law on the Jacobian. -/
  jacobianAddCommGroup : AddCommGroup J0

/-- Primitive package for degree-zero cuspidal divisors and their classes in
`J_0(N)`.

The fields isolate the exact geometric inputs missing from Mathlib v4.17.0:
modular-curve cusps, the degree-zero cuspidal divisor group, and the
Abel-Jacobi/class map into the Jacobian. -/
structure CuspidalDivisorClassPrimitive (N : ℕ) where
  /-- The underlying `X_0(N)`/`J_0(N)` package. -/
  curve : ModularCurveJ0Primitive N
  /-- The cusp type on `X_0(N)`. -/
  Cusp : Type
  /-- The inclusion of cusps into the compact modular curve. -/
  cuspToX0 : Cusp → curve.X0
  /-- The degree-zero divisor classes generated by cusps. -/
  degreeZeroCuspidalDivisor : Type
  /-- The image of a degree-zero cuspidal divisor in `J_0(N)`. -/
  divisorClass : degreeZeroCuspidalDivisor → curve.J0
  /-- Marker that these divisors are generated by cusp differences. -/
  generatedByCusps : Prop

/-- A positive multiple equal to zero proves finite additive order. -/
theorem isOfFinAddOrder_of_nsmul_eq_zero {A : Type*} [AddMonoid A] {x : A}
    (n : ℕ) (hn : 0 < n) (hx : n • x = 0) :
    IsOfFinAddOrder x :=
  isOfFinAddOrder_iff_nsmul_eq_zero.mpr ⟨n, hn, hx⟩

/-- A supplied Manin-Drinfeld torsion hypothesis gives torsion for each
cuspidal divisor class. -/
theorem cuspidalDivisorClass_isOfFinAddOrder_of_hypothesis
    {N : ℕ} (D : CuspidalDivisorClassPrimitive N)
    (hD :
      ∀ d : D.degreeZeroCuspidalDivisor,
        letI := D.curve.jacobianAddCommGroup
        IsOfFinAddOrder (D.divisorClass d))
    (d : D.degreeZeroCuspidalDivisor) :
    letI := D.curve.jacobianAddCommGroup
    IsOfFinAddOrder (D.divisorClass d) :=
  hD d

end ManinDrinfeldBoundary

-- Exported API for downstream files.
#check cuspStabilizer
#check parabolicNormalizer
#check cuspStabilizer_le_parabolicNormalizer
#check mem_parabolicNormalizer_of_smul_eq
#check subgroup_le_parabolicNormalizer_of_smul_eq
#check mem_cuspStabilizer_smul_iff
#check mem_parabolicNormalizer_smul_of_mem
#check mem_parabolicNormalizer_smul_iff
#check cuspStabilizer_normal_in_parabolicNormalizer
#check parabolicNormalizer_self_normalizing_of_normalizer_le
#check cuspParabolicFamily
#check cuspStabilizer_le_cuspParabolicFamily
#check mem_cuspParabolicFamily_of_smul_eq
#check ModularForm
#check CuspForm
#check CongruenceSubgroup.Gamma0
#check ParabolicCohomology
#check H1π_mem_parabolicCohomology
#check ParabolicCohomologyForCuspSet
#check H1π_mem_parabolicCohomologyForCuspSet
#check mem_parabolicCohomology_of_subgroup_le
#check ParabolicRestrictionData
#check ParabolicRestrictionData.mem_iff_restriction_eq_zero
#check ParabolicRestrictionData.restriction_eq_zero_of_mem
#check ParabolicRestrictionData.mem_of_restriction_eq_zero
#check ParabolicRestrictionKernelPrimitive
#check ParabolicPreservingEndomorphism
#check ParabolicPreservingEndomorphism.restrict
#check HeckeCompatibilityData
#check HeckeCompatibilityData.apply
#check HeckeCompatibilityData.apply_at_index
#check WeightTwoCuspForms
#check WeightTwoEichlerShimuraTarget
#check weightTwoTargetFst
#check weightTwoTargetSnd
#check YGammaCuspSpacePrimitive
#check ParabolicMeasure
#check peterssonKernel
#check peterssonDensity
#check cuspFormPeterssonDensity
#check peterssonLIntegral
#check PeterssonFinite
#check CuspFormPeterssonFinite
#check CuspPair
#check PreModularSymbol
#check modularSymbol
#check cuspPairMap
#check ManinGenerator
#check ManinSubgroup
#check ModularSymbolModule
#check maninAntisymmetryGenerator_mem
#check maninTriangleGenerator_mem
#check modularSymbol_self_mem_ManinSubgroup
#check modularSymbolQuotientMap_antisymmetry
#check modularSymbolQuotientMap_triangle
#check modularSymbolQuotientMap_self
#check modularSymbolQuotientMap_eq_neg_swap
#check modularSymbolQuotientMap_add_eq_neg
#check gammaCuspPair
#check gammaRelationGenerator
#check ModularSymbolRelationGenerator
#check ModularSymbolRelationSubgroup
#check ModularSymbol
#check modularSymbolRelation_antisymmetry_mem
#check modularSymbolRelation_triangle_mem
#check gammaRelationGenerator_mem
#check modularSymbol_self_mem_relationSubgroup
#check modularSymbolRelationQuotientMap_antisymmetry
#check modularSymbolRelationQuotientMap_triangle
#check modularSymbolQuotientMap_gamma
#check modularSymbolRelationQuotientMap_self
#check modularSymbolRelationQuotientMap_eq_neg_swap
#check modularSymbolRelationQuotientMap_add_eq_neg
#check modularSymbolRelationQuotientMap_gamma_eq
#check ModularCurveJ0Primitive
#check CuspidalDivisorClassPrimitive
#check isOfFinAddOrder_of_nsmul_eq_zero
#check cuspidalDivisorClass_isOfFinAddOrder_of_hypothesis

end ParabolicCohomology
end Roots
end MathlibExpansion
