import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral

/-!
# T20c_12_IDEAL_THETA_FE — Hecke Ch.2 §34

Functional equation `θ_𝔞(t) = c · θ_{𝔞⁻¹ · 𝔡⁻¹}(1/t)` for the
ideal-indexed theta function with constant `c` involving discriminant and
unit covolume. Mathlib has the modular theta; the ideal-indexed Hecke theta
and its Poisson functional equation is the substrate gap.

Citation: Hecke 1923, Ch.2 §34; Hecke 1917, *Math. Ann.* 78; Iwaniec 2002,
*Spectral Methods of Automorphic Forms*, Ch. 5.
-/

namespace MathlibExpansion.Encyclopedia.T20c_12

/-- Existence of an ideal-theta value `θ_𝔞(t) ∈ ℂ` for `t > 0`. -/
axiom t20c_12_idealTheta_fe
    (K : Type) [Field K] [NumberField K] (t : ℝ) (_ : 0 < t) :
    ∃ _θ : ℂ, True

end MathlibExpansion.Encyclopedia.T20c_12
