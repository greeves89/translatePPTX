#!/usr/bin/env python3
import sys
import types
import warnings
import os
from dotenv import load_dotenv

# .env laden
load_dotenv()

# Dummy-Injektion für das cgi-Modul in Python 3.13, inkl. minimaler Implementierung von parse_header
if sys.version_info >= (3, 13):
    warnings.warn("cgi module removed in Python 3.13; injecting dummy module with parse_header", DeprecationWarning)
    def parse_header(value):
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

from pptx import Presentation

# Prüfe, ob ein DeepL-API-Key in der .env vorhanden ist
deepl_api_key = os.getenv("DEEPL_API_KEY")
use_deepl = bool(deepl_api_key and deepl_api_key.strip())

if use_deepl:
    import deepl
    translator = deepl.Translator(deepl_api_key)
    print("[INFO] DeepL API-Key gefunden. Nutze DeepL für die Übersetzung.")
else:
    from googletrans import Translator as GoogleTranslator
    translator = GoogleTranslator()
    print("[INFO] Kein DeepL API-Key gefunden. Nutze Google Translate für die Übersetzung.")

def translate_text(text: str, target_language: str) -> str:
    if not text.strip():
        return text
    if use_deepl:
        try:
            # DeepL erwartet Sprachcodes in Großbuchstaben (z.B. "EN", "DE")
            result = translator.translate_text(text, target_lang=target_language.upper())
            return result.text
        except Exception as e:
            print(f"[ERROR] DeepL-Übersetzung fehlgeschlagen für '{text}': {e}")
            return text
    else:
        try:
            result = translator.translate(text, dest=target_language)
            return result.text
        except Exception as e:
            print(f"[ERROR] Google Translate fehlgeschlagen für '{text}': {e}")
            return text

def translate_pptx(input_path: str, target_language: str, output_path: str = None):
    print(f"[INFO] Starte Übersetzung der Datei: {input_path}")
    
    if not os.path.exists(input_path):
        raise FileNotFoundError(f"Die Datei wurde nicht gefunden: {input_path}")
    print(f"[INFO] Datei gefunden: {input_path}")
    
    print("[INFO] Lade PPTX-Präsentation...")
    prs = Presentation(input_path)
    print("[INFO] Präsentation erfolgreich geladen.")
    
    print("[INFO] Beginne mit der Verarbeitung der Folien...")
    for slide_index, slide in enumerate(prs.slides, start=1):
        print(f"[INFO] Verarbeite Folie {slide_index}/{len(prs.slides)}")
        for shape_index, shape in enumerate(slide.shapes, start=1):
            if shape.has_text_frame:
                print(f"[INFO] Verarbeite Text in Shape {shape_index} auf Folie {slide_index}")
                for paragraph_index, paragraph in enumerate(shape.text_frame.paragraphs, start=1):
                    for run_index, run in enumerate(paragraph.runs, start=1):
                        original_text = run.text
                        if original_text.strip():
                            print(f"[DEBUG] Ursprünglicher Text (Folie {slide_index}, Shape {shape_index}, Absatz {paragraph_index}, Run {run_index}): {original_text}")
                            translated_text = translate_text(original_text, target_language)
                            print(f"[DEBUG] Übersetzter Text: {translated_text}")
                            run.text = translated_text
    
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