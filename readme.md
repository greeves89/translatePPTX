Übersetzungs-PPTX-Tool

Dieses Tool liest eine PPTX-Präsentation seitenweise ein, übersetzt den darin enthaltenen Text mithilfe des Google Übersetzungsdienstes in eine angegebene Zielsprache und speichert die übersetzte Präsentation als neue Datei. Dabei bleiben alle Formatierungen und Inhalte (außer dem Text) erhalten.

⸻

Voraussetzungen
	•	Python 3:
Es wird empfohlen, Python 3.12 oder eine kompatible Version zu verwenden.
Hinweis: Für Python 3.13 wird ein Dummy-Modul für cgi injiziert, da dieses Modul entfernt wurde.
	•	Benötigte Python-Pakete:
Installiere folgende Pakete über pip:
	•	python-pptx
	•	googletrans==4.0.0rc1

pip install python-pptx googletrans==4.0.0rc1



⸻

Installation
	1.	Klone oder lade das Repository herunter.
	2.	Stelle sicher, dass die erforderlichen Pakete installiert sind.
	3.	Platziere die PPTX-Datei, die übersetzt werden soll, an einem zugänglichen Ort.

⸻

Nutzung

Das Tool wird über die Kommandozeile aufgerufen. Du musst den Pfad zur Eingabe-PPTX-Datei sowie den Sprachcode der Zielsprache (z. B. en für Englisch oder de für Deutsch) als Parameter übergeben.

Beispielaufruf

python3 translate_pptx.py "/Pfad/zur/Datei.pptx" en

Nach der Ausführung wird die übersetzte Präsentation im selben Verzeichnis gespeichert. Der Dateiname wird standardmäßig um den Suffix _translated ergänzt.

⸻

Log-Ausgaben

Während der Ausführung gibt das Tool verschiedene Log-Meldungen aus, die den Fortschritt dokumentieren, z. B.:
	•	Start und Abschluss der Verarbeitung
	•	Informationen zu geladenen Dateien und verarbeiteten Folien
	•	Details zu Übersetzungsergebnissen oder auftretenden Fehlern

Diese Ausgaben helfen dabei, den Ablauf zu überwachen und eventuelle Probleme zu identifizieren.

⸻

Wichtige Hinweise
	•	Internetverbindung:
Der Google Übersetzungsdienst benötigt eine aktive Internetverbindung.
	•	API-Limits:
Beachte, dass Übersetzungsdienste API-Limits oder Rate-Limiting haben können. Bei großen Präsentationen kann dies zu Verzögerungen führen.
	•	Cloud-Dateien:
Wenn sich die PPTX-Datei auf einem Cloud-Speicher (z. B. iCloud) befindet, stelle sicher, dass sie lokal verfügbar und vollständig synchronisiert ist.
	•	Python 3.13:
In Python 3.13 wurde das cgi-Modul entfernt. Das Tool injiziert daher einen Dummy, der eine minimale Implementierung von parse_header bietet. Dieser Workaround gilt, bis offizielle Updates der verwendeten Bibliotheken vorliegen.

⸻
