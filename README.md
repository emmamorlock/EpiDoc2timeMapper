# EpiDoc2timeMapper
Exemple d'exploitation d'un encodage TEI/EpiDoc pour une visualisation dans une carte geo-temporelle (avec TimeMapper par exemple)

Pour transformer le fichier xml avec oxygen Editor
- créer un scénario de validation
- Cocher 'Use xml-stylesheet declaration'
- choisir Saxon HE 
- dans l'onglet 'output', cliquer sur le bouton radio 'prompt for file'

Important : les feuilles de styles d'EpiDoc doivent être dans un dossier example-p5-xslt
pour mettre à jour le contenu du dossier avec les dernières mises à jour d'EpiDoc, c'est ici : https://sourceforge.net/p/epidoc/wiki/Stylesheets/

Ensuite créer un fichier avec l'extension .csv qui sera importé dans timeMapper... (exemple : theores-col2.csv)
