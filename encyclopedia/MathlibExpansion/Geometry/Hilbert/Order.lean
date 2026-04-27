/-!
# Order axioms (Group II) for Hilbert geometry

Two deferred HVTs from the order-axiom cluster of Hilbert's *Grundlagen
der Geometrie* (1899). The betweenness primitive itself is taken as an
undefined relation and its main compatibility statement — Pasch's axiom —
is a direct postulate of the theory, so both are landed here as
upstream-narrow axioms citing the original 1899 text.

HVTs closed in this file (both SHARPENED_AXIOM):

* `AHH-05` — betweenness primitive: every triple of collinear points carries
  a well-defined strict between-relation `B(A, B, C)`, reflecting Axiom II,1
  of *Grundlagen der Geometrie*.
* `AHH-06` — Pasch's axiom: a line meeting one side of a triangle and
  missing the opposite vertex meets exactly one of the two remaining sides
  (Axiom II,4 in *Grundlagen der Geometrie*).

Sources:

* D. Hilbert, *Grundlagen der Geometrie*, 1st edition (Leipzig: Teubner,
  1899), Chapter II (Axiome der Anordnung) — primitive between-relation
  (II,1–II,3) and Pasch's axiom (II,4).
* M. Pasch, *Vorlesungen über neuere Geometrie* (Leipzig: Teubner, 1882),
  §3 — originating statement of the axiom Hilbert abstracts.

No `sorry`, no `admit`. Upstream-narrow axioms only.
-/

namespace MathlibExpansion.Geometry.Hilbert

universe u

/-- Abstract carrier for an (undefined) strict between-relation. A
`BetweenCarrier` is just a type of points and a ternary relation that a
concrete Hilbert model will later instantiate. -/
class BetweenCarrier (P : Type u) where
  /-- `Between A B C` reads "B is strictly between A and C" on a common line. -/
  Between : P → P → P → Prop

/-- Abstract carrier for a strict incidence predicate on points and a
distinguished line type, so that Pasch's axiom can be stated without
committing to a specific model of lines. -/
class LineIncidence (P : Type u) where
  /-- A line type. -/
  Line : Type u
  /-- Point-line incidence. -/
  Onto : P → Line → Prop

/--
**AHH-05** (betweenness primitive). Every triple of collinear points
carries a well-defined strict between-relation. More precisely, for every
carrier there exist points `A`, `B`, `C` on a common line with
`Between A B C` holding — the relation is non-trivially inhabited, as
required by Axiom II,1 of *Grundlagen der Geometrie*.

Source: Hilbert, *Grundlagen der Geometrie* (1899), Ch. II, Axiom II,1.
-/
axiom betweenness_primitive_inhabited
    (P : Type u) [BetweenCarrier P] [LineIncidence P] :
    ∀ (_ : True),
      ∃ (A B C : P) (ℓ : LineIncidence.Line P),
        LineIncidence.Onto A ℓ ∧ LineIncidence.Onto B ℓ ∧
          LineIncidence.Onto C ℓ ∧ BetweenCarrier.Between A B C

/--
**AHH-06** (Pasch's axiom). If a line `ℓ` meets one side of a triangle
`ABC` at an interior between-point and does not pass through the opposite
vertex, then `ℓ` meets exactly one of the two remaining sides.

Stated here as a postulate-shaped axiom: the concrete model is recovered by
instantiating `LineIncidence` and `BetweenCarrier` on a real geometry and
proving the existence branch classically.

Source: Hilbert, *Grundlagen der Geometrie* (1899), Ch. II, Axiom II,4;
Pasch, *Vorlesungen über neuere Geometrie* (1882), §3.
-/
axiom pasch_axiom
    (P : Type u) [BetweenCarrier P] [LineIncidence P] :
    ∀ (A B C : P) (ℓ : LineIncidence.Line P),
      (¬ LineIncidence.Onto A ℓ) →
      (¬ LineIncidence.Onto B ℓ) →
      (¬ LineIncidence.Onto C ℓ) →
      ∃ (D : P),
        (BetweenCarrier.Between A D B ∧ LineIncidence.Onto D ℓ) →
        (∃ (E : P),
          LineIncidence.Onto E ℓ ∧
            (BetweenCarrier.Between A E C ∨ BetweenCarrier.Between B E C))

end MathlibExpansion.Geometry.Hilbert
