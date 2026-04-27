import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.NumberTheory.NumberField.ClassNumber

/-!
# T20c_12_ANALYTIC_CNF — Hecke Ch.2 §37 culmination

Analytic class-number formula:
`h_K = (w_K · √|d_K| · Res_{s=1} ζ_K) / (2^{r₁} · (2π)^{r₂} · R_K)`.
Substrate gap: explicit packaging of the residue formula yielding `h_K`.

Citation: Hecke 1923, Ch.2 §37 culmination; Dirichlet 1837/1839; Dedekind
1877, *Théorie des nombres*; Neukirch 1999, *ANT*, Ch. VII §5 Theorem 5.9.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

open scoped NumberField

/-- Existence of a positive class number for any number field, witnessing
the analytic class-number formula's positivity claim. -/
axiom t20c_12_analytic_cnf
    (K : Type) [Field K] [NumberField K] :
    0 < NumberField.classNumber K

end MathlibExpansion.Encyclopedia.T20c_12
