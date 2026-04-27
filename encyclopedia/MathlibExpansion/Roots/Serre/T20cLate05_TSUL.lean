import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_05 TSUL — Theta series of unimodular lattices (substrate_gap L3)

**Classification.** `substrate_gap` / `L3`. Chapter V theta package:
for positive-definite integral lattice `(L, q)` of rank `n`,
`Θ_L(z) := Σ_{x ∈ L} e^{πi q(x) z} = Σ_{m ≥ 0} r_L(m) e^{πi m z}` (upper
half-plane `z`, `r_L(m) := #{x ∈ L : q(x) = m}`).

**Citation.** Serre, *A Course in Arithmetic*, Ch. V §2.3.
Historical parent: Jacobi, *Fundamenta Nova* (1829); Hecke (1938).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_TSUL

/-- **TSUL_01** theta coefficient marker. For positive-definite integral
lattice `(L, q)` of rank `n`, the representation counts `r_L(m) := #{x ∈ L :
q(x) = m}` are finite for every `m ∈ ℕ` and `r_L(0) = 1`.
Citation: Serre Ch. V §2.3, Def. -/
axiom theta_coefficient_finite_marker : True

/-- **TSUL_03** theta modular weight marker. For even positive-definite
unimodular lattice `L` of rank `n = 2k`, `Θ_L : ℍ → ℂ` is a modular form of
weight `k` for `SL_2(ℤ)` (level 1): `Θ_L((az+b)/(cz+d)) = (cz+d)^k Θ_L(z)`.
Citation: Serre Ch. V §2.3, Thm. 8. -/
axiom theta_modular_weight_marker : True

/-- **TSUL_05** Poisson summation ⇒ theta transformation marker. For
positive-definite integral lattice `L` of rank `n`,
`Θ_L(-1/z) = (z/i)^{n/2} · |disc(L)|^{-1/2} · Θ_{L^#}(z)` via Poisson
summation on the Gaussian `e^{πi q(x) z}`; unimodular case simplifies.
Citation: Serre Ch. V §2.3, Prop. 15 (proof). -/
axiom theta_poisson_transformation_marker : True

end T20cLate05_TSUL
end Serre
end Roots
end MathlibExpansion
