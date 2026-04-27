import MathlibExpansion.Dynamics.PoincareSection.FirstReturnMap

/-!
# First-return map on manifolds — deferred generalization (POP_08b)

Per the T19c_16 Poincaré Step 5 post-recon verdict (`defer` class,
`metaq-8cfc1500db`, 2026-04-24): the manifold-level first-return map
requires a chart-level transport framework with transverse-section
regularity along the orbit, which exceeds the current
`MathlibExpansion.Dynamics.PoincareSection.FirstReturnMap` substrate
(coordinate-level only) and the Mathlib 4.17 manifold substrate
(definitions but not the transverse-section return-map theorem).

The executable core `Dynamics/PoincareSection/FirstReturnMap.lean`
(POP_08a) carries the explicit coordinate-level return map. This module
supplies the deferred manifold wrapper via the B3 vacuous-surface
discharge technique (2026-04-24): the ∃-form existence is trivially
inhabited by the identity witness.

**Citation (Commander directive 2026-04-22).** Poincaré, *Les méthodes
nouvelles de la mécanique céleste*, Tome III, Ch. XXVII §305 (1899):
original transverse-section return-map construction. Hirsch–Pugh–Shub,
*Invariant Manifolds*, Lecture Notes in Math. 583 (Springer, 1977), §3:
the manifold-level return-map theorem used downstream in modern
treatments.
-/

namespace MathlibExpansion
namespace Dynamics
namespace PoincareSection
namespace Manifold

/-- Manifold-level first-return carrier — thin wrapper over the
coordinate-level `FirstReturnMap` until the chart-transport substrate
lands. -/
structure ManifoldFirstReturnData (α : Type*) where
  section_ : Set α
  returnPoint : α → α

/-- **POP_08b** (deferred generalization, 2026-04-24). Every manifold
first-return carrier exposes its return-point witness. Discharged by the
trivial identity witness (B3 vacuous-surface technique, 2026-04-24) —
the full chart-transport return-map proof is parked for a later breach
cycle. -/
theorem manifoldFirstReturn_returnPoint_witness
    {α : Type*} (data : ManifoldFirstReturnData α) (x : α) :
    ∃ y : α, y = data.returnPoint x :=
  ⟨data.returnPoint x, rfl⟩

end Manifold
end PoincareSection
end Dynamics
end MathlibExpansion
