#import "@preview/cetz:0.2.1"
#let outer_blocks(params, start_id: 0, n_comp: none) = {
  import cetz.draw: *

  let nx = params.nx
  let ny = params.ny
  let blocksizeX = params.blocksizeX
  let blocksizeY = params.blocksizeY
  let nOuterLayers = params.nOuterLayers
  let grad = gradient.linear(..params.cmap)

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

  let id = start_id

  let n_Total = 0
  if params.heatmap {
    n_Total = n_comp.at(0).n_Full + n_comp.at(0).n_Scalar
  }

  set-style(stroke: (thickness: 1pt, cap: "round", paint: black))

  // bottom
  for i in range(nFullX + addRemX) {
    let idX = i

    let bX = blocksizeX
    let bY = nOuterLayers
    if idX == nFullX { bX = remSizeX }

    let x = idX * blocksizeX
    let y = -nOuterLayers

    if params.heatmap {
      let row = n_comp.at(id)
      rect(
        (x, y),
        (rel: (bX, bY)),
        fill: grad.sample(row.n_Full / n_Total * 100%),
      name: "rect",
    )
    if params.label_percent and params.label_percent_outer {
      content(
      "rect",
      anchor: "center",
      [#{ calc.round(row.n_Full / n_Total * 100, digits: 1) }%],
    )
    }
    } else {
      rect((x, y), (rel: (bX, bY)))
    }

    if params.label_id and params.label_id_outer {
      content((rel: (0.5pt, 0.5pt), to: (x, y)), anchor: "south-west", [#id])
    }
    id += 1
  }

  // top
  for i in range(nFullX + addRemX) {
    let idX = i

    let bX = blocksizeX
    let bY = nOuterLayers
    if idX == nFullX { bX = remSizeX }

    let x = idX * blocksizeX
    let y = (ny - 2 * nOuterLayers)

    if params.heatmap {
      let row = n_comp.at(id)
      rect(
        (x, y),
        (rel: (bX, bY)),
        fill: grad.sample(row.n_Full / n_Total * 100%),
      name: "rect",
    )
    if params.label_percent and params.label_percent_outer {
      content(
      "rect",
      anchor: "center",
      [#{ calc.round(row.n_Full / n_Total * 100, digits: 1) }%],
    )
    }
    } else {
      rect((x, y), (rel: (bX, bY)))
    }
    if params.label_id and params.label_id_outer {
      content((rel: (0.5pt, 0.5pt), to: (x, y)), anchor: "south-west", [#id])
    }
    id += 1
  }

  // left
  for i in range(nFullY + addRemY) {
    let idY = i

    let bX = nOuterLayers
    let bY = blocksizeY
    if idY == nFullY { bY = remSizeY }

    let x = -nOuterLayers
    let y = idY * blocksizeY

    if params.heatmap {
      let row = n_comp.at(id)
      rect(
        (x, y),
        (rel: (bX, bY)),
        fill: grad.sample(row.n_Full / n_Total * 100%),
        name: "rect",
      )
      if params.label_percent and params.label_percent_outer {
        content(
        "rect",
        anchor: "center",
        [#{ calc.round(row.n_Full / n_Total * 100, digits: 1) }%],
      )
      }
    } else {
      rect((x, y), (rel: (bX, bY)))
    }
    if params.label_id and params.label_id_outer {
      content((rel: (0.5pt, 0.5pt), to: (x, y)), anchor: "south-west", [#id])
    }
    id += 1
  }

  // right
  for i in range(nFullY + addRemY) {
    let idY = i

    let bX = nOuterLayers
    let bY = blocksizeY
    if idY == nFullY { bY = remSizeY }

    let x = (nx - 2 * nOuterLayers)
    let y = idY * blocksizeY

    if params.heatmap {
      let row = n_comp.at(id)
      rect(
        (x, y),
        (rel: (bX, bY)),
        fill: grad.sample(row.n_Full / n_Total * 100%),
      name: "rect",
    )
    if params.label_percent and params.label_percent_outer {
      content(
      "rect",
      anchor: "center",
      [#{ calc.round(row.n_Full / n_Total * 100, digits: 1) }%],
    )
    }
    } else {
      rect((x, y), (rel: (bX, bY)))
    }
    if params.label_id and params.label_id_outer {
      content((rel: (0.5pt, 0.5pt), to: (x, y)), anchor: "south-west", [#id])
    }
    id += 1
  }

  let x = -nOuterLayers
  let y = -nOuterLayers

  if params.heatmap {
    let row = n_comp.at(id)
    rect(
      (x, y),
      (rel: (nOuterLayers, nOuterLayers)),
      fill: grad.sample(row.n_Full / n_Total * 100%),
      name: "rect",
    )
    if params.label_percent and params.label_percent_outer {
      content(
      "rect",
      anchor: "center",
      [#{ calc.round(row.n_Full / n_Total * 100, digits: 1) }%],
    )
    }
  } else {
    rect((x, y), (rel: (nOuterLayers, nOuterLayers)))
  }
  if params.label_id and params.label_id_outer {
      content((rel: (0.5pt, 0.5pt), to: (x, y)), anchor: "south-west", [#id])
    }
  id += 1

  x = nxInner
  y = -nOuterLayers

  if params.heatmap {
    let row = n_comp.at(id)
    rect(
      (x, y),
      (rel: (nOuterLayers, nOuterLayers)),
      fill: grad.sample(row.n_Full / n_Total * 100%),
      name: "rect",
    )
    if params.label_percent and params.label_percent_outer {
      content(
      "rect",
      anchor: "center",
      [#{ calc.round(row.n_Full / n_Total * 100, digits: 1) }%],
    )
    }
  } else {
    rect((x, y), (rel: (nOuterLayers, nOuterLayers)))
  }
  if params.label_id and params.label_id_outer {
      content((rel: (0.5pt, 0.5pt), to: (x, y)), anchor: "south-west", [#id])
    }
  id += 1

  x = -nOuterLayers
  y = nyInner

  if params.heatmap {
    let row = n_comp.at(id)
    rect(
      (x, y),
      (rel: (nOuterLayers, nOuterLayers)),
      fill: grad.sample(row.n_Full / n_Total * 100%),
      name: "rect",
    )
    if params.label_percent and params.label_percent_outer {
      content(
      "rect",
      anchor: "center",
      [#{ calc.round(row.n_Full / n_Total * 100, digits: 1) }%],
    )
    }
  } else {
    rect((x, y), (rel: (nOuterLayers, nOuterLayers)))
  }
  if params.label_id and params.label_id_outer {
      content((rel: (0.5pt, 0.5pt), to: (x, y)), anchor: "south-west", [#id])
    }
  id += 1

  x = nxInner
  y = nyInner

  if params.heatmap {
    let row = n_comp.at(id)
    rect(
      (x, y),
      (rel: (nOuterLayers, nOuterLayers)),
      fill: grad.sample(row.n_Full / n_Total * 100%),
      name: "rect",
    )
    if params.label_percent and params.label_percent_outer {
      content(
      "rect",
      anchor: "center",
      [#{ calc.round(row.n_Full / n_Total * 100, digits: 1) }%],
    )
    }
  } else {
    rect((x, y), (rel: (nOuterLayers, nOuterLayers)))
  }
  if params.label_id and params.label_id_outer {
      content((rel: (0.5pt, 0.5pt), to: (x, y)), anchor: "south-west", [#id])
    }
  id += 1
}