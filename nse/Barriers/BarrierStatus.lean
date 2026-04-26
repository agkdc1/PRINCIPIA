import Mathlib

-- NavierStokes.Barriers.BarrierStatus
-- Taxonomy for NSB (Navier-Stokes Barrier) classification outcomes.
-- Introduced in boardroom `board-ns-basic-20260420-01` round 5 CONSENSUS.
-- Prevents mislabeling Kato small-data theory as Clay-scale evasion.

namespace NavierStokes.Barriers

/-- Classification of how a proof attempt relates to the NSB barrier system.
    Every claim that reaches the adversarial attack stage must carry one of
    these labels so the Commander can distinguish genuine barrier evasion from
    calibration artefacts. -/
inductive BarrierStatus where
  /-- The result lives inside Kato/Fujita small-data theory: it gives a
      conditional regularity result under ε-smallness of initial data in a
      critical norm.  This is real mathematics but does NOT address the
      Clay problem (large data, global smoothness). -/
  | calibrationOnly (reason : String) : BarrierStatus
  /-- The NSB in question does not apply to this particular formulation
      (e.g. a 2-D reduction, a linear model, a stationary problem).
      The result may be correct but carries no information about the
      3-D global regularity question. -/
  | notApplicable (reason : String) : BarrierStatus
  /-- The claim has survived all three adversarial attacks (TAA, DGNM, LWSA)
      and the certificate string records the attack log reference that
      establishes survival.  Gate 1 prerequisite satisfied. -/
  | survivesAttack (certificate : String) : BarrierStatus
  /-- The claim was falsified by at least one adversarial attack.
      The reason string identifies which attack succeeded and why. -/
  | failed (reason : String) : BarrierStatus
  deriving Repr, DecidableEq

/-- A claim is gate-cleared iff it carries a `survivesAttack` certificate. -/
def BarrierStatus.isGateCleared : BarrierStatus → Bool
  | survivesAttack _ => true
  | _                => false

/-- Extract the embedded string from any constructor (for logging). -/
def BarrierStatus.message : BarrierStatus → String
  | calibrationOnly r => r
  | notApplicable   r => r
  | survivesAttack  c => c
  | failed          r => r

end NavierStokes.Barriers
