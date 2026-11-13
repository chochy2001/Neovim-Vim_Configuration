// Renderiza un texto a PNG transparente con CoreText (macOS).
// Uso: swift texto_png.swift "<texto>" <salida.png> <fuente> <tamaño> <hex_color> [ancho_max]
import AppKit
let a = CommandLine.arguments
let text = a[1], out = a[2], fontName = a[3]
let size = CGFloat(Double(a[4])!), hex = a[5]
let maxW = a.count > 6 ? CGFloat(Double(a[6])!) : 1800
func color(_ h: String) -> NSColor {
    var v: UInt64 = 0; Scanner(string: h).scanHexInt64(&v)
    return NSColor(srgbRed: CGFloat((v >> 16) & 255) / 255, green: CGFloat((v >> 8) & 255) / 255, blue: CGFloat(v & 255) / 255, alpha: 1)
}
let font = NSFont(name: fontName, size: size) ?? NSFont.boldSystemFont(ofSize: size)
let para = NSMutableParagraphStyle(); para.alignment = .left
let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color(hex), .paragraphStyle: para]
let s = NSAttributedString(string: text, attributes: attrs)
var r = s.boundingRect(with: NSSize(width: maxW, height: 2000), options: [.usesLineFragmentOrigin, .usesFontLeading])
r.size.width = ceil(r.width) + 8; r.size.height = ceil(r.height) + 8
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(r.width), pixelsHigh: Int(r.height), bitsPerSample: 8, samplesPerPixel: 4,
                           hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
s.draw(with: NSRect(x: 4, y: 4, width: r.width - 8, height: r.height - 8), options: [.usesLineFragmentOrigin, .usesFontLeading])
NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out))
print(out, Int(r.width), Int(r.height))
