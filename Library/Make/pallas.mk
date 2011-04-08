### pallas -- Fichier de directives principal

# Author: Micha�l Le Barbier Gr�newald
# Date: Dim 13 avr 2008 23:56:07 CEST
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

### DESCRIPTION

.if !target(__<pallas>__)
__<pallas>__:

do-publish:
	cd Website; make all install PREFIX='${HOME}' WWWBASE='${HOME}/Workshop/Pages/bsdmakepscripts'

.include "subdir.mk"
.include "../../bps/bps.project.mk"

.endif # !target(__<pallas>__)

### End of file `pallas'
