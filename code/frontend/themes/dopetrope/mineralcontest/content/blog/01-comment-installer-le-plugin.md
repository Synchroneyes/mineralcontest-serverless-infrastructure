+++
content_type = "blog"
title = "Comment installer le plugin ?"
description = "Un tutoriel pas à pas pour pouvoir installer le plugin."
published_date = "13/6/2023"
slug = "installer-le-plugin"
author = "Synchroneyes"
draft = false
hidesidebar = true
+++


{{< table_of_contents >}}


### 1. Informations importantes
Avant toute chose, il est très important de noter les éléments suivants: <br />
**⚠️ Le plugin n'est pas compatible avec les hébergeurs gratuits tel que Aternos, Minestrator ou autre ⚠️**


Il est possible d'héberger un serveur sur son propre ordinateur, des tutoriels sont disponible sur YouTube. Il faut veiller à ouvrir ses ports réseaux sur sa box internet pour que vos amis puissent vous rejoindre.

### 2. Pré-requis

Dans un premier temps, il est important d'énoncer les différents pré-requis au bon fonctionnement du plugin. À l'heure actuelle, il est nécessaire de disposer d'un serveur **Spigot** en version **1.19**. <br />
Sur le serveur où est héberger le serveur Minecraft, que ça soit votre propre ordinateur ou un serveur que vous louez, **Java 18** doit être installé. Si vous louez un serveur et que vous choisissez la version 1.19 de Spigot, vous n'avez pas à vous soucier de ce point.

### 3. Téléchargement

Rendez-vous sur la page de téléchargement de fichiers présent [ici](/files/) et choisissez la version que vous désirez installer.
Vous trouverez un tableau similaire à celui présent ci-dessous: <br />

{{< html >}}
<table class="table table-bordered table-responsive">
    <thead>
        <th>Type</th>
        <th>Version</th>
        <th>Type de serveur</th>
        <th>Version de serveur</th>
    </thead>
    <tbody>
        <tr>
            <td>Type de plugin, prenez un type Plugin</td>
            <td>Version du plugin, la plus élevée vous offre la dernière 
version disponible</td>
            <td>Le type de serveur, généralement Spigot</td>
            <td>La version du serveur que vous utilisez. Notez qu’une 
version inférieur peut inclure des anciens bugs/problèmes</td>
        </tr>
    </tbody>
</table>
{{< /html >}}


⚠️ Il est également important de noter que l'équipe Mineral Contest n'apportera aucun support sur une version qui n'est pas la dernière disponible. ⚠️

### 4. Installation

C'est très simple, il vous suffit de placer le fichier `MineralContest.jar` dans le dossier Plugins présent dans votre serveur Minecraft.
Relancez ensuite le serveur.

### 5. Configuration

Ce plugin a été pensé afin d'être pratique et simple d'installation. Il n'y a aucune configuration nécessaire pour son bon fonctionnement. <br />

Cependant, dans le cas où vous souhaitez le placer dans un serveur avec d'autres plugins et plusieurs mondes (non mineral-contest), il y a un paramètre à changer.

Une fois le serveur démarré pour la première fois avec le plugin, dans le dossier `plugins` de votre serveur, un dossier `MineralContest` a été crée. À l'intérieur vous trouverez un dossier `config` puis un fichier `plugin_config.yaml`. Editez ce fichier avec un éditeur de texte, le bloc note suffit, et trouvez la ligne: `world_name: world`. Remplacez `world` par le nom du monde où vous souhaitez faire fonctionner le plugin. Si vous venez de créer un serveur dans le seul but de jouer à Mineral Contest, cette étape n'est pas nécessaire.

Une fois cette étape accomplie, relancez le serveur.

### 6. Vidéo explicative

Une vidéo est disponible sur Youtube, rendez-vous sur ce lien [https://youtube.com/watch?v=JUsEVdwfxfk](https://youtube.com/watch?v=JUsEVdwfxfk)

{{< youtube id="JUsEVdwfxfk" >}}

