/-!
# T20c_late_12 SMTLFB — smooth manifolds / tensor / Lie group / fiber bundle
(B1 defer)

**Classification.** `defer` / `B1` per Step 5 verdict. Kobayashi–Nomizu I, Ch. I
foundations (smooth manifolds, tensor fields, Lie groups, fiber bundles) are
already covered upstream in `Mathlib.Geometry.Manifold.IsManifold`,
`Mathlib.Geometry.Manifold.Algebra.LieGroup`, and
`Mathlib.Geometry.Manifold.VectorBundle.Basic`. This file is a **citation-only
defer marker** — no new axioms introduced.

**Dispatch note (cycle-3, 2026-04-25).** Defer HVT per doctrine: citation only,
no axiomatization. Cycle-2 import (`SmoothManifoldWithCorners`) was renamed
upstream to `IsManifold`; cycle-3 drops the import entirely since the marker
needs no Mathlib substrate.

**Citation.** Kobayashi & Nomizu, *Foundations of Differential Geometry*, Vol. I
(Wiley, 1963), Ch. I §§1–4, pp. 1–61. Historical parent: É. Cartan,
"Sur les variétés à connexion affine" (Annales ENS 1923–24); C. Ehresmann,
"Les connexions infinitésimales dans un espace fibré différentiable",
Colloque de topologie (CBRM, Bruxelles, 1950).
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_SMTLFB

/-- **SMTLFB_00** citation-defer marker (2026-04-25). Kobayashi–Nomizu Ch. I
foundations — smooth manifolds, tensor fields, Lie groups, fiber bundles —
are covered upstream. This marker reserves the root-hash pointer. -/
theorem smtlfb_citation_defer : True := trivial

end T20cLate12_SMTLFB
end KobayashiNomizu
end Roots
end MathlibExpansion
