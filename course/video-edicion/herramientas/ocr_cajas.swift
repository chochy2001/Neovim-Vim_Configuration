// OCR local (Vision) con posición: imprime JSON {archivo: [[texto, x, y, w, h, conf], ...]} en píxeles (origen arriba-izquierda).
import Foundation; import Vision; import AppKit
var out: [String: [[Any]]] = [:]
for path in CommandLine.arguments.dropFirst() {
    guard let img = NSImage(contentsOfFile: path), let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else { continue }
    let W = CGFloat(cg.width), H = CGFloat(cg.height)
    let req = VNRecognizeTextRequest(); req.recognitionLevel = .accurate; req.usesLanguageCorrection = false
    try? VNImageRequestHandler(cgImage: cg, options: [:]).perform([req])
    var r: [[Any]] = []
    for o in req.results ?? [] { if let c = o.topCandidates(1).first { let b = o.boundingBox
        r.append([c.string, Int(b.minX * W), Int((1 - b.maxY) * H), Int(b.width * W), Int(b.height * H), c.confidence]) } }
    out[(path as NSString).lastPathComponent] = r
}
print(String(data: try! JSONSerialization.data(withJSONObject: out), encoding: .utf8)!)
