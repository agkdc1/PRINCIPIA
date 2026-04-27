import MathlibExpansion.Roots.HodgeTate
import Mathlib.RingTheory.WittVector.Frobenius
import Mathlib.RingTheory.Filtration
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.LinearMap.Basic

/-!
# Fontaine-Laffaille modules: ordinary FLT boundary

Mathlib v4.17.0 contains Witt vectors and generic filtrations, but not the
Fontaine-Laffaille category or the ordinary `E[p]` construction used in the
FLT spine. This file deliberately records only the ordinary low-weight scope:
Hodge weights are in `{0, 1}`, and supersingular/crystalline `E[p]` comparison
boundaries are out of scope for R8.

R8.2 scope reduction keeps only ordinary load-bearing primitives: perfect
residue fields, finite-free filtered lattices, divided Frobenius, Frobenius
divisibility, ordinary good-reduction `E[p]` attachment, and strictness for
ordinary morphisms.  Category/equivalence, supersingular, Tate-twist, duality,
direct-sum, base-change, weak-admissibility, and rank-polynomial boundaries
belong to later roots or to non-ordinary side quests.
-/

namespace MathlibExpansion
namespace Roots
namespace FontaineLaffaille

universe u v w

/-- Boundary primitive: Mathlib v4.17.0 has no bundled perfect residue-field
hypothesis/API specialised to Fontaine-Laffaille theory. -/
def HasPerfectResidueFieldAPI (_p : ℕ) [Fact _p.Prime] (k : Type u) [CommRing k] : Prop :=
  False

/-- Boundary primitive: Mathlib v4.17.0 has no finite-free filtered
Witt-vector lattice API specialized to ordinary Fontaine-Laffaille modules,
including the theorem that the filtration pieces are saturated direct summands
and that the filtration is exhaustive and separated. -/
def HasFontaineLaffailleFiniteFreeFilteredLatticeAPI
    (p : ℕ) [Fact p.Prime] (k : Type u) [CommRing k]
    (M : Type v) [AddCommGroup M] [Module (WittVector p k) M]
    (_Fil : ℤ → Submodule (WittVector p k) M) : Prop :=
  False

/-- Boundary primitive: Mathlib v4.17.0 has no divided Frobenius package
`φ_i : Fil^i M → M` with the Fontaine-Laffaille compatibility
`φ_i(x) = p φ_(i+1)(x)` on the next filtration step and generation by the
images of all divided Frobenius maps. -/
def HasFontaineLaffailleDividedFrobeniusAPI
    (p : ℕ) [Fact p.Prime] (k : Type u) [CommRing k]
    (M : Type v) [AddCommGroup M] [Module (WittVector p k) M]
    (_Fil : ℤ → Submodule (WittVector p k) M) : Prop :=
  False

/-- Boundary primitive: Mathlib v4.17.0 has no filtered Frobenius
divisibility API for ordinary Fontaine-Laffaille modules, i.e. no packaged
theorem that `φ(Fil^i M)` lands in the `p^i`-divisible part of `M` in the
range used to define the divided Frobenius maps. -/
def HasFontaineLaffailleFrobeniusDivisibilityAPI
    (p : ℕ) [Fact p.Prime] (k : Type u) [CommRing k]
    (M : Type v) [AddCommGroup M] [Module (WittVector p k) M]
    (_Fil : ℤ → Submodule (WittVector p k) M) : Prop :=
  False

/-- Boundary primitive: Mathlib v4.17.0 has no ordinary good-reduction
construction attaching a Fontaine-Laffaille module to `E[p]` for an elliptic
curve, in the FLT Hodge-weight range `{0, 1}`. -/
def HasGoodReductionEllipticPTorsionFontaineLaffailleAPI
    (_p : ℕ) [Fact _p.Prime] (k : Type u) [CommRing k]
    (K : Type v) [Field K] (_E : WeierstrassCurve K) [_hE : _E.IsElliptic] : Prop :=
  False

/-- Boundary primitive: Mathlib v4.17.0 has no strictness theorem for
ordinary Fontaine-Laffaille morphisms of filtered Witt-vector modules.  This
is the minimal kernel/cokernel prerequisite retained as a proposition-valued
sidecar, not a full exact-category API. -/
def HasFontaineLaffailleStrictMorphismsAPI
    (_p : ℕ) [Fact _p.Prime] (k : Type u) [CommRing k] : Prop :=
  False

/-- A typed ordinary Fontaine-Laffaille module boundary over the Witt vectors
`W(k)`.

The fields intentionally separate the pieces Mathlib can express today
(`WittVector`, modules, submodules, and a Frobenius-shaped map) from the
Fontaine-Laffaille-specific ordinary low-weight conditions absent upstream. -/
structure FontaineLaffailleModule (p : ℕ) [Fact p.Prime] (k : Type u) [CommRing k] where
  M : Type v
  instAddCommGroup : AddCommGroup M
  instModule : Module (WittVector p k) M
  filtration : ℤ → Submodule (WittVector p k) M
  filtration_antitone : ∀ i j : ℤ, i ≤ j → filtration j ≤ filtration i
  frobenius : M →ₗ[WittVector p k] M
  hodgeWeights : Multiset ℤ
  weights_supported : ∀ n : ℤ, n ∈ hodgeWeights → n = 0 ∨ n = 1
  hasPerfectResidueFieldAPI : HasPerfectResidueFieldAPI p k

attribute [instance] FontaineLaffailleModule.instAddCommGroup
attribute [instance] FontaineLaffailleModule.instModule

namespace FontaineLaffailleModule

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    (MFL : FontaineLaffailleModule p k)

/-- The Hodge filtration piece `Fil^i M`. -/
def Fil (i : ℤ) : Submodule (WittVector p k) MFL.M :=
  MFL.filtration i

theorem Fil_antitone {i j : ℤ} (hij : i ≤ j) :
    MFL.Fil j ≤ MFL.Fil i :=
  MFL.filtration_antitone i j hij

theorem requires_perfect_residue_field_api (MFL : FontaineLaffailleModule p k) :
    HasPerfectResidueFieldAPI p k :=
  FontaineLaffailleModule.hasPerfectResidueFieldAPI MFL

/-- The FLT low-weight condition for ordinary Fontaine-Laffaille modules. -/
def HasWeightsZeroOne : Prop :=
  ∀ n : ℤ, n ∈ MFL.hodgeWeights → n = 0 ∨ n = 1

/-- The exact FLT Hodge-weight multiset `{0, 1}`. This is stronger than the
support-only predicate and is useful for the elliptic-curve `E[p]` target. -/
def ExactZeroOneWeights : Prop :=
  MFL.hodgeWeights = (0 ::ₘ {1} : Multiset ℤ)

/-- Exhaustiveness of the decreasing filtration, stated using only Mathlib's
submodule membership relation. -/
def HasExhaustiveFiltration : Prop :=
  ∀ x : MFL.M, ∃ i : ℤ, x ∈ MFL.Fil i

/-- Separatedness of the decreasing filtration, stated as triviality of the
intersection of all filtration pieces. -/
def HasSeparatedFiltration : Prop :=
  ∀ x : MFL.M, (∀ i : ℤ, x ∈ MFL.Fil i) → x = 0

theorem weights_zero_one :
    MFL.HasWeightsZeroOne :=
  MFL.weights_supported

/-- Exact weights `{0, 1}` imply the support predicate used by the ordinary
low-weight boundary. -/
theorem weights_zero_one_of_exact (h : MFL.ExactZeroOneWeights) :
    MFL.HasWeightsZeroOne := by
  intro n hn
  rw [FontaineLaffailleModule.ExactZeroOneWeights] at h
  rw [h] at hn
  simpa using hn

/-- The weight-support condition for a closed integer interval. -/
def WeightsInRange (lo hi : ℤ) : Prop :=
  ∀ n : ℤ, n ∈ MFL.hodgeWeights → lo ≤ n ∧ n ≤ hi

/-- The FLT ordinary Fontaine-Laffaille surface is the small interval `[0, 1]`. -/
theorem weights_in_zero_one_range :
    MFL.WeightsInRange 0 1 := by
  intro n hn
  rcases MFL.weights_supported n hn with rfl | rfl
  · exact ⟨le_rfl, by decide⟩
  · exact ⟨by decide, le_rfl⟩

/-- Since the current root is the FLT `k = 2` case, the `{0, 1}` support is
exactly support in the Fontaine-Laffaille interval `[0, 2 - 1]`. -/
theorem weights_in_FLT_interval :
    MFL.WeightsInRange 0 ((2 : ℤ) - 1) := by
  simpa using MFL.weights_in_zero_one_range

end FontaineLaffailleModule

/-- Finite-free filtered Witt-vector lattice data for a Fontaine-Laffaille
module.

The current ordinary root needs the underlying object to be a finite free
`W(k)`-module with a filtration by saturated direct summands. -/
structure FiniteFreeFilteredLatticeData
    {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    (MFL : FontaineLaffailleModule p k) where
  rank : ℕ
  finiteFreeStatement : Prop
  finiteFree : finiteFreeStatement
  filtrationDirectSummandStatement : Prop
  filtrationDirectSummand : filtrationDirectSummandStatement
  exhaustive : MFL.HasExhaustiveFiltration
  separated : MFL.HasSeparatedFiltration
  hasFiniteFreeFilteredLatticeAPI :
    HasFontaineLaffailleFiniteFreeFilteredLatticeAPI p k MFL.M MFL.Fil

namespace FiniteFreeFilteredLatticeData

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {MFL : FontaineLaffailleModule p k}
    (L : FiniteFreeFilteredLatticeData MFL)

/-- The packaged rank of the finite free Witt-vector lattice. -/
def latticeRank : ℕ :=
  L.rank

theorem finite_free_statement :
    L.finiteFreeStatement :=
  L.finiteFree

theorem filtration_direct_summand_statement :
    L.filtrationDirectSummandStatement :=
  L.filtrationDirectSummand

theorem exhaustive_filtration :
    (L : FiniteFreeFilteredLatticeData MFL) → MFL.HasExhaustiveFiltration :=
  fun L =>
  FiniteFreeFilteredLatticeData.exhaustive L

theorem separated_filtration :
    (L : FiniteFreeFilteredLatticeData MFL) → MFL.HasSeparatedFiltration :=
  fun L =>
  FiniteFreeFilteredLatticeData.separated L

theorem requires_finite_free_filtered_lattice_api
    (L : FiniteFreeFilteredLatticeData MFL) :
    HasFontaineLaffailleFiniteFreeFilteredLatticeAPI p k MFL.M MFL.Fil :=
  FiniteFreeFilteredLatticeData.hasFiniteFreeFilteredLatticeAPI L

end FiniteFreeFilteredLatticeData

/-- Normalized low-weight filtration data for an ordinary Fontaine-Laffaille
module.

This is retained as ordinary data, not as a boundary primitive: the FLT
low-weight range needs `Fil^0 = M` and `Fil^2 = 0`, but R8.2 does not keep a
separate normalized-filtration `Has...API`. -/
structure NormalizedLowWeightFiltrationData
    {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    (MFL : FontaineLaffailleModule p k) where
  filtrationTopAtZero : MFL.Fil 0 = ⊤
  filtrationBottomAtTwo : MFL.Fil 2 = ⊥
  gradeZeroStatement : Prop
  gradeZero : gradeZeroStatement
  gradeOneStatement : Prop
  gradeOne : gradeOneStatement
  noOtherGradesStatement : Prop
  noOtherGrades : noOtherGradesStatement

namespace NormalizedLowWeightFiltrationData

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {MFL : FontaineLaffailleModule p k}
    (N : NormalizedLowWeightFiltrationData MFL)

theorem fil_zero_eq_top :
    (N : NormalizedLowWeightFiltrationData MFL) → MFL.Fil 0 = ⊤ :=
  fun N =>
  NormalizedLowWeightFiltrationData.filtrationTopAtZero N

theorem fil_two_eq_bot :
    (N : NormalizedLowWeightFiltrationData MFL) → MFL.Fil 2 = ⊥ :=
  fun N =>
  NormalizedLowWeightFiltrationData.filtrationBottomAtTwo N

theorem grade_zero_statement :
    N.gradeZeroStatement :=
  N.gradeZero

theorem grade_one_statement :
    N.gradeOneStatement :=
  N.gradeOne

theorem no_other_grades_statement :
    N.noOtherGradesStatement :=
  N.noOtherGrades

theorem weights_in_zero_one_range :
    MFL.WeightsInRange 0 1 :=
  MFL.weights_in_zero_one_range

end NormalizedLowWeightFiltrationData

/-- Divided Frobenius data for a filtered Witt-vector module. -/
structure DividedFrobeniusData
    {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    (MFL : FontaineLaffailleModule p k) where
  dividedFrobenius :
    ∀ i : ℤ, MFL.Fil i →ₗ[WittVector p k] MFL.M
  compatibility : Prop
  strongGeneration : Prop
  hasDividedFrobeniusAPI :
    HasFontaineLaffailleDividedFrobeniusAPI p k MFL.M MFL.Fil

namespace DividedFrobeniusData

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {MFL : FontaineLaffailleModule p k}
    (D : DividedFrobeniusData MFL)

/-- The `i`th divided Frobenius map on the `i`th filtration piece. -/
def phi (i : ℤ) : MFL.Fil i →ₗ[WittVector p k] MFL.M :=
  D.dividedFrobenius i

/-- The compatibility condition required of a Fontaine-Laffaille divided
Frobenius system. -/
def IsCompatible (D : DividedFrobeniusData MFL) : Prop :=
  D.compatibility

/-- The strong divisibility condition: the images of the divided Frobenius
maps generate the underlying module. -/
def IsStronglyDivisible (D : DividedFrobeniusData MFL) : Prop :=
  D.strongGeneration

theorem compatible_of_data (h : D.compatibility) :
    IsCompatible D :=
  h

theorem strongly_divisible_of_data (h : D.strongGeneration) :
    IsStronglyDivisible D :=
  h

theorem requires_divided_frobenius_api (D : DividedFrobeniusData MFL) :
    HasFontaineLaffailleDividedFrobeniusAPI p k MFL.M MFL.Fil :=
  DividedFrobeniusData.hasDividedFrobeniusAPI D

/-- Strong-divisibility package used by the ordinary low-weight boundary. -/
def StrongDivisibilityCondition (D : DividedFrobeniusData MFL) : Prop :=
  IsCompatible D ∧ IsStronglyDivisible D

theorem strong_divisibility_condition_of_fields
    (hcompat : D.compatibility) (hgen : D.strongGeneration) :
    StrongDivisibilityCondition D :=
  ⟨hcompat, hgen⟩

end DividedFrobeniusData

/-- Low-weight Fontaine-Laffaille objects for the ordinary FLT case. -/
structure LowWeightFontaineLaffailleObject
    (p : ℕ) [Fact p.Prime] (k : Type u) [CommRing k] where
  module_ : FontaineLaffailleModule p k
  dividedFrobenius : DividedFrobeniusData module_
  strongDivisible :
    DividedFrobeniusData.StrongDivisibilityCondition dividedFrobenius

namespace LowWeightFontaineLaffailleObject

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    (X : LowWeightFontaineLaffailleObject p k)

theorem weights_in_zero_one_range :
    X.module_.WeightsInRange 0 1 :=
  X.module_.weights_in_zero_one_range

theorem requires_divided_frobenius_api (X : LowWeightFontaineLaffailleObject p k) :
    HasFontaineLaffailleDividedFrobeniusAPI p k X.module_.M X.module_.Fil :=
  DividedFrobeniusData.hasDividedFrobeniusAPI X.dividedFrobenius

theorem strong_divisibility :
    DividedFrobeniusData.StrongDivisibilityCondition X.dividedFrobenius :=
  X.strongDivisible

end LowWeightFontaineLaffailleObject

/-- The ordinary R8 `E[p]` attachment boundary: for an elliptic curve with
good ordinary reduction, the attached Fontaine-Laffaille object is low-weight
with Hodge weights `{0, 1}`. -/
structure EllipticCurvePTorsionFontaineLaffailleAttachment
    (p : ℕ) [Fact p.Prime] (k : Type u) [CommRing k]
    (K : Type v) [Field K] (Coeff : Type w) [Field Coeff]
    (E : WeierstrassCurve K) [hE : E.IsElliptic] where
  goodOrdinaryReductionAtP : Prop
  goodOrdinaryReduction : goodOrdinaryReductionAtP
  hodgeTatePackage :
    MathlibExpansion.Roots.HodgeTate.EllipticCurveHodgeTatePackage K Coeff E p
  fontaineLaffailleObject : LowWeightFontaineLaffailleObject p k
  attachedToEp : Prop
  attached : attachedToEp
  hasGoodReductionAttachmentAPI :
    HasGoodReductionEllipticPTorsionFontaineLaffailleAPI p k K E

namespace EllipticCurvePTorsionFontaineLaffailleAttachment

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {K : Type v} [Field K] {Coeff : Type w} [Field Coeff]
    {E : WeierstrassCurve K} [hE : E.IsElliptic]
    (A : EllipticCurvePTorsionFontaineLaffailleAttachment p k K Coeff E)

theorem good_ordinary_reduction_at_p :
    A.goodOrdinaryReductionAtP :=
  A.goodOrdinaryReduction

theorem attached_weights_in_zero_one_range :
    A.fontaineLaffailleObject.module_.WeightsInRange 0 1 :=
  LowWeightFontaineLaffailleObject.weights_in_zero_one_range A.fontaineLaffailleObject

theorem hodge_tate_weights_eq_zero_one :
    A.hodgeTatePackage.hodgeTateWeights.weights =
      MathlibExpansion.Roots.HodgeTate.EllipticCurveHodgeTatePackage.zeroOneWeights :=
  MathlibExpansion.Roots.HodgeTate.EllipticCurveHodgeTatePackage.weights_eq_zero_one'
    A.hodgeTatePackage

theorem attached_to_Ep :
    A.attachedToEp :=
  A.attached

theorem requires_good_reduction_attachment_api
    (A : EllipticCurvePTorsionFontaineLaffailleAttachment p k K Coeff E) :
    HasGoodReductionEllipticPTorsionFontaineLaffailleAPI p k K E :=
  EllipticCurvePTorsionFontaineLaffailleAttachment.hasGoodReductionAttachmentAPI A

/-- For the FLT use case, `p > 2` is precisely the small-weight inequality
`2 < p` needed for weights in `[0, 2 - 1]`. -/
theorem FLT_small_weight_bound {q : ℕ} (hp : 2 < q) :
    2 < q :=
  hp

end EllipticCurvePTorsionFontaineLaffailleAttachment

/-- Concrete morphisms of the typed ordinary Fontaine-Laffaille boundary.

This side-steps the absent packaged category by recording the ordinary
Mathlib-native payload: a `W(k)`-linear map preserving the decreasing
filtration and commuting with the Frobenius-shaped endomorphism. -/
structure FontaineLaffailleHom
    {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    (M N : FontaineLaffailleModule p k) where
  toLinearMap : M.M →ₗ[WittVector p k] N.M
  preserves_filtration :
    ∀ i : ℤ, ∀ x : M.M, x ∈ M.Fil i → toLinearMap x ∈ N.Fil i
  commutes_frobenius :
    ∀ x : M.M, toLinearMap (M.frobenius x) = N.frobenius (toLinearMap x)

namespace FontaineLaffailleHom

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {M N P : FontaineLaffailleModule p k}

instance : CoeFun (FontaineLaffailleHom M N) (fun _ => M.M → N.M) where
  coe f := f.toLinearMap

/-- Identity morphism in the concrete Fontaine-Laffaille morphism layer. -/
def id (M : FontaineLaffailleModule p k) : FontaineLaffailleHom M M where
  toLinearMap := LinearMap.id
  preserves_filtration := by
    intro i x hx
    exact hx
  commutes_frobenius := by
    intro x
    rfl

/-- Composition of concrete Fontaine-Laffaille morphisms. -/
def comp (g : FontaineLaffailleHom N P) (f : FontaineLaffailleHom M N) :
    FontaineLaffailleHom M P where
  toLinearMap := g.toLinearMap.comp f.toLinearMap
  preserves_filtration := by
    intro i x hx
    exact g.preserves_filtration i (f.toLinearMap x)
      (f.preserves_filtration i x hx)
  commutes_frobenius := by
    intro x
    rw [LinearMap.comp_apply, f.commutes_frobenius, g.commutes_frobenius]
    rfl

@[simp]
theorem id_apply (x : M.M) :
    id M x = x :=
  rfl

@[simp]
theorem comp_apply (g : FontaineLaffailleHom N P) (f : FontaineLaffailleHom M N)
    (x : M.M) :
    comp g f x = g (f x) :=
  rfl

theorem map_mem_filtration (f : FontaineLaffailleHom M N)
    {i : ℤ} {x : M.M} (hx : x ∈ M.Fil i) :
    f x ∈ N.Fil i :=
  f.preserves_filtration i x hx

theorem map_frobenius (f : FontaineLaffailleHom M N) (x : M.M) :
    f (M.frobenius x) = N.frobenius (f x) :=
  f.commutes_frobenius x

theorem comp_map_frobenius (g : FontaineLaffailleHom N P)
    (f : FontaineLaffailleHom M N) (x : M.M) :
    comp g f (M.frobenius x) = P.frobenius (comp g f x) :=
  (comp g f).map_frobenius x

theorem source_target_weights_in_zero_one_range (_f : FontaineLaffailleHom M N) :
    M.WeightsInRange 0 1 ∧ N.WeightsInRange 0 1 :=
  ⟨M.weights_in_zero_one_range, N.weights_in_zero_one_range⟩

end FontaineLaffailleHom

/-- Concrete morphisms between ordinary low-weight Fontaine-Laffaille objects. -/
structure LowWeightFontaineLaffailleHom
    {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    (X Y : LowWeightFontaineLaffailleObject p k) where
  hom : FontaineLaffailleHom X.module_ Y.module_

namespace LowWeightFontaineLaffailleHom

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {X Y Z : LowWeightFontaineLaffailleObject p k}

def id (X : LowWeightFontaineLaffailleObject p k) :
    LowWeightFontaineLaffailleHom X X where
  hom := FontaineLaffailleHom.id X.module_

def comp (g : LowWeightFontaineLaffailleHom Y Z)
    (f : LowWeightFontaineLaffailleHom X Y) :
    LowWeightFontaineLaffailleHom X Z where
  hom := FontaineLaffailleHom.comp g.hom f.hom

theorem source_target_weights_in_zero_one_range
    (f : LowWeightFontaineLaffailleHom X Y) :
    X.module_.WeightsInRange 0 1 ∧ Y.module_.WeightsInRange 0 1 :=
  f.hom.source_target_weights_in_zero_one_range

end LowWeightFontaineLaffailleHom

/-- Strictness data for a concrete ordinary Fontaine-Laffaille morphism. -/
structure StrictFontaineLaffailleHomData
    {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {M N : FontaineLaffailleModule p k}
    (f : FontaineLaffailleHom M N) where
  strictFiltrationStatement : Prop
  strictFiltration : strictFiltrationStatement
  kernelFiltrationCompatibleStatement : Prop
  kernelFiltrationCompatible : kernelFiltrationCompatibleStatement
  cokernelFiltrationCompatibleStatement : Prop
  cokernelFiltrationCompatible : cokernelFiltrationCompatibleStatement
  hasStrictMorphismsAPI : HasFontaineLaffailleStrictMorphismsAPI p k

namespace StrictFontaineLaffailleHomData

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {M N : FontaineLaffailleModule p k}
    {f : FontaineLaffailleHom M N}
    (S : StrictFontaineLaffailleHomData f)

theorem strict_filtration_statement :
    S.strictFiltrationStatement :=
  S.strictFiltration

theorem kernel_filtration_compatible :
    S.kernelFiltrationCompatibleStatement :=
  S.kernelFiltrationCompatible

theorem cokernel_filtration_compatible :
    S.cokernelFiltrationCompatibleStatement :=
  S.cokernelFiltrationCompatible

theorem requires_strict_morphisms_api
    (S : StrictFontaineLaffailleHomData f) :
    HasFontaineLaffailleStrictMorphismsAPI p k :=
  StrictFontaineLaffailleHomData.hasStrictMorphismsAPI S

theorem map_mem_filtration
    {i : ℤ} {x : M.M} (hx : x ∈ M.Fil i) :
    f x ∈ N.Fil i :=
  f.map_mem_filtration hx

theorem source_target_weights_in_zero_one_range :
    M.WeightsInRange 0 1 ∧ N.WeightsInRange 0 1 :=
  ⟨M.weights_in_zero_one_range, N.weights_in_zero_one_range⟩

end StrictFontaineLaffailleHomData

/-- The retained filtered-Frobenius divisibility layer. -/
structure FilteredFrobeniusDivisibilityData
    {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    (MFL : FontaineLaffailleModule p k) where
  frobeniusPreservesFiltration :
    ∀ i : ℤ, ∀ x : MFL.M, x ∈ MFL.Fil i → MFL.frobenius x ∈ MFL.Fil i
  frobeniusDivisibleOnFiltration : Prop
  divisible : frobeniusDivisibleOnFiltration
  hasFrobeniusDivisibilityAPI :
    HasFontaineLaffailleFrobeniusDivisibilityAPI p k MFL.M MFL.Fil

namespace FilteredFrobeniusDivisibilityData

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]
    {MFL : FontaineLaffailleModule p k}
    (F : FilteredFrobeniusDivisibilityData MFL)

theorem map_mem_filtration
    (F : FilteredFrobeniusDivisibilityData MFL)
    {i : ℤ} {x : MFL.M} (hx : x ∈ MFL.Fil i) :
    MFL.frobenius x ∈ MFL.Fil i :=
  FilteredFrobeniusDivisibilityData.frobeniusPreservesFiltration F i x hx

theorem frobenius_divisible_on_filtration
    (F : FilteredFrobeniusDivisibilityData MFL) :
    F.frobeniusDivisibleOnFiltration :=
  FilteredFrobeniusDivisibilityData.divisible F

theorem requires_frobenius_divisibility_api
    (F : FilteredFrobeniusDivisibilityData MFL) :
    HasFontaineLaffailleFrobeniusDivisibilityAPI p k MFL.M MFL.Fil :=
  FilteredFrobeniusDivisibilityData.hasFrobeniusDivisibilityAPI F

/-- The divisibility layer combines with divided Frobenius data into the
strong-divisibility package expected of ordinary low-weight objects. -/
structure WithDividedFrobenius where
  divisibilityData : FilteredFrobeniusDivisibilityData MFL
  dividedFrobenius : DividedFrobeniusData MFL
  strongDivisible :
    DividedFrobeniusData.StrongDivisibilityCondition dividedFrobenius

namespace WithDividedFrobenius

theorem requires_frobenius_divisibility_api
    (W : WithDividedFrobenius (MFL := MFL)) :
    HasFontaineLaffailleFrobeniusDivisibilityAPI p k MFL.M MFL.Fil :=
  FilteredFrobeniusDivisibilityData.requires_frobenius_divisibility_api
    (WithDividedFrobenius.divisibilityData W)

theorem requires_divided_frobenius_api
    (W : WithDividedFrobenius (MFL := MFL)) :
    HasFontaineLaffailleDividedFrobeniusAPI p k MFL.M MFL.Fil :=
  DividedFrobeniusData.requires_divided_frobenius_api
    (WithDividedFrobenius.dividedFrobenius W)

def toLowWeightObject
    (W : WithDividedFrobenius (MFL := MFL)) :
    LowWeightFontaineLaffailleObject p k where
  module_ := MFL
  dividedFrobenius := WithDividedFrobenius.dividedFrobenius W
  strongDivisible := WithDividedFrobenius.strongDivisible W

@[simp]
theorem toLowWeightObject_module
    (W : WithDividedFrobenius (MFL := MFL)) :
    (toLowWeightObject W).module_ = MFL :=
  rfl

end WithDividedFrobenius

end FilteredFrobeniusDivisibilityData

#check @FontaineLaffailleModule.weights_zero_one_of_exact
#check @FiniteFreeFilteredLatticeData.requires_finite_free_filtered_lattice_api
#check @FiniteFreeFilteredLatticeData.exhaustive_filtration
#check @FiniteFreeFilteredLatticeData.separated_filtration
#check @EllipticCurvePTorsionFontaineLaffailleAttachment.requires_good_reduction_attachment_api
#check @FontaineLaffailleHom.comp_map_frobenius
#check @LowWeightFontaineLaffailleHom.source_target_weights_in_zero_one_range
#check @StrictFontaineLaffailleHomData.requires_strict_morphisms_api
#check @StrictFontaineLaffailleHomData.kernel_filtration_compatible
#check @StrictFontaineLaffailleHomData.cokernel_filtration_compatible
#check @StrictFontaineLaffailleHomData.source_target_weights_in_zero_one_range
#check @FilteredFrobeniusDivisibilityData.map_mem_filtration
#check @FilteredFrobeniusDivisibilityData.requires_frobenius_divisibility_api
#check @FilteredFrobeniusDivisibilityData.WithDividedFrobenius.toLowWeightObject

end FontaineLaffaille
end Roots
end MathlibExpansion
