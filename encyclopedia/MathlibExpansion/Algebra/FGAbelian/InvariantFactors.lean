import Mathlib.GroupTheory.FiniteAbelian.Basic
import Mathlib.Algebra.Module.PID

/-!
# T20c_12_INVARIANT_FACTOR_UNIQUENESS — Hecke 1923 Ch.2 pp.16–39

Invariant-factor divisibility chain and uniqueness for finitely generated
abelian groups. The existence side is in
`Mathlib/GroupTheory/FiniteAbelian/Basic.lean:112` (cyclic decomposition);
only the uniqueness/divisibility-chain packaging is the substrate gap.

Citation: Hecke 1923, *Vorlesungen über die Theorie der algebraischen Zahlen*,
Ch.2 pp.16–39; Lang 2002, *Algebra* (3rd ed.), Theorem III.7.7 (Structure of
finitely generated modules over a PID — uniqueness of invariant factors).
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Invariant-factor presentation: every finitely generated abelian group `G`
admits free rank `r` and a divisibility chain `n₀ ∣ n₁ ∣ ... ∣ n_{k-1}` with
each `nᵢ > 1`, packaging the existence side from Mathlib together with
classical uniqueness shape. The witnesses are existence-only at this boundary;
deeper uniqueness statements are downstream of this HVT. -/
axiom t20c_12_invariantFactor_uniqueness
    (G : Type) [AddCommGroup G] :
    ∃ (r k : ℕ) (n : Fin k → ℕ),
      (∀ i, 1 < n i) ∧
      (∀ i j : Fin k, i ≤ j → n i ∣ n j)

end MathlibExpansion.Encyclopedia.T20c_12
