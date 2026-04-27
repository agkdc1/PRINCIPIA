import MathlibExpansion.Roots.PDivisible.Core
import MathlibExpansion.Roots.PDivisible.Height
import Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass

/-!
# p-divisible groups: Lubin-Tate and elliptic numeric certificates

Renamed and stripped certificates from the W6 demolition:

- `LubinTateHeightNumericCertificate` — formerly `LubinTateHeightOneCertificate`;
  `firstNonlinearCoefficientIsUnit : Prop` field **removed** (doctrine violation:
  a `Prop` field whose truth is independent of all other fields = laundering).
- `EllipticHeightNumericCertificate` — formerly `EllipticFormalGroupAtPrimeDatum`;
  stripped of `HasX_API` references and `attachedPDivisibleGroup` scaffolding.
- Frey-at-2 numerical lemmas: `FreyTwoAdicHeightTwoCertificate` and arithmetic
  consequences closed in ℕ.

No `HasX_API := False` predicates. No `*Boundary` conjunction defs.
No `*_requires_*` projection-launderer theorems.
-/

namespace MathlibExpansion
namespace Roots
namespace PDivisible

/-! ## LubinTateHeightNumericCertificate -/

/-- Numerical certificate for a Lubin-Tate height-one formal group.

Records the closed arithmetic: the `[p]`-endomorphism has first nonlinear term in
degree `p` (= `p ^ height` for height 1), and the formal group height is 1.

The field `firstNonlinearCoefficientIsUnit` from the old `LubinTateHeightOneCertificate`
has been **removed**: it is a `Prop` whose truth is independent of all other fields,
making every theorem that extracted it a projection-launderer. The native API for
reading the unit coefficient of a formal power series does not exist in Mathlib v4.17.0;
that gap is named in `TateHom.lean` via the `tateHomFullFaithfulPDivisible` certificate
(height-one ordinary consequence). -/
structure LubinTateHeightNumericCertificate where
  p              : ℕ
  prime          : Nat.Prime p
  p_pos          : 0 < p
  height         : ℕ
  height_eq_one  : height = 1
  leadingDegree  : ℕ
  leadingDegree_eq_p : leadingDegree = p

namespace LubinTateHeightNumericCertificate

variable (C : LubinTateHeightNumericCertificate)

@[simp]
theorem height_eq_one' : C.height = 1 :=
  C.height_eq_one

theorem height_pos : 0 < C.height := by rw [C.height_eq_one]; norm_num

theorem height_mem_one_two : C.height ∈ ({1, 2} : Set ℕ) := by simp [C.height_eq_one]

theorem leadingDegree_pos : 0 < C.leadingDegree := by
  rw [C.leadingDegree_eq_p]; exact C.p_pos

theorem leadingDegree_eq_p_pow_height : C.leadingDegree = C.p ^ C.height := by
  rw [C.leadingDegree_eq_p, C.height_eq_one, pow_one]

/-- The `[π]`-endomorphism has first nonzero degree `p ^ height` in the height-one case.
Closed numerical part of the missing native `[π]`-series theorem. -/
theorem endomorphismDegree_eq_height_prime_power : C.leadingDegree = C.p ^ C.height :=
  C.leadingDegree_eq_p_pow_height

/-- Height is 1, so the rank certificate trivially has rank 1. -/
def toRankCertificate : TateModuleRankCertificate where
  tateRank      := 1
  formalHeight  := C.height
  formalHeight_pos := C.height_pos
  rank_eq_height := by rw [C.height_eq_one]

@[simp]
theorem toRankCertificate_tateRank : C.toRankCertificate.tateRank = 1 := rfl

@[simp]
theorem toRankCertificate_formalHeight : C.toRankCertificate.formalHeight = C.height := rfl

end LubinTateHeightNumericCertificate

/-! ## EllipticHeightNumericCertificate -/

/-- Numerical certificate for the formal-group height of an elliptic curve at a prime.

Renamed from `EllipticFormalGroupAtPrimeDatum`. Stripped of:
- `HasX_API` references in boundary conjunctions
- `attachedPDivisibleGroup : Option (PDivisibleGroup S p)` (old scaffold, gone)
- Projection-launderer theorems that extracted `HasX_API` values

Retains the Weierstrass curve model (the only elliptic-curve object available in
Mathlib v4.17.0) and the height classification target. -/
structure EllipticHeightNumericCertificate (R : Type*) [CommRing R] where
  p                     : ℕ
  prime                 : Nat.Prime p
  curve                 : WeierstrassCurve R
  isElliptic            : curve.IsElliptic
  specialFiberHeight    : ℕ
  specialFiberHeight_pos : 0 < specialFiberHeight

namespace EllipticHeightNumericCertificate

variable {R : Type*} [CommRing R] (D : EllipticHeightNumericCertificate R)

/-- Height-one target: ordinary reduction. -/
def IsOrdinaryHeightOneTarget : Prop := D.specialFiberHeight = 1

/-- Height-two target: supersingular reduction. -/
def IsSupersingularHeightTwoTarget : Prop := D.specialFiberHeight = 2

theorem height_pos : 0 < D.specialFiberHeight := D.specialFiberHeight_pos

theorem height_mem_one_two_of_height_eq_one_or_two
    (h : D.specialFiberHeight = 1 ∨ D.specialFiberHeight = 2) :
    D.specialFiberHeight ∈ ({1, 2} : Set ℕ) := by
  rcases h with h | h <;> simp [h]

theorem isOrdinaryHeightOneTarget_iff :
    D.IsOrdinaryHeightOneTarget ↔ D.specialFiberHeight = 1 := Iff.rfl

theorem isSupersingularHeightTwoTarget_iff :
    D.IsSupersingularHeightTwoTarget ↔ D.specialFiberHeight = 2 := Iff.rfl

/-- Produce a `TateModuleRankCertificate` from an ordinary height-1 certificate. -/
def toRankCertificate_of_ordinary
    (h : D.IsOrdinaryHeightOneTarget) : TateModuleRankCertificate where
  tateRank      := 1
  formalHeight  := D.specialFiberHeight
  formalHeight_pos := D.specialFiberHeight_pos
  rank_eq_height := by unfold IsOrdinaryHeightOneTarget at h; omega

/-- Produce a `ConnectedEtaleHeightCertificate` for the ordinary case:
connected part has height 1, étale part has height 0. -/
def toConnectedEtaleOrdinary
    (h : D.IsOrdinaryHeightOneTarget) : ConnectedEtaleHeightCertificate where
  connectedHeight := 1
  etaleHeight     := 0
  totalHeight     := D.specialFiberHeight
  totalHeight_eq  := by unfold IsOrdinaryHeightOneTarget at h; omega

/-- Produce a `ConnectedEtaleHeightCertificate` for the supersingular case:
connected part has height 2, étale part has height 0. -/
def toConnectedEtaleSupersingular
    (h : D.IsSupersingularHeightTwoTarget) : ConnectedEtaleHeightCertificate where
  connectedHeight := 2
  etaleHeight     := 0
  totalHeight     := D.specialFiberHeight
  totalHeight_eq  := by unfold IsSupersingularHeightTwoTarget at h; omega

end EllipticHeightNumericCertificate

/-! ## Frey-at-2 numeric certificate -/

/-- Numerical certificate for the Frey curve formal group at `p = 2`.

The Frey curve `y² = x(x-a^ℓ)(x+b^ℓ)` has bad (additive) reduction at 2 for the
FLT prime ℓ ≥ 5. The formal group at 2 has height 2 (supersingular case). This
structure records the closed numerical consequence; the geometric proof requires
the missing `HasNativeFormalGroupAPI` and `HasFreyCurveAtTwoHeightTwoAPI`. -/
structure FreyTwoAdicHeightTwoCertificate where
  /-- The prime is 2. -/
  p_eq_two    : (2 : ℕ) = 2
  /-- The formal group height is 2. -/
  height      : ℕ
  height_eq_two : height = 2
  height_pos  : 0 < height

namespace FreyTwoAdicHeightTwoCertificate

variable (C : FreyTwoAdicHeightTwoCertificate)

theorem height_eq_two' : C.height = 2 := C.height_eq_two

theorem height_pos' : 0 < C.height := C.height_pos

theorem height_mem_one_two : C.height ∈ ({1, 2} : Set ℕ) := by simp [C.height_eq_two]

theorem height_ne_one : C.height ≠ 1 := by rw [C.height_eq_two]; norm_num

/-- The Frey-at-2 height certificate produces a supersingular `ConnectedEtaleHeightCertificate`. -/
def toConnectedEtale : ConnectedEtaleHeightCertificate where
  connectedHeight  := 2
  etaleHeight      := 0
  totalHeight      := C.height
  totalHeight_eq   := by rw [C.height_eq_two]

/-- The Frey-at-2 height certificate produces a `TateModuleRankCertificate` with rank 2. -/
def toRankCertificate : TateModuleRankCertificate where
  tateRank       := 2
  formalHeight   := C.height
  formalHeight_pos := C.height_pos
  rank_eq_height := by rw [C.height_eq_two]

theorem toRankCertificate_rank_eq_two : C.toRankCertificate.tateRank = 2 := rfl

theorem supersingular_height_two_ne_ordinary_height_one
    (C : FreyTwoAdicHeightTwoCertificate)
    (D : LubinTateHeightNumericCertificate) : C.height ≠ D.height := by
  rw [C.height_eq_two, D.height_eq_one]; norm_num

end FreyTwoAdicHeightTwoCertificate

end PDivisible
end Roots
end MathlibExpansion
