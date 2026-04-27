/-
T20c_late_16 Kato 1966 — DEFER row (cite-upstream).

1 DEFER topic — sharp upstream-narrow `axiom : True` per Doctrine v3 §4
("file sharp upstream-narrow axiom + citation-backed doc string"):

  BARS — Banach-algebra resolvent and spectrum (Ch. III §6).
  Status: fully COVERED upstream in `Mathlib/Analysis/Normed/Algebra/Spectrum.lean`.
  Hard boundary: this is the Banach-algebra spectrum side, NOT closed-operator or
  unbounded-spectral theory. The defer axiom marks the cite-upstream relationship
  for completeness of the Step 6 inventory.

QUARANTINE (no axiom row, header doc only):
  PLACEHOLDER_POISON_Q — covers two local poison files
    1. `SelfAdjointExtensions.lean` — `carrier := PUnit`, `deficiency_indices := True`,
       `extension_exists := True` — theorem-shape boundary, not operator theory.
    2. `BoundedSelfAdjoint.lean` — `proj := fun _ => 0`, `reconstructs := True` —
       vacuous spectral placeholder. Downstream `TraceClass.lean` and
       `JointMeasurement.lean` inherit the weakness.
  These are quarantined at the topic level and must be replaced by honest carriers
  (UHOC, SFBSR) before downstream Step 7 attempts can build on real foundations.
  No Lean axiom row written for the quarantine.

Citations: Kato 1966 *Perturbation Theory for Linear Operators* Ch. III §6;
S. Banach 1932 *Théorie des opérations linéaires* Monografje Mat. (substrate);
I. M. Gelfand 1941 *Normierte Ringe* Mat. Sbornik 9 (Banach-algebra spectrum
foundations adjacent to the BARS topic).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_16

/-- BARS (DEFER) — Kato 1966 Ch. III §6.
    Banach-algebra resolvent and spectrum. Fully COVERED upstream in
    `Mathlib/Analysis/Normed/Algebra/Spectrum.lean` — the local axiom row exists
    only as a sharp citation marker per Doctrine v3 §4.
    Hard boundary: this is the Banach-algebra spectrum side, NOT closed-operator
    or unbounded-spectral theory (those live in UHOC / GRC / SFBSR).
    Citation: Kato 1966 Ch. III §6; I. M. Gelfand 1941 *Normierte Ringe*
    Mat. Sbornik 9; upstream owner `Mathlib/Analysis/Normed/Algebra/Spectrum.lean`. -/
axiom t20c_late_16_bars_defer_cite_upstream : True

end MathlibExpansion.Encyclopedia.T20c_late_16
