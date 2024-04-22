---

# PowerShell Script voor het Exporteren van Maprechten naar CSV

Dit PowerShell-script is ontworpen om de toegangsrechten (ACLs) van submappen binnen een specifieke map te scannen en deze informatie te exporteren naar een CSV-bestand. Dit is bedoeld vooral voor audits.

## Vereisten

- PowerShell 5.1 of hoger
- Toegang tot de mappen waarvoor je de rechten wilt scannen

## Gebruik

1. Open PowerShell ISE als Administrator. Dit is noodzakelijk om toegang te krijgen tot de ACLs van de mappen.

2. Voer het script uit door het in PowerShell ISE te openen, change directory (cd) naar de directory dat je wilt scannen en run daarna het script.
   
3. Het script zal je vragen om bevestiging voordat het de scan start:
   ```
   Directory [Mapnaam] zal gescanned worden, dit kan lang duren als er veel folders/users/groups zijn (y/n)?
   ```
   Typ `y` om door te gaan of `n` om het script te stoppen.

## Output

Het script genereert een CSV-bestand met de naam `DirectoryPermissions[Mapnaam]_[Datum].csv` in de huidige map. Dit bestand bevat de volgende kolommen:

- `DirectoryPath`: Het volledige pad naar de map.
- `IdentityReference`: De gebruiker of groep waaraan de rechten zijn toegekend.
- `AccessControlType`: Geeft aan of de toegang is toegestaan of geweigerd.
- `FileSystemRights`: De specifieke rechten die zijn toegekend of geweigerd.
- `IsInherited`: Geeft aan of de rechten zijn geërfd van een bovenliggende map.

## Vooruitgangsbalk

Tijdens het uitvoeren van het script wordt een voortgangsbalk weergegeven die de voortgang toont van het scannen van de mappen en het exporteren van de gegevens naar het CSV-bestand.

## Belangrijke Opmerkingen

- Het script kan enige tijd in beslag nemen, afhankelijk van het aantal submappen.
- Zorg ervoor dat je voldoende rechten hebt om de maprechten te lezen.
- CPU usage zal rond de 50% liggen normaal gezien, als er andere processen bezig zijn die meer dan 50% gebruiken zal het zeer traag gaan, maar zal er geen bottleneck ontstaan normaal gezien.
---
