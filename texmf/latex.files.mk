### latex.files.mk -- Installation de fichiers pour un syst�me LaTeX

# Author: Micha�l Le Barbier Gr�newald
# Date: Dim  9 sep 2007 17:52:28 CEST
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

# LATEX+= lmodern.sty
# LATEX+= ts1lmvtt.fd
# ...
# APPLICATION = lm
# LATEXDIR = ${TEXMFDIR}/tex/latex${APPLICATIONDIR}
#
# .include "tex.files.ml"

# Le fragment pr�c�dent s'arrange pour que `build' d�pende des
# fichiers figurant dans la liste LATEX et pour que `install' installe
# ces fichiers dans ${LATEXDIR}.


TEXGROUP = LATEX
FORMAT = latex

.include "tex.files.mk"

### End of file `latex.files.mk'
