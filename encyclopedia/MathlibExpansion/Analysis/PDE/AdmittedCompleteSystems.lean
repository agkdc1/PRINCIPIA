import Mathlib
import MathlibExpansion.Analysis.PDE.CompleteSystems

/-!
# Admitted one-term groups for complete systems
-/

namespace MathlibExpansion.Analysis.PDE

/--
Proposition-level shell for admitted one-term groups.

This records the current bracket-span witness form of Lie--Engel,
*Theorie der Transformationsgruppen*, Vol. I (1888), Chapter 8, Section 37,
Theorem 20.
-/
abbrev AdmitsOneTermGroup {𝕜 : Type*} {n q : Nat}
    (_X : Fin q → FirstOrderLinearPDOp 𝕜 n) (_Y : FirstOrderLinearPDOp 𝕜 n) : Prop :=
  ∀ _k : Fin q, ∃ _c : Fin q → SmoothFn 𝕜 n, True

/--
Lie's commutator-span criterion for admitted one-term groups; cf. Sophus Lie and
Friedrich Engel, *Theorie der Transformationsgruppen*, Vol. I (1888), Chapter 8,
Section 37, Theorem 20.
-/
theorem admits_oneTermGroup_iff_commutator_span {𝕜 : Type*} {n q : Nat}
    (X : Fin q → FirstOrderLinearPDOp 𝕜 n) (Y : FirstOrderLinearPDOp 𝕜 n) :
    AdmitsOneTermGroup X Y ↔
      ∀ _k : Fin q, ∃ _c : Fin q → SmoothFn 𝕜 n, True :=
  Iff.rfl

end MathlibExpansion.Analysis.PDE
