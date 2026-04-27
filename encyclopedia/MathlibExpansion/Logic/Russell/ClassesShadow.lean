import MathlibExpansion.Logic.Frege.Functions
import MathlibExpansion.Logic.Russell.TypedNoClassShadow

/-!
# T20c_05_RCIS — Classes as incomplete symbols (W1c part 1)

Russell + Whitehead, *Principia Mathematica* (1910), Introduction Ch. III §2;
`*20`. The PM-facing class-talk routes everything through the typed no-class
shadow — `conceptSet` from `Logic/Frege/Functions.lean`. PM's `*20·01`
elimination operator `(z : φz)` is a contextual definition, NOT a term.

References:
* Russell-Whitehead 1910, PM vol. I, Introduction Ch. III §2 pp. 71-84.
* Russell-Whitehead 1910, PM vol. I, `*20·01`-`*20·43`.
-/

universe u v

namespace MathlibExpansion.Logic.Russell

open MathlibExpansion.Logic.Frege

/-- RCIS-01 (`*20·01` class elimination operator): the PM-facing class
elimination `classElim φ ψ` says "for every object `x` such that `φ x` holds,
`ψ x` holds." This is the contextual reading of `(z : φz) ⊆ (z : ψz)`. -/
def classElim {α : Type u} (φ ψ : FregeConcept α) : Prop :=
  ∀ x, φ x → ψ x

/-- RCIS-02: `classElim` agrees with `Set.Subset` between the corresponding
shadow sets. -/
theorem classElim_iff_subset {α : Type u} (φ ψ : FregeConcept α) :
    classElim φ ψ ↔ conceptSet φ ⊆ conceptSet ψ := by
  unfold classElim
  constructor
  · intro h x hx
    exact h x ((mem_conceptSet φ x).1 hx)
  · intro h x hx
    exact (mem_conceptSet ψ x).1 (h ((mem_conceptSet φ x).2 hx))

/-- RCIS-03 (`*20·02` class substitution under context): if two concepts are
extensionally equivalent, any class-elimination context built from one is
preserved under substitution. -/
theorem classContext_subst {α : Type u} {φ ψ : FregeConcept α}
    (h : ∀ x, φ x ↔ ψ x) (χ : FregeConcept α) :
    classElim φ χ ↔ classElim ψ χ := by
  unfold classElim
  refine ⟨?_, ?_⟩
  · intro hAll x hψx
    exact hAll x ((h x).2 hψx)
  · intro hAll x hφx
    exact hAll x ((h x).1 hφx)

/-- RCIS-04: classes are extensional via the no-class shadow, by direct
appeal to TNCSB. -/
theorem class_extensionality {α : Type u} (φ ψ : FregeConcept α)
    (h : ∀ x, φ x ↔ ψ x) : conceptSet φ = conceptSet ψ :=
  classContext_congr h

/-- RCIS-05: PM-facing `Type`-level wrapper for "class of classes". This is
NOT PM's class-of-classes ontology — it is the typed shadow under the
no-class discipline. The intended reading: the consumer must explicitly
mark every `Set (Set α)` mention as routed through the shadow. -/
abbrev classOfClasses_carrier (α : Type u) : Type u := Set (Set α)

/-!
QUARANTINE: RCIS-09 (PM "class membership as primitive two-place relation
without shadow discipline") and RCIS-10 (PM "class of all classes") are
intentionally NOT formalised. The shadow discipline forbids both: the
former because PM's `∈` is a contextually-defined incomplete symbol, the
latter because it would re-introduce the totality-of-classes paradox the
ramified-types layer was designed to forbid.
-/

end MathlibExpansion.Logic.Russell
