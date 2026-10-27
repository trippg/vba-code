---
name: pcb-ordering
description: PCB ordering: place a JLCPCB order in the browser once the board files are ready. Uses Jev (the user's browser-use tool) to upload the Gerber zip, BOM and CPL that the pcb-creation skill created, fill in the order form, and triple-check every setting and part placement before the user pays. Use when the user says they're ready to order a board from jlcpcb.com.
---

# PCB ordering (JLCPCB, with Jev)

The files come from the `pcb-creation` skill. This skill only uploads them and fills in the form. **The user pays, never Claude.**

## Before starting

1. **Find the files** and confirm they're the latest version. For each one, give the user the full path and the date it was made:
   - the Gerber zip (e.g. `cube_bridge_v3_gerbers.zip`; upload it as is, don't unzip it)
   - the BOM (`…_BOM_JLCPCB.csv`)
   - the CPL (`…_CPL_JLCPCB.csv`)
   - the `HOW TO ORDER` notes for this board
2. **Re-run the `pcb-creation` checklist** (its audit script, if the board has one) on exactly these files. Don't continue with any failure.
3. **Confirm the order details with the user:**
   - board quantity (5 minimum) and how many to assemble
   - PCB colour
   - assembly type (Economic or Standard, from the board's notes)
   - shipping method
4. **Jev must be running on the user's computer,** with the files reachable from there (e.g. in OneDrive). Claude doesn't type passwords: the user logs in to jlcpcb.com in the Jev browser.

## Filling in the order (Jev)

Use Jev for every step, and take a screenshot after each one.

1. **Upload the Gerbers.** Go to jlcpcb.com → Order Now → Add gerber file → upload the Gerber zip. Wait for the viewer to finish.
   - Check that the detected layer count and size match the board's notes (e.g. 2 layers, 60 × 40 mm).
   - Look at the viewer: outline present, holes on the pads, printing readable.
2. **Set the board options** from the notes:
   - base material FR-4
   - layers
   - thickness (1.6 mm unless the notes say otherwise)
   - quantity
   - colour
   - surface finish
   - "Mark on PCB": remove it if that's free, otherwise accept it
   Leave every other option at its default unless the notes say otherwise.
3. **Turn on PCB Assembly:**
   - PCBA type exactly as in the notes
   - assembly side
   - PCBA quantity
   - tooling holes: "added by customer" if the board has them
   Then Confirm.
4. **Upload the BOM and the CPL.**
5. **Parts page:** every row must show a matched part with the right LCSC number and enough stock. Stop and tell the user about any unmatched row, shortage or substitution. **Never accept a substitute part without the user's OK.**
6. **Placement preview:** check every polarised or multi-pin part against the notes (pin-1 dots and capacitor "+" on the square pads, connectors facing the right edge).
   - Rotate any that are wrong, then screenshot again.
   - Re-download or note any rotation changed, so the CPL can be updated to match.
7. **Remarks:** leave the remark box empty unless the notes need one.

## Triple check (before the user pays)

Do all three passes and report each one separately.

1. **Pass 1, the form against the notes:** re-read every field on the summary page (board options, assembly options, quantities) against the board's notes and what the user confirmed above.
2. **Pass 2, the parts against the files:**
   - The parts list on the site has the same count and LCSC numbers as the BOM file.
   - The placement preview has every designator from the CPL, with nothing missing, nothing extra, and polarity right.
3. **Pass 3, a fresh look:** reload the order summary and go through it from the top with fresh eyes. Compare the total cost against the expected range, and explain any fee you can't account for.

Then show the user:
- the summary screenshot
- the three pass results
- the total price and delivery estimate

and **stop at the payment step.** The user reviews it and pays themselves. If anything changed during the passes, run all three again.

## Never

- Enter card details, passwords or login codes.
- Click Pay, Place Order or Submit Payment.
- Change the design files, or accept part substitutions or "engineer suggestions", without the user's OK.
- Work on a repeat order: repeat orders reuse the old files exactly. Upload the new files as a new order instead.
