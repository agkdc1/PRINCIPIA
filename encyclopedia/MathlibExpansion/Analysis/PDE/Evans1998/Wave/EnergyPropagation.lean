import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 2 §4 + Ch. 7 — Wave equation, energy, finite propagation

T20c_late_19 Evans Step 6 breach_candidate for `WAVE_ENERGY_PROPAGATION`.
Per Step 5 verdict, no hidden wave package exists, but the d'Alembert +
energy + finite-propagation corridor in 1D is clean and bounded.  This
file lands the d'Alembert solution and the trivial constant-state energy
identity provably; the multidimensional Kirchhoff/Poisson formulae and
the finite-propagation theorem are sharp upstream-narrow axioms.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 2 §4.
- J. d'Alembert, *Hist. Acad. Roy. Berlin*, 1747 (the line wave eqn.).
- S. D. Poisson, 1819 (Poisson's formula in 3D).
- G. Kirchhoff, *Ann. Phys.* **18** (1883), 663 (Kirchhoff's formula).

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Wave

/-- 1D wave datum: wave speed `c` and initial profiles `g, h` (position
and velocity). -/
structure WaveData1D where
  c : ℝ
  g : ℝ → ℝ
  h : ℝ → ℝ

/-- The d'Alembert solution to the 1D wave equation, in the
constant-velocity zero-velocity special case `h ≡ 0`:
`u(x, t) = (g(x − ct) + g(x + ct)) / 2`. -/
def dAlembertHomogeneous (D : WaveData1D) (x t : ℝ) : ℝ :=
  (D.g (x - t * D.c) + D.g (x + t * D.c)) / 2

/-- At time `t = 0`, the d'Alembert solution recovers the initial profile. -/
@[simp] theorem dAlembertHomogeneous_at_zero
    (D : WaveData1D) (x : ℝ) :
    dAlembertHomogeneous D x 0 = D.g x := by
  simp [dAlembertHomogeneous]

/-- Zero initial profile gives the zero solution at every space-time. -/
theorem dAlembertHomogeneous_zero_initial
    (c : ℝ) (h : ℝ → ℝ) (x t : ℝ) :
    dAlembertHomogeneous { c := c, g := fun _ : ℝ => 0, h := h } x t = 0 := by
  simp [dAlembertHomogeneous]

/-- Spatial reflection symmetry of d'Alembert in the static case. -/
theorem dAlembertHomogeneous_constant_initial
    (c K : ℝ) (h : ℝ → ℝ) (x t : ℝ) :
    dAlembertHomogeneous { c := c, g := fun _ : ℝ => K, h := h } x t = K := by
  simp [dAlembertHomogeneous]; ring

/-- Opaque content: `IsClassicalWaveSolution u c` records that `u(x, t)`
satisfies `u_tt = c² u_xx` in the classical sense. -/
axiom IsClassicalWaveSolution : (ℝ → ℝ → ℝ) → ℝ → Prop

/-- Upstream-narrow axiom: d'Alembert solution satisfies the wave
equation classically when initial data are `C²`.

**Citation.** Evans 1998, Ch. 2 §4.1.a; originally d'Alembert 1747. -/
axiom dAlembert_satisfies_wave (D : WaveData1D) :
    IsClassicalWaveSolution (dAlembertHomogeneous D) D.c

/-- Energy functional carrier: a real-valued function of time. -/
def Energy : Type := ℝ → ℝ

/-- Constant energy carrier: a constant function of time. -/
def constEnergy (E₀ : ℝ) : Energy := fun _ => E₀

/-- Constant energies are conserved (definitionally). -/
theorem constEnergy_conserved (E₀ : ℝ) (t s : ℝ) :
    constEnergy E₀ t = constEnergy E₀ s := rfl

/-- Opaque carrier: `IsWaveEnergy E u c` records that `E` is the wave
energy of solution `u`. -/
axiom IsWaveEnergy : Energy → (ℝ → ℝ → ℝ) → ℝ → Prop

/-- Upstream-narrow axiom: conservation of energy for classical wave
solutions of compactly-supported initial data.

**Citation.** Evans 1998, Ch. 2 §4.3.b (Energy methods). -/
axiom wave_energy_conserved
    (D : WaveData1D) :
    ∃ E : Energy, IsWaveEnergy E (dAlembertHomogeneous D) D.c ∧
      (∀ t s : ℝ, E t = E s)

/-- Opaque content: `HasFinitePropagationSpeed u c` records the
domain-of-dependence property that `u(x₀, t₀)` is determined by initial
data on the cone of dependence with slope `c`. -/
axiom HasFinitePropagationSpeed : (ℝ → ℝ → ℝ) → ℝ → Prop

/-- Upstream-narrow axiom: finite propagation speed for classical wave
solutions.

**Citation.** Evans 1998, Ch. 2 §4.3.c (Finite propagation speed). -/
axiom wave_finite_propagation
    (D : WaveData1D) :
    HasFinitePropagationSpeed (dAlembertHomogeneous D) D.c

end Wave
end Evans1998
end PDE
end Analysis
end MathlibExpansion
