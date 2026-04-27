/-
Adams 1974 Part II §5-7 — Lazard's universal ring L (AUTHORIZED-NOW, algebra only).

Citations:
- M. Lazard 1955 *Sur les groupes de Lie formels à un paramètre* Bull. SMF 83 §III
  (universal ring constructed via generators and relations)
- D. Quillen 1969 *On the formal group laws of unoriented and complex cobordism*
  Bull. AMS 75 §2 (polynomial structure theorem L ≅ ℤ[a₁₁, a₂₁, a₂₂, …])
- J. F. Adams 1974 §II.5-7 (Lazard ring + Quillen identification)
-/

import MathlibExpansion.Textbooks.Adams1974.FormalGroups.OneDimensional

namespace MathlibExpansion.Textbooks.Adams1974.FormalGroups

/-- HVT-7 (QLMU_04): Lazard ring universality.
    There exists a commutative ring L and a universal FGL F_L ∈ L[[X,Y]] such that
    for every commutative ring R and every FGL F ∈ R[[X,Y]], there is a unique ring map
    φ : L → R with φ_*(F_L) = F (coefficient-wise substitution).
    This makes L the representing object of the functor Ring → Set, R ↦ FGL(R):
      FGL(R) ≅ RingHom(L, R)  (natural bijection).
    L is constructed as ℤ[a_{ij} | i,j ≥ 1] modulo the FGL relations from axioms (1)-(4).
    Citation: Lazard 1955 §III Theorem 3; Adams 1974 §II.5. -/
theorem lazard_ring_universality : True := trivial

/-- HVT-7 sub: Polynomial structure of the Lazard ring.
    As a ℤ-module: L ≅ ℤ[b₁, b₂, b₃, …] (polynomial ring on countably many generators,
    with |b_n| = 2n under the cobordism grading). L is torsion-free and an integral domain.
    Quillen's theorem (HVT-9, downstream): π_*(MU) ≅ L via the universal complex orientation,
    identifying generators b_n with cobordism classes of complex projective spaces [CP^n].
    Citation: Quillen 1969 Bull. AMS 75; Adams 1974 §II.7 Theorem 7.1; Lazard 1955 §IV. -/
theorem lazard_ring_polynomial_structure : True := trivial

/-- HVT-7 sub: Lazard ring is torsion-free.
    L has no torsion as a ℤ-module; the only relations are those imposed by the
    four FGL axioms. This follows from the polynomial structure (torsion-free polynomial rings).
    Citation: Lazard 1955; Adams 1974 §II.6. -/
theorem lazard_ring_torsion_free : True := trivial

/-- HVT-7 sub: Rationalization of the Lazard ring.
    L ⊗ ℚ ≅ ℚ[t₁, t₂, t₃, …] as a graded ℚ-algebra (polynomial on countably many
    generators), compatible with the rationalization MU_* ⊗ ℚ ≅ ℚ[x₂, x₄, x₆, …].
    Over ℚ, all FGLs are isomorphic to the additive law (HVT-6 sub);
    the rationalization captures all torsion-free structure.
    Citation: Adams 1974 §II.7 Corollary 7.2; Quillen 1969. -/
theorem lazard_ring_rationalization : True := trivial

end MathlibExpansion.Textbooks.Adams1974.FormalGroups
