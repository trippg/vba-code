---
name: jlcpcb-ordering
description: Prepare and check PCB files before ordering from JLCPCB, for bare boards or assembled boards (PCBA). Use when generating or reviewing Gerbers, drill files, BOM or CPL (placement) files for JLCPCB, checking a design against JLCPCB's manufacturing and assembly rules, choosing JLCPCB/LCSC parts, reading JLCPCB's DFM results, or when the user asks how to order from jlcpcb.com.
---

# JLCPCB ordering

Built from JLCPCB's help centre (ordering instructions; PCB Files Preparation; PCBA Technical Guidelines; PCB Layout Ordering; DFM Tool Help; capabilities pages; parts library), read Oct 2026. Exact numbers live in the reference files:

- `references/files-and-drill.md`: layer names, drill files, packaging, per-CAD export settings
- `references/capabilities.md`: standard 2-layer FR-4 manufacturing limits
- `references/assembly.md`: PCBA rules, BOM/CPL formats, parts library, THT, inspection
- `references/dfm-and-layout.md`: reading JLCPCB's DFM tool, fixing drill format, the PCB Layout service

**JLCPCB builds only from the Gerber and drill files.** PDFs, notes and spreadsheets in the zip are ignored, and if a zip has both design files and Gerbers, the Gerbers win. Anything that can't be expressed in the files goes in the order remark (sparingly: English remarks slow the review).

## Workflow

1. **Choose the service.** Bare boards only, or PCBA? For PCBA, pick **Economic** (one side, 10×10 to 470×500 mm, needs tooling holes, no rails) or **Standard** (both sides, boards from 70×70 mm; smaller boards get 5 mm rails added). See `references/assembly.md`.
2. **Design to the limits** in `references/capabilities.md`. Use the house rules below unless the design needs tighter ones.
3. **Export** RS-274X Gerbers and Excellon drills with the names in `references/files-and-drill.md`.
4. **Check** with the checklist below, and read the files back with a Gerber viewer (gerbv, tracespace, pygerber) before handing them over.
5. **For PCBA, write the BOM and CPL** in JLCPCB's exact column format. Every BOM row needs an LCSC/JLCPCB part number, and the part must exist in the JLCPCB parts library.
6. **Tell the user what to check** on JLCPCB's site: the DFM result and the placement preview (polarity and rotation of every polarised or multi-pin part).

## House rules (comfortable margins over JLCPCB's limits)

| Item | Use | JLCPCB limit |
|---|---|---|
| Trace / space | ≥ 0.25 / 0.3 mm | 0.10 / 0.10 mm (1 oz) |
| PTH annular ring | ≥ 0.3 mm | 0.18 mm absolute, 0.25 recommended |
| PTH hole | ≥ 0.6 mm for parts | 0.15 mm min; ≥ 0.5 mm recommended |
| Copper to board edge | ≥ 0.5 mm | 0.2 mm routed; 0.3 mm for Economic PCBA |
| Silkscreen | text ≥ 1.0 mm tall, strokes ≥ 0.15 mm | same |
| Pad to silkscreen | ≥ 0.15 mm (silk over a pad is removed) | 0.15 mm |

## Checklist before giving files to the user

**Gerber zip**
- [ ] One flat `.zip` with English file names and no special characters: Gerbers and drill files only.
- [ ] Copper (`GTL`/`GBL`), solder mask (`GTS`/`GBS`), top silkscreen (`GTO`), outline (`GKO`). An order missing the outline or drill is **cancelled**.
- [ ] **Exactly one outline layer**, continuous (watertight), with all slots, cutouts and V-cuts on it. No keep-out layer exported as `.GKO`.
- [ ] Drill file(s) are self-contained: header with `M48`, units, zero mode and a full tool list (`T1C0.800`…). Plated and non-plated holes are in **separate files** (`-PTH.drl` / `-NPTH.drl`), and plated slots sit in the plated drill file.
- [ ] RS-274X (not RS-274-D). Avoid Gerber X2 unless the CAD guide says otherwise.
- [ ] Read back with a viewer: outline present and closed, holes centred on pads, mask openings on every pad, silkscreen readable.

**Design**
- [ ] Everything within `references/capabilities.md`. No rectangular (square-cornered) slots. Plated slots ≥ 0.5 mm wide and ≥ 2 × as long as wide. Non-plated slots ≥ 1.0 mm.
- [ ] Silkscreen text ≥ 1 mm tall with ≥ 0.15 mm strokes.
- [ ] Boards ≤ 50 × 50 mm: suggest a panel, since tiny boards mill poorly.
- [ ] Solder-mask-defined pads, mask bridges, edge plating, via filling (`sk` layer) and plated slots each need a remark (wording in the references).

**Assembly (PCBA)**
- [ ] Economic: three 1.152 mm non-plated tooling holes in opposite corners, with 0.148 mm mask expansion. Standard: 5 mm rails and 1 mm fiducials, or let JLCPCB add them.
- [ ] Copper and parts ≥ 0.3 mm from the board edge (Economic boards are routed apart at ±0.2 mm).
- [ ] Every polarised part is marked on the silkscreen (pin-1 dot, "+", diode band). JLCPCB sets polarity **from the silkscreen** and it beats the CPL.
- [ ] BOM columns `Comment, Designator, Footprint, LCSC Part #`. CPL columns `Designator, Mid X, Mid Y, Layer, Rotation`, in mm. Designators identical in both files (they're upper-cased), each used once, ≤ 200 per BOM row, coordinates ≥ 0.2 mm apart.
- [ ] Parts the customer fits (modules, displays) are left out of both BOM and CPL.

## Ordering habits

- Repeat orders reuse the old production files exactly and aren't re-checked: never request changes on a repeat order. Upload a new design instead.
- Orders beyond capabilities are cancelled by email after review, so check before paying.
- Choose "Confirm Production File" when anything unusual is remarked (SMD pads, edge plating, copper-core heatsink pads), then inspect the processed Gerbers JLCPCB sends.
- Base-material markings may appear on any board and can't be removed.
- The website's Gerber viewer is a quick preview only. The DFM tool is better, but its green result only means that one rule passed.
- Test boards on arrival. Faults found only after reordering are covered for the first order only.
