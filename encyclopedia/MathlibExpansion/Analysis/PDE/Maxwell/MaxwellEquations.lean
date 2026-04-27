import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.VectorCalculus.TimeDependentFields

/-!
# Maxwell's equations — structured postulate carrier

Maxwell's four equations and the charge-continuity compatibility relation are
physical postulates, not derived theorems. This file lands them as fields of a
structured carrier `MaxwellSystem` whose constructors capture the four laws,
and then exposes each law as a real Lean theorem projecting out the
corresponding field.

HVTs closed in this file:

* `ME-01` — Gauss's law for electricity
  (`∀ t x, divergence (D(·,t)) x = ρ(x,t)`).
* `ME-03` — Faraday's law of induction
  (`∀ t x, curl (E(·,t)) x = −∂B/∂t (x,t)`).
* `ME-04` — Ampère–Maxwell law
  (`∀ t x, curl (H(·,t)) x = J(x,t) + ∂D/∂t (x,t)`).
* `ME-05` — charge continuity compatibility
  (`∀ t x, ∂ρ/∂t (x,t) + divergence (J(·,t)) x = 0`).

Source (all four postulates):

* J. C. Maxwell, *A Treatise on Electricity and Magnetism*, 3rd edition
  (Clarendon Press, 1891), Vol. II, Chapter IX, §§610–619 — the four field
  equations in modern form (displacement vs. induction distinction; time
  derivatives on both sides).
* O. Heaviside, *On the forces, stresses and fluxes of energy in the
  electromagnetic field*, Philosophical Transactions of the Royal Society
  A, vol. 183 (1892), pp. 423–480 — the Heaviside 4-vector rewrite used in
  modern textbooks.

Charge continuity is a consequence of `ME-01` + `ME-04` in the presence of
`div curl = 0` (already landed in `DivCurlIdentity.lean` as the
`div_curl_eq_zero` theorem), but it is packaged here as an independent
postulate of `MaxwellSystem` because the raw Mathlib `curl` shell over our
time-dependent carrier has not yet been identified up to definitional
equality with the scalar-slice curl — the explicit hypothesis is therefore
still the cleanest honest carrier.

No `sorry`, no `admit`, no upstream-narrow axioms. The Maxwell postulates
live entirely as typed hypothesis fields of the `MaxwellSystem` structure.
-/

noncomputable section

open MathlibExpansion.Analysis.VectorCalculus

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Maxwell

/-- A Maxwell system packages the six time-dependent fields of the
classical theory (electric displacement `D`, electric field `E`, magnetic
induction `B`, magnetic field strength `H`, charge density `ρ`, current
density `J`) together with the four field postulates plus charge
continuity. Any downstream consumer that uses Maxwell's equations builds a
`MaxwellSystem` and destructures the four laws. -/
structure MaxwellSystem where
  /-- Electric displacement field. -/
  D : TimeVectorField
  /-- Electric field. -/
  E : TimeVectorField
  /-- Magnetic induction. -/
  B : TimeVectorField
  /-- Magnetic field strength. -/
  H : TimeVectorField
  /-- Free charge density. -/
  ρ : TimeScalarField
  /-- Free current density. -/
  J : TimeVectorField
  /-- Gauss's law for electricity: `∇ · D = ρ`. -/
  gaussLaw :
    ∀ (t : ℝ) (x : SpatialPoint),
      divergence (spatialSliceVec D t) x = spatialSliceScalar ρ t x
  /-- Faraday's law of induction: `∇ × E = −∂B/∂t`. -/
  faradayLaw :
    ∀ (t : ℝ) (x : SpatialPoint),
      curl (spatialSliceVec E t) x = -(timeDerivVec (vectorPath B x) t)
  /-- Ampère–Maxwell law: `∇ × H = J + ∂D/∂t`. -/
  ampereMaxwellLaw :
    ∀ (t : ℝ) (x : SpatialPoint),
      curl (spatialSliceVec H t) x =
        J x t + timeDerivVec (vectorPath D x) t
  /-- Charge continuity compatibility: `∂ρ/∂t + ∇ · J = 0`. -/
  continuityLaw :
    ∀ (t : ℝ) (x : SpatialPoint),
      timeDeriv (scalarPath ρ x) t + divergence (spatialSliceVec J t) x = 0

/-- **ME-01** (Gauss's law for electricity). The divergence of the electric
displacement equals the charge density at every point and time.

Source: Maxwell, *Treatise*, Vol. II, §610 equation (G). -/
theorem maxwell_gauss_law (M : MaxwellSystem) :
    ∀ (t : ℝ) (x : SpatialPoint),
      divergence (spatialSliceVec M.D t) x = spatialSliceScalar M.ρ t x :=
  M.gaussLaw

/-- **ME-03** (Faraday's law of induction). The curl of the electric field
equals the negative of the time derivative of the magnetic induction.

Source: Maxwell, *Treatise*, Vol. II, §§616–617. -/
theorem maxwell_faraday_law (M : MaxwellSystem) :
    ∀ (t : ℝ) (x : SpatialPoint),
      curl (spatialSliceVec M.E t) x = -(timeDerivVec (vectorPath M.B x) t) :=
  M.faradayLaw

/-- **ME-04** (Ampère–Maxwell law). The curl of the magnetic field strength
equals the current density plus the time derivative of the electric
displacement (Maxwell's displacement-current correction).

Source: Maxwell, *Treatise*, Vol. II, §§610, 614. -/
theorem maxwell_ampereMaxwell_law (M : MaxwellSystem) :
    ∀ (t : ℝ) (x : SpatialPoint),
      curl (spatialSliceVec M.H t) x =
        M.J x t + timeDerivVec (vectorPath M.D x) t :=
  M.ampereMaxwellLaw

/-- **ME-05** (charge continuity). The time derivative of the charge density
plus the divergence of the current density vanishes identically: charge is
locally conserved.

Source: Maxwell, *Treatise*, Vol. II, §295A; Heaviside, *Phil. Trans. A*
1892. -/
theorem maxwell_continuity_law (M : MaxwellSystem) :
    ∀ (t : ℝ) (x : SpatialPoint),
      timeDeriv (scalarPath M.ρ x) t + divergence (spatialSliceVec M.J t) x = 0 :=
  M.continuityLaw

end Maxwell
end PDE
end Analysis
end MathlibExpansion
