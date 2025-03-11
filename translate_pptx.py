#!/usr/bin/env python3
import sys
import types
import warnings

# Dummy-Injektion für das cgi-Modul in Python 3.13, inkl. minimaler Implementierung von parse_header
if sys.version_info >= (3, 13):
    warnings.warn("cgi module removed in Python 3.13; injecting dummy module with parse_header", DeprecationWarning)
    def parse_header(value):
        # Eine einfache Implementierung: Teilt den Header in Hauptwert und Parameter
        parts = value.split(";")
        key = parts[0].strip()
        params = {}
        for param in parts[1:]:
            if "=" in param:
                k, v = param.split("=", 1)
                params[k.strip()] = v.strip()
        return key, params

    cgi_dummy = types.ModuleType("cgi")
    cgi_dummy.parse_header = parse_header
    sys.modules["cgi"] = cgi_dummy

import os
from pptx import Presentation
from googletrans import Translator

def translate_pptx(input_path: str, target_language: str, output_path: str = None):
    """
    Liest eine PPTX-Datei ein, übersetzt den Text aller Slides in die angegebene Sprache und speichert eine neue Datei.
    
    Args:
        input_path: Pfad zur Eingabe-PPTX-Datei.
        target_language: Sprachcode der Zielsprache (z. B. "de" für Deutsch, "en" für Englisch).
        output_path: Optionaler Pfad zur Ausgabedatei. Falls nicht angegeben, wird der Dateiname mit "_translated" ergänzt.
    """
    print(f"[INFO] Starte Übersetzung der Datei: {input_path}")
    
    # Überprüfe, ob die Datei existiert
    if not os.path.exists(input_path):
        raise FileNotFoundError(f"Die Datei wurde nicht gefunden: {input_path}")
    print(f"[INFO] Datei gefunden: {input_path}")
    
    # Lade die Präsentation
    print("[INFO] Lade PPTX-Präsentation...")
    prs = Presentation(input_path)
    print("[INFO] Präsentation erfolgreich geladen.")
    
    translator = Translator()
    
    # Iteriere über alle Slides
    print("[INFO] Beginne mit der Verarbeitung der Folien...")
    for slide_index, slide in enumerate(prs.slides, start=1):
        print(f"[INFO] Verarbeite Folie {slide_index}/{len(prs.slides)}")
        # Iteriere über alle Formen (shapes) der Slide
        for shape_index, shape in enumerate(slide.shapes, start=1):
            if shape.has_text_frame:
                print(f"[INFO] Verarbeite Text in Shape {shape_index} auf Folie {slide_index}")
                for paragraph_index, paragraph in enumerate(shape.text_frame.paragraphs, start=1):
                    for run_index, run in enumerate(paragraph.runs, start=1):
                        original_text = run.text
                        if original_text.strip():  # Nur nicht-leeren Text übersetzen
                            print(f"[DEBUG] Ursprünglicher Text (Folie {slide_index}, Shape {shape_index}, Absatz {paragraph_index}, Run {run_index}): {original_text}")
                            try:
                                translated = translator.translate(original_text, dest=target_language)
                                print(f"[DEBUG] Übersetzter Text: {translated.text}")
                                run.text = translated.text
                            except Exception as e:
                                print(f"[ERROR] Fehler bei der Übersetzung von '{original_text}': {e}")
    
    # Bestimme den Ausgabe-Pfad, falls nicht explizit angegeben
    if not output_path:
        base, ext = os.path.splitext(input_path)
        output_path = f"{base}_translated{ext}"
    print(f"[INFO] Speichere die übersetzte Datei unter: {output_path}")
    
    prs.save(output_path)
    print(f"[INFO] Übersetzte Datei erfolgreich gespeichert: {output_path}")

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: python translate_pptx.py <input_file.pptx> <target_language>")
        sys.exit(1)

    input_file = sys.argv[1]
    target_lang = sys.argv[2]
    print(f"[INFO] Aufruf mit Datei: {input_file} und Zielsprache: {target_lang}")
    translate_pptx(input_file, target_lang)