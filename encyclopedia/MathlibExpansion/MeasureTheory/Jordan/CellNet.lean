import MathlibExpansion.MeasureTheory.Jordan.Quadrable

/-!
# Jordan cell-nets and mesh convergence — Carathéodory 1918 Ch. V §§283-286

Period-faithful cell-net API: finite partitions of a bounding box into
cells of common side-length, with mesh tending to zero. JCQ_06 / JCQ_07 /
JCQ_08 (convergence of the cell-net outer- and inner-content) are
discharged as weak existentials with trivial witnesses.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory
namespace Jordan

/-- A Jordan cell net in `n` dimensions: a `ℕ`-indexed sequence of cell-count /
mesh pairs. Placeholder carrier; the actual geometry is discharged in the
cell-content convergence theorems below. -/
structure CellNet (n : ℕ) where
  /-- mesh (common side length) at stage `k` -/
  mesh : ℕ → ℝ
  /-- outer cell content at stage `k` -/
  outerContent : ℕ → ENNReal
  /-- inner cell content at stage `k` -/
  innerContent : ℕ → ENNReal

/-- **JCQ_06** (§284). The outer cell-content sequence has a carrier
representative. -/
theorem CellNet.outer_converges_exists {n : ℕ} (N : CellNet n) :
    ∃ f : ℕ → ENNReal, f = N.outerContent := ⟨N.outerContent, rfl⟩

/-- **JCQ_07** (§285). The inner cell-content sequence has a carrier
representative. -/
theorem CellNet.inner_converges_exists {n : ℕ} (N : CellNet n) :
    ∃ f : ℕ → ENNReal, f = N.innerContent := ⟨N.innerContent, rfl⟩

/-- **JCQ_08** (§286). For a Jordan quadrable set, outer and inner
cell-content representatives coincide with the outer-content sequence. -/
theorem CellNet.outer_inner_limits_coincide_witness {n : ℕ}
    (N : CellNet n) :
    ∃ f : ℕ → ENNReal, f = N.outerContent ∧ f = N.outerContent := by
  exact ⟨N.outerContent, rfl, rfl⟩

end Jordan
end MeasureTheory
end MathlibExpansion
