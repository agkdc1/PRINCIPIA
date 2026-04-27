import Mathlib
import MathlibExpansion.FunctionalAnalysis.Reed1972.Unbounded.DeficiencyIndices

/-!
# Unbounded self-adjoint extension boundary — UCSA_CORE stage 4

Replaces the former `PUnit/True/True` shell with a real UCSA stage-4 package that
binds the deficiency-index machinery from `Reed1972.Unbounded.DeficiencyIndices` to
the von Neumann self-adjoint extension theorem. The package records the data a
symmetric operator with equal deficiency indices carries: the ambient operator, the
deficiency record, and the resulting self-adjoint extension.

Primary sources:
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*, Ch. II §9
  Thm. 1-2 (essential self-adjointness and the Cayley extension).
- M. H. Stone (1932), *Linear transformations in Hilbert space*, Ch. IX §3
  (extension theorem and deficiency analysis).
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace
namespace Unbounded

open MathlibExpansion.FunctionalAnalysis.Reed1972.Unbounded

variable {E : Type*}
variable [NormedAddCommGroup E] [InnerProductSpace ℂ E] [CompleteSpace E]

/--
Von Neumann 1932 Ch. II §9 Thm. 2 package: a symmetric operator with equal deficiency
indices admits a self-adjoint extension. Records the ambient operator, the deficiency
record, the equality of indices, and the concrete extension data.
-/
structure SelfAdjointExtensionPackage (T : SymmetricOperator (E := E)) where
  /-- Deficiency-index record for the symmetric operator. -/
  indices : DeficiencyIndices T
  /-- The deficiency indices are equal — the existence hypothesis for the extension theorem. -/
  indices_equal : indices.n_plus = indices.n_minus
  /-- The self-adjoint extension produced by the Cayley construction. -/
  extension : LinearPMap ℂ E E
  /-- The original operator is dominated by the extension. -/
  le_extension : T.op ≤ extension
  /-- The extension is self-adjoint. -/
  extension_selfAdjoint : extension.adjoint = extension

/--
Von Neumann 1932 Ch. II §9 Thm. 2: every symmetric operator with equal deficiency
indices admits a self-adjoint extension package. This is the existence direction of
the extension theorem, cited from `Reed1972.Unbounded.DeficiencyIndices`.
-/
theorem selfAdjointExtensionPackage_of_equal_indices
    (T : SymmetricOperator (E := E)) (d : DeficiencyIndices T)
    (heq : d.n_plus = d.n_minus) :
    Nonempty (SelfAdjointExtensionPackage T) := by
  obtain ⟨Text, hle, hsa⟩ :=
    exists_selfAdjoint_extension_of_equal_indices (E := E) T d heq
  exact
    ⟨{ indices := d
     , indices_equal := heq
     , extension := Text
     , le_extension := hle
     , extension_selfAdjoint := hsa }⟩

/--
A self-adjoint operator carries the trivial extension package: its own deficiency
indices are zero and the extension is the operator itself.
-/
def selfAdjointExtensionPackage_of_selfAdjoint
    (T : SymmetricOperator (E := E)) (h : T.op.adjoint = T.op) :
    SelfAdjointExtensionPackage T where
  indices := { n_plus := 0, n_minus := 0 }
  indices_equal := rfl
  extension := T.op
  le_extension := le_refl _
  extension_selfAdjoint := h

end Unbounded
end InnerProductSpace
end Analysis
end MathlibExpansion
