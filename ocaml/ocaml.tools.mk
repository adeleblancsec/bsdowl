### ocaml.tools.mk -- Pseudo commandes pour CAML

# Author: Micha�l Le Barbier Gr�newald
# Date: Sam  7 jul 2007 20:50:52 CEST
# Lang: fr_FR.ISO8859-1

# $Id$

# BSDMake Pall�s Scripts (http://home.gna.org/bsdmakepscripts/)
# This file is part of BSDMake Pall�s Scripts
# 
# Copyright (C) Micha�l Le Barbier Gr�newald - 2006-2009
# 
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt


### SYNOPSIS

# .include "ocaml.target.mk"
# .include "ocaml.tools.mk"


### DESCRIPTION

# Ce module d�finit les pseudo-commande MLCB, MLCN, etc. indiqu�es
# dans le tableau ci-dessous.

# MLCB		Compilateur code octet
# MLCN		Compilateur code natif
# MLCI		Compilateur d'interfaces
#                rappelons que les fichiers d'interfaces pr�par�s avec
#                un compilateur peuvent �tre utilis�s avec l'autre.
# MLAB		Facteur d'archives (biblioth�ques) code octet
# MLAN		Facteur d'archives (biblioth�ques) code natif
# MLLB		�diteur de liens code octet
# MLLN		�diteur de liens code natif
# MLPO		Cr�ateur de paquet code octet
# MLPX		Cr�ateur de paquet code natif

.if !target(__<ocaml.tools.mk>__)
__<ocaml.tools.mk>__:

_OCAML_TOOLS+= MLCI MLCB MLCN MLAB MLAN MLLB MLLN MLPO MLPX

MLCB?= ocamlc -c
MLCN?= ocamlopt -c
.if !empty(TARGET:Mbyte_code)
MLCI?= ocamlc -c
.else
MLCI?= ocamlopt -c
.endif
MLAB?= ocamlc -a
MLAN?= ocamlopt -a
MLLB?= ocamlc
MLLN?= ocamlopt
MLPO?= ${MLCB} -pack
MLPX?= ${MLCN} -pack

.endif#!target(__<ocaml.tools.mk>__)

### End of file `ocaml.tools.mk'
