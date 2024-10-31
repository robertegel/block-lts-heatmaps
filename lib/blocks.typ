#import "@preview/cetz:0.2.2"

#let latex_textwidth_factor = 0.7
#let margin = 0mm

#set page(width: auto, height: auto, margin: margin)
#set text(font: "New Computer Modern", size: 10pt)
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
  heatmap: false,
  input: "random_test",
  cmap: color.map.mako.rev(),
  // cmap: color.map.crest,
  label_percent: true,
  label_percent_outer: false,
  round_digits: 0,
  legend: true,
  //
  // case heatmap: false
  //
  nx: 37,
  ny: 30,
  blocksizeX: 7,
  blocksizeY: 7,
  nOuterLayers: 2,
)

#let draw_blocks(params) = {
  let n_comp = none
  let n_Total = 0
  if params.heatmap {
    let meta = yaml("../input/" + params.input + ".yaml")
    params.nx = meta.nx
    params.ny = meta.ny
    params.blocksizeX = meta.blocksizeX
    params.blocksizeY = meta.blocksizeY
    params.nOuterLayers = meta.nOuterLayers

    if meta.keys().contains("scale") {
      params.scale = meta.scale
    }

    n_comp = csv("../input/" + params.input + ".csv", row-type: dictionary).map(row => {
      for (key, value) in row {
        row.at(key) = int(value)
      }
      return row
    })

    n_Total = n_comp.at(0).n_Full + n_comp.at(0).n_Scalar
  }

  let nx = params.nx
  let ny = params.ny
  let blocksizeX = params.blocksizeX
  let blocksizeY = params.blocksizeY
  let nOuterLayers = params.nOuterLayers
  let grad = gradient.linear(..params.cmap)

  cetz.canvas(
    length: 1mm,
    {
      import cetz.draw: *
      import "outer_blocks.typ": outer_blocks

      let _scale = params.latex_fig_width / (nx * 1mm)
      if params.keys().contains("scale") {
        _scale = params.scale
      }
      scale(_scale)

      let nxInner = nx - 2 * nOuterLayers
      let nyInner = ny - 2 * nOuterLayers
      let nFullX = int(nxInner / blocksizeX)
      let nFullY = int(nyInner / blocksizeY)
      let remSizeX = (nxInner / blocksizeX - nFullX) * blocksizeX
      let remSizeY = (nyInner / blocksizeY - nFullY) * blocksizeY

      let addRemX = 0
      if remSizeX > 0 { addRemX = 1 }
      let addRemY = 0
      if remSizeY > 0 { addRemY = 1 }

      let nInner = (nFullX + addRemX) * (nFullY + addRemY)
      let n = nInner + 2 * (nFullX + addRemX) + 2 * (nFullY + addRemY) + 4

      set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 0.4pt, cap: "round"),
        content: (padding: 1pt, paint: black),
      )

      if params.grid {
        grid(
          (-nOuterLayers, -nOuterLayers),
          (nx - nOuterLayers, ny - nOuterLayers),
          step: 1mm,
          stroke: gray + 0.1pt,
        )
      }

      if nOuterLayers > 0 {
        outer_blocks(params, start_id: nInner, n_comp: n_comp)
      }

      set-style(stroke: (thickness: 1pt, cap: "round", paint: black))

      let id = 0
      for i in range(nInner) {
        let idY = calc.floor(id / (nFullX + addRemX))
        let idX = id - idY * (nFullX + addRemX)

        let bX = blocksizeX
        let bY = blocksizeY
        if idX == nFullX { bX = remSizeX }
        if idY == nFullY { bY = remSizeY }

        let x = idX * blocksizeX
        let y = idY * blocksizeY

        if params.heatmap {
          let row = n_comp.at(id)
          let fill = grad.sample(row.n_Full / n_Total * 100%)

          if params.keys().contains("transparent"){
            fill = fill.transparentize(params.transparent)
          }

          rect(
            (x, y),
            (rel: (bX, bY)),
            fill: fill,
            name: "rect",
          )
          if params.label_percent {
            content(
              "rect",
              anchor: "center",
              [#{ calc.round(row.n_Full / n_Total * 100, digits: params.round_digits) }],
            )
          }
        } else {
          rect((x, y), (rel: (bX, bY)))
        }

        if params.label_id {
          content((rel: (0.5pt, 0.5pt), to: (x, y)), anchor: "south-west", [#id])
        }

        id += 1
      }

      if params.keys().contains("legend") and params.legend {

        // hidden rect for centering (b/c 100% label is wider than 0%)
        rect(
          (
            - 50 - params.nOuterLayers,
            - 28pt / latex_textwidth_factor / _scale - params.nOuterLayers * 1mm,
          ),
          (rel: (params.nx + 100, 10pt / latex_textwidth_factor / _scale)),
          fill: white,
          stroke: white,
        )

        rect(
          (
            0 - nOuterLayers,
            - 28pt / latex_textwidth_factor / _scale - params.nOuterLayers * 1mm,
          ),
          (rel: (params.nx - 0, 10pt / latex_textwidth_factor / _scale)),
          fill: gradient.linear(..params.cmap.rev()),
          name: "legend",
        )

        content((
          rel: (0, 4pt / latex_textwidth_factor / _scale),
          to: "legend.north-west",
        ), [Share of scalar flux computations], anchor: "south-west")

        for i in range(0, 6) {
          line(
            ("legend.south-west", i / 5 * 100%, "legend.south-east"),
            (rel: (0, -5pt / latex_textwidth_factor / _scale)),
          )
          content(
            (rel: (0, -3pt / latex_textwidth_factor / _scale)),
            [#str(i / 5 * 100)%],
            anchor: "north",
          )
        }
      }
    },
  )
}

#draw_blocks(params)