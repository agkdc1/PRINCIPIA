import MathlibExpansion.SetTheory.Cantor.PowerSet

/-!
# Deferred theorem-35 wrappers

These rows were explicitly deferred by the Step 5 verdict because the reusable
mathematics already exists locally under `MathlibExpansion.SetTheory.Cantor`.
The axioms below are intentionally narrow historical wrappers so the chapter
ledger has exact theorem-`35` placeholders without reopening the landed Cantor
owner file.
-/

namespace MathlibExpansion.SetTheory.Zermelo

universe u

/-- Zermelo `1908`, *Untersuchungen über die Grundlagen der Mengenlehre. I*,
Theorem `35`, pp. `279`-`280`: the powerset of `S` is equivalent to the
binary-choice product space used in the second proof of Cantor's theorem. -/
theorem theorem35_powersetEquivBoolCoverings {α : Type u} (S : Set α) :
    Nonempty (𝒫 S ≃ Set.pi (Set.univ : Set S) (fun _ => (Set.univ : Set Bool))) := by
  exact ⟨MathlibExpansion.SetTheory.Cantor.powersetEquivBoolCoverings S⟩

/-- Zermelo `1908`, *Untersuchungen über die Grundlagen der Mengenlehre. I*,
Theorem `35`, pp. `279`-`280`: the cardinality of the powerset agrees with the
binary-choice product space from the theorem-`35` proof architecture. -/
theorem theorem35_mk_powerset_eq_boolCoverings {α : Type u} (S : Set α) :
    Cardinal.mk ↥(𝒫 S) = Cardinal.mk (Set.pi (Set.univ : Set S) (fun _ => (Set.univ : Set Bool))) := by
  exact MathlibExpansion.SetTheory.Cantor.mk_powerset_eq_boolCoverings S

end MathlibExpansion.SetTheory.Zermelo
