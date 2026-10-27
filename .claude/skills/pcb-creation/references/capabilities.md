# Standard 2-layer FR-4 capabilities

Source: jlcpcb.com/capabilities/pcb-capabilities (read Oct 2026). Re-check the page for anything critical: these limits change.

| Feature | Limit |
|---|---|
| Min trace / space | 0.10/0.10 mm (1 oz); 0.16/0.16 (2 oz); 0.2/0.2 (2.5 oz); 0.25/0.25 (3.5 oz); 0.3/0.3 (4.5 oz). Width tolerance ±20%. |
| Drill diameter | 0.15–6.3 mm (0.1 mm only at ≤ 1 mm thickness with ENIG/OSP, extra cost). ≥ 6.3 mm holes are CNC-routed. |
| Via (hole / pad) | min 0.15/0.25 mm (0.1/0.2 under the same conditions). Preferred hole ≥ 0.2 mm, pad 0.15 mm larger than the hole. Surcharge for 0.1–0.15 mm holes, or 0.2/0.25 mm holes with pads < 0.45 mm. |
| PTH hole tolerance | +0.13 / −0.08 mm. Recommended PTH ≥ 0.5 mm. Position tolerance ±0.075 mm. |
| NPTH | min 0.50 mm. NPTH pad annular ring ≥ 0.45 mm. |
| Plated slot | width ≥ 0.5 mm, length ≥ 2 × width |
| Non-plated slot | width ≥ 1.0 mm, drawn on GM1/GKO |
| Rectangular (square-cornered) holes or slots | not supported |
| PTH annular ring | ≥ 0.25 mm recommended, 0.18 mm absolute (1 oz); ≥ 0.254 mm (2 oz) |
| Hole-to-hole | 0.2 mm between vias, 0.45 mm between pads |
| Clearances | via hole to track 0.2 mm; PTH to track 0.28 mm min (0.35 recommended); NPTH to track 0.2 mm; pad to track 0.1 mm |
| SMD pads | 0.15 mm between different nets; min pad 0.25 × 0.25 mm |
| Copper to edge | ≥ 0.2 mm to a routed edge or slot; ≥ 0.4 mm to a V-cut |
| Solder mask bridge | 0.10 mm at 1 oz (0.13 mm with black or white mask); 0.20 mm at 2 oz. Mask opening 1:1 with the pad, ≥ 0.09 mm to neighbouring traces. |
| Silkscreen | line ≥ 0.15 mm, text height ≥ 1.0 mm, width:height 1:6, pad to silkscreen 0.15 mm. Outline fonts: fill ≥ 0.15 mm, hollows > 0.2 mm. |
| Board size | min 3 × 3 mm (10 × 10 mm if castellated or edge-plated); max 670 × 600 mm at ≥ 0.8 mm thick (599 × 497 mm thinner). Over 200 × 250 mm, a shortfall may be refunded rather than remade. |
| Thickness | 0.4 / 0.6 / 0.8 / 1.0 / 1.2 / 1.6 / 2.0 mm; ±10% at ≥ 1 mm, ±0.1 mm below |
| Outline tolerance | ±0.2 mm (±0.1 mm precision CNC); ±0.4 mm on V-cuts |
| Copper weight (outer) | 1 / 2 / 2.5 / 3.5 / 4.5 oz |
| Dielectric constant | 4.5 |
| Surface finish | HASL (leaded or lead-free), ENIG, OSP. No HASL at ≤ 0.4 mm thick. |
| Castellated holes | ≥ 0.5 mm diameter, ≥ 1 mm from the edge, ≥ 0.5 mm apart; board ≥ 10 × 10 mm and ≥ 0.6 mm thick |
| Layers | 1, 2, 4, 6… (no 3-layer: one inner layer is built as a 4-layer board). No blind or buried vias. |

## Panels

- Boards at least 2 mm apart.
- V-cut panels 70 × 70 to 475 × 475 mm. V-cut lines are straight, run edge to edge, ≥ 2 mm apart, with zero gap between boards along the cut. No V-cut at 0.4 mm thickness. Extra charge if a board side is under 15 mm.
- JLCPCB panelises rectangles and circles only.
- "Single PCB" with your own panel: ≤ 5 designs. "Panel by Customer": ≤ 10 designs.
