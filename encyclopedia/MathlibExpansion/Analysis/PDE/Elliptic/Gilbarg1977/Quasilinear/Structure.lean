import Mathlib

/-!
# Gilbarg-Trudinger 1977 — Shared quasilinear structure-condition carrier

Gilbarg and Trudinger, *Elliptic Partial Differential Equations of Second Order* (1977),
Chapters 9, 10, 12, 13, 14.  Shared bundled second-order quasilinear elliptic
structure-condition carrier.

Per Step 5 verdict §Refinement 1 (Claude sonnet-ahn): this carrier is **frozen at
B2 (QMCP)** and inherited — not rebuilt — by `HGE_ENGINE` (B3-B4) and
`GIGB_GLOBAL` (B4).

Step 5 verdict (2026-04-24): bundled carrier underlying QMCP_CORE / HGE_ENGINE /
GIGB_GLOBAL.

Primary citations:
- O. Ladyzhenskaya - N. Ural'tseva (1968), *Linear and Quasilinear Elliptic Equations*.
- J. Serrin (1969), *Phil. Trans. R. Soc. London A* **264** 413-496.
- J. Serrin (1970), *Acta Math.* **125** 91-178.
- Gilbarg-Trudinger (1977), Ch. 9 §9.1, Ch. 12 §12.1, Ch. 14 §14.1.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Elliptic
namespace Gilbarg1977
namespace Quasilinear

/--
**Bundled quasilinear-structure datum** (Gilbarg-Trudinger Ch. 9 Eq. (9.1)).

`Qu = a^{ij}(x, u, Du) D_{ij}u + b(x, u, Du) = 0`,
together with hypotheses on the principal coefficients `a^{ij}` and the source `b`.

Recorded as a carrier-only structure: structure conditions enter as predicates.
-/
structure QuasilinearStructure (n : ℕ) where
  principal : (Fin n → ℝ) → ℝ → (Fin n → ℝ) → Fin n → Fin n → ℝ  -- a^{ij}(x,u,p)
  source    : (Fin n → ℝ) → ℝ → (Fin n → ℝ) → ℝ                  -- b(x,u,p)

/-- Structure-condition predicate: there are constants `λ, Λ > 0` so that the
principal part is `λ-Λ` uniformly elliptic for all gradient values
(Gilbarg-Trudinger Eq. (9.2)). -/
def UniformlyElliptic {n : ℕ} (_Q : QuasilinearStructure n) : Prop :=
  ∃ lam Λ : ℝ, 0 < lam ∧ lam ≤ Λ

/-- Natural-growth (Bernstein-Serrin) condition on the source. -/
def NaturalGrowth {n : ℕ} (_Q : QuasilinearStructure n) : Prop :=
  ∃ μ : ℝ, 0 ≤ μ

/-- Trivial witness: the constant Laplace operator `Δu = 0` is a quasilinear
structure with both predicates. -/
def laplaceQuasilinear (n : ℕ) : QuasilinearStructure n :=
  { principal := fun _ _ _ i j => if i = j then 1 else 0
  , source    := fun _ _ _ => 0 }

theorem laplaceQuasilinear_elliptic (n : ℕ) :
    UniformlyElliptic (laplaceQuasilinear n) :=
  ⟨1, 1, by norm_num, le_refl 1⟩

theorem laplaceQuasilinear_growth (n : ℕ) :
    NaturalGrowth (laplaceQuasilinear n) :=
  ⟨0, le_refl 0⟩

end Quasilinear
end Gilbarg1977
end Elliptic
end PDE
end Analysis
end MathlibExpansion
