# Files, naming and drill rules

Sources: jlcpcb.com/help/article/suggested-naming-patterns, gerber-files-preparation, manually-adding-tool-list-for-a-drill-file, how-to-order-boards-with-solder-mask-defined-pads, and the per-CAD export guides in the "PCB Files Preparation" catalog.

## Layer names JLCPCB recognises (Protel extensions)

| Extension | Layer |
|---|---|
| `.GTL` / `.GBL` | top / bottom copper |
| `.G2L`, `.G3L`… (or `.G1`, `.G2`… from Eagle/Altium/KiCad) | inner copper, numbered in stack-up order. A skipped number causes a layer-count mismatch and stops the job. Negative planes `GP1`/`GP2` aren't looked for. |
| `.GTS` / `.GBS` | top / bottom solder mask (required: missing or blank means the whole board is masked) |
| `.GTO` / `.GBO` | top / bottom silkscreen |
| `.GTP` / `.GBP` | top / bottom paste (only for stencils or SMT) |
| `.GKO` or `.GM1` | board outline, plus slots, cutouts and V-cuts |
| `.XLN` (also `.TXT` from Altium, `.drl` from KiCad/EasyEDA) | drills |
| drill map / drawing | "highly recommended", optional |
| `sk` | vias to fill (ink, epoxy or copper paste); remark the layer name and its use |

- **Outline priority** when several exist: `GM` layers beat others, and the lowest number wins (`GM3` beats `GM`/`GM7`). If only one layer has a complete outline, that one is used. Keep only one, and never export a keep-out layer as `.GKO` unless it is the outline.
- **Extra layers** (stiffener, heatsink pad, extra `GM`…) are ignored unless their purpose is in the remark.
- **Other CAD tools' extensions** must be renamed to the pattern above: Proteus `.TXT` Gerbers, ORCAD/Allegro `.PHO`/`.ART`, PCB Wizard `.gb0`–`.gb3`.
- **Tap drill files:** only `thruhole.tap` is recognised; otherwise use `.XLN`.
- **Packaging:** one `.zip` or `.rar`, files at the top level, English names, no special characters, Gerbers and drills together.
- **Format:** RS-274X required; RS-274-D isn't supported. Gerber X2 advice conflicts: the Eagle, Proteus and Altium guides say don't use X2, while the KiCad 9 guide ticks it. When in doubt, use plain RS-274X.

### Common errors

- "Could not find drill file" on a 4-layer board usually means blind/buried vias were enabled. JLCPCB doesn't support them.
- "Board Outline Not Found" means the outline is on the wrong layer.

## Drill files

- **Excellon 2** is assumed. Say "Excellon 1" in the remark if that's what it is, or holes can be misread.
- **Self-contained header**: `M48`, units (`METRIC` or `INCH`), zero mode (`LZ`/`TZ`), a full tool list, then `%`. Common faults are a missing header, a missing tool list, or no units or zero mode.
- **Manual tool-list fix** (CAD tools that put sizes in a separate `.inf` or report file):
  1. Write one line per tool: `T1C0.45`, `T2C0.79`… Delete everything else.
  2. Paste the lines between `M48` and `%`, adding those lines if missing.
  3. Use the same unit as the coordinates (mil to inch: ÷ 1000, so 157.4 mil = `T01C0.1574`).
  4. Add the unit after `M48` if known; otherwise CAM works it out.
- **Protel `T01F00S00` lines** carry no size: replace them.
- **Plated vs non-plated:** separate files are accepted and recommended, e.g. KiCad `-PTH.drl` / `-NPTH.drl`, EasyEDA `Drill_PTH_Through.DRL` / `Drill_NPTH_Through.DRL`, Altium's "separate plated/non-plated". Eagle's CAM job merges them into one `.XLN`.
- **Plated slots** go in the plated drill file, and need a remark such as "Please note: there are 3 plated slotted holes in this design". Minimum width: the general rule is 0.5 mm (the Eagle and Proteus guides say 0.65 mm), and length ≥ 2 × width.
- **Units:** each Excellon file states its own, so inch drills with mm Gerbers are fine.
- **Oval holes:** KiCad "alternate drill mode". CircuitMaker uses `G85` slots.

## Solder-mask-defined (SMD) pads

The mask must overlap the copper by ≥ 0.076 mm (3 mil) on every side. The order form has no option for this, and CAM will otherwise enlarge the openings (ruining the boards), so:
1. Remark: "Please note: Parts U1, U2, … utilize Solder Mask Defined Pads. Please do not adjust or modify the solder mask for these components."
2. Set **Confirm Production File = Yes**, then inspect the processed Gerbers JLCPCB sends.

## Special boards

- **Copper core:** direct heatsink pad separate from the connecting pads, ≥ 1 mm wide. Show it on its own layer or as a screenshot, remark it, and choose Confirm Production File.
- **Flex:** same as FR-4, plus a stiffener layer with position and thickness, remarked.

## Per-CAD export settings (condensed)

- **KiCad 9:** RS-274X, Protel extensions on, 4.6 mm, 1:1, filled, drill marks none, check zone fills, X2 on.
  - Layers: F/B.Cu, F/B.Mask, F/B.Silkscreen, Edge.Cuts, plus F/B.Paste for assembly, plus In1…In(n−2).
  - Drill: Excellon, alternate oval mode, absolute origin, mm, decimal zeros, PTH and NPTH in separate files.
- **KiCad 7/8:** Protel extensions, plot reference designators, check zone fills, subtract soldermask from silkscreen (KiCad 8 also: plot footprint text, tent vias). Same drill settings, and a drill map in Gerber format.
- **KiCad 6:** as 7/8 with X2 ticked, mirror off, zip with the drill map.
- **KiCad 5:** File → Plot. Exclude PCB edge from other layers, exclude pads from silk, Protel extensions, subtract mask from silk. Same drill settings.
- **KiCad in a non-English language:** Protel extensions are required, and `Edge_Cuts.gbr` must be renamed to `.GKO`.
- **Altium 24/25/26:**
  - Gerber: "Gerber Files" (not X2), mm, 4:4, include unconnected mid-layer pads, merge regions off.
  - Layers: GM outline (GKO only if there's no GM), GTL/GBL, GTO/GBO, GTS/GBS, GTP/GBP.
  - NC drill: inches 2:5, keep zeros, absolute origin, separate plated/non-plated files.
  - Zip the output folder flat.
- **Eagle:** use JLCPCB's CAM jobs (`jlcpcb_2/4/6_layer_v9.cam` for 8.6–9.6.2; `_v72` for 7.2–8.5.2, where a wrong job makes "holes scale up 10×"; `_v6` for ≤ 7.1). No X2.
  - Outline: watertight on layer 20. Plated slots on Milling 46 as zero-width lines.
  - Delete the `.gpi`/`.dri` files before zipping.
- **EasyEDA:** File → Generate PCB Fabrication File. The `.GTA`/`.GBA`/`.GML`/`.GDL` files are informational only. Drill format 3:3 (4:2 for large boards).
- **Proteus:** Output → Gerber/Excellon, RS-274X, no X2. Untick "Edge (will appear on all layers)". Outline and cutouts on Mech 1, with Slotting/Routing layer = Mech 1.
- **CircuitMaker 2:** embedded apertures. Don't tick Keep-Out. NC drill 2:4, absolute, separate PTH/NPTH, G85 slots.
- **PCB Wizard:**
  1. Export RS-274X, one file per layer, then rename `.gb0`→`.GKO`, `.gb1`→`.GBL`, `.gb2`→`.GTL`, `.gb3`→`.GTO`.
  2. Export again with "pads only" for the masks.
  3. Add the tool list from the `.inf` file to the drill file.
- **Fritzing:** File → Export → for Production → Extended Gerber, then zip the folder.
- **DipTrace / Sprint Layout:** Export All Gerbers plus NC Drill. The guides give settings only as screenshots.
- **PCBE:** split the combined header line `%ASAXBY*OFA0B0*MOMM*FSLAX43Y43*IPPOS*%` into separate `%…*%` lines in every file.
