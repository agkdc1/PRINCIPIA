import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 NIC_CORE — Norm index computations (B2 breach_candidate)

**Classification.** `breach_candidate` / `B2` per Step 5 verdict. Norm-
quotient surface on local/global ideles and idele classes. Assigned to
`codex-opus-ahn2` tier.

**Dispatch note.** Cycle-1 opens the B2 breach with marker axioms for: the
local norm index `[K_v^× : N_{L_w/K_v}(L_w^×)]` equal to the local-degree
for unramified completions, the global idele norm `N_{L/K} : I_L → I_K`,
and the global-norm-index identity
`[C_K : N_{L/K}(C_L)] = [L:K]` for a cyclic `L/K` (global cyclic norm
index = degree).

**Citation.** Lang, *Algebraic Number Theory* (Addison-Wesley 1970), Ch. IX.
Historical parent: Artin–Tate, *Class Field Theory* (Harvard 1952 /
Benjamin 1967), Ch. 5; Herbrand, "Sur la theorie des groupes de
decomposition", J. Math. Pures Appl. 11 (1932). Modern: Cassels–Frohlich
Ch. VII (Tate); Neukirch §VI.3.
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_NIC

/-- **NIC_01** local norm index marker (2026-04-24). For `L_w / K_v` a
finite Galois extension of local fields, the norm group
`N_{L_w/K_v}(L_w^×) ⊂ K_v^×` is open of finite index, and for unramified
extensions the index equals the residue-degree `f = [κ_w : κ_v]`.

Citation: Lang Ch. IX §1, Prop. 1, p. 182; Serre *Local Fields* §XIV.6. -/
axiom local_norm_index_marker : True

/-- **NIC_03** global idele norm marker (2026-04-24). For `L/K` a finite
extension of number fields, the idele norm `N_{L/K} : I_L → I_K` defined
componentwise by local norms is a continuous group homomorphism sending
`L^×` to `K^×` and inducing `N_{L/K} : C_L → C_K`.

Citation: Lang Ch. IX §1, p. 185; Cassels–Frohlich Ch. II §16. -/
axiom global_idele_norm_marker : True

/-- **NIC_05** global cyclic norm index marker (2026-04-24). For `L/K` a
finite cyclic extension of number fields, the index
`[C_K : N_{L/K}(C_L)] = [L : K]`.
This is "global reciprocity's numerical heart": the idele-class norm
index matches the degree.

Citation: Lang Ch. IX §3, Thm. 1, p. 191; Artin–Tate Ch. 5 §1. -/
axiom global_cyclic_norm_index_marker : True

end T20cLate04_NIC
end Lang
end Roots
end MathlibExpansion
