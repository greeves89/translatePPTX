⸻

PPTX Übersetzungstool

Dieses Tool liest eine PPTX-Präsentation seitenweise ein, übersetzt den darin enthaltenen Text mithilfe eines Übersetzungsdienstes in eine angegebene Zielsprache und speichert die übersetzte Präsentation als neue Datei. Dabei bleiben Formatierung und sonstige Inhalte unverändert.

Hinweis:
Das Tool unterstützt zwei Übersetzungsdienste:

- DeepL: Wird verwendet, wenn in der .env ein DeepL-API-Key hinterlegt ist.
- Google Translate: Wird automatisch genutzt, falls kein DeepL-API-Key vorhanden ist oder der Key nicht gesetzt ist.

⸻

Voraussetzungen

- Python 3:
Es wird empfohlen, Python 3.12 oder eine kompatible Version zu verwenden.
Hinweis für Python 3.13:
Das cgi-Modul wurde in Python 3.13 entfernt. Das Tool injiziert einen Dummy, der eine minimale Implementierung von parse_header bereitstellt.
- Systempakete:
Es werden keine zusätzlichen Systempakete benötigt, da alle Abhängigkeiten über pip installiert werden.

⸻

Requirements

Erstelle eine Datei namens requirements.txt mit folgendem Inhalt:

	python-pptx
	googletrans==4.0.0rc1
	deepl
	python-dotenv

Installiere die benötigten Pakete mit:

	pip install -r requirements.txt



⸻

Installation

1.	Klone oder lade das Repository herunter, in dem sich das Tool (z. B. translate_pptx.py) befindet.
2.	Stelle sicher, dass du eine lokale PPTX-Datei hast, die übersetzt werden soll.
3.	Erstelle im selben Verzeichnis eine .env-Datei und trage deinen DeepL‑API-Key ein (optional):
4.		DEEPL_API_KEY=your_deepl_api_key_here

Fehlt der Key oder ist er leer, wird automatisch Google Translate genutzt.

⸻

Nutzung

Das Tool wird über die Kommandozeile aufgerufen. Du musst den Pfad zur Eingabe-PPTX-Datei sowie den Sprachcode der Zielsprache (z. B. en für Englisch, de für Deutsch oder andere im Euroraum gängige Codes) als Parameter übergeben.

Beispielaufruf

	python3 translate_pptx.py "/Pfad/zur/Datei.pptx" en

Nach der Ausführung wird die übersetzte Präsentation im gleichen Verzeichnis gespeichert. Der Dateiname wird standardmäßig um den Suffix _translated ergänzt.

⸻

Log-Ausgaben

Während der Ausführung gibt das Tool verschiedene Log-Meldungen aus:

- "[DEBUG]: Detaillierte Informationen zum Originaltext und zur Übersetzung einzelner Textabschnitte
- "[ERROR]: Fehlermeldungen, falls beim Übersetzen eines Textabschnitts ein Fehler auftritt
- "[INFO]: Statusmeldungen (z. B. Dateipfad, geladenes PPTX, Speichern der Datei)
  
Diese Meldungen helfen dir, den Ablauf zu überwachen und eventuelle Probleme zu identifizieren.

⸻

Wichtige Hinweise

- Internetverbindung:
Für den Zugriff auf die Übersetzungsdienste (DeepL oder Google Translate) ist eine aktive Internetverbindung erforderlich.

- API-Limits:
Übersetzungsdienste können API-Limits oder Rate-Limiting besitzen. Bei sehr großen Präsentationen kann es zu Verzögerungen kommen.

- Cloud-Dateien:
Stelle sicher, dass die zu verarbeitende PPTX-Datei lokal verfügbar ist (bei Dateien in Cloud-Verzeichnissen kann es zu Zugriffsproblemen kommen).

- Python 3.13 Workaround:
In Python 3.13 wurde das cgi-Modul entfernt. Daher wird zu Beginn des Skripts ein Dummy-Modul mit einer minimalen parse_header-Implementierung geladen. Dieser Workaround gilt, bis offizielle Updates der verwendeten Bibliotheken verfügbar sind.

⸻
