// Dibuja el visor de teclas nuevo (teclas estilo tecla física sobre una pastilla oscura) en PNG 1920x1080 transparente.
// Uso: swift teclas_png.swift trabajos.json   ([{"out": "...png", "pos": "A"|"B", "groups": [["Shift","N"],["j"]], "alpha": 1.0}])
// Sin halo, sin brillo ni sombra difusa: solo el borde inferior de la tecla para dar volumen.
import AppKit
let jobs = try! JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))) as! [[String: Any]]
// Ancla: la esquina izquierda/centro de la caja vieja (A: abajo-izquierda; B: abajo-centro, parte 1)
let ANCHOR: [String: (x: CGFloat, cy: CGFloat, center: Bool)] = ["A": (16, 761, false), "B": (536, 1016, true)]
let capH: CGFloat = 66, capR: CGFloat = 11, depth: CGFloat = 5, padX: CGFloat = 14, padY: CGFloat = 13, gapGroup: CGFloat = 16, gapPlus: CGFloat = 8
func font(_ s: String) -> NSFont { NSFont(name: "AvenirNext-DemiBold", size: s.count == 1 ? 38 : 28) ?? NSFont.boldSystemFont(ofSize: 30) }
let plusFont = NSFont(name: "AvenirNext-DemiBold", size: 30)!
func attr(_ s: String, _ f: NSFont, _ c: NSColor) -> NSAttributedString { NSAttributedString(string: s, attributes: [.font: f, .foregroundColor: c]) }
let capFill = NSColor(srgbRed: 0.965, green: 0.969, blue: 0.976, alpha: 1), capEdge = NSColor(srgbRed: 0.70, green: 0.72, blue: 0.77, alpha: 1)
let capText = NSColor(srgbRed: 0.09, green: 0.10, blue: 0.12, alpha: 1), pill = NSColor(srgbRed: 0.075, green: 0.082, blue: 0.10, alpha: 0.90)
let plusCol = NSColor(srgbRed: 0.85, green: 0.87, blue: 0.91, alpha: 1)
for j in jobs {
    let groups = j["groups"] as! [[String]], pos = j["pos"] as! String, alpha = CGFloat((j["alpha"] as? Double) ?? 1)
    // medir
    var widths: [[CGFloat]] = []
    for g in groups { widths.append(g.map { max(capH, ceil(attr($0, font($0), capText).size().width) + 30) }) }
    let plusW = ceil(attr("+", plusFont, plusCol).size().width)
    var total: CGFloat = 0
    for (gi, g) in widths.enumerated() { total += g.reduce(0, +) + CGFloat(g.count - 1) * (plusW + 2 * gapPlus); if gi < widths.count - 1 { total += gapGroup } }
    let pw = total + 2 * padX, ph = capH + depth + 2 * padY
    let an = ANCHOR[pos]!
    let px = an.center ? an.x - pw / 2 : an.x, pyTop = an.cy - ph / 2
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 1920, pixelsHigh: 1080, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState(); let ctx = NSGraphicsContext(bitmapImageRep: rep)!; NSGraphicsContext.current = ctx
    ctx.cgContext.setAlpha(alpha); ctx.cgContext.beginTransparencyLayer(auxiliaryInfo: nil)
    func R(_ x: CGFloat, _ yTop: CGFloat, _ w: CGFloat, _ h: CGFloat) -> NSRect { NSRect(x: x, y: 1080 - yTop - h, width: w, height: h) }
    pill.setFill(); NSBezierPath(roundedRect: R(px, pyTop, pw, ph), xRadius: 18, yRadius: 18).fill()
    var x = px + padX; let y = pyTop + padY
    for (gi, g) in groups.enumerated() {
        for (ci, c) in g.enumerated() {
            let w = widths[gi][ci]
            capEdge.setFill(); NSBezierPath(roundedRect: R(x, y + depth, w, capH), xRadius: capR, yRadius: capR).fill()
            capFill.setFill(); NSBezierPath(roundedRect: R(x, y, w, capH), xRadius: capR, yRadius: capR).fill()
            let s = attr(c, font(c), capText), sz = s.size()
            s.draw(at: NSPoint(x: x + (w - sz.width) / 2, y: 1080 - y - capH / 2 - sz.height / 2 + 1))
            x += w
            if ci < g.count - 1 {
                let p = attr("+", plusFont, plusCol), ps = p.size()
                p.draw(at: NSPoint(x: x + gapPlus, y: 1080 - y - capH / 2 - ps.height / 2 + 1)); x += plusW + 2 * gapPlus
            }
        }
        x += gapGroup
    }
    ctx.cgContext.endTransparencyLayer(); NSGraphicsContext.restoreGraphicsState()
    try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: j["out"] as! String))
}
print("ok", jobs.count)
