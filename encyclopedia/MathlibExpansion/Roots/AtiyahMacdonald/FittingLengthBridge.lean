import MathlibExpansion.Roots.AtiyahMacdonald.FittingIdeal
import MathlibExpansion.Roots.AtiyahMacdonald.NumericLength

/-!
# Atiyah-Macdonald numerics bridge

This file packages the three pieces the Diamond 1996 consumer actually needs:

1. finite-length hypotheses for the cotangent and congruence modules,
2. canonical ideal assignments for those modules,
3. canonical numeric lengths for those modules.

The bridge is intentionally minimal. It removes the free-data vulnerability in
the original Diamond `FittingLengthAPI` by storing only the finite-length
hypotheses; every ideal and length exposed from the API is then computed from
canonical definitions in the A-M substrate.
-/

namespace MathlibExpansion.Roots.AtiyahMacdonald

universe u

structure FittingLengthBridge
    (O : Type u) [CommRing O]
    (Φ : Type u) [AddCommGroup Φ] [Module O Φ]
    (ψ : Type u) [AddCommGroup ψ] [Module O ψ] where
  finiteLengthΦ : IsFiniteLength O Φ
  finiteLengthψ : IsFiniteLength O ψ

namespace FittingLengthBridge

variable {O : Type u} [CommRing O]
variable {Φ : Type u} [AddCommGroup Φ] [Module O Φ]
variable {ψ : Type u} [AddCommGroup ψ] [Module O ψ]

/-- Canonical ideal attached to the cotangent module. -/
def fittingΦ (_api : FittingLengthBridge O Φ ψ) : Ideal O :=
  fittingIdeal (R := O) (M := Φ)

/-- Canonical ideal attached to the congruence module. -/
def fittingψ (_api : FittingLengthBridge O Φ ψ) : Ideal O :=
  fittingIdeal (R := O) (M := ψ)

/-- Natural-number length attached to the cotangent module. -/
noncomputable def lengthΦ (api : FittingLengthBridge O Φ ψ) : ℕ :=
  finiteLengthNat (R := O) (M := Φ) api.finiteLengthΦ

/-- Natural-number length attached to the congruence module. -/
noncomputable def lengthψ (api : FittingLengthBridge O Φ ψ) : ℕ :=
  finiteLengthNat (R := O) (M := ψ) api.finiteLengthψ

/-- The cotangent-side ideal lies below the cotangent annihilator. -/
theorem fittingΦ_le_annΦ (api : FittingLengthBridge O Φ ψ) :
    api.fittingΦ ≤ Module.annihilator O Φ :=
  fittingIdeal_le_annihilator (R := O) (M := Φ)

/-- The congruence-side ideal lies below the congruence annihilator. -/
theorem fittingψ_le_annψ (api : FittingLengthBridge O Φ ψ) :
    api.fittingψ ≤ Module.annihilator O ψ :=
  fittingIdeal_le_annihilator (R := O) (M := ψ)

/-- The cotangent-side ideal is definitionally the annihilator in the current bridge. -/
@[simp]
theorem fittingΦ_eq_annihilator (api : FittingLengthBridge O Φ ψ) :
    api.fittingΦ = Module.annihilator O Φ :=
  fittingIdeal_eq_annihilator (R := O) (M := Φ)

/-- The congruence-side ideal is definitionally the annihilator in the current bridge. -/
@[simp]
theorem fittingψ_eq_annihilator (api : FittingLengthBridge O Φ ψ) :
    api.fittingψ = Module.annihilator O ψ :=
  fittingIdeal_eq_annihilator (R := O) (M := ψ)

/-- The cotangent-side natural length matches the internal `ℕ∞` length. -/
theorem lengthΦ_eq_moduleLength (api : FittingLengthBridge O Φ ψ) :
    (api.lengthΦ : ℕ∞) = moduleLength (R := O) (M := Φ) := by
  rw [moduleLength_eq_coe_finiteLengthNat (R := O) (M := Φ) api.finiteLengthΦ]
  simp [lengthΦ]

/-- The congruence-side natural length matches the internal `ℕ∞` length. -/
theorem lengthψ_eq_moduleLength (api : FittingLengthBridge O Φ ψ) :
    (api.lengthψ : ℕ∞) = moduleLength (R := O) (M := ψ) := by
  rw [moduleLength_eq_coe_finiteLengthNat (R := O) (M := ψ) api.finiteLengthψ]
  simp [lengthψ]

/-- Canonical bridge constructor from finite-length hypotheses. -/
theorem ofFiniteLength
    (hΦ : IsFiniteLength O Φ) (hψ : IsFiniteLength O ψ) :
    FittingLengthBridge O Φ ψ :=
  ⟨hΦ, hψ⟩

end FittingLengthBridge

end MathlibExpansion.Roots.AtiyahMacdonald
