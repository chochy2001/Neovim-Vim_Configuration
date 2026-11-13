// Capas de una tarjeta explicativa (las anima Fusion). Uso: swift tarjeta_capas.swift trabajos.json
// Por trabajo escribe en "dir": card.png, keys.png, antes.png, despues.png, hl.png, cur_block.png, cur_bar.png, metricas.json
// Estilo: panel oscuro, barra de color por categoría, teclas como teclas físicas, línea de código monoespaciada. Sin halo ni sombra difusa.
import AppKit
let jobs = try! JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))) as! [[String: Any]]
func C(_ h: UInt32, _ a: CGFloat = 1) -> NSColor { NSColor(srgbRed: CGFloat((h >> 16) & 255) / 255, green: CGFloat((h >> 8) & 255) / 255, blue: CGFloat(h & 255) / 255, alpha: a) }
let CAT: [String: UInt32] = ["modo": 0xA78BFA, "movimiento": 0x38BDF8, "operador": 0xF87171, "objeto de texto": 0xFBBF24, "busqueda": 0x34D399, "edicion": 0xFB923C, "ventanas": 0x60A5FA, "archivo": 0x94A3B8]
let CATL: [String: String] = ["modo": "MODO", "movimiento": "MOVIMIENTO", "operador": "OPERADOR", "objeto de texto": "OBJETO DE TEXTO", "busqueda": "BÚSQUEDA", "edicion": "EDICIÓN", "ventanas": "VENTANAS", "archivo": "ARCHIVO"]
let W: CGFloat = 640
let mono = NSFont(name: "Menlo-Regular", size: 30)!, monoB = NSFont(name: "Menlo-Bold", size: 30)!
let desc = NSFont(name: "AvenirNext-Medium", size: 25)!, cat = NSFont(name: "AvenirNext-Bold", size: 15)!
let capF1 = NSFont(name: "AvenirNext-DemiBold", size: 30)!, capF2 = NSFont(name: "AvenirNext-DemiBold", size: 22)!
let plusF = NSFont(name: "AvenirNext-DemiBold", size: 24)!
func canvas(_ w: Int, _ h: Int, _ draw: (CGFloat) -> Void) -> NSBitmapImageRep {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: w, pixelsHigh: h, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState(); NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep); draw(CGFloat(h)); NSGraphicsContext.restoreGraphicsState(); return rep
}
func save(_ r: NSBitmapImageRep, _ p: String) { try! r.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: p)) }
func A(_ s: String, _ f: NSFont, _ c: NSColor, kern: CGFloat = 0) -> NSAttributedString { NSAttributedString(string: s, attributes: [.font: f, .foregroundColor: c, .kern: kern]) }
for j in jobs {
    let dir = j["dir"] as! String, keys = j["teclas"] as! [String], texto = j["texto"] as! String, categoria = j["categoria"] as! String
    let demo = j["demo"] as? [String: Any], corrige = (j["corrige_audio"] as? Bool) ?? false
    let H: CGFloat = demo == nil ? 168 : 252
    let accent = C(CAT[categoria] ?? 0x94A3B8)
    // geometría común
    let pad: CGFloat = 26, capH: CGFloat = 52, capY: CGFloat = 46, codeY: CGFloat = 168, codeH: CGFloat = 60
    let cw = A("M", mono, .white).size().width, lineH = A("Mg", mono, .white).size().height
    let textX: CGFloat = pad + 18, textBase = codeY + (codeH - lineH) / 2
    func R(_ x: CGFloat, _ yTop: CGFloat, _ w: CGFloat, _ h: CGFloat, _ HH: CGFloat) -> NSRect { NSRect(x: x, y: HH - yTop - h, width: w, height: h) }
    // tarjeta
    save(canvas(Int(W), Int(H)) { HH in
        C(0x14161B, 0.94).setFill(); NSBezierPath(roundedRect: R(0, 0, W, H, HH), xRadius: 18, yRadius: 18).fill()
        accent.setFill(); NSBezierPath(roundedRect: R(0, 0, 7, H, HH), xRadius: 3.5, yRadius: 3.5).fill()
        A(CATL[categoria] ?? categoria.uppercased(), cat, accent, kern: 1.6).draw(at: NSPoint(x: pad, y: HH - 16 - 20))
        if corrige {
            let t = A("CORRECCIÓN", cat, C(0x1A1300), kern: 1.2), s = t.size()
            C(0xFBBF24).setFill(); NSBezierPath(roundedRect: R(W - pad - s.width - 18, 13, s.width + 18, 26, HH), xRadius: 8, yRadius: 8).fill()
            t.draw(at: NSPoint(x: W - pad - s.width - 9, y: HH - 13 - 26 + (26 - s.height) / 2))
        }
        A(texto, desc, C(0xF3F4F6)).draw(at: NSPoint(x: pad, y: HH - (capY + capH + 14) - 34))
        if demo != nil { C(0x0B0C10).setFill(); NSBezierPath(roundedRect: R(pad, codeY, W - 2 * pad, codeH, HH), xRadius: 10, yRadius: 10).fill() }
    }, "\(dir)/card.png")
    // teclas (capa aparte para la animación de pulsación)
    var kx: CGFloat = pad; var spans: [(String, CGFloat, Bool)] = []   // (etiqueta, ancho, plus después)
    var i = 0
    while i < keys.count {
        let k = keys[i]; let isMod = ["Ctrl", "Shift", "Alt"].contains(k)
        let f = k.count == 1 ? capF1 : capF2
        spans.append((k, max(capH, ceil(A(k, f, .black).size().width) + 26), isMod && i + 1 < keys.count)); i += 1
    }
    save(canvas(Int(W), Int(H)) { HH in
        for (k, w, plus) in spans {
            let f = k.count == 1 ? capF1 : capF2
            C(0xAEB3BE).setFill(); NSBezierPath(roundedRect: R(kx, capY + 4, w, capH, HH), xRadius: 9, yRadius: 9).fill()
            C(0xF6F7F9).setFill(); NSBezierPath(roundedRect: R(kx, capY, w, capH, HH), xRadius: 9, yRadius: 9).fill()
            let s = A(k, f, C(0x15171C)); let sz = s.size(); s.draw(at: NSPoint(x: kx + (w - sz.width) / 2, y: HH - capY - capH / 2 - sz.height / 2 + 1))
            kx += w + 8
            if plus { let p = A("+", plusF, C(0xD1D5DB)); p.draw(at: NSPoint(x: kx, y: HH - capY - capH / 2 - p.size().height / 2)); kx += p.size().width + 8 }
        }
    }, "\(dir)/keys.png")
    var met: [String: Any] = ["W": W, "H": H, "keys_cx": (pad + kx) / 2, "keys_cy": capY + capH / 2]
    if let d = demo {
        let antes = d["antes"] as! String, despues = d["despues"] as! String
        let hl0 = d["hl_ini"] as! Int, hl1 = d["hl_fin"] as! Int
        for (name, s) in [("antes", antes), ("despues", despues)] {
            save(canvas(Int(W), Int(H)) { HH in A(s, mono, C(0xE5E7EB)).draw(at: NSPoint(x: textX, y: HH - textBase - lineH)) }, "\(dir)/\(name).png")
        }
        save(canvas(Int(W), Int(H)) { HH in
            if hl1 > hl0 { C(0xEF4444, 0.55).setFill(); NSBezierPath(roundedRect: R(textX + CGFloat(hl0) * cw - 2, textBase - 2, CGFloat(hl1 - hl0) * cw + 4, lineH + 4, HH), xRadius: 5, yRadius: 5).fill() }
        }, "\(dir)/hl.png")
        save(canvas(Int(ceil(cw)), Int(ceil(lineH))) { HH in C(0x3DDC84, 0.78).setFill(); NSRect(x: 0, y: 0, width: ceil(cw), height: ceil(lineH)).fill() }, "\(dir)/cur_block.png")
        save(canvas(4, Int(ceil(lineH))) { HH in C(0x3DDC84).setFill(); NSRect(x: 0, y: 0, width: 4, height: ceil(lineH)).fill() }, "\(dir)/cur_bar.png")
        met["char_w"] = cw; met["text_x"] = textX; met["line_cy"] = textBase + lineH / 2; met["cur_block_w"] = ceil(cw); met["line_h"] = ceil(lineH)
    }
    let md = try! JSONSerialization.data(withJSONObject: met); try! md.write(to: URL(fileURLWithPath: "\(dir)/metricas.json"))
}
print("ok", jobs.count)
