import MathlibExpansion.Logic.Russell.TypedNoClassShadow
import MathlibExpansion.Logic.Frege.SafeShadow

/-!
# T20c_05_AVQ — Apparent variables and quantification (W1a)

Russell + Whitehead, *Principia Mathematica* (1910), `*9`-`*11`. PM-facing
wrapper layer over the already-landed Frege SafeShadow carriers. PM's
"apparent variable" is what modern logic calls a bound variable; the seven
wrappers below name PM's exact inference shells.

References:
* Russell-Whitehead 1910, PM vol. I, `*9`-`*11`.
* Peano, *Formulario Mathematico* — apparent-variable term origin
  (cited PM Introduction).
-/

universe u

namespace MathlibExpansion.Logic.Russell

open MathlibExpansion.Logic.Frege

/-- AVQ-01 (`*9·1` ∀-elim): universal instantiation. PM-facing wrapper over
`fregeAllObj_elim`. -/
theorem russell_forall_elim {α : Type u} {P : FregeConcept α}
    (h : FregeAllObj P) (a : α) : P a :=
  fregeAllObj_elim h a

/-- AVQ-02 (`*9·11`): existential introduction. -/
theorem russell_exists_intro {α : Type u} (P : FregeConcept α)
    (a : α) (h : P a) : ∃ x, P x :=
  ⟨a, h⟩

/-- AVQ-03 (`*9·12`): existential elimination shell over the `FregeConcept`
carrier. The variable `x` is PM's apparent variable; we discharge it via the
hypothetical-discharge form. -/
theorem russell_exists_elim {α : Type u} {P : FregeConcept α} {q : Prop}
    (h₁ : ∃ x, P x) (h₂ : ∀ x, P x → q) : q := by
  obtain ⟨x, hx⟩ := h₁
  exact h₂ x hx

/-- AVQ-04 (`*10·11` real-variable rule): schematic instantiation at the
predicate level. Direct wrapper over `frege_forall_fun_elim`. -/
theorem russell_forall_fun_elim {α : Type u} {Φ : FregeConcept α → Prop}
    (h : ∀ F, Φ F) (G : FregeConcept α) : Φ G :=
  frege_forall_fun_elim h G

/-- AVQ-05 (`*10·12` bound-to-free): under universal instantiation a bound
variable becomes free. Capture-free shell. -/
theorem russell_bound_to_free {α : Type u} {P : FregeConcept α}
    (h : ∀ x, P x) (a : α) : P a := h a

/-- AVQ-06 (`*10·13` apparent-scope congruence): if two predicates agree
pointwise, their universal closures are equivalent. -/
theorem russell_apparent_scope_congr {α : Type u} (P Q : FregeConcept α)
    (h : ∀ x, P x ↔ Q x) : (∀ x, P x) ↔ (∀ x, Q x) := by
  refine ⟨fun hP x => (h x).1 (hP x), fun hQ x => (h x).2 (hQ x)⟩

/-- AVQ-07 (`*10·1` ∀-intro via hypothetical discharge). -/
theorem russell_all_intro {α : Type u} (P : FregeConcept α)
    (h : ∀ x, P x) : FregeAllObj P := h

/-!
QUARANTINE: AVQ-quarantine — the PM elementary-proposition carrier closure.
We do NOT identify Lean's `∀` binder with PM's apparent-variable syntax in
the ramified-syntax sense; that lives in `RamifiedTypes.lean`. The wrappers
above are presentation, not new logic.
-/

end MathlibExpansion.Logic.Russell
