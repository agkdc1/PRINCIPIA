import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_13 CVB_DEFER — Complex Vector Bundle Core (Atiyah 1967 §I.1, defer, DEFER)
    **Classification.** defer — generic topological vector-bundle carrier is already theorem-bearing
    upstream (`Mathlib.Topology.VectorBundle.Basic`); only thin convenience wrappers remain for
    opportunistic cleanup. Single citation marker, no fireline work here.
    **Citation.** M. F. Atiyah, *K-Theory*, W. A. Benjamin (New York, 1967; Addison-Wesley 1989
    reprint), Chapter I §1.1-§1.4 (complex vector bundle carrier CVB_01-CVB_05); Steenrod,
    *Topology of Fibre Bundles* (Princeton 1951) §1-§4 as pre-1967 source. -/
namespace MathlibExpansion
namespace Roots
namespace Atiyah
namespace T20cLate13_CVB_DEFER

/-- **CVB_01-05** (deferred, citation-only) complex vector bundle E → X with continuous projection,
    local triviality over a ℂ-vector space, compatible transition cocycle, zero section, and
    morphism category. Delegated to `Mathlib.Topology.VectorBundle.Basic` and
    `Mathlib.Topology.FiberBundle.Basic`; the Atiyah-flavored convenience wrappers (finite rank,
    ℂ-scalar naturality, trivial bundle factor) are not load-bearing for any later theorem in this
    packet and remain deferred (Atiyah §I.1; Steenrod 1951). -/
axiom cvb_complex_vector_bundle_carrier_deferred_marker : True

end T20cLate13_CVB_DEFER
end Atiyah
end Roots
end MathlibExpansion
