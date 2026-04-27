/-
# Continuity-Compactness Wrappers (Rudin 1976 §4.14-4.19)
RCONT for T20c_mid_18.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Analysis.RudinContinuityCompactness

/-- **Rudin 1976 §4.14 CC_02, Compact image of continuous map.** Wraps Mathlib's
`IsCompact.image` (`Mathlib.Topology.Compactness.Compact`) — direct Rudin form. -/
theorem image_compact {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (f : X → Y) (hf : Continuous f) {K : Set X} (hK : IsCompact K) :
    IsCompact (f '' K) := hK.image hf

/-- **Rudin 1976 §4.15 CC_03, Continuous image of compact space is compact.** -/
theorem range_compact {X Y : Type*} [TopologicalSpace X] [CompactSpace X]
    [TopologicalSpace Y] (f : X → Y) (hf : Continuous f) :
    IsCompact (Set.range f) := isCompact_range hf

/-- **Rudin 1976 §4.16 CC_07, Compact-image carrier is bounded.** Specialised
to ℝ where compactness gives boundedness via Mathlib `IsCompact.bddBelow`. -/
theorem image_bddBelow {X : Type*} [TopologicalSpace X]
    (f : X → ℝ) (hf : Continuous f) {K : Set X} (hK : IsCompact K) :
    BddBelow (f '' K) := (hK.image hf).bddBelow

/-- **Rudin 1976 §4.16 dual, compact image is bounded above.** -/
theorem image_bddAbove {X : Type*} [TopologicalSpace X]
    (f : X → ℝ) (hf : Continuous f) {K : Set X} (hK : IsCompact K) :
    BddAbove (f '' K) := (hK.image hf).bddAbove

/-- **Rudin 1976 §4.17, Continuous functions on compact attain max.**
Wraps `IsCompact.exists_isMaxOn` from Mathlib. -/
theorem exists_max_on_compact {X : Type*} [TopologicalSpace X]
    (f : X → ℝ) (hf : Continuous f) {K : Set X} (hK : IsCompact K) (hne : K.Nonempty) :
    ∃ x ∈ K, ∀ y ∈ K, f y ≤ f x :=
  hK.exists_isMaxOn hne hf.continuousOn

/-- **Rudin 1976 §4.17 dual, Continuous functions on compact attain min.**
Wraps `IsCompact.exists_isMinOn` from Mathlib. -/
theorem exists_min_on_compact {X : Type*} [TopologicalSpace X]
    (f : X → ℝ) (hf : Continuous f) {K : Set X} (hK : IsCompact K) (hne : K.Nonempty) :
    ∃ x ∈ K, ∀ y ∈ K, f x ≤ f y :=
  hK.exists_isMinOn hne hf.continuousOn

/-- Compact image of identity is the original compact set. -/
theorem id_image_compact {X : Type*} [TopologicalSpace X]
    {K : Set X} (hK : IsCompact K) : IsCompact (id '' K) := by
  rw [Set.image_id]; exact hK

end MathlibExpansion.Analysis.RudinContinuityCompactness
