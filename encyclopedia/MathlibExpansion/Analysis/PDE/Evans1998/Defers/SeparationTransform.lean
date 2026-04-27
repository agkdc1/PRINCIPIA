import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 4 §§1–3 + §5 — Separation, transform, similarity methods (DEFER)

T20c_late_19 Evans Step 6 DEFER row for `SEPARATION_TRANSFORM_SIMILARITY`.

Per Step 5 verdict (Codex Round 1) and ratified by Claude:

> This row is mostly downstream packaging over already-separate Fourier
> / heat / Laplace owners and does not justify first-wave budget.

Therefore this file does not attempt the breach.  Instead it files a
single sharp upstream-narrow axiom recording the citation pointer for
the future queue candidate, per Commander directive (2026-04-22):

> If you can't identify the modern upstream for a DEFERRED HVT: look
> into the textbook's own citations.  Name the exact cited work in the
> axiom doc string.  It becomes a future queue candidate.  NO vague
> DEFERRED — citation-backed only.

**Cited works (from Evans 1998 Ch. 4 §§1–3, 5).**
- J. B. J. Fourier, *Théorie analytique de la chaleur*, Paris, 1822
  (separation of variables; transform method).
- L. Schwartz, *Théorie des distributions* I & II, 1950–51 (Fourier
  transform on tempered distributions).
- G. I. Barenblatt, *Similarity, Self-Similarity, and Intermediate
  Asymptotics*, 1979 (similarity / scaling methods).
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 4 §§1–3 (separation,
  Fourier transform, Laplace transform), §5 (similarity solutions).

**Future queue.** This row should be re-fired only after Fourier
representation, distribution theory, and self-similar scaling owners
have been honestly landed by their primary textbook queues
(`T19c_04 Fourier`, etc.); collapsing them under Evans wrappers is
explicitly counter-productive (Codex Round 1, ratified by Claude).

No `sorry`, no `admit`. One sharp upstream axiom (citation pointer).
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Defers

/-- Carrier for the DEFER queue pointer.  Records that the topic has been
identified, scoped, and routed back to the upstream Fourier / Schwartz /
Barenblatt queues for a future cycle. -/
structure SeparationTransformDeferPointer where
  topic_key            : String
  upstream_fourier     : String
  upstream_schwartz    : String
  upstream_barenblatt  : String
  evans_anchor         : String

/-- Concrete pointer instance recording the four upstream citations. -/
def separationTransformDefer : SeparationTransformDeferPointer :=
  { topic_key           := "T20c_late_19_SEPARATION_TRANSFORM_SIMILARITY"
    upstream_fourier    :=
      "Fourier 1822, Théorie analytique de la chaleur"
    upstream_schwartz   :=
      "Schwartz 1950–51, Théorie des distributions I+II"
    upstream_barenblatt :=
      "Barenblatt 1979, Similarity, Self-Similarity, Intermediate Asymptotics"
    evans_anchor        := "Evans 1998, Ch. 4 §§1–3 + §5" }

/-- Opaque predicate: `IsDeferredToUpstream P` records that the DEFER
pointer is registered as the canonical upstream-routing fact for this
topic.  Used by the encyclopedia DB to mark the row as routed without
forcing a phantom theorem-owner landing. -/
axiom IsDeferredToUpstream : SeparationTransformDeferPointer → Prop

/-- Upstream-narrow citation-backed DEFER axiom for
`SEPARATION_TRANSFORM_SIMILARITY`.  This is the explicit replacement for
a vague "DEFERRED" row, per Commander 2026-04-22 directive: the four
named upstream works are the future queue candidates.

**Citations** (re-stated for searchability):
- Fourier 1822;  Schwartz 1950–51;  Barenblatt 1979;  Evans 1998 Ch. 4. -/
axiom separation_transform_deferred_to_upstream :
    IsDeferredToUpstream separationTransformDefer

end Defers
end Evans1998
end PDE
end Analysis
end MathlibExpansion
