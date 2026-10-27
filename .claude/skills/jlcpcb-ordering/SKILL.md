---
name: jlcpcb-ordering
description: Prepare and check PCB files before ordering from JLCPCB (bare boards or assembled). Use when generating Gerbers, drill files, BOM or placement (CPL) files for JLCPCB, when reviewing a design against JLCPCB's ordering rules, or when the user asks how to order a board from jlcpcb.com.
---

# JLCPCB ordering

Rules from JLCPCB's ordering guide (https://jlcpcb.com/help/article/instructions-for-ordering, updated Sep 2026), plus the file formats their assembly service expects. Check every item before handing files to the user. JLCPCB builds **only from the Gerber files**: notes, PDFs, DXFs and spreadsheets inside the zip are ignored, and if a zip has both design files and Gerbers, the Gerbers win.

## Gerber zip: must-haves

- **Board outline:** exactly one complete outline layer (e.g. `.GKO`). Delete any extra mechanical layers (`GM`, `GM1`…); with several, JLCPCB picks `GM`/the lowest-numbered `GM` and ignores the rest. Slots, cutouts, milling and V-cuts go on that same outline layer, drawn about 0.15 mm wide (wider lines are cut along their centre).
- **Drill file** (Excellon). An order missing the outline or drill layer is **cancelled**. If a board genuinely has no holes, say so in the order remark.
- **Solder mask layers** (top and bottom). If missing or blank, the whole board is covered in mask with no pad openings.
- **Copper layers** for every layer ordered. There is no 3-layer process: a "4-layer" order with only one inner layer is queried.
- **Solder paste layer:** only needed for a stencil or SMT assembly. A through-hole-only board can leave it out.

## Design rules to check

| Item | Rule |
|---|---|
| Silkscreen text | Stroke width **≥ 0.15 mm**, gap between letters ≥ 0.15 mm, height **≥ 1 mm**, width:height about 1:6. Outline fonts: fill lines ≥ 0.15 mm, hollow parts > 0.2 mm. Thinner text may be widened or come out unclear, and complaints aren't accepted. |
| Silkscreen over openings | Pad openings win: silkscreen on a pad is removed unless remarked. |
| Solder-mask bridges | Need ≥ 0.2 mm pad-to-pad spacing on 1–2 layer boards (0.1 mm multilayer), and a note in the order remark. |
| Plated slots | Width ≥ 0.5 mm, length ≥ 2 × width, rounded ends, in the drill layer. |
| Edge plating | Mark the location on a Gerber layer and in the remark; choose "Confirm Production File". |
| Small boards | Boards ≤ 50 × 50 mm mill poorly: suggest panelising. |
| Large boards | Boards > 200 × 250 mm: shortfall may be refunded instead of made up. |
| Panels | JLCPCB panelises only rectangles and circles (V-cut). "Single PCB" with a self-made panel: ≤ 5 designs. "Panel by Customer": ≤ 10. |

Base-material markings may appear and can't be removed. The website's Gerber viewer is only a quick preview, so check the real files too.

## Ordering habits

- **Avoid the remark field** unless a rule above needs it: orders with English notes take longer in review.
- **Repeat orders** reuse the previous production files exactly and aren't re-checked, so never ask for changes on a repeat order. Upload a new design instead.
- Orders beyond JLCPCB's capabilities, or with missing layers, are cancelled by email after review. Check before paying.
- Test boards on arrival. Problems found only after reordering are covered for the first order only.

## Assembly files (PCBA)

Upload these alongside the Gerber zip on the assembly step. Parts must exist in JLCPCB/LCSC's catalogue.

**BOM** (CSV or XLSX), one row per part value:

| Comment | Designator | Footprint | LCSC Part # |
|---|---|---|---|
| 220Ω | R1,R2,R3 | AXIAL-0.4 | C… |

**CPL / placement** (CSV), one row per part, in mm from the board's bottom-left corner, top-view:

| Designator | Mid X | Mid Y | Layer | Rotation |
|---|---|---|---|---|
| R1 | 31.08mm | 30.27mm | Top | 0 |

- Through-hole parts are assembled too (choose a service that includes through-hole). Footprint origins and rotations differ between libraries, so **check every part in JLCPCB's placement preview** and rotate any that are off before paying.
- Mark parts the customer will supply or fit themselves as "do not place" by leaving them out of the BOM and CPL.

## Checklist to run before giving files to the user

1. Zip has one outline layer, drill, both copper layers and both mask layers, and nothing that relies on notes.
2. All silkscreen text ≥ 1 mm tall with ≥ 0.15 mm strokes.
3. Board size, slots and panel settings are within the rules above.
4. BOM and CPL designators match exactly, every BOM row has an LCSC part number, and part polarities are marked on the silkscreen (pin-1 dots, + signs).
5. Tell the user which parts to double-check in JLCPCB's placement preview (polarised and multi-pin parts).
