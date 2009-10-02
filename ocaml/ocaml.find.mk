### ocaml.find.mk -- Ligne de commande avec ocamlfind

# Author: Micha�l Le Barbier Gr�newald
# Date: Sam  7 jul 2007 20:14:16 CEST
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

# USE_OCAMLFIND = yes
# PACKAGES+= unix
# PACKAGES+= nums
# PREDICATES+= mt
# .include "ocaml.target.mk"
# .include "ocaml.find.mk"
# .include "ocaml.tools.mk"


### DESCRIPTION

# Ce module d�termine gr�ce � la pr�sence d'une liaison pour l'une des
# variables PACKAGES, PREDICATES ou USE_OCAMLFIND, si l'usager
# souhaite utiliser ocamlfind. Dans ce cas, ce module les
# pseudo-commandes pour la compilation et l'�dition de lien avec
# OCAMLFIND.


.if !target(__<ocaml.find.mk>__)
__<ocaml.find.mk>__:

.if defined(PACKAGES)&&!empty(PACKAGES)
USE_OCAMLFIND=yes
.endif

.if defined(PREDICATES)&&!empty(PREDICATES)
USE_OCAMLFIND=yes
.endif

USE_OCAMLFIND?=no

.if ${USE_OCAMLFIND} == yes
MLCB?= ocamlfind ocamlc -c
MLCN?= ocamlfind ocamlopt -c
OCAMLDOC?= ocamlfind ocamldoc
.if !empty(TARGET:Mbyte_code)
MLCI?= ocamlfind ocamlc -c
.else
MLCI?= ocamlfind ocamlopt
.endif
MLLB?= ocamlfind ocamlc -linkpkg
MLLN?= ocamlfind ocamlopt -linkpkg
.endif

.for pseudo in MLCB MLCN MLCI MLLB MLLN OCAMLDOC
.if defined(PACKAGES)&&!empty(PACKAGES)
${pseudo}+= -package "${PACKAGES}"
.endif
.if defined(PREDICATES)&&!empty(PREDICATES)
${pseudo}+= -predicates "${PREDICATES}"
.endif
.endfor

.endif #!target(__<ocaml.find.mk>__)

### End of file `ocaml.find.mk'
