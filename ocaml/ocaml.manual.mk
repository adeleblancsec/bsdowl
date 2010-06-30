### ocaml.manual.mk -- Pr�paration de la r�f�rence HTML

# Author: Micha�l Le Barbier Gr�newald
# Date: Lun 10 mar 2008 11:59:53 CET
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

# Ce module permet de pr�parer une r�f�rence HTML � partir de fichiers
# sources contenant des commentaires OCamldoc.

# MANUAL = backend.odoc
# MANUAL+= filter.odoc
#
# SEARCHES = backend_src
# SEARCHES+= filter_src
#
# .include "ocaml.manual.mk"


### DESCRIPTION

# SEARCHES
#  Liste de dossiers � consulter pour trouver les fichiers `odoc'. Les
#   termes de la liste sont exprim�s relativement � .OBJDIR. 


### R�ALISATION

.include "bps.init.mk"

.if defined(MANUAL)&&!empty(MANUAL)
ODOC_FORMAT = html
.for module in ${MANUAL}
ODOC_LOAD+= ${module}
.endfor

USE_ODOC = yes

.include "ocaml.odoc.mk"
.endif

.include "bps.own.mk"
.include "bps.usertarget.mk"

### End of file `ocaml.manual.mk'
