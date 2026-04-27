import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_06 CMAG — Complex multiplication + abelian class generation (breach_candidate B5, opus max)

**Classification.** `breach_candidate` / `B5`, opus-max tier. Chapter XIII
deep consumer: CM elliptic curve `E/K` with `End(E) ≅ 𝒪_F` for imaginary
quadratic `F`, Main Theorem of CM — singular moduli `j(E) ∈ K^{ab}` generate
the Hilbert class field `H_F/F`, torsion points generate ray class fields.

**Prerequisites.** Consumes `GARI_CORE` + `CFFC_CORE` + `LCFR_CORE` + `CKE_
CORE`. CM class-generation becomes honest only after reciprocity + existence
theorem exist.

**Citation.** Cassels–Fröhlich, *Algebraic Number Theory* (1967), Chapter XIII
(Serre, "Complex multiplication"). Historical parents: Kronecker (1854)
*Jugendtraum* program; Weber (1899) *Lehrbuch der Algebra* Bd. III; Deuring
(1941) "Die Typen der Multiplikatorenringe elliptischer Funktionenkörper";
Shimura–Taniyama (1961) *Complex Multiplication of Abelian Varieties and its
Applications to Number Theory*.
-/

namespace MathlibExpansion
namespace Roots
namespace Cassels
namespace T20cLate06_CMAG

/-- **CMAG_01** CM elliptic curve endomorphism marker. An elliptic curve
`E` over a number field `K` has *complex multiplication* by an order
`𝒪 ⊆ F` in an imaginary quadratic field `F` if `End_{K̄}(E) ≅ 𝒪`. Then `E`
is defined over `F · K` after possibly extending scalars; the action of
`Gal(K̄/F)` on the Tate module `T_ℓ(E)` factors through `𝒪 ⊗ ℤ_ℓ`-linear
automorphisms.
Citation: Cassels–Fröhlich Ch. XIII §§1–3; Deuring (1941); Shimura–Taniyama
(1961) §§3–4. -/
axiom cm_elliptic_curve_endomorphism_marker : True

/-- **CMAG_03** singular `j`-invariants generate Hilbert class field marker.
Let `F` be imaginary quadratic, `𝒪_F` its maximal order, `E/ℂ` an elliptic
curve with `End(E) = 𝒪_F`. Then `j(E)` is an algebraic integer, and
`F(j(E)) = H_F`, the Hilbert class field of `F` (= maximal unramified
abelian extension). The singular moduli `{j(E_𝔞) : 𝔞 \in Cl(F)}` are
Galois-conjugate, permuted by `Gal(H_F/F) ≅ Cl(F)` via the Artin map.
Citation: Cassels–Fröhlich Ch. XIII §§4–7; Kronecker (1854); Weber (1899);
Shimura–Taniyama (1961) §§5–7. -/
axiom singular_moduli_hilbert_class_field_marker : True

/-- **CMAG_05** CM torsion generates ray class fields marker. Let `E/H_F`
have CM by `𝒪_F`. For an ideal `𝔣 ⊆ 𝒪_F`, the field
`H_F(E[𝔣]) = K_𝔣`,
the ray class field of `F` modulo `𝔣`. The action of
`Gal(K_𝔣 / H_F) ≅ (𝒪_F / 𝔣)^× / \mathrm{image}(𝒪_F^×)` on `E[𝔣]` is the
natural one, yielding an explicit Kronecker–Weber-style description of
`F^{ab}`: every finite abelian extension of `F` lies in `F(j(E), E_{tors})`.
Citation: Cassels–Fröhlich Ch. XIII §§8–10; Kronecker (1854) *Jugendtraum*;
Shimura–Taniyama (1961) Main Theorem. -/
axiom cm_torsion_ray_class_field_marker : True

end T20cLate06_CMAG
end Cassels
end Roots
end MathlibExpansion
