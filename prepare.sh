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
        if ! eval "$install_cmd"; then
            echo "[ERROR] Installation von $pkg_name ist fehlgeschlagen. Bitte installiere $pkg_name manuell."
            exit 1
        fi
    else
        echo "[ERROR] $pkg_name wird benötigt. Bitte installiere $pkg_name manuell und starte das Skript erneut."
        exit 1
    fi
}

# Prüfe, ob Homebrew installiert ist
if ! command -v brew &> /dev/null; then
    echo "[ERROR] Homebrew ist nicht installiert. Bitte installiere Homebrew von https://brew.sh und führe das Skript erneut aus."
    exit 1
fi
echo "[INFO] Homebrew gefunden."

# Prüfe, ob Python3 installiert ist
if ! command -v python3 &> /dev/null; then
    prompt_install "Python3" "brew install python"
else
    echo "[INFO] Python3 ist bereits installiert."
fi

# Prüfe und installiere cmake, falls nicht vorhanden
if ! command -v cmake &> /dev/null; then
    prompt_install "cmake" "brew install cmake"
else
    echo "[INFO] cmake ist bereits installiert."
fi

# Prüfe und installiere coreutils (liefert nproc), falls nproc nicht gefunden wird
if ! command -v nproc &> /dev/null; then
    prompt_install "coreutils (liefert nproc)" "brew install coreutils"
else
    echo "[INFO] nproc (coreutils) ist bereits installiert."
fi

# Optional: Aktualisiere pip. Überprüfe zunächst die Version und downgrade, falls nötig.
echo "[INFO] Überprüfe Pip-Version..."
current_pip=$(python3 -m pip --version | awk '{print $2}')
# Vergleich: Wenn aktuelle Version größer als 24.0 (also ≥ 24.1) ist, downgraden
if [[ "$current_pip" > "24.0" ]]; then
    echo "[INFO] Aktuelle Pip-Version ($current_pip) ist ≥ 24.1. Downgrading auf Pip 24.0, um Probleme mit textract zu vermeiden..."
    python3 -m pip install --upgrade pip==24.0 --break-system-packages
    new_pip=$(python3 -m pip --version | awk '{print $2}')
    echo "[INFO] Neue Pip-Version: $new_pip"
else
    echo "[INFO] Pip-Version ($current_pip) ist in Ordnung."
fi

# Prüfe, ob textract installiert ist und ungültige Anforderungen hat.
if pip show textract > /dev/null 2>&1; then
    echo "[WARNING] Das Paket textract ist installiert und könnte Probleme verursachen."
    read -p "Möchtest du textract deinstallieren und aus dem GitHub-Repository installieren? [y/N]: " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        echo "[INFO] Deinstalliere textract..."
        if ! python3 -m pip uninstall -y textract --break-system-packages; then
            echo "[ERROR] Konnte textract nicht automatisch deinstallieren. Bitte deinstalliere es manuell."
            exit 1
        fi
        echo "[INFO] textract wurde deinstalliert."
        echo "[INFO] Klone textract Repository und patche setup.py..."
        TMP_DIR=$(mktemp -d)
        if ! git clone https://github.com/deanmalmgren/textract.git "$TMP_DIR/textract"; then
            echo "[ERROR] Klonen des textract-Repositories fehlgeschlagen."
            exit 1
        fi
        cd "$TMP_DIR/textract" || exit 1
        # Patch: Ersetze "extract-msg<=0.29.*" durch "extract-msg<=0.29"
        if sed -i.bak 's/extract-msg<=0.29\.\*/extract-msg<=0.29/' setup.py; then
            echo "[INFO] setup.py erfolgreich gepatcht."
        else
            echo "[ERROR] Patchen von setup.py fehlgeschlagen."
            exit 1
        fi
        if ! python3 -m pip install . --break-system-packages; then
            echo "[ERROR] Konnte textract nicht aus dem Repository installieren. Bitte installiere es manuell."
            exit 1
        fi
        cd - > /dev/null
        rm -rf "$TMP_DIR"
    else
        echo "[ERROR] textract ist erforderlich und muss fehlerfrei installiert sein. Bitte beheben Sie das Problem und starten Sie das Skript erneut."
        exit 1
    fi
fi

# Installiere Python-Abhängigkeiten aus der requirements.txt
echo "[INFO] Installiere Python-Abhängigkeiten..."
if ! pip install -r requirements.txt --break-system-packages; then
    echo "[ERROR] Es gab Fehler bei der Installation der Python-Abhängigkeiten."
    echo "Bitte überprüfen Sie die obigen Fehlermeldungen und installieren Sie die fehlenden Pakete manuell."
    exit 1
fi

echo "[INFO] prepare.sh abgeschlossen. Alle erforderlichen Abhängigkeiten sind installiert."
echo "Falls Probleme aufgetreten sind, lesen Sie die obigen Hinweise und installieren Sie die fehlenden Pakete manuell."
echo "Sie können jetzt das Übersetzungsskript starten (z. B. 'python3 translate_file.py <input_file> <target_language>')."