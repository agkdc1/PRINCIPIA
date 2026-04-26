import NavierStokes.AxisymNoSwirl.Gamma.EnergyInequality
import NavierStokes.AxisymNoSwirl.Gamma.AxisCompatibility

/-!
# NavierStokes.AxisymNoSwirl.Gamma.MaxPrinciple

Stampacchia weak comparison theorem (Route W crown jewel) for the axisymmetric
no-swirl `Γ = ω_θ / r` transport-diffusion equation.

Combining the W4 truncated energy inequality (`energy_inequality_truncation`)
with non-negativity of the dissipation profile gives monotone decay of the
truncation energy

  `(1/2) ∫_Ω ((Γ - k)_+)^2 dν`

along the time evolution. Vanishing initial truncation energy at level `k`
propagates forward to vanishing truncation energy on `[0, T]` — this is the
energy form of the weak maximum principle. Combined with the W4 coercivity
certificate's Graph carrier and `memLp_shiftedPosPart`, this also yields the
textbook `L^∞` propagation in a.e. form.

Textbook spine: **DiBenedetto Ch. II–III** (Stampacchia / weak comparison).

No new axioms. Substrate:
- W1 (`DriftCancellation.lean`) — drift cancellation against `(Γ - k)_+`
- W2 (`Coercivity.lean`) — diffusion coercivity on positive-part truncations
- W3 (`AxisCompatibility.lean`) — axis exhaustion on `(2/r)∂_r` defect
- W4 (`EnergyInequality.lean`) — time-local energy inequality
- C5 weighted Sobolev (Graph + ParabolicTruncation + Steklov)
- B4 (`Operator.lean`, `Transport.lean`) — `Γ` operator and transport shell
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

open MeasureTheory Set Real intervalIntegral
open scoped ENNReal NNReal

namespace NavierStokes.AxisymNoSwirl.Gamma

open NavierStokes.Geometry.Cylindrical
open NavierStokes.Analysis.WeightedSobolev
open NavierStokes.AxisymNoSwirl.BiotSavart
open NavierStokes.Mathlib.WeightedSobolev

/-! ## Pointwise non-negativity

Foundational positivity facts driving the Stampacchia comparison step. -/

/-- The instantaneous truncation energy is non-negative. -/
theorem truncationEnergyAt_nonneg
    (U : ℝ → AxisymNoSwirlField) (k t : ℝ) :
    0 ≤ truncationEnergyAt U k t := by
  unfold truncationEnergyAt
  refine mul_nonneg (by norm_num) ?_
  exact integral_nonneg (fun p => sq_nonneg _)

/-- The truncation Dirichlet energy is non-negative. -/
theorem truncationDirichletEnergy_nonneg (u : Graph) (k : ℝ) :
    0 ≤ truncationDirichletEnergy u k := by
  unfold truncationDirichletEnergy truncationGradientNormSq
  exact integral_nonneg (fun p => add_nonneg (sq_nonneg _) (sq_nonneg _))

/-- The W4 dissipation profile `c(s) * dissipation(s)` is non-negative on
`[0, T]`: the coercive constant is positive (W2) and the dissipation is a sum
of squares. -/
theorem coercivity_times_dissipation_nonneg
    (U : ℝ → AxisymNoSwirlField) (k T : ℝ)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U k T hdiv hsolves)
    (s : ℝ) (hs : s ∈ Set.Icc 0 T) :
    0 ≤ hEnergy.coercivityConst s * hEnergy.dissipation s := by
  refine mul_nonneg
    (le_of_lt (coercivityConst_pos U k T hdiv hsolves hEnergy s hs)) ?_
  rw [hEnergy.dissipation_agrees s hs]
  exact truncationDirichletEnergy_nonneg _ _

/-! ## Monotone decay

The truncation energy is non-increasing on `[0, T]`, dominated by the initial
truncation energy. Direct corollary of the W4 energy inequality. -/

/-- **Monotone decay of the truncation energy.**

The instantaneous truncation energy at any `t ∈ [0, T]` is bounded by the
initial truncation energy. -/
theorem truncationEnergyAt_le_initial
    (U : ℝ → AxisymNoSwirlField) (k T : ℝ)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U k T hdiv hsolves)
    (t : ℝ) (ht : t ∈ Set.Icc 0 T) :
    truncationEnergyAt U k t ≤ truncationEnergyAt U k 0 := by
  have hineq :=
    energy_inequality_truncation U k T hdiv hsolves hEnergy t ht
  have hq_nn :
      ∀ s ∈ Set.Icc (0 : ℝ) t,
        0 ≤ hEnergy.coercivityConst s * hEnergy.dissipation s := by
    intro s hs
    have hsT : s ∈ Set.Icc (0 : ℝ) T := ⟨hs.1, le_trans hs.2 ht.2⟩
    exact coercivity_times_dissipation_nonneg U k T hdiv hsolves hEnergy s hsT
  have h_int_nn :
      0 ≤ ∫ s in (0 : ℝ)..t,
        hEnergy.coercivityConst s * hEnergy.dissipation s :=
    intervalIntegral.integral_nonneg ht.1 hq_nn
  linarith

/-! ## Stampacchia weak maximum principle (energy form) — CROWN JEWEL -/

/-- **Stampacchia weak maximum principle (energy form).**

The Route W crown jewel. For axisymmetric no-swirl `Γ` solving the
transport-diffusion equation under `divergenceCyl u = 0`, with the W4
energy-inequality certificate in hand, vanishing initial truncation energy at
level `k` propagates forward:

  `truncationEnergyAt U k 0 = 0  ⟹  ∀ t ∈ [0, T], truncationEnergyAt U k t = 0`

Equivalently:

  `‖(Γ(0) - k)_+‖_{L²(ν)} = 0  ⟹  ∀ t ∈ [0, T], ‖(Γ(t) - k)_+‖_{L²(ν)} = 0`

This is the Route W weak comparison theorem in the energy formulation: the
`L²(ν)` norm of the positive truncation `(Γ - k)_+` cannot grow above its
initial value (here, zero). Combined with the integral characterization of
zero `L²(ν)` norm (see `stampacchia_L_infty_propagation` below), this gives
the textbook `L^∞ → L^∞` propagation statement. -/
theorem stampacchia_weak_max_principle
    (U : ℝ → AxisymNoSwirlField) (k T : ℝ)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U k T hdiv hsolves)
    (h_init : truncationEnergyAt U k 0 = 0) :
    ∀ t ∈ Set.Icc 0 T, truncationEnergyAt U k t = 0 := by
  intro t ht
  have hdec :
      truncationEnergyAt U k t ≤ truncationEnergyAt U k 0 :=
    truncationEnergyAt_le_initial U k T hdiv hsolves hEnergy t ht
  have hnn : 0 ≤ truncationEnergyAt U k t := truncationEnergyAt_nonneg U k t
  rw [h_init] at hdec
  linarith

/-! ## Bridge: `L^∞` propagation in a.e. form

The energy form `truncationEnergyAt U k t = 0` is a vanishing weighted-`L²`
norm of `(Γ(U t) - k)_+`. Combined with W4's coercivity certificate (which
witnesses that `(Γ(U t) - k)_+ = graph.shiftedPosPart k` for a `Graph`
carrier `g` with `g.shiftedPosPart k ∈ L²(ν)` — using `0 ≤ k`), we obtain the
pointwise a.e. `L^∞` bound. -/

/-- The squared positive-part truncation is integrable on `Ω` w.r.t. the
weighted measure, derived from the W4 coercivity certificate's graph carrier
and `memLp_shiftedPosPart` (which requires `0 ≤ k`). -/
theorem integrable_sq_shiftedPosPart_of_certificate
    (U : ℝ → AxisymNoSwirlField) (k T : ℝ) (hk : 0 ≤ k)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U k T hdiv hsolves)
    (t : ℝ) (ht : t ∈ Set.Icc 0 T) :
    Integrable
      (fun p => (shiftedPosPart (Γ (U t)) k p) ^ 2)
      (weightedMeasure.restrict Ω) := by
  -- W4 cert provides a graph g whose shiftedPosPart matches (Γ - k)_+
  set cert := hEnergy.coercivity t ht with hcert
  set g := cert.graph with hg_def
  have hshift_eq :
      (fun p => shiftedPosPart (Γ (U t)) k p)
        = g.shiftedPosPart k := by
    funext p
    have h := congrFun cert.shifted_eq_graph p
    -- shifted_eq_graph: shiftedPositivePart Γ k = g.shiftedPosPart k
    -- shiftedPositivePart and shiftedPosPart both reduce to fun p => max (·p - k) 0
    show max (Γ (U t) p - k) 0 = max (g.val p - k) 0
    simpa [shiftedPositivePart, Graph.shiftedPosPart, shiftedPosPart] using h
  have hg_memLp : MemLp (g.shiftedPosPart k) 2 weightedMeasure :=
    Graph.memLp_shiftedPosPart g hk
  have hΓ_memLp :
      MemLp (fun p => shiftedPosPart (Γ (U t)) k p) 2 weightedMeasure := by
    rw [hshift_eq]; exact hg_memLp
  -- Direct from Mathlib: f ∈ L²(μ) ⟹ f² ∈ L¹(μ).
  have hsq_int :
      Integrable
        (fun p => (shiftedPosPart (Γ (U t)) k p) ^ 2) weightedMeasure :=
    hΓ_memLp.integrable_sq
  exact hsq_int.restrict (s := Ω)

/-- **Stampacchia `L^∞` propagation (a.e. form).**

The textbook Route W weak comparison conclusion: an a.e. `L^∞` bound on the
initial data propagates forward in time. With `0 ≤ M` and the W4 certificate
at level `M`,

  `(Γ(U 0) - M)_+ = 0`  a.e. on Ω
  ⟹  `∀ t ∈ [0, T], (Γ(U t) - M)_+ = 0`  a.e. on Ω

i.e. `Γ(U 0) ≤ M` a.e. on Ω propagates to `Γ(U t) ≤ M` a.e. on Ω for every
`t ∈ [0, T]`. -/
theorem stampacchia_L_infty_propagation
    (U : ℝ → AxisymNoSwirlField) (M T : ℝ) (hM : 0 ≤ M)
    (hdiv : ∀ t, divergenceCyl (U t) = 0)
    (hsolves : SolvesΓTransport U hdiv)
    (hEnergy : EnergyInequalityCertificate U M T hdiv hsolves)
    (h_init_ae :
      (fun p => shiftedPosPart (Γ (U 0)) M p)
        =ᵐ[weightedMeasure.restrict Ω] 0) :
    ∀ t ∈ Set.Icc 0 T,
      (fun p => shiftedPosPart (Γ (U t)) M p)
        =ᵐ[weightedMeasure.restrict Ω] 0 := by
  intro t ht
  -- Step 1: Convert h_init_ae to truncationEnergyAt U M 0 = 0
  have hsq_init_ae :
      (fun p => (shiftedPosPart (Γ (U 0)) M p) ^ 2)
        =ᵐ[weightedMeasure.restrict Ω] 0 := by
    filter_upwards [h_init_ae] with p hp
    simp [hp]
  have h_init_int_zero :
      ∫ p in Ω, (shiftedPosPart (Γ (U 0)) M p) ^ 2 ∂ weightedMeasure = 0 := by
    have h := integral_congr_ae (μ := weightedMeasure.restrict Ω)
      (f := fun p => (shiftedPosPart (Γ (U 0)) M p) ^ 2)
      (g := fun _ : E3 => (0 : ℝ)) hsq_init_ae
    simpa using h
  have h_init_zero : truncationEnergyAt U M 0 = 0 := by
    unfold truncationEnergyAt
    rw [h_init_int_zero]; ring
  -- Step 2: Apply Stampacchia weak maximum principle
  have h_t_zero : truncationEnergyAt U M t = 0 :=
    stampacchia_weak_max_principle U M T hdiv hsolves hEnergy h_init_zero t ht
  have h_t_int_zero :
      ∫ p in Ω, (shiftedPosPart (Γ (U t)) M p) ^ 2 ∂ weightedMeasure = 0 := by
    have hformula : truncationEnergyAt U M t
        = (1 / 2 : ℝ)
          * ∫ p in Ω, (shiftedPosPart (Γ (U t)) M p) ^ 2 ∂ weightedMeasure := rfl
    have := h_t_zero
    rw [hformula] at this
    linarith
  -- Step 3: Recover ae form using integrability + non-negativity
  have h_t_int : Integrable
      (fun p => (shiftedPosPart (Γ (U t)) M p) ^ 2)
      (weightedMeasure.restrict Ω) :=
    integrable_sq_shiftedPosPart_of_certificate
      U M T hM hdiv hsolves hEnergy t ht
  have h_t_nn_ae :
      0 ≤ᵐ[weightedMeasure.restrict Ω]
        (fun p => (shiftedPosPart (Γ (U t)) M p) ^ 2) :=
    Filter.Eventually.of_forall (fun p => sq_nonneg _)
  have h_t_sq_ae :
      (fun p => (shiftedPosPart (Γ (U t)) M p) ^ 2)
        =ᵐ[weightedMeasure.restrict Ω] 0 :=
    (integral_eq_zero_iff_of_nonneg_ae h_t_nn_ae h_t_int).mp h_t_int_zero
  filter_upwards [h_t_sq_ae] with p hp
  have hp' : (shiftedPosPart (Γ (U t)) M p) ^ 2 = 0 := hp
  exact (pow_eq_zero_iff (n := 2) (by norm_num)).mp hp'

end NavierStokes.AxisymNoSwirl.Gamma

end
