// Insignia de marca (la anima Fusion): pastilla oscura + baldosa blanca con el icono (Simple Icons CC0, en su color) + nombre. Sin etiqueta "MENCIONADO".
// Si no hay icono (Windows, VS Code: retirados de Simple Icons), solo el nombre con una barra de su color. Nunca un logo inventado.
// Uso: swift marca_capas.swift trabajos.json  ([{"dir","marca","icono": ruta|null,"color":"RRGGBB"}])
import AppKit
let jobs = try! JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))) as! [[String: Any]]
func C(_ h: String, _ a: CGFloat = 1) -> NSColor { var v: UInt64 = 0; Scanner(string: h).scanHexInt64(&v)
    return NSColor(srgbRed: CGFloat((v >> 16) & 255) / 255, green: CGFloat((v >> 8) & 255) / 255, blue: CGFloat(v & 255) / 255, alpha: a) }
let W: CGFloat = 520, H: CGFloat = 104
let nameF = NSFont(name: "AvenirNext-DemiBold", size: 32)!
for j in jobs {
    let dir = j["dir"] as! String, marca = j["marca"] as! String, col = C(j["color"] as? String ?? "94A3B8")
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(W), pixelsHigh: Int(H), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState(); NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    C("14161B", 0.94).setFill(); NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: W, height: H), xRadius: 20, yRadius: 20).fill()
    var tx: CGFloat = 24
    if let ip = j["icono"] as? String, let img = NSImage(contentsOfFile: ip) {
        NSColor.white.setFill(); NSBezierPath(roundedRect: NSRect(x: 14, y: 12, width: 80, height: 80), xRadius: 16, yRadius: 16).fill()
        if ip.hasSuffix(".svg") {   // icono monocromo: se pinta con el color de la marca
            let t = NSImage(size: NSSize(width: 54, height: 54), flipped: false) { r in img.draw(in: r); col.set(); r.fill(using: .sourceAtop); return true }
            t.draw(in: NSRect(x: 27, y: 25, width: 54, height: 54))
        } else { img.draw(in: NSRect(x: 21, y: 19, width: 66, height: 66)) }
        tx = 112
    } else { col.setFill(); NSBezierPath(roundedRect: NSRect(x: 18, y: 22, width: 8, height: 60), xRadius: 4, yRadius: 4).fill(); tx = 44 }
    // Solo icono + nombre (pedido del operador 2026-11-13: la palabra "MENCIONADO" se veía mal). Nombre centrado en vertical.
    let nombre = NSAttributedString(string: marca, attributes: [.font: nameF, .foregroundColor: NSColor.white])
    nombre.draw(at: NSPoint(x: tx, y: ((H - nombre.size().height) / 2).rounded()))
    NSGraphicsContext.restoreGraphicsState()
    try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "\(dir)/card.png"))
    try! JSONSerialization.data(withJSONObject: ["W": W, "H": H]).write(to: URL(fileURLWithPath: "\(dir)/metricas.json"))
}
print("ok", jobs.count)
