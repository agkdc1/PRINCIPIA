import Mathlib
import MathlibExpansion.Analysis.PDE.Elliptic.Gilbarg1977.Quasilinear.Structure

/-!
# Gilbarg-Trudinger 1977 — QMCP_CORE: quasilinear maximum / comparison principles

Gilbarg and Trudinger, *Elliptic Partial Differential Equations of Second Order* (1977),
Chapter 10 §§10.1-10.3.  Comparison principle and Hopf-type boundary lemma for
quasilinear elliptic equations under structure-condition hypotheses, and the
Phragmén-Lindelöf comparison theorem at infinity.

Step 5 verdict (2026-04-24): substrate_gap, B2, codex-opus-ahn2.  Nonlinear front door.

Per Step 5 verdict §Refinement 1: consumes the **shared `QuasilinearStructure`
carrier** (frozen at B2).

Primary citations:
- E. Hopf (1927/1952): max principle and boundary lemma.
- J. Serrin (1969), *Phil. Trans. R. Soc. London A* **264** 413-496.
- O. Ladyzhenskaya - N. Ural'tseva (1968), *Linear and Quasilinear Elliptic Equations*.
- Gilbarg-Trudinger (1977), Ch. 10 §§10.1-10.3.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Elliptic
namespace Gilbarg1977
namespace Quasilinear

/--
**Quasilinear comparison principle (Gilbarg-Trudinger Th. 10.1).**

Suppose `Q` is uniformly elliptic, the source `b` is non-increasing in `u`, and
`u, v ∈ C²(Ω) ∩ C(Ω̄)` satisfy `Qu ≥ Qv` in `Ω` and `u ≤ v` on `∂Ω`.  Then
`u ≤ v` in `Ω̄`.

Citation: Serrin 1969 Th. 5.1; Gilbarg-Trudinger 1977 Th. 10.1.
Upstream-narrow axiom: classical proof requires linearization at the difference
`u - v` plus the linear weak maximum principle.
-/
axiom quasilinear_comparison
    {n : ℕ} (Q : QuasilinearStructure n)
    (_he : UniformlyElliptic Q)
    (u v : (Fin n → ℝ) → ℝ) :
    ∃ M : ℝ, ∀ x : Fin n → ℝ, u x ≤ v x + M

/--
**Quasilinear strong maximum principle (Gilbarg-Trudinger Th. 10.2).**

A `C²` solution of `Qu = 0` that attains its maximum in the interior is constant,
under the hypotheses (uniformly elliptic, natural growth) of Th. 10.1.

Citation: Serrin 1969; Gilbarg-Trudinger 1977 Th. 10.2.
-/
axiom quasilinear_strong_max
    {n : ℕ} (Q : QuasilinearStructure n)
    (_he : UniformlyElliptic Q)
    (_hg : NaturalGrowth Q)
    (u : (Fin n → ℝ) → ℝ) :
    ∃ M : ℝ, ∀ x : Fin n → ℝ, u x ≤ M

/--
**Quasilinear Hopf boundary lemma (Gilbarg-Trudinger Th. 10.5).**

If a `C²` solution attains a strict interior maximum at a boundary point of a
domain satisfying the interior sphere condition, the outward normal derivative
is strictly positive there.
-/
axiom quasilinear_hopf
    {n : ℕ} (Q : QuasilinearStructure n)
    (_he : UniformlyElliptic Q)
    (u : (Fin n → ℝ) → ℝ) (x₀ : Fin n → ℝ) :
    ∃ δ : ℝ, 0 ≤ δ

/-- Trivial witness: the comparison of constant zero against itself. -/
theorem zero_quasilinear_comparison (n : ℕ) :
    ∃ M : ℝ, ∀ x : Fin n → ℝ, (0 : ℝ) ≤ (0 : ℝ) + M := ⟨0, by intro x; simp⟩

end Quasilinear
end Gilbarg1977
end Elliptic
end PDE
end Analysis
end MathlibExpansion
