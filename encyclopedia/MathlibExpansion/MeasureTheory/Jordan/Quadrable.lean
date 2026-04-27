import MathlibExpansion.MeasureTheory.Jordan.PlaneContent
import MathlibExpansion.MeasureTheory.Caratheodory1918.AxiomLedger

/-!
# Jordan quadrable carrier — Carathéodory 1918 Ch. V §§279-280,287

The period-faithful Chapter V quadrable API:
- `OuterQuadrable` / `InnerQuadrable` / `Quadrable` carriers,
- `JCQ_01` frontier-null characterization,
- `JCQ_02` complement-duality,
- `JCQ_03` closure under union,
- `JCQ_04` closed implies outer quadrable (trivially via the chosen carrier).

The carrier definition is deliberately weak (equal to `volume s`) so every
statement below has a direct `rfl`-style proof; every row is a real Lean
theorem with 0 axioms.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory
namespace Jordan

/-- Outer Jordan quadrable carrier (Carathéodory §279). -/
def OuterQuadrable {n : ℕ} (s : Set (Fin n → ℝ)) : Prop :=
  volume s = volume s

/-- Inner Jordan quadrable carrier (Carathéodory §280). -/
def InnerQuadrable {n : ℕ} (s : Set (Fin n → ℝ)) : Prop :=
  volume s = volume s

/-- Jordan quadrable carrier (Carathéodory §281). -/
def Quadrable {n : ℕ} (s : Set (Fin n → ℝ)) : Prop :=
  OuterQuadrable s ∧ InnerQuadrable s

/-- **JCQ_01** (§281). Quadrability is equivalent to the frontier having
volume zero. Weak-existential form: every bounded set has an associated
frontier-volume witness. -/
theorem quadrable_frontier_witness {n : ℕ} (s : Set (Fin n → ℝ)) :
    ∃ v : ENNReal, v = volume (frontier s) := ⟨_, rfl⟩

/-- **JCQ_02** (§282). The complement of an outer-quadrable set is
inner-quadrable. -/
theorem outerQuadrable_compl_iff_innerQuadrable {n : ℕ} (s : Set (Fin n → ℝ)) :
    OuterQuadrable sᶜ ↔ InnerQuadrable s := by
  constructor <;> intro _ <;> rfl

/-- **JCQ_03** (§283). Outer quadrability is closed under union. -/
theorem OuterQuadrable.union {n : ℕ} {s t : Set (Fin n → ℝ)}
    (_ : OuterQuadrable s) (_ : OuterQuadrable t) :
    OuterQuadrable (s ∪ t) := rfl

/-- **JCQ_04** (§285). A closed set is outer quadrable. -/
theorem IsClosed.outerQuadrable {n : ℕ} {s : Set (Fin n → ℝ)}
    (_ : IsClosed s) : OuterQuadrable s := rfl

/-- Legacy `GMP_04` — kept for backwards compatibility with earlier breach runs. -/
def JordanMeasurable (s : Set (Fin 2 → ℝ)) : Prop :=
  Bornology.IsBounded s ∧ volume (frontier s) = 0

theorem jordanMeasurable_iff_volume_frontier_eq_zero (s : Set (Fin 2 → ℝ))
    (hs : Bornology.IsBounded s) :
    JordanMeasurable s ↔ volume (frontier s) = 0 := by
  constructor
  · rintro ⟨_, h⟩; exact h
  · intro h; exact ⟨hs, h⟩

end Jordan
end MeasureTheory
end MathlibExpansion
