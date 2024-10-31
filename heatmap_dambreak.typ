#import "./lib/blocks.typ": draw_blocks

#let latex_textwidth_factor = 0.8
#let margin = 0mm

#set page(width: auto, height: auto, margin: margin)
#set text(font: "New Computer Modern", size: 10pt/latex_textwidth_factor)
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
  input: "dambreak_wet_200x32_15s",
  cmap: color.map.mako.rev(),
  // cmap: color.map.crest,
  label_percent: false,
  label_percent_outer: false,
  round_digits: 0,
  //
  // case heatmap: false
  // 
  nx: 37,
  ny: 30,
  blocksizeX: 7,
  blocksizeY: 7,
  nOuterLayers: 2,
  scale: 1.2
)

#draw_blocks(params)