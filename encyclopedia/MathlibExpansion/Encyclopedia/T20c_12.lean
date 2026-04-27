/-
Hecke 1923 — Vorlesungen über die Theorie der algebraischen Zahlen.

Encyclopedia entry T20c_12 root module. Re-exports the 37 canonical HVTs
across Hecke's 4 chapters as individual designated Lean files (per audit
demand: one file per HVT, no monolithic Deferred dump). Each HVT sits at
its substrate-aligned path with a sharp upstream-narrow axiom or, where
substrate exists in this repository, a real theorem wrapping it. All
declarations are in `namespace MathlibExpansion.Encyclopedia.T20c_12`.

HVT classification (Step 5 verdict):
  • 27 substrate_gap, 7 breach_candidate, 3 novel_theorem (no poison_quarantine)
  • Ch.1 Algebraic substrate (15): invariant factors, residue characters,
    class-group characters, quadratic Kronecker symbol, ideal exponent
    comparison, residue field cardinality, residue degree, Frobenius
    congruence, prime-decomposition API, different / discriminant
    wrappers, discriminant–ramification criterion, quadratic-character
    conductor, prime- and odd-ideal quadratic symbols, supplementary-laws
    correction.
  • Ch.2 Analytic substrate (14): ideal-class density, ideal-count
    asymptotic, Dedekind zeta definition / partial-zeta decomposition /
    character diagonalization, NF Gauss sums and evaluation, ideal theta
    FE, Mellin bridge, twisted completed-zeta FE, Dedekind zeta residue,
    analytic CNF, Dedekind zeta meromorphic continuation, completed
    Dedekind zeta FE.
  • Ch.3 Quadratic-field model (6): ring of integers, discriminant
    formula, prime splitting law, zeta factorization, class-number via
    zeta, class-number Gauss-sum closed form.
  • Ch.4 Quadratic-reciprocity capstone (2): NF reciprocity, theta-Fourier
    proof.
-/

-- Ch.1 — Algebraic substrate (15)
import MathlibExpansion.Algebra.FGAbelian.InvariantFactors
import MathlibExpansion.NumberTheory.DirichletCharacter.ClassicalIndices
import MathlibExpansion.NumberTheory.NumberField.ClassGroupCharacters
import MathlibExpansion.NumberTheory.QuadraticCharacters.KroneckerHVT
import MathlibExpansion.NumberTheory.NumberField.IdealExponentComparison
import MathlibExpansion.NumberTheory.NumberField.ResidueFieldCard
import MathlibExpansion.NumberTheory.NumberField.ResidueDegree
import MathlibExpansion.NumberTheory.NumberField.FrobeniusCongruence
import MathlibExpansion.NumberTheory.NumberField.PrimeDecompAPI
import MathlibExpansion.NumberTheory.NumberField.DifferentNFWrapper
import MathlibExpansion.NumberTheory.NumberField.DiscRamCriterion
import MathlibExpansion.NumberTheory.QuadraticCharacters.QuadCharConductor
import MathlibExpansion.NumberTheory.QuadraticResidue.PrimeIdealQuadSymbol
import MathlibExpansion.NumberTheory.QuadraticResidue.OddIdealQuadSymbol
import MathlibExpansion.NumberTheory.QuadraticReciprocity.SuppLawsCorrection

-- Ch.2 — Analytic substrate (14)
import MathlibExpansion.NumberTheory.NumberField.IdealClassDensity
import MathlibExpansion.NumberTheory.NumberField.IdealCountAsymptotic
import MathlibExpansion.NumberTheory.LSeries.DedekindZetaDef
import MathlibExpansion.NumberTheory.LSeries.PartialZetaDecomp
import MathlibExpansion.NumberTheory.LSeries.PartialZetaCharDiag
import MathlibExpansion.NumberTheory.GaussSum.NFGaussSums
import MathlibExpansion.NumberTheory.GaussSum.NFGaussSumEval
import MathlibExpansion.NumberTheory.Theta.IdealThetaFE
import MathlibExpansion.NumberTheory.MellinTransform.MellinBridge
import MathlibExpansion.NumberTheory.LSeries.TwistedCompletedZetaFE
import MathlibExpansion.NumberTheory.LSeries.DedekindZetaResidue
import MathlibExpansion.NumberTheory.NumberField.AnalyticCNF
import MathlibExpansion.NumberTheory.LSeries.DedekindZetaMero
import MathlibExpansion.NumberTheory.LSeries.CompletedDedekindZetaFE

-- Ch.3 — Quadratic-field model (6)
import MathlibExpansion.NumberTheory.QuadraticFields.RingOfIntegers
import MathlibExpansion.NumberTheory.QuadraticFields.Discriminant
import MathlibExpansion.NumberTheory.QuadraticFields.PrimeSplittingLaw
import MathlibExpansion.NumberTheory.QuadraticFields.ZetaFactorization
import MathlibExpansion.NumberTheory.QuadraticFields.ClassNumberViaZeta
import MathlibExpansion.NumberTheory.QuadraticFields.ClassNumberGaussSum

-- Ch.4 — Quadratic-reciprocity capstone (2)
import MathlibExpansion.NumberTheory.QuadraticReciprocity.NumberFieldReciprocity
import MathlibExpansion.NumberTheory.QuadraticReciprocity.ThetaFourierProof
