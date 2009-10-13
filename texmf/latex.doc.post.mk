### latex.doc.post.mk -- Produce LaTeX documents

# Author: Micha�l Le Barbier Gr�newald
# Date: Dim  9 sep 2007 14:49:18 CEST
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

# Confer `tex.doc.mk'.

_latex_doc_summary: .USE
	${INFO} 'Information summary for ${.TARGET:T}'
	@- (\
	  ! ${GREP} 'LaTeX \(Error\|Warning\|Font Error\)' ${.TARGET:R}.log \
	) && ${ECHO} 'Everything seems in order'

.for var in _TEX_DVI _TEX_PDF _TEX_PS
.if defined(${var})&&!empty(${var})
.for doc in ${${var}}
${doc}: _latex_doc_summary
.endfor
.endif
.endfor

### End of file `latex.doc.post.mk'
