# Tumbuh Cap Pilot

A small, open-hardware experiment in **gravity-separated plant metabolism**.

The cap keeps two paths legible and physically distinct:

- **clean path** — known water enters through an isolated tube;
- **living path** — mulch, biochar, microbes, and later detritivores process organic material in a removable cartridge;
- **root interface** — gravity delivers the resulting moisture and soluble nutrients downward without a pump.

The goal of version 0 is not to simulate an entire ecosystem. It is to establish a serviceable physical interface whose claims can be tested one at a time.

## What is in this repository

- [`cad/tumbuh_cap_v0.scad`](cad/tumbuh_cap_v0.scad) — parametric OpenSCAD source for the cap, reactor cartridge, split plant collar, and fit coupon.
- [`index.html`](index.html) — public project page and pilot checklist.

The generated rendering that inspired the architecture is a design prompt, not a dimensioned manufacturing drawing. The SCAD file is the first executable specification.

## Design invariants

1. **Clean water never passes through the organic cartridge.**
2. **Dirty or biologically active material remains removable.**
3. **Gravity is the only required transport mechanism.**
4. **Every hidden channel has a visible service point.**
5. **A failure should drain visibly rather than silently flood the roots.**
6. **Living tissue never bears directly against a hard printed edge.**

## Version 0 architecture

The 120 mm cap carries three independently printable parts:

- a main cap with a central plant opening;
- a clean-water grommet port;
- a removable slotted reactor cartridge with a coarse mesh liner;
- a split collar insert that can be resized for different stems.

The raised line and X near the two ports are tactile channel symbols. They are deliberately asymmetric so the paths remain distinguishable when labels are wet, muddy, or unreadable.

## Before visiting IdeaSpace

1. Install OpenSCAD.
2. Open `cad/tumbuh_cap_v0.scad`.
3. Set `part = "test_coupon"` and export STL.
4. Slice the coupon for the actual IdeaSpace printer.
5. Bring the actual silicone tube, grommet, mesh, pot, and calipers.
6. Print the coupon before committing material to the full cap.

IdeaSpace currently badges patrons on Bambu Lab printers and requires a badging appointment plus an equipment reservation before independent use. Confirm material, slicer, and allowable job duration with staff before the visit.

## Print sequence

### Print 0 — fit coupon

The coupon validates:

- clean-port/grommet fit;
- cartridge clearance;
- first-layer behavior;
- wall thickness and layer adhesion.

Adjust these parameters before printing the cap:

```scad
clean_grommet_hole_d = 8.2;
cartridge_clearance = 0.45;
seat_d = 112;
```

### Print 1 — dry mechanical assembly

Export and print:

```scad
part = "cap";
part = "cartridge";
part = "collar";
```

Suggested initial settings, subject to IdeaSpace staff guidance and the selected printer:

- PETG rather than PLA for wet testing;
- 0.20 mm layers;
- 4 perimeters;
- 5 top and bottom layers;
- 25–35% infill;
- no support unless the slicer identifies an unavoidable bridge.

Do not treat a 3D print as inherently watertight or food-safe.

## Pilot gates

Do not put worms, plants, fertilizer, or valuable soil into version 0 until the preceding gate passes.

### Gate A — geometry

- cap sits stably on the chosen pot or test vessel;
- cartridge installs and removes by hand;
- plant collar does not clamp the stem;
- all drains remain inspectable.

### Gate B — clean-water isolation

Use dyed tap water in the clean tube and plain water in the cartridge.

Pass condition:

- no dyed water appears in the cartridge;
- no cartridge water appears at the clean inlet;
- all leakage is externally visible.

### Gate C — gravity flow

Run measured 50 mL inputs at several heights.

Record:

- input volume;
- time to first drip;
- total output after 5, 15, and 30 minutes;
- retained volume;
- leak location, if any.

### Gate D — clog challenge

Line the cartridge with mesh and test, in order:

1. coarse biochar;
2. damp shredded leaf litter;
3. leaf litter plus a small amount of finished compost.

Pass condition:

- drainage remains visible and serviceable;
- the cartridge can be removed without disturbing the clean path;
- a clog produces overflow at a visible location rather than pressure buildup.

### Gate E — biological microcosm

Use a sacrificial planter and a microbial cartridge first. Run a matched control planter without the cartridge. Measure soil moisture, odor, visible mold, plant condition, and drainage for at least two weeks.

Only after the microbial pilot behaves predictably should detritivores be considered. Earwigs are ecologically interesting decomposers and predators, but version 0 should not intentionally confine wild earwigs. Their appearance can be recorded as an observation rather than treated as a required component.

## Minimal bill of materials

- PETG filament;
- 6–8 mm silicone tube, selected before finalizing the port;
- matching soft grommet;
- coarse inert mesh;
- washed coarse biochar;
- catch tray or transparent test vessel;
- graduated cylinder or kitchen measuring syringe;
- calipers;
- optional food coloring for channel-isolation tests.

## Collaboration with Tumbuh / OmegaClaw

AlwaysHungrie's `tumbuh-omegaclaw-experiments` develops a verification layer for plant agents: claims are checked against the exact memory surface the agent actually uses. This hardware pilot provides a complementary physical surface: measured water input, cartridge state, drainage, and interventions can become witnessed observations rather than free-form agent claims.

A productive integration target is a tiny append-only pilot log:

```json
{
  "timestamp": "2026-08-06T19:20:00-04:00",
  "cap_version": "v0.1",
  "channel": "clean",
  "input_ml": 50,
  "output_ml_15m": 42,
  "observer": "human",
  "notes": "no cross-channel dye observed"
}
```

That is enough to begin joining physical behavior to verifiable agent memory without pretending the cap itself is autonomous.

## Attribution

Initial concept and architecture: Paul Carver Tiffany III with GPT research collaboration.

Ralf contributed the ecological observation that fallen walnuts form a dark, damp niche in which earwigs participate in decomposition and predation. That observation strengthened the design emphasis on sheltered removable habitat, gravity, and keeping clean water distinct from biologically active flow.

Hardware collaboration and agent integration are invited from AlwaysHungrie and the Tumbuh/OmegaClaw community.

## Licenses

- Hardware design files: **CERN Open Hardware Licence Version 2 — Permissive** (`CERN-OHL-P-2.0`).
- Documentation and diagrams: **Creative Commons Attribution 4.0 International** (`CC BY 4.0`).
- Software added later: **MIT License**.

This three-part licensing scheme is more precise than applying MIT to physical hardware or Creative Commons to source code.

## Safety and scope

This is an experimental garden prototype. It is not certified for potable water, food contact, pressure, electrical control, structural loading, unattended irrigation, or the containment of animals. Test outdoors or over a catch basin. Avoid anaerobic liquids, manure tea, unknown waste streams, and sealed biological chambers.
