// OCR local (Vision) de los recortes de la caja de teclas. Uso: swift ocr_teclas.swift img1.png img2.png ... > salida.json
import Foundation
import Vision
import AppKit
var out: [String: [String: Any]] = [:]
for path in CommandLine.arguments.dropFirst() {
    guard let img = NSImage(contentsOfFile: path), let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else { continue }
    let req = VNRecognizeTextRequest()
    req.recognitionLevel = .accurate
    req.usesLanguageCorrection = false
    req.recognitionLanguages = ["en-US"]
    let h = VNImageRequestHandler(cgImage: cg, options: [:])
    try? h.perform([req])
    var txt: [String] = []; var conf: [Float] = []
    for o in (req.results ?? []) { if let c = o.topCandidates(1).first { txt.append(c.string); conf.append(c.confidence) } }
    out[(path as NSString).lastPathComponent] = ["texto": txt.joined(separator: " "), "conf": conf]
}
let d = try! JSONSerialization.data(withJSONObject: out, options: [.prettyPrinted, .sortedKeys])
print(String(data: d, encoding: .utf8)!)
