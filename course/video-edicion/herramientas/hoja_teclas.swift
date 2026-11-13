// Hoja de revisión: cada recorte con su lectura debajo. Uso: swift hoja_teclas.swift salida.png lista.txt (líneas "ruta\tetiqueta")
import AppKit
let a = CommandLine.arguments; let lines = try! String(contentsOfFile: a[2], encoding: .utf8).split(separator: "\n")
let cols = 4, tw = 420, th = 170; let rows = (lines.count + cols - 1) / cols
let W = cols * tw, H = rows * th
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: W, pixelsHigh: H, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
NSColor(white: 0.25, alpha: 1).setFill(); NSRect(x: 0, y: 0, width: W, height: H).fill()
for (i, l) in lines.enumerated() {
    let p = l.split(separator: "\t", omittingEmptySubsequences: false); let x = (i % cols) * tw, yTop = (i / cols) * th
    if let img = NSImage(contentsOfFile: String(p[0])) { img.draw(in: NSRect(x: x + 5, y: H - yTop - 120, width: 410, height: 115)) }
    let lab = "\(i + 1). " + (p.count > 1 ? String(p[1]) : "")
    let at: [NSAttributedString.Key: Any] = [.font: NSFont.monospacedSystemFont(ofSize: 22, weight: .bold), .foregroundColor: NSColor.yellow]
    lab.draw(at: NSPoint(x: x + 8, y: H - yTop - 158), withAttributes: at)
}
NSGraphicsContext.current = nil
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: a[1]))
