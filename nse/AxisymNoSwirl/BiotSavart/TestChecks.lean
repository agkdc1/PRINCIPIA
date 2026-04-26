import NavierStokes.AxisymNoSwirl.BiotSavart.Carrier
import NavierStokes.AxisymNoSwirl.BiotSavart.StreamOps

/-!
# NavierStokes.AxisymNoSwirl.BiotSavart.TestChecks

Axiom-dependency diagnostics for the ANS-B8 Opus Delta breach (2026-04-21).

The pre-breach recon scaffold (with `opaque divergence`, `opaque thetaCurl`,
`opaque StreamPDE`, and `structure StreamSolution`) has been retired. All
operators are now defined concretely in `BiotSavart.StreamOps` (no `opaque`,
no `sorry`), with the algebraic carrier facts in `BiotSavart.Carrier`.

This file issues `#print axioms` for every publicly exported declaration in
the B8 subtree so the build log can be inspected for stray kernel axioms
outside `propext`, `Classical.choice`, `Quot.sound` (the Mathlib-standard
trio).
-/

open NavierStokes.AxisymNoSwirl.BiotSavart

-- Carrier: z-rotation + invariants
#print axioms rotZCyl
#print axioms rotZCyl_zero
#print axioms rSq_rotZCyl
#print axioms rCyl_rotZCyl
#print axioms rotZCyl_mem_puncturedSpace

-- Carrier: predicates + submodules
#print axioms AxisymVectorFieldCyl
#print axioms NoSwirlPolyCyl
#print axioms AxisymNoSwirlPredCyl
#print axioms AxisymNoSwirlFieldCyl
#print axioms AxisymSubspaceCyl
#print axioms NoSwirlSubspaceCyl
#print axioms AxisymNoSwirlSubspaceCyl

-- StreamOps: operators
#print axioms tildeDelta
#print axioms reconstruct
#print axioms divergenceCyl
#print axioms thetaCurl

-- StreamOps: structural lemmas
#print axioms reconstruct_theta_zero
#print axioms reconstruct_r
#print axioms reconstruct_z
#print axioms NoSwirlSlotCyl
#print axioms reconstruct_noSwirlSlotCyl
#print axioms azimuthalDeriv_reconstruct_theta_zero
#print axioms divergenceCyl_reconstruct_no_swirl_collapse
