import Mathlib

/-!
# Flach1992 — Typed congruence module data

Typed congruence-module carrier for the RHS of the Flach–Wiles bound:

  O / η  (the "η invariant" / congruence module)

where `η = ker(π : R →+* O)` is the kernel of the augmentation map from
the Hecke algebra `R` to the ring of integers `O` of the coefficient field.

The `length : ℕ` field is the finite length of this congruence module,
which MW1984 controls via the Kubota–Leopoldt p-adic L-function
(`charIdeal_eq_unit_mul_Lp`). The Flach breach consumes only `length`;
the full MW1984 derivation chain is not reprised here — it enters in the
next breach layer as a derivation of `C.length` from the L-value.

Strictly richer than `Wiles1995.CongruenceLength`: it carries the ring
map `π : R →+* O` explicitly, making the congruence-module structure
visible to the typed Flach bound and to future Schlessinger cotangent work.

## Axioms introduced by this file

**0.** No axiom, no sorry.

## Reference

- Mazur–Wiles, *Class fields of abelian extensions of ℚ*,
  Invent. Math. 76 (1984).
- Wiles, *Modular elliptic curves and Fermat's Last Theorem*,
  Ann. Math. 141 (1995), §2 (η invariant definition).
-/

namespace MathlibExpansion.Roots.Flach1992

/-- **Typed congruence module data.**

Records:
* `π : R →+* O` — the augmentation (specialisation) ring map from the
  Hecke algebra `R` to the coefficient ring `O`;
* `length : ℕ` — the finite length of the congruence module `O / ker(π)`,
  the quantity that MW1984 bounds via the p-adic L-function.

Parameters:
* `R` — the Hecke algebra (deformation ring side);
* `O` — the coefficient ring (ring of integers of the local field). -/
structure CongruenceModuleData (R O : Type*) [CommRing R] [CommRing O] where
  /-- The augmentation ring map `π : R →+* O` (specialisation to O). -/
  π : R →+* O
  /-- Finite length of the congruence module `O / ker(π)`. -/
  length : ℕ

/-- The congruence ideal `η = ker(π)` inside the Hecke algebra `R`. -/
def CongruenceModuleData.congruenceIdeal {R O : Type*} [CommRing R] [CommRing O]
    (C : CongruenceModuleData R O) : Ideal R :=
  RingHom.ker C.π

end MathlibExpansion.Roots.Flach1992
