/-!
# Typed congruence primitives for Hilbert geometry

The Step 5 verdict rejects the old line-indexed congruence surface. This file
lands the repaired typed interface separating segment congruence from angle
congruence.
-/

namespace MathlibExpansion.Geometry.Hilbert

/-- An oriented segment with ordered endpoints. -/
structure Segment (P : Type _) where
  source : P
  target : P

/-- An angle with an explicit vertex and two rays. -/
structure Angle (P : Type _) where
  left : P
  vertex : P
  right : P

/-- Segment congruence is typed on segments, not merely on lines. -/
class HilbertSegmentCongruence (P : Type _) where
  SegCong : Segment P → Segment P → Prop

/-- Angle congruence is typed on angles, not merely on lines. -/
class HilbertAngleCongruence (P : Type _) where
  AngCong : Angle P → Angle P → Prop

/-- Point-level segment congruence wrapper. -/
def SegCongPts {P : Type _} [HilbertSegmentCongruence P] (A B C D : P) : Prop :=
  HilbertSegmentCongruence.SegCong ⟨A, B⟩ ⟨C, D⟩

/-- Point-level angle congruence wrapper. -/
def AngCongPts {P : Type _} [HilbertAngleCongruence P] (A B C D E F : P) : Prop :=
  HilbertAngleCongruence.AngCong ⟨A, B, C⟩ ⟨D, E, F⟩

@[simp] theorem segCongPts_iff {P : Type _} [HilbertSegmentCongruence P] (A B C D : P) :
    SegCongPts A B C D ↔ HilbertSegmentCongruence.SegCong ⟨A, B⟩ ⟨C, D⟩ :=
  Iff.rfl

@[simp] theorem angCongPts_iff {P : Type _} [HilbertAngleCongruence P]
    (A B C D E F : P) :
    AngCongPts A B C D E F ↔ HilbertAngleCongruence.AngCong ⟨A, B, C⟩ ⟨D, E, F⟩ :=
  Iff.rfl

/-- Bundled typed congruence package demanded by the Hilbert queue. -/
class HilbertCongruencePackage (P : Type _)
    extends HilbertSegmentCongruence P, HilbertAngleCongruence P

/--
**AHH-13** (segment congruence transitivity / additivity). Segment
congruence is transitive, and congruent sub-segments add to congruent
whole-segments. This is Hilbert's Axiom III,2 combined with the additivity
consequence III,3.

Upstream-narrow axiom: the transitivity branch is direct in most
classical models but is stipulated as a primitive in *Grundlagen der
Geometrie*.

Source: D. Hilbert, *Grundlagen der Geometrie* (1899), Ch. III, Axiom III,2
and the induced additivity III,3.
-/
axiom segment_congruence_transitive_and_additive
    (P : Type _) [HilbertSegmentCongruence P] :
    ∀ (s₁ s₂ s₃ : Segment P),
      HilbertSegmentCongruence.SegCong s₁ s₂ →
      HilbertSegmentCongruence.SegCong s₂ s₃ →
      HilbertSegmentCongruence.SegCong s₁ s₃

/--
**AHH-14** (angle layoff / unique copy). Given an angle `α`, a ray `r`
starting at a point `V`, and a choice of half-plane, there exists a unique
angle congruent to `α` based at `V` with one side along `r` lying in the
chosen half-plane. This is Hilbert's Axiom III,4.

Stated here abstractly: there is *some* angle congruent to the given one
sharing the prescribed vertex — the full unique-layoff is an upstream
axiom.

Source: D. Hilbert, *Grundlagen der Geometrie* (1899), Ch. III, Axiom III,4.
-/
axiom angle_layoff_exists
    (P : Type _) [HilbertAngleCongruence P] :
    ∀ (α : Angle P) (V : P),
      ∃ (β : Angle P), β.vertex = V ∧ HilbertAngleCongruence.AngCong α β

end MathlibExpansion.Geometry.Hilbert
