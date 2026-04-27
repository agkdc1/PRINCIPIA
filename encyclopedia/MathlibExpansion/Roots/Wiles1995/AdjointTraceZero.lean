import Mathlib

/-!
# Wiles1995 — Trace-zero adjoint substrate (ad⁰)

For a residual datum `ρ̄ : G → GL₂(k)`, Wiles' Selmer / cotangent
arguments are stated on the **trace-zero** summand of the adjoint
representation `ad ρ̄ = End_k (k²)`:

  ad⁰ ρ̄ := ker (trace : End_k (k²) → k)

This file provides that substrate as a typed carrier independent of any
specific `Representation` packaging, so downstream Wiles 1995 files can
use it without dragging `ContinuousGaloisCohomology` along. The adjoint
action on `Module.End k (Fin 2 → k)` preserves the trace (well-known
algebraic fact: `trace (P ∘ φ ∘ P⁻¹) = trace φ`), so `ad⁰` is a genuine
sub-representation of `ad`.

**Axioms introduced by this file**: 0.

The poison-class avoidance here is structural: everything is stated on
`Module.End k (Fin 2 → k)` plus `LinearMap.trace`, which live in
pure Mathlib. No import of `Roots.ContinuousGaloisCohomology` anywhere.
-/

namespace MathlibExpansion.Roots.Wiles1995

universe u

open Module LinearMap

variable (k : Type u) [Field k]

/-- **Trace-zero endomorphisms of `k²`** — the carrier of `ad⁰ ρ̄`.

A subtype of `Module.End k (Fin 2 → k)` cut out by
`LinearMap.trace k (Fin 2 → k) = 0`. This is the `2`-dimensional
adjoint minus its `1`-dimensional scalar summand. -/
def TraceZeroEnd : Type u :=
  { φ : Module.End k (Fin 2 → k) //
      LinearMap.trace k (Fin 2 → k) φ = 0 }

namespace TraceZeroEnd

variable {k}

instance : Zero (TraceZeroEnd k) :=
  ⟨⟨0, by simp⟩⟩

instance : Add (TraceZeroEnd k) :=
  ⟨fun a b => ⟨a.1 + b.1, by
    have : LinearMap.trace k (Fin 2 → k) (a.1 + b.1) = 0 := by
      rw [map_add]; simp [a.2, b.2]
    simpa using this⟩⟩

instance : Neg (TraceZeroEnd k) :=
  ⟨fun a => ⟨-a.1, by
    have : LinearMap.trace k (Fin 2 → k) (-a.1) = 0 := by
      rw [map_neg]; simp [a.2]
    simpa using this⟩⟩

instance : SMul k (TraceZeroEnd k) :=
  ⟨fun c a => ⟨c • a.1, by
    have : LinearMap.trace k (Fin 2 → k) (c • a.1) = 0 := by
      rw [map_smul]; simp [a.2]
    simpa using this⟩⟩

/-- Extract the underlying endomorphism. -/
def toEnd (a : TraceZeroEnd k) : Module.End k (Fin 2 → k) := a.1

/-- The trace of a trace-zero endomorphism is zero. -/
theorem trace_eq_zero (a : TraceZeroEnd k) :
    LinearMap.trace k (Fin 2 → k) a.1 = 0 := a.2

end TraceZeroEnd

/-- **Conjugation by an invertible 2×2 matrix preserves trace-zero.**

If `φ ∈ ad⁰` (i.e. `trace φ = 0`) and `P : GL₂(k)`, then
`P · φ · P⁻¹` still has trace zero. This is the key stability fact
making `ad⁰` a sub-representation of `ad` under the Galois action.

Proof by cyclicity of trace: `trace (P · φ · P⁻¹) = trace (P⁻¹ · P · φ)
= trace φ`. We use `LinearMap.trace_mul_comm` and the fact
`P.symm ∘ₗ P = id`. -/
theorem traceZero_stable_conj {k : Type u} [Field k]
    (P : (Fin 2 → k) ≃ₗ[k] (Fin 2 → k))
    (φ : Module.End k (Fin 2 → k))
    (hφ : LinearMap.trace k (Fin 2 → k) φ = 0) :
    LinearMap.trace k (Fin 2 → k)
        ((P.toLinearMap).comp (φ.comp P.symm.toLinearMap)) = 0 := by
  -- Step 1: rewrite `P ∘ₗ (φ ∘ₗ P.symm)` as `(P ∘ₗ φ) ∘ₗ P.symm` then
  -- apply cyclicity to move `P.symm` to the front.
  have h1 : (P.toLinearMap).comp (φ.comp P.symm.toLinearMap)
      = (P.toLinearMap.comp φ) * P.symm.toLinearMap := by
    ext x; simp [LinearMap.mul_apply]
  -- Step 2: cyclicity — `trace (A * B) = trace (B * A)`.
  have h2 : LinearMap.trace k (Fin 2 → k)
              ((P.toLinearMap.comp φ) * P.symm.toLinearMap)
          = LinearMap.trace k (Fin 2 → k)
              (P.symm.toLinearMap * (P.toLinearMap.comp φ)) :=
    LinearMap.trace_mul_comm _ _ _
  -- Step 3: P.symm ∘ₗ P = id, so P.symm * (P ∘ₗ φ) = φ.
  have h3 : P.symm.toLinearMap * (P.toLinearMap.comp φ) = φ := by
    ext x; simp [LinearMap.mul_apply]
  rw [h1, h2, h3, hφ]

end MathlibExpansion.Roots.Wiles1995
