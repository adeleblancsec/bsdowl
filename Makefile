### Makefile

# Author: Micha�l Gr�newald
# Date: Ven 10 f�v 2006 16:50:40 GMT
# Lang: fr_FR.ISO8859-1

# $Id$

PROJECT = bsdmakepscripts
VERSION = 1.1
AUTHOR = Micha�l Gr�newald

SUBDIR+= bps
SUBDIR+= ocaml
SUBDIR+= text
SUBDIR+= misc
SUBDIR+= www
SUBDIR+= support

# Le fichier Makefile.inc est produit par la commande
# `./configure'. Tant que la commande `./configure' n'a pas �t�
# utilis�e pour pr�parer l'arbre des sources, ce Makefile ne peut pas
# �tre utilis�.

.include "Makefile.inc"
.include "pallas.mk"

### End of file `Makefile'
