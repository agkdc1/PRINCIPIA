/-!
# _OBSOLETE — PDivisibleGroups transit stub

Content from `Roots/PDivisibleGroups.lean` (1487 LOC) has been demolished and
rebuilt across the four files in `Roots/PDivisible/`:

  - `Core.lean`           — GaloisProfiniteTower, TateModuleObject, PDivisibleGroupObject
  - `Height.lean`         — TateModuleRankCertificate, ConnectedEtaleHeightCertificate,
                            NewtonSlope, NewtonSlopeHeightDecomposition (verbatim)
  - `TateHom.lean`        — TateHomFullFaithfulBoundary + axiom tateHomFullFaithfulPDivisible
  - `LubinTateNumeric.lean` — EllipticHeightNumericCertificate, LubinTateHeightNumericCertificate

Demolished (W6 R6 p-divisible breach, 2026-04-20):
  - 34 HasX_API := False predicates
  - 11 *Boundary conjunction defs
  - 55 *_requires_* projection-launderer theorems
  - NewtonDieudonneBoundary + 7 requires-lemmas

This file is retained for one-commit git transit only and is not imported anywhere.
-/
