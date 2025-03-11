Übersetzungs-PPTX-Tool

Dieses Tool liest eine PPTX-Präsentation seitenweise ein, übersetzt den darin enthaltenen Text mithilfe des Google Übersetzungsdienstes in eine angegebene Zielsprache und speichert die übersetzte Präsentation als neue Datei. Dabei bleiben alle Formatierungen und Inhalte (außer dem Text) erhalten.

Voraussetzungen
	•	Python 3:
Es wird empfohlen, Python 3.12 oder eine kompatible Version zu verwenden.
Hinweis: Für Python 3.13 wird ein Dummy-Modul für cgi injiziert, da dieses Modul in Python 3.13 entfernt wurde.
	•	Benötigte Python-Pakete:
Installiere folgende Pakete über pip:
	•	python-pptx
	•	googletrans==4.0.0rc1
Beispiel:

pip install python-pptx googletrans==4.0.0rc1



Installation
	1.	Klone oder lade das Repository herunter.
	2.	Stelle sicher, dass die erforderlichen Pakete installiert sind.
	3.	Platziere die PPTX-Datei, die übersetzt werden soll, an einem zugänglichen Ort.

Nutzung

Das Tool wird über die Kommandozeile aufgerufen. Der Pfad zur Eingabe-PPTX-Datei sowie der Sprachcode der Zielsprache (z. B. en für Englisch oder de für Deutsch) müssen als Parameter übergeben werden.

Beispielaufruf

python3 translate_pptx.py '/Pfad/zur/Datei.pptx' en

Nach der Ausführung wird die übersetzte Präsentation im selben Verzeichnis abgelegt. Der Dateiname wird standardmäßig um den Suffix _translated ergänzt.

Log-Ausgaben

Während der Ausführung gibt das Tool verschiedene Log-Meldungen aus, die den Fortschritt (wie z. B. geladene Datei, verarbeitete Folien, Übersetzungsergebnisse) dokumentieren. Diese Informationen können hilfreich sein, um Fehler zu identifizieren oder den Ablauf zu überwachen.

Wichtige Hinweise
	•	Internetverbindung:
Da das Tool den Google Übersetzungsdienst verwendet, ist eine aktive Internetverbindung erforderlich.
	•	API-Limits:
Beachte, dass Übersetzungsdienste API-Limits oder Rate-Limiting haben können, was bei großen Präsentationen zu Verzögerungen führen kann.
	•	Cloud-Dateien:
Wenn die PPTX-Datei auf einem Cloud-Speicher liegt, stelle sicher, dass sie lokal verfügbar und vollständig synchronisiert ist.
	•	Python 3.13:
In Python 3.13 wurde das cgi-Modul entfernt. Das Tool injiziert einen Dummy, der eine minimale Implementierung von parse_header bietet. Dies ist als Workaround gedacht, bis offizielle Updates von den verwendeten Bibliotheken verfügbar sind.

