*"The repository name is a small homage to Newton's Philosophiae Naturalis Principia Mathematica (1687)."*

# Principia Mathematica — Lean 4 Encyclopedia of Mathematics

## Purpose

This repository presents a Lean 4 formalization **corpus** organized as an evolving
encyclopedia of mathematics, built against Mathlib4. The encyclopedia is the broader
work; Fermat's Last Theorem and the Navier–Stokes regularity problem are included as
flagship case studies that exercise the same formalization pipeline against two of
the hardest historically-closed and historically-open problems.

The corpus is the product of a tiered AI-agent formalization pipeline (methodology
paper forthcoming). It is open in scope — new branches land as the campaign
continues.

## Corpus inventory

A textbook-by-textbook ledger of what the pipeline has ingested so far is at
[`CORPUS.md`](CORPUS.md). It currently lists 113 textbook-level entries (19th c.,
20th c. early/mid/late, 21st c.) with sample sub-targets. The roadmap section at
the end lists the next ~290 primary-source papers queued for the same pipeline.

## Repository layout

```
PRINCIPIA/
├── CORPUS.md               Ingested + planned textbook ledger
├── encyclopedia/           Encyclopedia tree (1,554 Lean files, builds against Mathlib4 v4.17.0)
│   ├── lakefile.lean
│   ├── lake-manifest.json
│   ├── lean-toolchain
│   ├── MathlibExpansion.lean         (root module)
│   ├── MathlibExpansion/             (Algebra, Analysis, NumberTheory, Geometry,
│   │                                   AlgebraicGeometry, AlgebraicTopology,
│   │                                   CategoryTheory, FieldTheory, GroupTheory,
│   │                                   Foundations, FunctionalAnalysis, Dynamics,
│   │                                   Combinatorics, Roots, Textbooks,
│   │                                   Encyclopedia, …)
│   └── MathlibOverlay/               (extensions and overlay modules)
├── flt/                    Case study: FLT proof scaffolding (Frey/Ribet/Mazur/Taylor–Wiles/BCDT/Wiles)
├── nse/                    Case study: Navier–Stokes Phase 1 (axisymmetric no-swirl, branches B1–B8 except B6)
├── README.md
├── LICENSE                 Apache 2.0
└── .gitignore
```

The encyclopedia tree is the broader corpus. The two case-study directories carve out
the FLT and NSE work specifically so they can be reviewed and built in isolation.

## Encyclopedia (`encyclopedia/`)

The encyclopedia tree contains 1,554 Lean files spanning:

- **Algebra** — commutative, homological, group/ring/field, multilinear
- **Analysis** — real, complex, Fourier, harmonic, weighted Sobolev, weak / Sobolev / Banach / Hilbert spaces
- **AlgebraicGeometry** — schemes, sheaves, divisors, intersection theory
- **AlgebraicTopology** — homotopy, homology, fibre bundles, characteristic classes
- **NumberTheory** — class field theory, Iwasawa theory, p-adic Hodge, modular forms
- **Geometry** — differential, Riemannian, symplectic, Cartan
- **CategoryTheory** — abelian, derived, monoidal, ∞-category foundations
- **FieldTheory**, **GroupTheory**, **FunctionalAnalysis**, **Dynamics**, **Combinatorics**, **DecisionTheory**, **DedekindCuts**, **ComplexGeometry**
- **Foundations** — type-theory, choice, computability adjacent material
- **Encyclopedia** — pipeline-curated entries
- **Roots** — root-level definitions consumed by FLT, NSE, and downstream files
- **Textbooks** — per-textbook formalizations from the ingestion campaign

Each subtree is organized so that the corresponding Mathlib4 path is the primary
reference; the files extend Mathlib4 with additional theorems, supporting
infrastructure, and explicit witness constructions. As of this snapshot the corpus
includes 72 unconditional theorems with zero `sorry` annotations across Wave 21
(Fourier/Pontryagin/Heat-PDE/Zahlbericht/Riemannian-Cartan/Tail clusters), all
building green.

## Case study I — Fermat's Last Theorem (`flt/`)

The FLT case study formalizes the proof structure of Wiles' theorem:

| Component | Directory | Status |
|---|---|---|
| Frey curve construction & two-adic properties | `Frey1986/`, `FreyTwoAdic.lean`, `FreySemistable.lean` | Structurally complete |
| Ribet's level-lowering theorem | (referenced via `FLT.lean`) | Structural skeleton |
| Mazur's irreducibility theorem | `Mazur1989/` | Structurally complete |
| Taylor–Wiles patching | `TaylorWiles1995/` | Structural skeleton |
| BCDT modularity lifting | `BCDT2001/` | Structural skeleton |
| Wiles deformation-ring / Hecke-ring isomorphism | `Wiles1995/` | Structural skeleton |
| Top-level FLT aggregation | `FLT.lean` | Structurally complete |

**What "structurally complete" means:** the Lean 4 type-checks successfully with
explicit `sorry`-annotated obligations marking each open sub-goal. These are not
hidden — every unresolved obligation is a named, located `sorry` that Lean reports.
The structure is real; the discharge campaign is ongoing.

This is **not** a proof of FLT (Wiles proved it in 1995). The `flt/` tree is a
machine-checkable scaffolding of that proof, with 1,307 proof obligations across 557
files explicitly remaining.

## Case study II — Navier–Stokes Phase 1 (`nse/`)

NSE Phase 1 formalizes branches B1, B2, B3, B4, B5, B7, and B8 of the axisymmetric
no-swirl Navier–Stokes regularity argument in Lean 4 against Mathlib4. **B6 is the
only Phase 1 branch not yet breached, deferred to Phase 2.** The NSE formalization
should not be read as a claim of regularity or blow-up for the full 3D incompressible
Navier–Stokes system.

## The 1,307 outstanding obligations (FLT case study)

Across the FLT corpus, 1,307 `sorry`-bearing proof obligations remain in 557 files:

- **Upstream-narrow axioms**: obligations whose discharge requires results not yet in
  Mathlib4 (e.g., certain p-adic Hodge theory lemmas, Fontaine-Laffaille bounds).
  These are cited by name with the historical source paragraph.
- **Structural placeholders**: obligations that are discharge-ready once a dependent
  upstream result lands.
- **Hard analytic targets**: a small number of genuinely deep analytic steps that
  require further research.

A future campaign will systematically discharge these, beginning with the
upstream-narrow axioms that are closest to existing Mathlib4 infrastructure.

## Building

```bash
# Encyclopedia tree
cd encyclopedia && lake build

# FLT case study
cd flt && lake build

# NSE Phase 1 case study
cd nse && lake build
```

Requires Lean 4.17+ and Mathlib4 (see `lakefile.lean` in each subdirectory).

## Methodology

The formalization pipeline operates as a tiered inference cascade: a frontier model
first decomposes each source text into candidate theorem targets; a lightweight model
performs rapid alignment checks against existing formal libraries; intermediate-tier
models handle moderately complex targets; and the frontier model is re-engaged for
the hardest unresolved goals. A final reverse-sweep discharges deferred targets that
became tractable after earlier breakthroughs. Multiple AI agents operate in parallel
throughout, providing independent cross-checks to prevent hallucination and ensure
consistency across the proof corpus.

The pipeline ingested approximately 68 graduate-level mathematics textbooks and a
growing set of primary-source papers across the 19th, 20th, and early 21st centuries
during the campaign that produced this snapshot.

A companion paper will be submitted to arXiv (`math.NT`, cross-listed `math.LO`).

## Acknowledgments

- The **Mathlib4 community** — for the formal mathematics library this work extends
- The **Lean theorem prover** team — for Lean 4
- **Kevin Buzzard** and the Imperial College FLT formalization project — this work
  builds on the same Mathlib4 substrate the Buzzard project is developing; the goals
  are collaborative, not competitive
- **Nicolas Bourbaki**, **Mizar**, **Hilbert** — historical predecessors in the
  formalized-mathematics tradition

## License

Apache 2.0 — see `LICENSE`. This work is derivative of Mathlib4 (Apache 2.0);
MIT would create a license conflict with upstream.
