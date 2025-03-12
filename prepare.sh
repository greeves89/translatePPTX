#!/bin/bash
# prepare.sh
# Dieses Skript installiert alle notwendigen System-Abhängigkeiten (nicht-Python) 
# und führt dann die Installation der Python-Abhängigkeiten aus der requirements.txt durch.
# Voraussetzung: Homebrew muss installiert sein.

# Prüfe, ob Homebrew installiert ist
if ! command -v brew &> /dev/null; then
    echo "Homebrew ist nicht installiert. Bitte installiere Homebrew von https://brew.sh und führe das Skript erneut aus."
    exit 1
fi

echo "Homebrew gefunden."

# Installiere cmake, falls nicht vorhanden
if ! command -v cmake &> /dev/null; then
    echo "Installiere cmake..."
    brew install cmake
else
    echo "cmake ist bereits installiert."
fi

# Installiere coreutils, falls nproc nicht gefunden wird
if ! command -v nproc &> /dev/null; then
    echo "Installiere coreutils (liefert nproc)..."
    brew install coreutils
else
    echo "nproc (coreutils) ist bereits installiert."
fi

# Optional: Update pip (falls notwendig)
echo "Aktualisiere pip (optional)..."
python3 -m pip install --upgrade pip

# Installiere Python-Abhängigkeiten aus der requirements.txt
echo "Installiere Python-Abhängigkeiten..."
pip install -r requirements.txt --break-system-packages

echo "Prepare.sh abgeschlossen. Alle erforderlichen Abhängigkeiten sind installiert."
echo "Du kannst jetzt das Übersetzungsskript starten (z. B. 'python3 translate_file.py <input_file> <target_language>')."