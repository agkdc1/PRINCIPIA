import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 QCP — QCoh / coherent sheaf package (B1 substrate, Ch. II)

**Classification.** `substrate_gap` / `B1` per Step 5 verdict. Main owner
shelf for coherent `O_X`-modules: the first Hartshorne breach wedge is the
coherent-subcategory package on `X.Modules` — closure, exactness, tensor/Hom,
and change-of-rings.

**Dispatch note.** Cycle-1 opens the B1 owner shelf with marker axioms:
`coherent_subcategory_closed`, `qcoh_tensor_hom_exact`, and
`change_of_rings_bridge`. These reserve the Hartshorne II §5 theorem surface
pending sharp signature landing in cycle-2 once the upstream
`AlgebraicGeometry.Modules` API packages stabilize.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. II §5,
pp. 108–129. Historical parent: Serre, "Faisceaux algébriques cohérents",
Ann. Math. 61 (1955), §§1–4; EGA I §§5–9; EGA Inew §§1–6. Modern: Stacks
Project Tag 01AG (QCoh), Tag 01XZ (Coherent).
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_QCP

/-- **QCP_01** coherent-subcategory closure marker (2026-04-24). On a
locally Noetherian scheme `X`, the coherent `O_X`-modules form an abelian
full subcategory of `QCoh(X)` closed under kernels, cokernels, and finite
direct sums. Marker reserves the B1 owner slot.

Citation: Hartshorne Ch. II Prop. 5.7, p. 113. -/
axiom coherent_subcategory_closed_marker : True

/-- **QCP_04** tensor / Hom exactness marker (2026-04-24). On a scheme `X`,
tensor product `⊗_{O_X}` of qcoh sheaves is right-exact; Hom is left-exact.
Sharp signature deferred until QCoh tensor packaging lands upstream.

Citation: Hartshorne Ch. II Prop. 5.2, p. 110. -/
axiom qcoh_tensor_hom_exact_marker : True

/-- **QCP_07** change-of-rings bridge marker (2026-04-24). For a morphism
of schemes `f : X → Y`, the pushforward `f_*` preserves quasi-coherence
when `f` is quasi-compact and quasi-separated.

Citation: Hartshorne Ch. II Prop. 5.8, p. 115. -/
axiom change_of_rings_bridge_marker : True

end T20cLate02_QCP
end Hartshorne
end Roots
end MathlibExpansion
