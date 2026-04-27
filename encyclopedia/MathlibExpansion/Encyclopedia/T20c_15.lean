/-
Levi-Civita 1925 — *Lezioni di calcolo differenziale assoluto*.

Encyclopedia entry T20c_15 root module.  Re-exports the 88 axiomatized HVTs
(across Levi-Civita's 4 chapter blocks) as grouped Deferred files keyed
to the per-track landing-zone organization from the Step 5 verdict.
The four `poison_quarantine` items (CHR_10, LGC_01, GGE_04, RCC_06)
are intentionally NOT axiomatized: they wait on the local
`Geodesic.lean:32` and `ExponentialMap.lean:27` axiom-tainted shells
being replaced by a real geodesic ODE / connection package.

HVT classification (Step 5 verdict):
  • 46 substrate_gap, 21 novel_theorem, 22 breach_candidate, 4 poison_quarantine
  • Track A — Tensor Algebra Substrate (Cap. IV §§3-13): 7
  • Track B — Complete First-Order Systems (Cap. II-III): 9
  • Track C — Metric Tensor / Line Element (Cap. V §§1-8): 7
  • Track D — Christoffel Symbols (Cap. V §§12-17): 9 (CHR_10 quarantined)
  • Track E — Covariant Derivative / Ricci Lemma (Cap. VI §§1-7): 10
  • Track F — Geodesic / Autoparallelism (Cap. V §§23-27): 6
  • Track G — Locally Geodesic Coordinates (Cap. VI §§11-12): 3 (LGC_01 quarantined)
  • Track H — Gaussian Curvature / Geodesic Excess (Cap. VII §§8-10): 3 (GGE_04 quarantined)
  • Track I — Riemann Curvature Tensor / Bianchi (Cap. VII §§1-8): 9
  • Track J — Constant Curvature / Schur (Cap. VIII): 8
  • Track K — Class Zero / Class One Quadratic Forms (Cap. IX): 8
  • Track L — Ricci Rotation / Canonical Congruences (Cap. X): 9 (RCC_06 quarantined)

Three propositions are COVERED by Mathlib (no HVT row, no axiom):
  • TCTL_01 — Mathlib `Matrix/Basis.lean:235`
  • TCTL_05 — Mathlib `Dual.lean:396`
  • TCTL_08 — Mathlib `Matrix/Basis.lean:203`
-/

import MathlibExpansion.Encyclopedia.T20c_15.TrackA_TensorCoords
import MathlibExpansion.Encyclopedia.T20c_15.TrackB_CompleteSystems
import MathlibExpansion.Encyclopedia.T20c_15.TrackC_MetricTensor
import MathlibExpansion.Encyclopedia.T20c_15.TrackD_Christoffel
import MathlibExpansion.Encyclopedia.T20c_15.TrackE_CovariantDerivative
import MathlibExpansion.Encyclopedia.T20c_15.TrackF_Geodesic
import MathlibExpansion.Encyclopedia.T20c_15.TrackG_NormalCoords
import MathlibExpansion.Encyclopedia.T20c_15.TrackH_SurfaceCurvature
import MathlibExpansion.Encyclopedia.T20c_15.TrackI_RiemannCurvature
import MathlibExpansion.Encyclopedia.T20c_15.TrackJ_ConstantCurvature
import MathlibExpansion.Encyclopedia.T20c_15.TrackK_ClassInvariants
import MathlibExpansion.Encyclopedia.T20c_15.TrackL_RicciRotation
