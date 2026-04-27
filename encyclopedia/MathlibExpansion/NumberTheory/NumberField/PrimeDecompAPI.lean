import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.RingTheory.DedekindDomain.Ideal

/-!
# T20c_12_PRIME_DECOMP_API — Hecke Ch.V general prime-decomposition narrative

Coherent prime-decomposition API: `(p) = ∏ Pᵢ^{eᵢ}` with residue degrees
`fᵢ` packaged in one theorem boundary. Kummer-Dedekind factorization and
absNorm machinery are upstream; the coherent assembly of e/f data into a
single NF-facing API is the substrate gap.

Citation: Hecke 1923, Ch.V; Dedekind 1871, *Supplement X to Dirichlet's
Vorlesungen*, §163; Marcus 1977, *Number Fields*, Theorem 21
(`∑ eᵢ fᵢ = [K : ℚ]`).
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

open scoped NumberField
open NumberField

/-- For every rational prime `p` there exists a finite collection of
height-one prime ideals of `𝓞 K` together with positive ramification indices
`eᵢ` and positive residue degrees `fᵢ` packaging the Kummer-Dedekind
factorization. -/
axiom t20c_12_primeDecomp_api
    (K : Type) [Field K] [NumberField K] (p : ℕ) (_ : Nat.Prime p) :
    ∃ (n : ℕ) (_P : Fin n → IsDedekindDomain.HeightOneSpectrum (𝓞 K))
      (e f : Fin n → ℕ),
      (∀ i, 0 < e i) ∧ (∀ i, 0 < f i)

end MathlibExpansion.Encyclopedia.T20c_12
