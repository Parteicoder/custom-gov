# Custom Governor - Keqing

Dieses Mod fügt **Keqing** und **Ningguang** als zusätzliche Gouverneure für Civilization VI hinzu.

## Basis

Dieses Projekt ist als Erweiterung / Add-on zur bestehenden **Liyue and Inazuma Pack** Mod gedacht:

- https://github.com/dwughjsd/LiyueInazuma_civ6mod
- Steam Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=2944798624

Die Referenz-Mod nutzt die Mod-GUID:

```text
8772720f-9d8b-4f4f-a46d-87bdfa7b2966
```

Diese ID ist in `custom-gov.modinfo` als Abhängigkeit eingetragen. Dadurch soll Civilization VI dieses Add-on nur zusammen mit der Liyue/Inazuma-Mod aktivieren.

## Aktueller Inhalt

- **Keqing - Yuheng der Sieben Sterne** als Gouverneurin
- **Ningguang - Tianquan der Qixing** als Gouverneurin
- Promotion-Trees mit Grundfähigkeit und mehreren Aufwertungen
- Reichsweite Effekte statt reiner Stadtboni
- Platzhalter-Icons und Platzhalter-Porträts aus vorhandenen Civ-VI-Governor-Ressourcen

## Reichsweite Effekte

### Keqing

- Grundfähigkeit: +1 Produktion in allen Städten
- Aufwertung 1: +2 Gold in allen Städten
- Aufwertung 2: +15 % Produktion für Bezirke in allen Städten
- Aufwertung 3A: +1 Wissenschaft in allen Städten
- Aufwertung 3B: +1 Kultur in allen Städten

### Ningguang

- Grundfähigkeit: +4 Gold auf Handelsrouten aus eigenen Städten
- Aufwertung 1: +3 Gold aus Handelsrouten mit fremden Städten
- Aufwertung 2: +2 Einflusspunkte pro Runde auf Stadtstaaten
- Aufwertung 3: +2 Große-Händler-Punkte pro Runde

## Bekannte Einschränkungen

- Icons und Porträts sind Platzhalter.
- Ein echter Ingame-Test in Civilization VI ist nötig, um Datenbank- und UI-Fehler endgültig auszuschließen.

## Installation

1. Installiere und aktiviere die Liyue/Inazuma-Referenzmod.
2. Lade dieses Repository als ZIP herunter oder klone es.
3. Kopiere den Ordner in deinen Civilization-VI-Mods-Ordner.
4. Aktiviere **Custom Governor - Keqing** im Spiel.
5. Starte ein neues Spiel mit Rise and Fall / Gathering Storm.
6. Öffne das Gouverneursmenü und prüfe, ob Keqing und Ningguang ohne `LOC_...`-Fehler erscheinen.
7. Prüfe im Spiel, ob die reichsweiten Werte nach Ernennung und Aufwertung der Gouverneure steigen.

## Credits

- Basierend auf der Liyue/Inazuma Mod von dwughjsd
- Governor-Design von Parteicoder + Grok
