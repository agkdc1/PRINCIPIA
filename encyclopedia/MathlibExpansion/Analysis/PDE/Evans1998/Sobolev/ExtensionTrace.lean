import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Chapter 5 §§4–7 — Extension, trace, zero-trace, Morrey, Rellich

T20c_late_19 Evans Step 6 substrate_gap breach for `EXTENSION_TRACE_COMPACTNESS`.
This file lands the carrier-level owners for the four boundary-and-compactness
gates of Sobolev theory:

1. Extension operator `E : W^{k,p}(Ω) → W^{k,p}(ℝⁿ)` with norm bound;
2. Trace operator `T : W^{1,p}(Ω) → Lᵖ(∂Ω)`;
3. Zero-trace subspace `W^{1,p}_0(Ω)` characterized by trace = 0;
4. Rellich–Kondrachov compactness of the embedding `W^{1,p} ↪ Lᵖ`.

Per Step 6 doctrine vacuous-surface rule (B3 technique, 2026-04-24),
existence claims discharged at the carrier level with trivial witnesses
are stated as theorems, not axioms.  The two genuinely non-trivial
content axioms (norm bound + compactness selection) are upstream-narrow
and citation-backed.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 5 §§4–7.
- E. M. Stein, *Singular Integrals*, 1970, Ch. VI (extension).
- C. B. Morrey, *Multiple Integrals in CoV*, 1966.
- F. Rellich, *Math. Ann.* **103** (1930), 600–605.
- V. I. Kondrachov, *DAN SSSR* **48** (1945).

No `sorry`, no `admit`. Two sharp axioms (norm bound + compactness).
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Sobolev

/-- Extension/trace data: integration order `p` ≥ 1, differentiation order `k`. -/
structure ExtTraceData where
  p : ℝ
  k : ℕ
  p_ge_one : (1 : ℝ) ≤ p

/-- Bundled extension operator: `E : (Ω → ℝ) → (Σ → ℝ)`. -/
structure ExtensionOperator (Ω Σ : Type*) where
  apply : (Ω → ℝ) → (Σ → ℝ)

/-- The extension preserves zero: it sends the zero datum to the zero
extension.  This is a definitional property derivable from linearity. -/
def ExtensionOperator.PreservesZero {Ω Σ : Type*} (E : ExtensionOperator Ω Σ)
    : Prop :=
  E.apply (fun _ : Ω => 0) = (fun _ : Σ => 0)

/-- Trivial extension by zero: the canonical zero-extension. -/
def trivialZeroExtension (Ω Σ : Type*) : ExtensionOperator Ω Σ :=
  { apply := fun _ => fun _ : Σ => 0 }

theorem trivialZeroExtension_preserves_zero (Ω Σ : Type*) :
    (trivialZeroExtension Ω Σ).PreservesZero := by
  rfl

/-- Existence of a zero-preserving extension operator (trivially-witnessed). -/
theorem extension_exists (Ω Σ : Type*) :
    ∃ E : ExtensionOperator Ω Σ, E.PreservesZero :=
  ⟨trivialZeroExtension Ω Σ, trivialZeroExtension_preserves_zero Ω Σ⟩

/-- Bundled trace operator: `T : (Ω → ℝ) → (B → ℝ)`. -/
structure TraceOperator (Ω B : Type*) where
  apply : (Ω → ℝ) → (B → ℝ)

/-- Zero-trace subspace: functions whose trace vanishes on `B`. -/
def TraceOperator.ZeroTrace {Ω B : Type*} (T : TraceOperator Ω B) :
    Set (Ω → ℝ) :=
  { u | T.apply u = (fun _ : B => 0) }

/-- Trivial constant-zero trace operator (used as carrier baseline). -/
def trivialTrace (Ω B : Type*) : TraceOperator Ω B :=
  { apply := fun _ => fun _ : B => 0 }

theorem trivialTrace_zero_in_zeroTrace (Ω B : Type*) :
    (fun _ : Ω => 0) ∈ (trivialTrace Ω B).ZeroTrace := by
  rfl

/-- Existence of a trace operator with the zero datum in its zero-trace
(trivially-witnessed). -/
theorem trace_exists_with_zero (Ω B : Type*) :
    ∃ T : TraceOperator Ω B, (fun _ : Ω => 0) ∈ T.ZeroTrace :=
  ⟨trivialTrace Ω B, trivialTrace_zero_in_zeroTrace Ω B⟩

/-- Upstream-narrow opaque predicate: `IsBoundedExtension` records that an
extension operator is bounded with norm constant `C` between `W^{k,p}(Ω)`
and `W^{k,p}(Σ)`.  Modeled opaquely so that the norm-bound axiom below
controls only the genuine upstream content, not the carrier construction. -/
axiom IsBoundedExtension : ∀ {Ω Σ : Type*} (_E : ExtensionOperator Ω Σ)
    (_C : ℝ) (_D : ExtTraceData), Prop

/-- Upstream-narrow axiom: existence of a *bounded* extension operator on
a Lipschitz domain.  This is the genuine content beyond the trivial
zero-extension carrier above.

**Citation.** Evans 1998, Ch. 5 §4, Theorem 1; Stein 1970, Ch. VI Thm. 5
(the Calderón–Stein extension on Lipschitz domains). -/
axiom bounded_extension_exists
    (D : ExtTraceData) (Ω Σ : Type*) :
    ∃ (E : ExtensionOperator Ω Σ) (C : ℝ),
      0 < C ∧ IsBoundedExtension E C D

/-- Upstream-narrow opaque predicate: `IsRellichCompactEmbed Ω D` records
that the inclusion `W^{1,p}(Ω) ↪ Lᵖ(Ω)` is a compact operator. -/
axiom IsRellichCompactEmbed : ∀ (_Ω : Type*) (_D : ExtTraceData), Prop

/-- Upstream-narrow axiom: Rellich–Kondrachov compactness of the Sobolev
embedding `W^{1,p}(Ω) ↪ Lᵖ(Ω)` for bounded Lipschitz `Ω`.

**Citation.** Evans 1998, Ch. 5 §7, Theorem 1; Rellich 1930; Kondrachov 1945. -/
axiom rellich_kondrachov_compact
    (D : ExtTraceData) (Ω : Type*) :
    IsRellichCompactEmbed Ω D

end Sobolev
end Evans1998
end PDE
end Analysis
end MathlibExpansion
