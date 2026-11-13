// Capas a pantalla completa (1920x1080, transparentes) para la lista de "En esta parte" y el título del resumen.
// Uso: swift lista_capas.swift trabajos.json  ([{"dir","parte","titulo","items":[{"teclas":[..],"texto":".."}]}])
// Escribe: titulo.png, item-XX.png (cada comando en su celda), resumen-titulo.png. Sin halo ni sombras.
import AppKit
let jobs = try! JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))) as! [[String: Any]]
func C(_ h: UInt32, _ a: CGFloat = 1) -> NSColor { NSColor(srgbRed: CGFloat((h >> 16) & 255) / 255, green: CGFloat((h >> 8) & 255) / 255, blue: CGFloat(h & 255) / 255, alpha: a) }
let NAVY = C(0x343B6E), ORANGE = C(0xE9A23B), INK = C(0x1F2333)
func canvas(_ draw: () -> Void) -> NSBitmapImageRep {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 1920, pixelsHigh: 1080, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState(); NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep); draw(); NSGraphicsContext.restoreGraphicsState(); return rep }
func save(_ r: NSBitmapImageRep, _ p: String) { try! r.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: p)) }
func A(_ s: String, _ f: NSFont, _ c: NSColor, k: CGFloat = 0) -> NSAttributedString { NSAttributedString(string: s, attributes: [.font: f, .foregroundColor: c, .kern: k]) }
let small = NSFont(name: "AvenirNext-Bold", size: 22)!, big = NSFont(name: "AvenirNext-Bold", size: 58)!, txt = NSFont(name: "AvenirNext-Medium", size: 27)!
let cap1 = NSFont(name: "AvenirNext-DemiBold", size: 28)!, cap2 = NSFont(name: "AvenirNext-DemiBold", size: 20)!
func Y(_ yTop: CGFloat, _ h: CGFloat) -> CGFloat { 1080 - yTop - h }
func keycaps(_ keys: [String], x0: CGFloat, yTop: CGFloat) -> CGFloat {
    var x = x0; let h: CGFloat = 50
    for (i, k) in keys.enumerated() {
        let f = k.count == 1 ? cap1 : cap2; let w = max(h, ceil(A(k, f, .black).size().width) + 24)
        C(0xAEB3BE).setFill(); NSBezierPath(roundedRect: NSRect(x: x, y: Y(yTop + 4, h), width: w, height: h), xRadius: 9, yRadius: 9).fill()
        C(0xF6F7F9).setFill(); NSBezierPath(roundedRect: NSRect(x: x, y: Y(yTop, h), width: w, height: h), xRadius: 9, yRadius: 9).fill()
        C(0xC9CDD6).setStroke(); let b = NSBezierPath(roundedRect: NSRect(x: x + 0.5, y: Y(yTop, h) + 0.5, width: w - 1, height: h - 1), xRadius: 9, yRadius: 9); b.lineWidth = 1; b.stroke()
        let s = A(k, f, C(0x15171C)); s.draw(at: NSPoint(x: x + (w - s.size().width) / 2, y: Y(yTop, h) + (h - s.size().height) / 2 + 1))
        x += w + 7
        if ["Ctrl", "Shift", "Alt"].contains(k) && i + 1 < keys.count { let p = A("+", cap1, INK); p.draw(at: NSPoint(x: x, y: Y(yTop, h) + 8)); x += p.size().width + 7 }
    }
    return x
}
for j in jobs {
    let dir = j["dir"] as! String, parte = j["parte"] as! Int, titulo = j["titulo"] as! String, items = j["items"] as! [[String: Any]]
    save(canvas {
        A("PARTE \(parte) · EN ESTA PARTE VAS A APRENDER", small, ORANGE, k: 2).draw(at: NSPoint(x: 230, y: Y(150, 30)))
        A(titulo, big, NAVY).draw(at: NSPoint(x: 226, y: Y(185, 80)))
    }, "\(dir)/titulo.png")
    let cols = 2, rowH: CGFloat = 92, top: CGFloat = 320, colX: [CGFloat] = [230, 1000]
    let rows = (items.count + 1) / 2
    for (i, it) in items.enumerated() {
        let c = i < rows ? 0 : 1, r = i < rows ? i : i - rows
        save(canvas {
            let yTop = top + CGFloat(r) * rowH
            let xe = keycaps(it["teclas"] as! [String], x0: colX[c], yTop: yTop)
            A(it["texto"] as! String, txt, INK).draw(at: NSPoint(x: max(xe + 14, colX[c] + 200), y: Y(yTop + 8, 36)))
        }, "\(dir)/item-\(String(format: "%02d", i))-capa.png")
    }
    _ = cols
    save(canvas {
        A("PARTE \(parte) · RESUMEN", small, ORANGE, k: 2).draw(at: NSPoint(x: 230, y: Y(150, 30)))
        A("Lo que aprendiste: \(titulo.lowercased())", big, NAVY).draw(at: NSPoint(x: 226, y: Y(185, 80)))
    }, "\(dir)/resumen-titulo.png")
}
print("ok", jobs.count)
