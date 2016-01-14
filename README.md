# WinHideDrive
Versteckt beliebige Laufwerke im Arbeitsplatz &amp; Windows Explorer. 

Werden die Laufwerke direkt angesprochen (z.B. in der Suchleiste des Explorers oder auf der Kommandozeile) sind sie weiterhin zugänglich.

<img src="../master/picture/win10.overview.png?raw=true "Übersicht"" width="30%"></img> <img src="../master/picture/win10.settings.applied.png?raw=true "Einstellungen übernommen"" width="30%"></img> 

- WinHideDrive_x64.exe - Ausführbare 64 Bit Version der Anwendung
- WinHideDrive.exe - Ausführbare 32 Bit Version der Anwendung
- WinHideDrive.au3 - Anwendung als Autoit-Quellcode (www.autoitscript.com)
- WinHideDrive.ico - Das genutzte Anwendungsicon (www.typicons.com)	

Keine Installation notwendig. Entsprechende .exe herunterladen und ausführen.

Funktionsweise:<br>Setzt den Registry-Wert NoDrives in<br>HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer.

Getestet mit:
- Windows XP 32 Bit
- Windows 7 64 Bit 
- Windows 10 64 Bit


Benötigte Berechtigung:
- Admin-Rechte zum Anlegen des Registry-Schlüssels

Sonstiges:
- Benötigt Neustart um die vorgenomme Einstellung zu übernehmen
