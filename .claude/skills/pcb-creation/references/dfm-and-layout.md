# DFM tool and PCB Layout service

Sources: jlcpcb.com/help/article/dfm-analysis-result-view-help, dfm-main-interface-help-pcb (read via the HK and KR copies, since the English page was empty), dfm-drill-layer-format-adjustment, why-are-drill-holes-not-aligned-with-the-copper-layer, instructions-for-pcb-layout-ordering, how-do-i-place-a-layout-order. Read Oct 2026.

## Using JLCPCB's DFM tool

- **Main screen:**
  - Views: Gerber, Wireframe, 2D and 3D simulation, with a metric/imperial toggle and layer visibility. Unrecognised layers appear under "miscellaneous layers"; hover over one to see the source file name.
  - **[DFM Check]** runs the analysis.
  - The **Overview** tab shows board info, useful for cost.
  - The **All** tab lists every check with red/orange/green counts and a Detail button. The button's colour is the worst level found.
- **Reading results:**
  - The title bar reads "Module > Item", e.g. "Routing Layer Analysis > Trace Spacing".
  - Each layer shows (Danger, Warning, Good) counts, e.g. "Top Layer (50, 0, 0)".
  - **Value** is usually a distance; items with no value (e.g. dangling trace ends) are always Warning or Danger.
  - **Objects** are shown as primitives in mil: `r3.94` = 3.94 mil circle, or trace width; `rect20x30`; `oval20x50`; designators for component checks; "null" for one-object checks.
  - Only the 50 worst results are kept for each item.
  - The rules panel gives each level's thresholds and explains the production risk.
- **How to act on it:**
  1. First confirm the files were parsed correctly: outline, layer count, drills aligned.
  2. Review **Danger** before Warning.
  3. Danger or Warning doesn't automatically mean "can't be made": judge the value against `capabilities.md`.
  4. Green means that one rule passed, not the whole board.
  5. Re-run DFM after every change.

## Fixing a misread drill file

Many Excellon files omit units, zero mode or digit format. DFM guesses these (right about 99% of the time).
- **A wrong guess shows** as holes squeezed into a corner or spread beyond the board, instead of centred on their pads.
- **To fix it:**
  1. Open the PCB DFM (non-simulation) view.
  2. Top right, click **[Drill Format]**.
  3. Set Coordinates (Absolute/Relative), Zero mode (Leading/Trailing), Decimal digits (e.g. 3:5 = 3 before and 5 after the point, so `-04532700` = −45.327) and Unit (Metric/Imperial).
  4. With several drill files, click **[Apply to All Layers]**, then **[Confirm]**.
- **If spacing is right but sizes are wrong,** change the unit.
- **If a file keeps both leading and trailing zeros,** choose Trailing.
- **JLCPCB's wording of Leading/Trailing reads backwards** against the usual Excellon meaning, so judge by on-screen alignment, not the labels. Don't copy the article's example setting (Trailing for an `LZ` file) onto other files.
- **To avoid the problem,** write drill files with explicit decimal points and a full header (`M48`, `METRIC` or `INCH`, tool list).
- **If holes still don't line up:** make pads single round or rectangular objects, not shapes built from line segments (about 80% of pads is enough to align; round via pads usually are). NPTH-only boards can't be auto-aligned.

## PCB Layout service (JLCPCB designs the board)

Separate from manufacturing: you supply a schematic and requirements, and JLCPCB's engineers lay out the board.

- **Quote categories:**
  - **Normal:** through-hole vias only, few high-speed or high-power signals, placement not dense.
  - **Power:** power region > 30% of the design.
  - **High-speed:** ≥ 1 GHz signals, EMI or radiation control, or Rogers/PTFE material.
  - **HDI:** microvias < 0.15 mm, > 130 pins per square inch, < 3/3 mil trace/space, or ≥ 8 dense layers.
- **What you provide:**
  - Size limit (rectangular by default).
  - Layer count (treated as a maximum).
  - Pad count (SMD plus through-hole).
  - Requirements file (.xlsx template on the order page).
  - Schematic and PCB (.zip/.rar, any EDA; EasyEDA Pro preferred), with all footprints included. Missing footprints may cost extra, and they may ask for the BOM and datasheets.
  - Other files (DXF, datasheets).
- **What you get:** Gerber RS-274X, CPL, BOM, DXF, a 3D model (OBJ; STEP via EasyEDA Pro), an assembly-drawing PDF, the source files and production instructions (stack-up, impedance).
- **Ordering steps:**
  1. Go to design.jlcpcb.com and choose "Start a Layout Quote".
  2. Upload the requirements and design files.
  3. Enter the known details to get a quote and lead time.
  4. Submit the order.
  5. Engineers review it and email a payment request; pay from Order History.
