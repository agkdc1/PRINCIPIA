import MathlibExpansion.Logic.Russell.RelationDomain

/-!
# T20c_05_AR — Ancestral relation (W5 part 1)

Russell + Whitehead, *Principia Mathematica* (1910), `*90`-`*97`. The
"ancestral" `R*` of a relation `R` is the smallest reflexive-transitive
relation containing `R`. PM's introduction of induction proper happens
here.

References:
* Russell-Whitehead 1910, PM vol. I, `*90·01`-`*90·17`.
* Frege 1879, *Begriffsschrift* §29 (originator of the ancestral).
* Russell 1903, *The Principles of Mathematics* §245.
-/

universe u v

namespace MathlibExpansion.Foundations.Relations

open MathlibExpansion.Logic.Frege
open MathlibExpansion.Logic.Russell
open MathlibExpansion.Logic.Russell

/-- AR-01 (`*90·01·001` `russell_hereditary`): a class `A` is `R`-hereditary
when it is closed under `R`-image. -/
def russell_hereditary {α : Type u} (R : FregeRelation α α) (A : α → Prop) : Prop :=
  ∀ x y, A x → R x y → A y

/-- AR-02 (`*90·01` `russell_ancestral`): the ancestral `R*` is the
intersection of all `R`-hereditary classes containing `x` — i.e., `R* x y`
iff every `R`-hereditary class through `x` also contains `y`. -/
def russell_ancestral {α : Type u} (R : FregeRelation α α) : FregeRelation α α :=
  fun x y => ∀ A : α → Prop, A x → russell_hereditary R A → A y

/-- AR-03 (`*90·11` reflexivity of ancestral): every `x` is ancestrally
related to itself. -/
@[simp] theorem russell_ancestral_refl {α : Type u} (R : FregeRelation α α) (x : α) :
    russell_ancestral R x x := fun _ hAx _ => hAx

/-- AR-04 (`*90·121` containment of `R` in `R*`). -/
theorem russell_ancestral_of_base {α : Type u} {R : FregeRelation α α}
    {x y : α} (hR : R x y) : russell_ancestral R x y := by
  intro A hAx hHerA
  exact hHerA x y hAx hR

/-- AR-05 (`*90·14` transitivity of ancestral). -/
theorem russell_ancestral_trans {α : Type u} {R : FregeRelation α α}
    {x y z : α} (hxy : russell_ancestral R x y) (hyz : russell_ancestral R y z) :
    russell_ancestral R x z := by
  intro A hAx hHerA
  exact hyz A (hxy A hAx hHerA) hHerA

/-- AR-06 (`*90·112` ancestral step from base): if `R* x y` and `R y z`,
then `R* x z`. -/
theorem russell_ancestral_step {α : Type u} {R : FregeRelation α α}
    {x y z : α} (hxy : russell_ancestral R x y) (hyz : R y z) :
    russell_ancestral R x z :=
  russell_ancestral_trans hxy (russell_ancestral_of_base hyz)

/-- AR-07 (`*90·17` induction principle for ancestral): if `A` contains `x`
and is `R`-hereditary, then `A` contains every `R*`-descendant of `x`. -/
theorem russell_ancestral_induction {α : Type u} (R : FregeRelation α α)
    {A : α → Prop} (x : α) (hAx : A x) (hHerA : russell_hereditary R A) :
    ∀ y, russell_ancestral R x y → A y := fun y h => h A hAx hHerA

/-- AR-08 (`*90·18` ancestral monotonicity): if `R ⊆ S`, then `R* ⊆ S*`. -/
theorem russell_ancestral_mono {α : Type u} {R S : FregeRelation α α}
    (h : ∀ x y, R x y → S x y) {x y : α} (hxy : russell_ancestral R x y) :
    russell_ancestral S x y := by
  intro A hAx hHerS
  exact hxy A hAx (fun u v hAu hRuv => hHerS u v hAu (h u v hRuv))

/-- AR-09 (HARD NOVEL `russell_ancestral_idempotent`): the ancestral of the
ancestral is the ancestral itself; iterating the construction adds nothing. -/
theorem russell_ancestral_idempotent {α : Type u} (R : FregeRelation α α)
    (x y : α) :
    russell_ancestral (russell_ancestral R) x y ↔ russell_ancestral R x y := by
  constructor
  · intro h
    refine h (fun u => russell_ancestral R x u) (russell_ancestral_refl R x) ?_
    intro u v hRu hRuv
    exact russell_ancestral_trans hRu hRuv
  · intro hxy
    exact russell_ancestral_of_base hxy

/-- AR-10 (`*90·31` `R*` is itself `R`-hereditary in the second slot). -/
theorem russell_ancestral_hereditary_right {α : Type u} (R : FregeRelation α α)
    (x : α) :
    russell_hereditary R (russell_ancestral R x) := by
  intro y z hxy hRyz
  exact russell_ancestral_step hxy hRyz

/-- AR-11 (`*90·41` ancestral via converse): the converse of the ancestral
of `R` equals the ancestral of the converse of `R`. -/
theorem russell_ancestral_converse {α : Type u} (R : FregeRelation α α)
    (x y : α) :
    russell_ancestral (russell_converse R) y x ↔
      russell_ancestral R x y := by
  constructor
  · intro h
    refine h (fun u => russell_ancestral R u y) (russell_ancestral_refl R y) ?_
    intro u v hAu hRuv
    exact russell_ancestral_trans (russell_ancestral_of_base hRuv) hAu
  · intro h
    refine h (fun u => russell_ancestral (russell_converse R) u x)
      (russell_ancestral_refl (russell_converse R) x) ?_
    intro u v hAu hRuv
    have hRvu : russell_converse R v u := hRuv
    exact russell_ancestral_trans (russell_ancestral_of_base hRvu) hAu

end MathlibExpansion.Foundations.Relations
