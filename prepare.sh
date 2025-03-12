#!/bin/bash
# prepare.sh
# Dieses Skript installiert alle notwendigen System-Abhängigkeiten (nicht-Python) 
# und führt dann die Installation der Python-Abhängigkeiten aus der requirements.txt durch.
# Voraussetzung: Homebrew muss installiert sein.

# Funktion, um interaktiv nachzufragen, ob ein Paket installiert werden soll.
prompt_install() {
    pkg_name="$1"
    install_cmd="$2"
    read -p "$pkg_name ist nicht installiert. Möchtest du es jetzt installieren? [y/N]: " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        echo "Installiere $pkg_name..."
        eval "$install_cmd"
    else
        echo "$pkg_name wird benötigt. Das Skript wird beendet."
        exit 1
    fi
}

# Prüfe, ob Homebrew installiert ist
if ! command -v brew &> /dev/null; then
    echo "Homebrew ist nicht installiert. Bitte installiere Homebrew von https://brew.sh und führe das Skript erneut aus."
    exit 1
fi

echo "Homebrew gefunden."

# Prüfe, ob Python3 installiert ist
if ! command -v python3 &> /dev/null; then
    prompt_install "Python3" "brew install python"
else
    echo "Python3 ist bereits installiert."
fi

# Prüfe und installiere cmake, falls nicht vorhanden
if ! command -v cmake &> /dev/null; then
    prompt_install "cmake" "brew install cmake"
else
    echo "cmake ist bereits installiert."
fi

# Prüfe und installiere coreutils, falls nproc nicht gefunden wird
if ! command -v nproc &> /dev/null; then
    prompt_install "coreutils (liefert nproc)" "brew install coreutils"
else
    echo "nproc (coreutils) ist bereits installiert."
fi

# Optional: Update pip (falls notwendig)
echo "Aktualisiere pip (optional)..."
python3 -m pip install --upgrade pip

# Installiere Python-Abhängigkeiten aus der requirements.txt
echo "Installiere Python-Abhängigkeiten..."
pip install -r requirements.txt --break-system-packages

echo "prepare.sh abgeschlossen. Alle erforderlichen Abhängigkeiten sind installiert."
echo "Du kannst jetzt das Übersetzungsskript starten (z. B. 'python3 translate_file.py <input_file> <target_language>')."