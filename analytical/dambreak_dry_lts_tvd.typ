#import "../lib/blocks.typ": draw_blocks

#let latex_textwidth_factor = 0.8
#let margin = 1mm

#set page(width: auto, height: auto, margin: margin)
#set text(font: "New Computer Modern", size: 12pt)
#show math.equation: set text(font: "New Computer Modern Math")
#show raw: set text(font: "New Computer Modern Mono")

#let params = (
  grid: true,
  label_id: false,
  label_id_outer: false,
  // latex KOMA script textwidth -> resulting fig_width
  latex_fig_width: 157.49817mm * latex_textwidth_factor - margin, 
  //
  // case heatmap: true
  // 
  heatmap: true,
  // input: "johanna_scalar64",
  input: "analytical/dambreak_dry_lts_tvd",
  cmap: color.map.mako.slice(30, color.map.mako.len()).rev(),
  // cmap: color.map.crest,
  label_percent: false,
  label_percent_outer: false,
  round_digits: 0,
  transparent: 0%,
  legend: true,
  //
  // case heatmap: false
  // 
  nx: 37,
  ny: 30,
  blocksizeX: 7,
  blocksizeY: 7,
  nOuterLayers: 2,
  // scale: 1.2
)

#draw_blocks(params)