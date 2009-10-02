### make_for_match.mk -- Teste la substiution et le MATCH

# Author: Micha�l Le Barbier Gr�newald
# Date: Jeu 13 mar 2008 21:58:28 CET
# Lang: fr_FR.ISO8859-15

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

# > bsdmake -f make_for_match.mk -V LIST.3
# b e
#
# Ce qui permet de conclure que l'emploi conjoint de for et du
# pr�dicat match dans la figure suivante est licite. Ceci d�coule du
# fait que ${x} est substitu� dans les membres de la boucle.

LIST.1= a b c d e
LIST.2= a c d

.for x in ${LIST.1}
.if empty(LIST.2:M${x})
LIST.3+=${x}
.endif
.endfor

### End of file `make_for_match'
