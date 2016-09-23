# Art génératif

Simulation 3D d'un automate cellulaire (jeu de la vie, Conway) en __``JAVA ``__.
Pour cela, nous avons utilisé __Processing__.

## Règles

- une naissance a lieu lorsque l'environnement est favorable (exactement ***n*** voisins sont vivants)
- la mort intervient par isolement avec moins de ***m*** voisins vivants ou par surpopulation avec plus de ***p*** voisins vivants

*n, m et p sont des variables configurables.*

## Fonctionnalités

### Activer le mode plein écran :

Remplacer
```java
size(800, 600, P3D);
```
Par 
```java
fullscreen(P3D);
```

### Activer le mode debug (*pause entre chaque itération*)

Changer la valeur en __true__ de la variable ``debugMode`` :
```java
boolean debugMode = true;
```
Puis taper sur ``ESPACE`` pour avancer d'une itération à chaque fois.

### Activer le mode screenshot

Changer la valeur en __true__ de la variable ``screenshotMode`` :
```java
boolean screenshotMode = true;
```

Il sauvegardera une image par itération dans le dossier "screenshots";

### Modifier les conditions de vie et de mort

Le tableau ``rules`` contient dans l'ordre : apparition de la vie, limite "mort par isolation", limite "mort par surpopulation".

### Modifier la taille des cubes

Modifier la valeur de la variable ``SIZE``.

### Modifier la vitesse entre chaque itération

Modifier la valeur de la variable ``timerMax``.

### Exporter son tableau "monde" au format ***world***

Utiliser la fonction ``exportWorld()``, prend comme paramètre le nom du fichier :
```java
exportWorld("test");
```

### Bouger dans le repère

Appuyez sur les touches multidirectionnelles du clavier.

### Importer son tableau "monde" au format ***world***

Utiliser la fonction ``importWorld()``, prend comme paramètre le nom du fichier :
```java
importWorld("test");
```

## Remarque

Aide par ligne pour la syntaxe du fichier ``file.world`` :
- coordonnées x, y et z séparées par un ``;``
- 0 ou 1 séparés par un ``,``
- le prochain fichier à importer ``nextWorld = test2`` *(facultatif)*
- le nombre d'itérations avant l'import du nouveau fichier ``duration = 30`` ou ``duration = auto`` pour attendre des motifs stables
- la distance entre la caméra et l'objectif ``cameraDistance = 300`` *(facultatif)*
- permettre l'apparition de figures aléatoires ``random = true`` *(facultatif)*
