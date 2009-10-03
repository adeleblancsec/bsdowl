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

.include "subdir.mk"
.include "../../bps/bps.project.mk"

# Ouverture d'un shell pour le d�veloppeur
#
# La substitution de la variable MAKEFLAGS est modifi�e pour que les
# options de type `-I' de make apparaissent sous forme compacte. Pour
# cela, elle fait l'hypoth�se que les termes commen�ant par un `/' ou
# un `.' sont des chemins � traiter comme arguments pour `-I'.
#
# La variable SHELL est d�finie dans l'environnement.

shell:
	env MAKEFLAGS="${.MAKEFLAGS:C|-I||:C|^[/\.]|-I/|}" ${SHELL}

.endif # !target(__<pallas>__)

### End of file `pallas'
