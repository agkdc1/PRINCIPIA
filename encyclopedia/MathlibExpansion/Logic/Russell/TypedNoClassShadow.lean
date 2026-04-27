import MathlibExpansion.Logic.Frege.Functions

/-!
# T20c_05_TNCSB — Typed no-class shadow bridge (F1)

Russell + Whitehead, *Principia Mathematica* (1910), Introduction Ch. III §2 and
`*20·01`-`*20·43`. This file is the foundational gating wrapper: every
downstream Russell-facing topic routes class-talk through `conceptSet`. The only
extensional substrate consumed is `lean/MathlibExpansion/Logic/Frege/Functions.lean`
(`conceptSet`) and `Mathlib/Data/Set/Defs.lean` (`Set.ext`).

Doctrine: `Set α` IS NOT PM class ontology. PM classes are incomplete symbols
eliminated through the contextual definition of `*20·01`. The wrappers below
expose only the extensional behaviour PM does admit (context congruence and
equality-by-membership) and DO NOT introduce any new set-theoretic content.
-/

universe u

namespace MathlibExpansion.Logic.Russell

open MathlibExpansion.Logic.Frege

/-- TNCSB_01 (Russell-facing context congruence): if two Frege concepts are
extensionally equivalent at every object, the shadow class context is
substitutable. -/
theorem classContext_congr {α : Type u} {F G : FregeConcept α}
    (h : ∀ x, F x ↔ G x) : conceptSet F = conceptSet G := by
  apply Set.ext
  intro x
  rw [mem_conceptSet, mem_conceptSet]
  exact h x

/-- TNCSB_02 (Russell-facing equality by membership): formal extensional
equivalence of class-shadow predicates collapses to set equality, mirroring
the `*20·43` extensionality direction. -/
theorem conceptSet_eq_iff {α : Type u} (F G : FregeConcept α) :
    conceptSet F = conceptSet G ↔ ∀ x, F x ↔ G x := by
  constructor
  · intro hEq x
    have hMem : x ∈ conceptSet F ↔ x ∈ conceptSet G := by rw [hEq]
    rw [mem_conceptSet, mem_conceptSet] at hMem
    exact hMem
  · intro h
    exact classContext_congr h

/-- TNCSB_03: membership shadow is exactly the underlying concept application,
the gating step required by every downstream class-quantifier wrapper. -/
@[simp] theorem russell_class_mem {α : Type u} (F : FregeConcept α) (x : α) :
    x ∈ conceptSet F ↔ F x := mem_conceptSet F x

end MathlibExpansion.Logic.Russell
