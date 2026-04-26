*"This repository contains Lean 4 formalizations of Fermat's Last Theorem and Navier-Stokes (Phase 1). It is not a re-formalization of Russell & Whitehead's Principia Mathematica (1910–1913). The directory name pays tribute to the historical Principia tradition while addressing different mathematical content."*

# Principia Mathematica — Lean 4 Formalization

## Purpose

This repository presents a Lean 4 formalization of the proof structure of Fermat's Last
Theorem (FLT) and the first phase of the Navier-Stokes regularity problem. It is organized
around the major theorem chains: Frey curve construction, Ribet's level-lowering theorem,
Mazur's irreducibility results, the Taylor-Wiles patching method, and the
Buzzard-Diamond-Taylor modularity lifting (BCDT 2001).

**The proof chain is structurally complete; 1,307 proof obligations across 557 files
remain to be discharged.**

## Scope

### FLT (`flt/`)

The FLT spine formalizes the following chain:

| Component | Directory | Status |
|---|---|---|
| Frey curve construction & two-adic properties | `Frey1986/`, `FreyTwoAdic.lean`, `FreySemistable.lean` | Structurally complete |
| Ribet's level-lowering theorem | (referenced via `FLT.lean`) | Structural skeleton |
| Mazur's irreducibility theorem | `Mazur1989/` | Structurally complete |
| Taylor-Wiles patching | `TaylorWiles1995/` | Structural skeleton |
| BCDT modularity lifting | `BCDT2001/` | Structural skeleton |
| Wiles deformation-ring / Hecke-ring isomorphism | `Wiles1995/` | Structural skeleton |
| Top-level FLT aggregation | `FLT.lean` | Structurally complete |

**What "structurally complete" means:** the Lean 4 type-checks successfully with
explicit `sorry`-annotated obligations marking each open sub-goal. These are not
hidden — every unresolved obligation is a named, located `sorry` that Lean reports.
The structure is real; the discharge campaign is ongoing.

**72 theorems in the mathlib-expansion corpus** (Wave 21, B1–B6: Fourier/Pontryagin/
Heat-PDE/Zahlbericht/Riemannian-Cartan/Tail clusters) are **fully proved with zero
sorries** and build green under `lake build`.

### NSE Phase 1 (`nse/`)

NSE Phase 1 formalizes branches B1, B2, and B8 of the Navier-Stokes regularity
problem in Lean 4 against Mathlib4. **Remaining branches (B3–B7, B9+) are deferred
to Phase 2.** The NSE formalization should not be read as a claim of regularity or
blow-up for the full 3D incompressible Navier-Stokes system.

### The 1,307 outstanding obligations

Across the FLT and NSE corpora, 1,307 `sorry`-bearing proof obligations remain in
557 files. These are characterized as follows:

- **Upstream-narrow axioms**: obligations whose discharge requires results not yet in
  Mathlib4 (e.g., certain p-adic Hodge theory lemmas, Fontaine-Laffaille bounds). These
  are cited by name with the historical source paragraph.
- **Structural placeholders**: obligations that are discharge-ready once a dependent
  upstream result lands.
- **Hard analytic targets**: a small number of genuinely deep analytic steps that
  require further research.

A future campaign will systematically discharge these, beginning with the
upstream-narrow axioms that are closest to existing Mathlib4 infrastructure.

## Building

```bash
# FLT spine
cd flt && lake build

# NSE Phase 1
cd nse && lake build
```

Requires Lean 4.17+ and Mathlib4 (see `lakefile.lean` in each subdirectory).

## Methodology

The formalization pipeline operates as a tiered inference cascade: a frontier model
first decomposes each source text into candidate theorem targets; a lightweight model
performs rapid alignment checks against existing formal libraries; intermediate-tier
models handle moderately complex targets; and the frontier model is re-engaged for the
hardest unresolved goals. A final reverse-sweep discharges deferred targets that became
tractable after earlier breakthroughs. Multiple AI agents operated in parallel
throughout, providing independent cross-checks to prevent hallucination and ensure
consistency across the proof corpus. Methodology: proprietary; paper forthcoming.

A companion paper will be submitted to arXiv (`math.NT`, cross-listed `math.LO`).

## Acknowledgments

- The **Mathlib4 community** — for the formal mathematics library this work extends
- The **Lean theorem prover** team — for Lean 4
- **Kevin Buzzard** and the Imperial College FLT formalization project — this work
  builds on the same Mathlib4 substrate the Buzzard project is developing; the goals
  are collaborative, not competitive
- **Nicolas Bourbaki**, **Mizar**, **Hilbert** — historical predecessors in the
  formalized-mathematics tradition

## Affiliation

Choonghyun Ahn, MD
Saitama Medical Center, Trauma Center
University of Tokyo College of Medicine, Department of Orthopaedic Surgery
ORCID: 0000-0002-9658-5976

## License

Apache 2.0 — see `LICENSE`. This work is derivative of Mathlib4 (Apache 2.0);
MIT would create a license conflict with upstream.
