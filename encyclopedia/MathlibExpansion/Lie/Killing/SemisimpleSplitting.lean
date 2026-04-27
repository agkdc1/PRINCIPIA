import Mathlib.Algebra.Lie.Semisimple.Basic
import Mathlib.Algebra.Lie.Killing

/-!
# Semisimple-ideal splitting (Cartan 1894, CKF_04)

For a Lie algebra over a commutative ring with non-degenerate Killing form, the
atoms of the ideal lattice are simple Lie subalgebras and their supremum is the
whole algebra.

This is the semisimple-ideal splitting row. Source: É. Cartan, *Sur la structure
des groupes de transformations finis et continus* (1894), Ch. IV §4, Théorème V;
with Killing (1888-90), *Die Zusammensetzung der stetigen endlichen
Transformationsgruppen* Parts III-IV, as precursor.

The Mathlib witnesses are
- `LieAlgebra.IsKilling.instSemisimple` (Killing ⇒ IsSemisimple)
- `LieAlgebra.IsSemisimple.isSimple_of_isAtom` (each atom is simple)
- `LieAlgebra.IsSemisimple.sSup_atoms_eq_top` (atoms span the algebra)
- `LieAlgebra.IsSemisimple.sSupIndep_isAtom` (atoms are independent)
all due to Oliver Nash / Johan Commelin.
-/

noncomputable section

open LieAlgebra

universe u v

namespace MathlibExpansion.Lie.Killing

variable (K : Type u) (L : Type v)
  [Field K] [LieRing L] [LieAlgebra K L] [Module.Finite K L]
  [LieAlgebra.IsKilling K L]

/--
A Killing Lie algebra over a field is semisimple — the instance path through
Mathlib's `LieAlgebra.IsKilling.instSemisimple`.
-/
theorem isSemisimple_of_isKilling : LieAlgebra.IsSemisimple K L :=
  inferInstance

/--
Atoms of the ideal lattice of a Killing Lie algebra are simple Lie subalgebras.
-/
theorem isSimple_atom_of_isKilling (I : LieIdeal K L) (hI : IsAtom I) :
    LieAlgebra.IsSimple K I :=
  LieAlgebra.IsSemisimple.isSimple_of_isAtom (R := K) (L := L) I hI

/--
The atoms of the ideal lattice of a Killing Lie algebra span the whole algebra.
-/
theorem sSup_atoms_eq_top_of_isKilling :
    sSup {I : LieIdeal K L | IsAtom I} = ⊤ :=
  LieAlgebra.IsSemisimple.sSup_atoms_eq_top

/--
The atoms of the ideal lattice of a Killing Lie algebra are `sSup`-independent.
-/
theorem sSupIndep_isAtom_of_isKilling :
    sSupIndep {I : LieIdeal K L | IsAtom I} :=
  LieAlgebra.IsSemisimple.sSupIndep_isAtom

end MathlibExpansion.Lie.Killing
