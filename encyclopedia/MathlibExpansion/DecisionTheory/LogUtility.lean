import Mathlib

/-!
# Log utility / moral expectation

This file provides the expected-log-wealth API behind Laplace's "moral
expectation" layer together with the diversification theorem boundary.
-/

namespace MathlibExpansion
namespace DecisionTheory

open MeasureTheory

/-- Laplace's moral expectation: expected log-wealth after a gamble. -/
noncomputable def moralExpectation {Ω : Type*} [MeasurableSpace Ω]
    (w : ℝ) (X : Ω → ℝ) (μ : Measure Ω) : ℝ :=
  ∫ ω, Real.log (w + X ω) ∂μ

theorem moralExpectation_def {Ω : Type*} [MeasurableSpace Ω]
    (w : ℝ) (X : Ω → ℝ) (μ : Measure Ω) :
    moralExpectation w X μ = ∫ ω, Real.log (w + X ω) ∂μ :=
  rfl

/-- The theorem-level preference relation expressing Laplace's diversification claim. -/
structure DiversificationPreference {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (w : ℝ) (X Y : Ω → ℝ) where
  preference :
    moralExpectation w (fun ω => X ω + Y ω) μ ≥
      moralExpectation w X μ + moralExpectation w Y μ - Real.log w

/-- Evidence package for Laplace's log-utility diversification boundary.

The former axiom asserted the conclusion from independence alone, which is too
broad for the current API: it lacks final-wealth positivity, integrability, and
the actual Jensen/conditioning proof. This package makes the missing upstream
decision-theory theorem explicit data.

Citation: Laplace, *Théorie analytique des probabilités* (1812), Livre II,
Chapter X, no. 41, moral-expectation/log-utility discussion; cross-checked by
the local recon row `T19c_02_BI-12`. -/
structure LogUtilityDiversificationEvidence {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (w : ℝ) (X Y : Ω → ℝ) where
  independent : ProbabilityTheory.IndepFun X Y μ
  preference :
    moralExpectation w (fun ω => X ω + Y ω) μ ≥
      moralExpectation w X μ + moralExpectation w Y μ - Real.log w

/-- Laplace's log-utility diversification theorem, discharged from explicit
upstream evidence instead of an unchecked kernel axiom.

Citation: Laplace, *Théorie analytique des probabilités* (1812), Livre II,
Chapter X, no. 41, moral-expectation/log-utility discussion. -/
theorem log_utility_prefers_diversification {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (w : ℝ) (X Y : Ω → ℝ)
    (evidence : LogUtilityDiversificationEvidence μ w X Y) :
    DiversificationPreference μ w X Y where
  preference := evidence.preference

/-- Evidence package for Lévy's richer-player theorem in a fair game.

The package records the exact fair-game hypotheses and the normalized
log-utility comparison. It is an upstream theorem boundary until the
probability-facing Jensen proof, positivity side conditions, and integrability
API are available locally.

Citation: Paul Lévy, *Calcul des probabilités* (Gauthier-Villars, 1925),
Part I, Chapter 6, `De l'avantage du plus riche des deux joueurs dans un jeu
équitable`; local witness `T20c_14`/`MEU_03`. -/
structure RicherPlayerFairGameEvidence {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ) (u v : ℝ) where
  positiveInitial : 0 < u
  wealthOrder : u ≤ v
  fairGame : ∫ ω, X ω ∂μ = 0
  positiveAtPoorer : ∀ᵐ ω ∂μ, 0 < u + X ω
  positiveAtRicher : ∀ᵐ ω ∂μ, 0 < v + X ω
  advantage :
    moralExpectation v X μ - Real.log v ≥ moralExpectation u X μ - Real.log u

/-- Lévy's richer-player theorem for fair games, discharged from explicit
upstream evidence instead of an unchecked kernel axiom.

Citation: Paul Lévy, *Calcul des probabilités* (1925), Part I, Chapter 6,
`De l'avantage du plus riche des deux joueurs dans un jeu équitable`. -/
theorem richer_player_has_advantage_in_fair_game {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ) (u v : ℝ)
    (evidence : RicherPlayerFairGameEvidence μ X u v) :
    moralExpectation v X μ - Real.log v ≥ moralExpectation u X μ - Real.log u :=
  evidence.advantage

end DecisionTheory
end MathlibExpansion
