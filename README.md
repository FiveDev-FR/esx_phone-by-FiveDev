# esx_phone-by-FiveDev
Fivem esx_phone

As we are a french team, this readme is written in baguette. An english translation is available too, lower on this file. 

**Fonctionalitées**
- Interface utilisateurs tout à la souris
- Appel à Police, Ambulance, Depanneur, Taxi avec position GPS
- Possibilité d'envoyer un message en anonyme
- Nommer les contacte lors de l'enregistrement du numéro
- Si un Contacte est en ligne une bulle verte s'affiche à côté de celui-ci

![esx_phone](https://cdn.discordapp.com/attachments/314380362815897602/328718080245235723/unknown.png)


**Prerequis**
*Obligatoire*
- [es_extended](https://github.com/indilo53/fivem-es_extended) (Indilo53)

**Prerequis**
*Optionnel*
- [esx_policejob](https://github.com/indilo53/fivem-esx_policejob) (Indilo53)
- [esx_ambulancejob](https://github.com/indilo53/fivem-esx_ambulancejob) (Indilo53)
- [esx_taxijob](https://github.com/Lariime/esx_taxijob) (Lariime)
- [esx_depanneurjob](https://github.com/ig0ne/esx_depanneurjob) (ig0ne)

**Instructions**
- Coller esx_phone dans esx
- Installer le sql dans la bdd
- Ajouter esx_phone dans votre citmp-server
- Supprimer les 
      TriggerEvent('esx_phone:registerCallback', function(source, phoneNumber, message)
      end)
  dans les ambulance, depanneurs, taxi et policejob.
 
 
**Credits**
- Si vous repartagez ce scripts merci de mentionner la team "FiveDev"
- Si vous modifiez ces fichiers, vous devez partager cette nouvelle version.


**Auteurs**
- Renaiku & .flo (FiveDev)

**Support**
- [Discord ESX](https://discord.gg/vVpwCpU)
- Etant donné que c'est un script pour ESX nous ne pourrons pas vous aider si vous voulez l'intégrer à un autre "core"


*English version*

**Features**
- Full mouse controlled user interface
- Call Police / EMS / Towtruck & Taxi with GPS position sent
- Anonymous message available (no phone number shown on receiver side)
- Save a contact in the phone with the name you want
- Shows a litle greeen buble next to online contact


![esx_phone](https://cdn.discordapp.com/attachments/314380362815897602/328718080245235723/unknown.png)


**Prerequisites**
*Mandatory*
- [es_extended](https://github.com/indilo53/fivem-es_extended) (Indilo53)

**Prerequisites**
*Optionnal*
- [esx_policejob](https://github.com/indilo53/fivem-esx_policejob) (Indilo53)
- [esx_ambulancejob](https://github.com/indilo53/fivem-esx_ambulancejob) (Indilo53)
- [esx_taxijob](https://github.com/Lariime/esx_taxijob) (Lariime)
- [esx_depanneurjob](https://github.com/ig0ne/esx_depanneurjob) (ig0ne)

**Instructions**
- Paste esx_phone into ressources/esx
- Run .sql file onto your database to create and modify needed table
- Add esx_phone into your citmp-server
- Comment out or delete :
	TriggerEvent('esx_phone:registerCallback', function(source, phoneNumber, message)
      end)
  inside ambulance, towtruc (depanneur), taxi and policejob if needed

 
 
**Credits**
- If you re-share this script, thanks to credit the FiveDev team
- If you modify this script, you have to share the new version


**Authors**
- Renaiku & .flo (FiveDev)

**Support**
- [Discord ESX](https://discord.gg/vVpwCpU)
- Given this is an ESX script, we won't be able to help you if you want to use it with any other "core" 
