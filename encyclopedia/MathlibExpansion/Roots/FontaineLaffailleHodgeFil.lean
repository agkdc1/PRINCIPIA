import MathlibExpansion.Roots.FontaineLaffaille

/-!
# R8.3 — Native Hodge filtration for low-weight Fontaine-Laffaille modules

Real definitions and sorry-free theorems for the Hodge filtration in the
low-weight (weights `{0, 1}`) Fontaine-Laffaille setting over Witt vectors
`W(k)`.

In the FLT elliptic-curve context, FL modules have Hodge weights in `{0, 1}`,
forcing the filtration shape:

```
M = Fil⁰ ⊇ Fil¹ ⊇ Fil² = 0
```

The two axioms `fil_zero_eq_top` (`Fil 0 = ⊤`) and `fil_two_eq_bot`
(`Fil 2 = ⊥`), together with antitonicity, suffice to prove:
- Exhaustiveness: `∀ x, ∃ i, x ∈ Fil i` (and the `iSup` form `⨆ i, Fil i = ⊤`)
- Separatedness: `∀ x, (∀ i, x ∈ Fil i) → x = 0` (and `⨅ i, Fil i = ⊥`)
- Monotone extensions: `Fil i = ⊤` for `i ≤ 0`, `Fil i = ⊥` for `i ≥ 2`

No `False`-gated boundary primitive is used in this file.
-/

namespace MathlibExpansion
namespace Roots
namespace FontaineLaffaille

universe u v w

/-! ### R8.3: The `LowWeightHodgeFiltration` structure -/

/-- A low-weight Hodge filtration of a `W(k)`-module.

This is a standalone, `False`-free structure encoding the Hodge filtration for
a Fontaine-Laffaille module with Hodge weights in `{0, 1}`.  The two key
axioms — `fil_zero_eq_top` and `fil_two_eq_bot` — together with antitonicity
fully determine the filtration outside degree `1`:

```
…  Fil⁻¹ = Fil⁰ = M ⊇ Fil¹ ⊇ Fil² = Fil³ = … = 0
```

All theorems in the `LowWeightHodgeFiltration` namespace are sorry-free. -/
structure LowWeightHodgeFiltration
    (p : ℕ) [Fact p.Prime] (k : Type u) [CommRing k] where
  /-- The underlying `W(k)`-module carrier type. -/
  M : Type v
  instAddCommGroup : AddCommGroup M
  instModule : Module (WittVector p k) M
  /-- The decreasing Hodge filtration by `W(k)`-submodules. -/
  Fil : ℤ → Submodule (WittVector p k) M
  /-- The filtration is antitone: `i ≤ j → Fil j ≤ Fil i`. -/
  fil_antitone : Antitone Fil
  /-- `Fil⁰ = M`: the zeroth filtration piece is the whole module.
  Encodes the low-weight condition: all Hodge weights are `≥ 0`. -/
  fil_zero_eq_top : Fil 0 = ⊤
  /-- `Fil² = 0`: the filtration vanishes at degree 2.
  Encodes the low-weight condition: all Hodge weights are `≤ 1`. -/
  fil_two_eq_bot : Fil 2 = ⊥

attribute [instance] LowWeightHodgeFiltration.instAddCommGroup
attribute [instance] LowWeightHodgeFiltration.instModule

namespace LowWeightHodgeFiltration

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]

/-! ### Monotone extensions of the two boundary axioms -/

/-- The filtration equals `⊤` at all non-positive degrees. -/
theorem fil_nonpos_eq_top (H : LowWeightHodgeFiltration p k)
    {i : ℤ} (hi : i ≤ 0) : H.Fil i = ⊤ := by
  apply le_antisymm le_top
  calc ⊤ = H.Fil 0 := H.fil_zero_eq_top.symm
    _ ≤ H.Fil i    := H.fil_antitone hi

/-- The filtration equals `⊥` at all degrees `≥ 2`. -/
theorem fil_two_le_eq_bot (H : LowWeightHodgeFiltration p k)
    {i : ℤ} (hi : 2 ≤ i) : H.Fil i = ⊥ := by
  apply le_antisymm _ bot_le
  calc H.Fil i ≤ H.Fil 2 := H.fil_antitone hi
    _ = ⊥               := H.fil_two_eq_bot

/-- `Fil¹ ≤ Fil⁰`. -/
theorem fil_one_le_fil_zero (H : LowWeightHodgeFiltration p k) :
    H.Fil 1 ≤ H.Fil 0 :=
  H.fil_antitone (by norm_num)

/-- `Fil² ≤ Fil¹`. -/
theorem fil_two_le_fil_one (H : LowWeightHodgeFiltration p k) :
    H.Fil 2 ≤ H.Fil 1 :=
  H.fil_antitone (by norm_num)

/-- `Fil⁰ = ⊤`: simp-tagged alias. -/
@[simp]
theorem fil_zero_top (H : LowWeightHodgeFiltration p k) : H.Fil 0 = ⊤ :=
  H.fil_zero_eq_top

/-- `Fil² = ⊥`: simp-tagged alias. -/
@[simp]
theorem fil_two_bot (H : LowWeightHodgeFiltration p k) : H.Fil 2 = ⊥ :=
  H.fil_two_eq_bot

/-- The filtration at non-positive degrees agrees with `Fil 0`. -/
theorem fil_nonpos_eq_fil_zero (H : LowWeightHodgeFiltration p k)
    {i : ℤ} (hi : i ≤ 0) : H.Fil i = H.Fil 0 :=
  (H.fil_nonpos_eq_top hi).trans H.fil_zero_eq_top.symm

/-- The filtration at degrees `≥ 2` agrees with `Fil 2`. -/
theorem fil_two_le_eq_fil_two (H : LowWeightHodgeFiltration p k)
    {i : ℤ} (hi : 2 ≤ i) : H.Fil i = H.Fil 2 :=
  (H.fil_two_le_eq_bot hi).trans H.fil_two_eq_bot.symm

/-! ### Exhaustiveness -/

/-- Every element lies in `Fil 0 = M`. -/
theorem mem_fil_zero (H : LowWeightHodgeFiltration p k) (x : H.M) :
    x ∈ H.Fil 0 := by
  rw [H.fil_zero_eq_top]; exact Submodule.mem_top

/-- Every element lies in `Fil i` for all `i ≤ 0`. -/
theorem mem_fil_nonpos (H : LowWeightHodgeFiltration p k)
    {i : ℤ} (hi : i ≤ 0) (x : H.M) : x ∈ H.Fil i := by
  rw [H.fil_nonpos_eq_top hi]; exact Submodule.mem_top

/-- The filtration is exhaustive: every element lies in some `Fil i`.
Witnessed by `i = 0` via `Fil 0 = ⊤`. -/
theorem exhaustive (H : LowWeightHodgeFiltration p k) (x : H.M) :
    ∃ i : ℤ, x ∈ H.Fil i :=
  ⟨0, H.mem_fil_zero x⟩

/-- Exhaustiveness in `iSup` form: `⨆ i : ℤ, Fil i = ⊤`. -/
theorem iSup_fil_eq_top (H : LowWeightHodgeFiltration p k) :
    ⨆ i : ℤ, H.Fil i = ⊤ := by
  apply le_antisymm le_top
  calc ⊤ = H.Fil 0        := H.fil_zero_eq_top.symm
    _ ≤ ⨆ i : ℤ, H.Fil i := le_iSup H.Fil 0

/-! ### Separatedness -/

/-- `x ∈ Fil 2` iff `x = 0`. -/
theorem mem_fil_two_iff_zero (H : LowWeightHodgeFiltration p k) (x : H.M) :
    x ∈ H.Fil 2 ↔ x = 0 := by
  rw [H.fil_two_eq_bot]
  simp

/-- The filtration is separated: if `x ∈ Fil i` for all `i`, then `x = 0`.
Witnessed by `Fil 2 = ⊥`. -/
theorem separated (H : LowWeightHodgeFiltration p k) {x : H.M}
    (hx : ∀ i : ℤ, x ∈ H.Fil i) : x = 0 :=
  (H.mem_fil_two_iff_zero x).mp (hx 2)

/-- Separatedness in `iInf` form: `⨅ i : ℤ, Fil i = ⊥`. -/
theorem iInf_fil_eq_bot (H : LowWeightHodgeFiltration p k) :
    ⨅ i : ℤ, H.Fil i = ⊥ := by
  apply le_antisymm _ bot_le
  calc ⨅ i : ℤ, H.Fil i ≤ H.Fil 2 := iInf_le H.Fil 2
    _ = ⊥                           := H.fil_two_eq_bot

/-! ### The two-step filtration picture -/

/-- For every integer `i`, `Fil i` is one of `⊤`, `Fil 1`, or `⊥`. -/
theorem fil_determined (H : LowWeightHodgeFiltration p k) (i : ℤ) :
    H.Fil i = ⊤ ∨ H.Fil i = H.Fil 1 ∨ H.Fil i = ⊥ := by
  rcases le_or_lt i 0 with hi0 | hi0
  · exact Or.inl (H.fil_nonpos_eq_top hi0)
  · rcases le_or_lt 2 i with hi2 | hi2
    · exact Or.inr (Or.inr (H.fil_two_le_eq_bot hi2))
    · have heq : i = 1 := by omega
      exact Or.inr (Or.inl (congrArg H.Fil heq))

/-- `Fil 1` lies between `⊥` and `⊤`. -/
theorem bot_le_fil_one_le_top (H : LowWeightHodgeFiltration p k) :
    ⊥ ≤ H.Fil 1 ∧ H.Fil 1 ≤ ⊤ :=
  ⟨bot_le, le_top⟩

/-- `Fil 1` is sandwiched: `Fil 2 ≤ Fil 1 ≤ Fil 0`. -/
theorem fil_one_sandwich (H : LowWeightHodgeFiltration p k) :
    H.Fil 2 ≤ H.Fil 1 ∧ H.Fil 1 ≤ H.Fil 0 :=
  ⟨H.fil_two_le_fil_one, H.fil_one_le_fil_zero⟩

/-- The filtration is eventually `⊤` (at and below degree 0). -/
theorem fil_eventually_top (H : LowWeightHodgeFiltration p k) :
    ∀ i : ℤ, i ≤ 0 → H.Fil i = ⊤ :=
  fun _i hi => H.fil_nonpos_eq_top hi

/-- The filtration is eventually `⊥` (at and above degree 2). -/
theorem fil_eventually_bot (H : LowWeightHodgeFiltration p k) :
    ∀ i : ℤ, 2 ≤ i → H.Fil i = ⊥ :=
  fun _i hi => H.fil_two_le_eq_bot hi

end LowWeightHodgeFiltration

/-! ### #check witnesses for R8.3 deliverables -/

-- Exhaustive filtration
#check @LowWeightHodgeFiltration.exhaustive
#check @LowWeightHodgeFiltration.iSup_fil_eq_top
#check @LowWeightHodgeFiltration.mem_fil_zero

-- Separated filtration
#check @LowWeightHodgeFiltration.separated
#check @LowWeightHodgeFiltration.iInf_fil_eq_bot
#check @LowWeightHodgeFiltration.mem_fil_two_iff_zero

-- Fil^0 = M
#check @LowWeightHodgeFiltration.fil_zero_top
#check @LowWeightHodgeFiltration.fil_nonpos_eq_top

-- Fil^2 = 0
#check @LowWeightHodgeFiltration.fil_two_bot
#check @LowWeightHodgeFiltration.fil_two_le_eq_bot

-- Two-step filtration picture
#check @LowWeightHodgeFiltration.fil_determined
#check @LowWeightHodgeFiltration.fil_one_sandwich
#check @LowWeightHodgeFiltration.fil_eventually_top
#check @LowWeightHodgeFiltration.fil_eventually_bot


end FontaineLaffaille
end Roots
end MathlibExpansion
