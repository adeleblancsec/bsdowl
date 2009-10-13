### tex.files.main.mk -- Installation de fichiers pour un système TeX

# Author: Michaël Le Barbier Grünewald
# Date: Dim  9 sep 2007 17:32:25 CEST
# Lang: fr_FR.ISO8859-15

# $Id$

# BSDMake Pallàs Scripts (http://home.gna.org/bsdmakepscripts/)
# This file is part of BSDMake Pallàs Scripts
#
# Copyright (C) Michaël Le Barbier Grünewald - 2006-2009
#
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt

# Voir le fichier `tex.files.mk' pour la documentation.

MKTEXLSR?= mktexlsr
FILESGROUPS+= TEXFILES
FORMAT?= generic
APPLICATION?= misc
TEXDOCDIR?= ${TEXMFDIR}/doc/${FORMAT}${APPLICATIONDIR}
TEXFILESDIR?= ${TEXMFDIR}/tex/${FORMAT}${APPLICATIONDIR}

.if defined(TEXFILES)&&!empty(TEXFILES)
post-install: post-install-mktexlsr
post-install-mktexlsr:
	${MKTEXLSR} ${TEXMFDIR}
.endif

### End of file `tex.files.main.mk'
