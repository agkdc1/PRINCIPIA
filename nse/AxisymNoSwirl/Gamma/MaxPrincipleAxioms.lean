import NavierStokes.AxisymNoSwirl.Gamma.MaxPrinciple

/-!
# `#print axioms` probe for B5-W5 Stampacchia max principle.

Evidence file. Lists the axiom dependencies of the four Route W deliverables:

- `truncationEnergyAt_le_initial`        — monotone decay
- `stampacchia_weak_max_principle`        — CROWN JEWEL (energy form)
- `integrable_sq_shiftedPosPart_of_certificate` — `L²` integrability bridge
- `stampacchia_L_infty_propagation`       — `L^∞` propagation (a.e. form)
-/

open NavierStokes.AxisymNoSwirl.Gamma

#print axioms truncationEnergyAt_le_initial
#print axioms stampacchia_weak_max_principle
#print axioms integrable_sq_shiftedPosPart_of_certificate
#print axioms stampacchia_L_infty_propagation
