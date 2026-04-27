import MathlibExpansion.Roots.PDivisible.Core
import MathlibExpansion.Roots.PDivisible.Height
import MathlibExpansion.Roots.PDivisible.TateHom
import MathlibExpansion.Roots.PDivisible.LubinTateNumeric

/-!
# p-divisible groups (rebuilt W6 R6, 2026-04-20)

Re-exports the four PDivisible sub-files replacing the demolished
`Roots/PDivisibleGroups.lean` (1487 LOC, 34 HasX_API predicates, 11 *Boundary defs,
55 *_requires_* projection-launderers deleted).

| File | Content |
|------|---------|
| `Core` | GaloisProfiniteTower, TateModuleObject, PDivisibleGroupObject, PDivisibleHom |
| `Height` | TateModuleRankCertificate, ConnectedEtaleHeightCertificate, NewtonSlope, NewtonSlopeHeightDecomposition |
| `TateHom` | TateHomFullFaithfulBoundary + certificate projection tateHomFullFaithfulPDivisible |
| `LubinTateNumeric` | LubinTateHeightNumericCertificate, EllipticHeightNumericCertificate, FreyTwoAdicHeightTwoCertificate |
-/
