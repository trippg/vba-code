# Assembly (PCBA)

Sources: jlcpcb.com/capabilities/pcb-assembly-capabilities and these help articles: bill-of-materials-for-pcb-assembly, pick-place-file-for-pcb-assembly, advice-for-bom-and-cpl-files-preparation, pcb-assembly-faqs, pcb-assembly-faqs-part-2, how-to-add-tooling-holes-for-pcb-assembly-order, how-to-add-edge-rails-fiducials-for-pcb-assembly-order, panelizing-your-pcb-for-assembly, minimum-spacing-for-smd-components, moisture-sensitivity-level-msl-for-electronic-parts, smt-stencil-data-prepared-for-smt-orders, pcba-visual-inspection-polarity-solder-joints-guide, x-ray-inspection-report-interpretation-guide. Also the parts library at jlcpcb.com/parts. Read Oct 2026.

## Economic vs Standard

| | Economic | Standard |
|---|---|---|
| Sides | one (SMT and through-hole) | one or both |
| Layers / thickness | 2, 4, 6 layers; 0.8–1.6 mm | 1–32 layers |
| Single board size | 10 × 10 to 470 × 500 mm | 70 × 70 to 460 × 500 mm (smaller boards get 5 mm rails on two sides, snapped off at a V-cut) |
| Panel size | 10 × 10 to 250 × 250 mm | 70 × 70 to 250 × 250 mm |
| Quantity | 2–50 | larger runs |
| Rails / fiducials | not needed | needed (or added by JLCPCB) |
| **Tooling holes** | **mandatory** | — |
| Smallest parts | 0402, 0.4 mm IC pitch, 0.5 mm BGA | 01005, 0.35 mm IC pitch, 0.3 mm BGA |
| Not available | V-cut, gold fingers, castellations, edge plating | — |
| Reflow | 255 ± 5 °C, fixed | 240 ± 5 °C, with solder-paste inspection |

Economic boards are routed apart at about ±0.2 mm, so keep copper and parts ≥ 0.3 mm from the edge.

## Board features for assembly

- **Tooling holes (Economic):** 2–3 holes in opposite corners, as far apart as practical, in empty space.
  - Each one: 1.152 mm (45.4 mil) round, **non-plated**, with 0.148 mm solder-mask expansion.
  - Holes that don't meet this are ignored, and JLCPCB adds its own.
- **Edge rails (Standard):** ≥ 5 mm wide. Boards ship with the rails on; removal must be requested and costs extra.
- **Fiducials:** undrilled round copper pads with no mask: 1 mm pad in a 2 mm mask opening. Place 3–4 along the edges, ≥ 3.35 mm from the edge. A second article gives 3.85 mm from a panel edge and 2 mm tooling holes on panel rails. JLCPCB can add fiducials itself.
- **Panels for assembly:**
  - Side 150–200 mm with 2–6 boards is suggested. "Panel by JLC" above 50 boards.
  - Panelising avoids the minimum processing charge of $0.46 per board.
  - With "Panel by JLCPCB", fiducials and tooling holes go on the rails only.
  - BOM/CPL options: "Single Piece, please help me repeat the data" (your files describe one board) or "Complete File" (your files cover the whole panel).

## Spacing between SMD parts (mm)

| | 0201/0402 | 0603/0805 | 1206 | SOT | SOP | QFP | QFN | BGA |
|---|---|---|---|---|---|---|---|---|
| chip 0201/0402 | 0.15 | 0.18 | 0.25 | 0.2 | 0.4 | 0.5 | 1.0 | 1.0 |
| chip 0603/0805 | 0.18 | 0.18 | 0.25 | 0.2 | 0.4 | 0.5 | 1.0 | 1.0 |
| chip 1206 | 0.25 | 0.25 | 0.35 | 0.2 | 0.4 | 0.5 | 1.0 | 1.0 |
| SOT | | | | 0.4 | 0.4 | 1.0 | 1.0 | 1.0 |
| SOP | | | | | 0.5 | 1.25 | 1.0 | 1.0 |
| QFP | | | | | | 1.25 | 1.0 | 1.5 |
| QFN | | | | | | | 1.0 | 1.5 |
| BGA | | | | | | | | 2.0 |

The reflow guide suggests ≥ 0.3 mm pad spacing to avoid solder bridges.

## Polarity and orientation

- **Engineers set polarity from the silkscreen.** With no mark, the order waits on an email. If the silkscreen and the CPL disagree, the silkscreen wins.
- **Mark every polarised part:**
  - IC pin-1 dot.
  - "+" on polarised capacitors.
  - Diode cathode band, or a triangle pointing at the cathode.
  - LED footprints matching the exact part's anode/cathode (generic LED footprints often end up reversed).
- **In the DFM/placement view:**
  - For diodes, "+" is the anode and "−" the cathode. For polarised capacitors, "+" is the anode.
  - The red dot is the IC orientation mark. It isn't strictly pin 1: a part is right when the dot on the part matches the dot on the board.

## BOM

- **Columns:** `Comment` (value/spec), `Designator`, `Footprint`, `LCSC Part #` (or `JLCPCB Part #`) for automatic matching. File type `.csv`, `.xls` or `.xlsx`.
- **Designators:**
  - Converted to upper case, so never tell parts apart by case.
  - Each one appears only once in the whole BOM.
  - At most 200 per row: split longer rows.
  - Use standard prefixes (R, C, U, J, D…).
- **Part numbers:** give the full MPN or a JLCPCB/LCSC part number. Vague text such as "LED 0805 red" isn't enough.
- **Matching:** only parts that are matched and confirmed are bought and placed. Unmatched lines are left unplaced.
- **Parts the customer fits themselves:** leave them out of both BOM and CPL. Unassembled parts can't be shipped loose with the boards.

## CPL (placement)

- **Columns:** `Designator`, `Mid X`, `Mid Y`, `Layer` (`Top`/`Bottom`), `Rotation`. File type `.csv`, `.xls` or `.xlsx`.
- **Coordinates:** the part's centroid in mm, one unit throughout. Rotation in degrees, positive = counter-clockwise.
- **Layers:** top and bottom go in one file.
- **KiCad `.pos`:** rename `Ref, PosX, PosY, Rot, Side` to `Designator, Mid X, Mid Y, Rotation, Layer`.
- **Matching the BOM:** designators must match exactly. Only parts in both files are assembled. Any two parts' coordinates must be ≥ 0.2 mm apart.
- **Through-hole parts** need CPL rows too.
- **Rotation:**
  - A footprint's 0° should match how the part sits in its tape, which can differ between part numbers in the same package.
  - If the placement preview is wrong, change `Rotation` (or `Mid X`/`Mid Y`) and re-upload.
  - If left uncorrected, engineers fix rotation and polarity from the silkscreen.
- **File hygiene:** no Excel error triangles (paste into a fresh sheet if needed), no special characters in file names.

## Parts library (jlcpcb.com/parts)

- **700k+ in stock,** with live prices. Each part page shows its JLCPCB/LCSC number, its **Basic/Promotional** or **Extended** status, its assembly type (SMT, or "Wave Soldering" for through-hole) and the PCBA types it supports (Economic and/or Standard).
- **Basic parts** are kept loaded on the machines. **Extended parts** carry a per-part loading fee, shown at order time. Prefer Basic parts where the design allows.
- **Bought parts** are kept in your JLCPCB parts library for future PCBA orders and can't be shipped separately.
- **Private library:** pre-order and reserve parts free.
- **Global sourcing:** for parts not listed.
- **Consignment:** ship your own parts to JLCPCB.
- **Check before writing a BOM row:** look up the part at `https://jlcpcb.com/partdetail/<C-number>`, and confirm it supports the PCBA type you're ordering and is in stock.

## Through-hole (THT) assembly

- Through-hole parts marked "Wave Soldering" in the library are **hand-soldered**: about $3.50 labour per order plus about $0.0173 per joint, and about 1 extra day.
- Tall, rough-topped or hard-to-pick parts are placed by hand.
- Through-hole parts get no stencil openings.
- Parts needing extra work (hardware, cables, heatsinks) are "Mechanical assembly components": set PCBA remark = Yes and describe the method, or attach instructions.

## Stencil (SMT orders)

- Stencil data comes from JLCPCB's verified part data, not your paste layer. Openings are made only for the parts being placed.
- Remark any special paste: a battery-holder centre pad, paste on pads with no part (give locations), BGA paste volume. Step stencils are offered for very mixed sizes.
- The stencil isn't shipped with SMT orders; its data is kept for repeats.
- Via-in-pad wicks solder away: use filled or capped vias.

## Moisture sensitivity (MSL)

Floor life out of the bag at 30 °C / 60% RH:

| MSL | Floor life |
|---|---|
| 1 | unlimited |
| 2 | 1 year |
| 2a | 4 weeks |
| 3 | 168 h |
| 4 | 72 h |
| 5 | 48 h |
| 5a | 24 h |
| 6 | bake, then solder at once |

- JLCPCB offers baking at 60 °C for 48 h.
- Boards with many MSL ≥ 3 LEDs: choose baking and a functional test, or after-sales claims are void.
- Functional test (Standard only): about $16 setup plus about $8 an hour, with your test procedure.

## On arrival

- **Setup:** an ESD-safe bench, a magnifier (5–10×, or 10–20× for 0.4 mm pitch), judged against IPC-A-610 Class 2 using the BOM, the assembly drawing and the order's DFM analysis.
- **Board:** warpage, chipped edges, scratches through to copper, flux residue (no-clean paste; boards aren't washed).
- **Parts:** orientation against the DFM drawing (diodes, LEDs, electrolytic and tantalum capacitors, ICs, connectors), and wrong or missing parts against the selected parts list.
- **Solder:** bridges (fine-pitch parts, headers), tombstoning (0402/0603), cold or open joints, misalignment, solder balls.
- **Hidden joints** (BGA/QFN): Order History → Production Progress → X-Ray Report. More than about 25% voiding is a concern.
- **First power-on:** inspect with the power off first. Measure resistance between the supply rails for shorts, then voltages at key points.
- **Reporting a defect:** put a red-dot sticker beside it (not on an IC or gold fingers), bag the board separately, and send the order number, counts, and overall and close-up photos or video.
