import MathlibExpansion.Roots.PDivisible.Core

/-!
# p-divisible groups: Height certificates

Salvaged height-certificate structures from the W6 demolition:
- `TateModuleElement` — alias for `TateModuleObject` over a `PDivisibleGroupObject`
- `TateModuleRankCertificate` — numerical rank/height comparison certificate
- `ConnectedEtaleHeightCertificate` — additive height decomposition certificate
- `NewtonSlope` — single Newton slope (numerator/denominator)
- `NewtonSlopeHeightDecomposition` — arithmetic shell of Newton/Dieudonne classification

All `HasX_API := False` references removed. No boundary conjunctions. No projection laundering.
-/

namespace MathlibExpansion
namespace Roots
namespace PDivisible

/-! ## TateModuleElement -/

/-- A Tate module element for a `PDivisibleGroupObject`: a compatible sequence of
levelwise points. Alias for `TateModuleObject` on the underlying `GaloisProfiniteTower`. -/
abbrev TateModuleElement
    {Γ : Type*} [Group Γ] [TopologicalSpace Γ] [IsTopologicalGroup Γ]
    {p : ℕ} (G : PDivisibleGroupObject Γ p) :=
  TateModuleObject G.toGaloisProfiniteTower

/-! ## TateModuleRankCertificate -/

/-- A numerical certificate for the rank/height comparison expected from the Tate module
once Mathlib has native p-divisible groups and `ℤ_p`-modules.

The fields `tateRank` and `formalHeight` are natural numbers; `rank_eq_height` asserts
their equality. The Tate 1967 interface is recorded by
`tateHomFullFaithfulPDivisible` in `TateHom.lean`. -/
structure TateModuleRankCertificate where
  tateRank      : ℕ
  formalHeight  : ℕ
  formalHeight_pos : 0 < formalHeight
  rank_eq_height : tateRank = formalHeight

namespace TateModuleRankCertificate

variable (C : TateModuleRankCertificate)

theorem height_eq_rank : C.formalHeight = C.tateRank :=
  C.rank_eq_height.symm

theorem rank_pos : 0 < C.tateRank := by
  rw [C.rank_eq_height]; exact C.formalHeight_pos

theorem rank_eq_one_of_height_eq_one (h : C.formalHeight = 1) : C.tateRank = 1 := by
  rw [C.rank_eq_height, h]

theorem rank_eq_two_of_height_eq_two (h : C.formalHeight = 2) : C.tateRank = 2 := by
  rw [C.rank_eq_height, h]

theorem height_eq_one_iff_rank_eq_one : C.formalHeight = 1 ↔ C.tateRank = 1 := by
  constructor
  · exact C.rank_eq_one_of_height_eq_one
  · intro h; rw [C.height_eq_rank, h]

theorem height_eq_two_iff_rank_eq_two : C.formalHeight = 2 ↔ C.tateRank = 2 := by
  constructor
  · exact C.rank_eq_two_of_height_eq_two
  · intro h; rw [C.height_eq_rank, h]

theorem rank_mem_one_two_of_height_eq_one_or_two
    (h : C.formalHeight = 1 ∨ C.formalHeight = 2) :
    C.tateRank ∈ ({1, 2} : Set ℕ) := by
  rcases h with h | h
  · simp [C.rank_eq_one_of_height_eq_one h]
  · simp [C.rank_eq_two_of_height_eq_two h]

theorem height_mem_one_two_of_rank_eq_one_or_two
    (h : C.tateRank = 1 ∨ C.tateRank = 2) :
    C.formalHeight ∈ ({1, 2} : Set ℕ) := by
  rcases h with h | h
  · simp [C.height_eq_rank, h]
  · simp [C.height_eq_rank, h]

end TateModuleRankCertificate

/-! ## ConnectedEtaleHeightCertificate -/

/-- Numerical certificate for the height decomposition expected from the connected-étale
exact sequence of a p-divisible group. The arithmetic is closed; the native exact sequence
and its formal-group comparison remain unavailable in Mathlib v4.17.0. -/
structure ConnectedEtaleHeightCertificate where
  connectedHeight : ℕ
  etaleHeight     : ℕ
  totalHeight     : ℕ
  totalHeight_eq  : totalHeight = connectedHeight + etaleHeight

namespace ConnectedEtaleHeightCertificate

variable (C : ConnectedEtaleHeightCertificate)

theorem connectedHeight_le_totalHeight : C.connectedHeight ≤ C.totalHeight := by
  rw [C.totalHeight_eq]; exact Nat.le_add_right C.connectedHeight C.etaleHeight

theorem etaleHeight_le_totalHeight : C.etaleHeight ≤ C.totalHeight := by
  rw [C.totalHeight_eq]; exact Nat.le_add_left C.etaleHeight C.connectedHeight

theorem totalHeight_eq_connectedHeight_of_etaleHeight_eq_zero
    (h : C.etaleHeight = 0) : C.totalHeight = C.connectedHeight := by
  rw [C.totalHeight_eq, h, Nat.add_zero]

theorem totalHeight_eq_etaleHeight_of_connectedHeight_eq_zero
    (h : C.connectedHeight = 0) : C.totalHeight = C.etaleHeight := by
  rw [C.totalHeight_eq, h, Nat.zero_add]

theorem connectedHeight_eq_totalHeight_sub_etaleHeight :
    C.connectedHeight = C.totalHeight - C.etaleHeight := by
  rw [C.totalHeight_eq, Nat.add_sub_cancel]

theorem etaleHeight_eq_totalHeight_sub_connectedHeight :
    C.etaleHeight = C.totalHeight - C.connectedHeight := by
  rw [C.totalHeight_eq, Nat.add_comm, Nat.add_sub_cancel]

theorem totalHeight_eq_one_cases (h : C.totalHeight = 1) :
    (C.connectedHeight = 1 ∧ C.etaleHeight = 0) ∨
      (C.connectedHeight = 0 ∧ C.etaleHeight = 1) := by
  have hsum : C.connectedHeight + C.etaleHeight = 1 := by rw [← C.totalHeight_eq, h]
  omega

theorem connectedHeight_eq_one_of_totalHeight_eq_one_of_etaleHeight_eq_zero
    (htotal : C.totalHeight = 1) (hetale : C.etaleHeight = 0) :
    C.connectedHeight = 1 := by
  have hsum : C.connectedHeight + C.etaleHeight = 1 := by rw [← C.totalHeight_eq, htotal]
  simpa [hetale] using hsum

theorem etaleHeight_eq_one_of_totalHeight_eq_one_of_connectedHeight_eq_zero
    (htotal : C.totalHeight = 1) (hconnected : C.connectedHeight = 0) :
    C.etaleHeight = 1 := by
  have hsum : C.connectedHeight + C.etaleHeight = 1 := by rw [← C.totalHeight_eq, htotal]
  simpa [hconnected] using hsum

theorem totalHeight_mem_one_two_of_connected_etale_cases
    (h : (C.connectedHeight = 1 ∧ C.etaleHeight = 0) ∨
         (C.connectedHeight = 0 ∧ C.etaleHeight = 1) ∨
         (C.connectedHeight = 2 ∧ C.etaleHeight = 0) ∨
         (C.connectedHeight = 1 ∧ C.etaleHeight = 1) ∨
         (C.connectedHeight = 0 ∧ C.etaleHeight = 2)) :
    C.totalHeight ∈ ({1, 2} : Set ℕ) := by
  rcases h with h | h | h | h | h
  · rw [C.totalHeight_eq, h.1, h.2]; simp
  · rw [C.totalHeight_eq, h.1, h.2]; simp
  · rw [C.totalHeight_eq, h.1, h.2]; simp
  · rw [C.totalHeight_eq, h.1, h.2]; simp
  · rw [C.totalHeight_eq, h.1, h.2]; simp

end ConnectedEtaleHeightCertificate

/-! ## NewtonSlope -/

/-- A single Newton slope, represented as `numerator / denominator` with
`0 ≤ numerator ≤ denominator` and positive denominator. -/
structure NewtonSlope where
  numerator   : ℕ
  denominator : ℕ
  denominator_pos         : 0 < denominator
  numerator_le_denominator : numerator ≤ denominator

namespace NewtonSlope

/-- Slope `0`: the étale part in the classical Newton decomposition. -/
def IsEtale (s : NewtonSlope) : Prop :=
  s.numerator = 0

/-- Slope `1`: the multiplicative/connected height-one extremal part. -/
def IsMultiplicative (s : NewtonSlope) : Prop :=
  s.numerator = s.denominator

theorem numerator_eq_zero_of_isEtale {s : NewtonSlope} (h : s.IsEtale) : s.numerator = 0 :=
  h

theorem numerator_eq_denominator_of_isMultiplicative {s : NewtonSlope} (h : s.IsMultiplicative) :
    s.numerator = s.denominator :=
  h

end NewtonSlope

/-! ## NewtonSlopeHeightDecomposition -/

/-- A numerical Newton-slope decomposition of total height into étale, intermediate, and
multiplicative contributions. This is intentionally just the closed arithmetic shell of
the real Dieudonne/Newton classification. -/
structure NewtonSlopeHeightDecomposition where
  etaleHeight        : ℕ
  mixedSlopeHeight   : ℕ
  multiplicativeHeight : ℕ
  totalHeight        : ℕ
  totalHeight_eq_sum :
    totalHeight = etaleHeight + mixedSlopeHeight + multiplicativeHeight

namespace NewtonSlopeHeightDecomposition

variable (D : NewtonSlopeHeightDecomposition)

theorem etaleHeight_le_totalHeight : D.etaleHeight ≤ D.totalHeight := by
  rw [D.totalHeight_eq_sum]
  exact Nat.le_add_right_of_le (Nat.le_add_right D.etaleHeight D.mixedSlopeHeight)

theorem mixedSlopeHeight_le_totalHeight : D.mixedSlopeHeight ≤ D.totalHeight := by
  rw [D.totalHeight_eq_sum]
  exact le_trans (Nat.le_add_left D.mixedSlopeHeight D.etaleHeight)
    (Nat.le_add_right (D.etaleHeight + D.mixedSlopeHeight) D.multiplicativeHeight)

theorem multiplicativeHeight_le_totalHeight : D.multiplicativeHeight ≤ D.totalHeight := by
  rw [D.totalHeight_eq_sum, Nat.add_assoc]
  exact le_trans
    (Nat.le_add_left D.multiplicativeHeight D.mixedSlopeHeight)
    (Nat.le_add_left (D.mixedSlopeHeight + D.multiplicativeHeight) D.etaleHeight)

theorem totalHeight_eq_etaleHeight_of_no_mixed_no_multiplicative
    (hmixed : D.mixedSlopeHeight = 0) (hmul : D.multiplicativeHeight = 0) :
    D.totalHeight = D.etaleHeight := by
  rw [D.totalHeight_eq_sum, hmixed, hmul]; simp

theorem totalHeight_eq_multiplicativeHeight_of_no_etale_no_mixed
    (hetale : D.etaleHeight = 0) (hmixed : D.mixedSlopeHeight = 0) :
    D.totalHeight = D.multiplicativeHeight := by
  rw [D.totalHeight_eq_sum, hetale, hmixed]; simp

theorem totalHeight_eq_mixedSlopeHeight_of_no_etale_no_multiplicative
    (hetale : D.etaleHeight = 0) (hmul : D.multiplicativeHeight = 0) :
    D.totalHeight = D.mixedSlopeHeight := by
  rw [D.totalHeight_eq_sum, hetale, hmul, Nat.zero_add, Nat.add_zero]

end NewtonSlopeHeightDecomposition

end PDivisible
end Roots
end MathlibExpansion
