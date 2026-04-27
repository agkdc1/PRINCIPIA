import Mathlib
import MathlibExpansion.LocalHeckeAlgebra
import MathlibExpansion.Roots.Mazur1977.PrimeLevelHecke
import MathlibExpansion.Roots.Mazur1977.EisensteinIdeal
import MathlibExpansion.Roots.Mazur1977.LocalizedHecke

/-!
# Eisenstein Gorenstein boundary at prime level (Mazur 1977, Corollary II.16.3)

Mazur's Eisenstein-ideal paper proves that for prime level `Γ₀(p)` with
weight `2`, the Hecke algebra localized at the Eisenstein maximal ideal is
Gorenstein. That is the honest load-bearing boundary in the current
`mathlib-expansion` substrate: a statement about the localized Hecke algebra
itself, not about an arbitrary module over it.

The previous axiom in this file claimed that every finite `T_𝔪`-module had
`Module.finrank = 1`. That statement is false in general and has been
deleted. The replacement keeps the historical name `mazurGorenstein163` so
the audit surface stays stable, but its signature now matches the actual
prime-level Eisenstein result: the localized Hecke algebra is Gorenstein as a
`ℤ_[p]`-algebra.

Citation: Barry Mazur, *Modular curves and the Eisenstein ideal*,
Publications Mathématiques de l'IHÉS 47 (1977), pp. 33-186,
Corollary II.16.3 (Corollary 16.3 in the paper): the Eisenstein-localized
Hecke algebra is Gorenstein.

The full Eisenstein-ideal paper, the Mazur torsion theorem, and the `J₀(p)` /
Néron-model geometry remain out of scope; see the breach report and
`PrimeLevelHecke.lean` for the precise contract.

**Doctrine v2.** All hypotheses are typed data or typed predicates on
typed data. No free-Prop laundering. The axiom itself is the single
boundary-of-formalization line and is explicitly counted in the breach
axiom budget.
-/

namespace MathlibExpansion.Roots.Mazur1977

open scoped Padic

universe v w x

/-- **Prime-level Eisenstein data for Mazur's Gorenstein theorem.**

Bundles the exact surface carried by the live Mazur/Wiles files:

- the prime level `p` with typeclass witness `[Fact p.Prime]`,
- a weight-2 prime-level Hecke carrier over `ℤ_[p]`,
- a localization `T_𝔪`, and
- a typed witness that the maximal ideal `𝔪` is Eisenstein.

This is the honest boundary visible in the current namespace. The downstream
modular-symbol multiplicity-one package is not formalized here because the
needed modular-symbol / cohomology bridge is still absent. -/
structure EisensteinPrimeLevelHeckeData where
  /-- Prime level `p`. -/
  p : ℕ
  /-- Mazur's theorem is the prime-level case. -/
  [primeLevel : Fact p.Prime]
  /-- Consumer-supplied carrier for the weight-2 Hecke action. -/
  modularSymbols : Type v
  /-- Additive structure on the carrier. -/
  [instAddCommGroup : AddCommGroup modularSymbols]
  /-- `ℤ_[p]`-module structure on the carrier. -/
  [instModule : Module ℤ_[p] modularSymbols]
  /-- Prime-level Hecke carrier over `ℤ_[p]`. -/
  hecke : PrimeLevelHeckeCarrier.{0,v,w} ℤ_[p] modularSymbols p
  /-- Localization of the Hecke algebra at a maximal ideal. -/
  localized : PrimeLevelLocalizedHecke.{0,v,w,x} hecke
  /-- Mazur's Gorenstein theorem is applied at the Eisenstein maximal ideal. -/
  eisenstein : IsEisenstein hecke localized.maximalIdeal

attribute [instance] EisensteinPrimeLevelHeckeData.instAddCommGroup
                     EisensteinPrimeLevelHeckeData.primeLevel
                     EisensteinPrimeLevelHeckeData.instModule

/-- **Mazur 1977, Corollary II.16.3 — Eisenstein-localized Hecke algebra is Gorenstein.**

At prime level `Γ₀(p)` with `p` prime and weight `2`, the Hecke algebra
localized at the Eisenstein maximal ideal is Gorenstein. On the current
substrate we record this through the existing honest Gorenstein interface
`MathlibExpansion.LocalHeckeAlgebra.IsGorensteinCondition`, i.e. injectivity
of the localized algebra as a module over itself.

Exact citation: Barry Mazur, *Modular curves and the Eisenstein ideal*,
Publications Mathématiques de l'IHÉS 47 (1977), pp. 33-186,
Corollary II.16.3 (Corollary 16.3 in the paper).

This is narrower than the deleted generic rank-one axiom and matches the
actual theorem shape that downstream Mazur/Wiles files can consume once the
local Hecke algebra and modular-symbol bridges are expanded. -/
axiom mazurGorenstein163
    (D : EisensteinPrimeLevelHeckeData.{v,w,x}) :
    MathlibExpansion.LocalHeckeAlgebra.IsGorensteinCondition D.localized.algebra

end MathlibExpansion.Roots.Mazur1977
