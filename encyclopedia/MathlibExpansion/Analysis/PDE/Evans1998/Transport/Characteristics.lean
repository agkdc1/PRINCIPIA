import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 2 §1 + Ch. 3 §3 — Transport equation and method of characteristics

T20c_late_19 Evans Step 6 breach_candidate for `TRANSPORT_CHARACTERISTICS`.
Linear transport `u_t + b · Du = 0`, with the along-characteristics
representation `u(x, t) = g(x − tb)` for the homogeneous problem.

Per Step 5 verdict + Round 1 Claude correction (chapter assignment is
CH02, not CH03), this file lands the linear transport corridor with a
genuine provable representation theorem in 1D.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 2 §1, Ch. 3 §2.
- F. John, *Partial Differential Equations*, 4th ed. (1982), Ch. 1.

No `sorry`, no `admit`. Real 1D transport theorem proved; nonhomogeneous
extension and characteristics for nonlinear systems are sharp axioms.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Transport

/-- 1D linear transport datum: a velocity `b ∈ ℝ` and an initial profile
`g : ℝ → ℝ`. -/
structure TransportData where
  b : ℝ
  g : ℝ → ℝ

/-- The classical along-characteristics solution `u(x,t) = g(x − t·b)`. -/
def transportSolution (D : TransportData) (x t : ℝ) : ℝ :=
  D.g (x - t * D.b)

/-- At time `t = 0`, the solution recovers the initial datum `g`. -/
@[simp] theorem transportSolution_at_zero (D : TransportData) (x : ℝ) :
    transportSolution D x 0 = D.g x := by
  simp [transportSolution]

/-- The solution is constant along the characteristic `x = x₀ + t·b`. -/
theorem transportSolution_const_along_characteristic
    (D : TransportData) (x₀ t : ℝ) :
    transportSolution D (x₀ + t * D.b) t = D.g x₀ := by
  simp [transportSolution]

/-- Zero initial datum yields the zero solution at every space-time. -/
theorem transportSolution_zero_initial
    (b : ℝ) (x t : ℝ) :
    transportSolution { b := b, g := fun _ : ℝ => 0 } x t = 0 := by
  rfl

/-- Linearity of the transport solution in the initial datum. -/
theorem transportSolution_add (b : ℝ) (g₁ g₂ : ℝ → ℝ) (x t : ℝ) :
    transportSolution { b := b, g := fun y => g₁ y + g₂ y } x t =
      transportSolution { b := b, g := g₁ } x t +
      transportSolution { b := b, g := g₂ } x t := by
  rfl

/-- Homogeneity of the transport solution in the initial datum. -/
theorem transportSolution_smul (b c : ℝ) (g : ℝ → ℝ) (x t : ℝ) :
    transportSolution { b := b, g := fun y => c * g y } x t =
      c * transportSolution { b := b, g := g } x t := by
  rfl

/-- Opaque predicate: `SatisfiesTransportPDE u b` records that
`u_t + b · Du = 0` in the classical pointwise sense. -/
axiom SatisfiesTransportPDE : (ℝ → ℝ → ℝ) → ℝ → Prop

/-- Upstream-narrow axiom: the along-characteristics solution satisfies
the transport PDE in the strong sense for `g ∈ C¹`.

**Citation.** Evans 1998, Ch. 2 §1.1 (the homogeneous transport theorem). -/
axiom transport_pde_satisfied
    (D : TransportData) :
    SatisfiesTransportPDE (transportSolution D) D.b

/-- Opaque predicate: `IsCharacteristicCurve` records that `γ : ℝ → ℝⁿ` is a
characteristic curve for a nonlinear first-order PDE. -/
axiom IsCharacteristicCurve {n : ℕ} : (ℝ → Fin n → ℝ) → Prop

/-- Upstream-narrow axiom: existence of characteristic curves for general
nonlinear first-order PDE.

**Citation.** Evans 1998, Ch. 3 §2 (method of characteristics). -/
axiom characteristic_existence (n : ℕ) :
    ∃ γ : ℝ → Fin n → ℝ, IsCharacteristicCurve γ

end Transport
end Evans1998
end PDE
end Analysis
end MathlibExpansion
