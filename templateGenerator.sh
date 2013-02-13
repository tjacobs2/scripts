classname=$1
#classname="test"
rosettaPath=`pwd | sed 's/.*mini\/src\/\(.*\)/\1/'`
rosettaPath="${rosettaPath}/"
tracerName=`echo $rosettaPath | tr '/' '.'`
ifndefName=`echo $rosettaPath | tr '/' '_'`
classPath=`echo $rosettaPath | tr '/' '::'`

ccFile="// -*- mode:c++;tab-width:2;indent-tabs-mode:t;show-trailing-whitespace:t;rm-trailing-spaces:t -*- \n
// vi: set ts=2 noet:\n
//\n
// (c) Copyright Rosetta Commons Member Institutions.\n
// (c) This file is part of the Rosetta software suite and is made available under license.\n
// (c) The Rosetta software is developed by the contributing members of the Rosetta Commons.\n
// (c) For more information, see http://www.rosettacommons.org. Questions about this can be\n
// (c) addressed to University of Washington UW TechTransfer, email: license@u.washington.edu.\n
\n
/// @file   ${rosettaPath}${classname}.cc\n
/// @brief  \n
/// @author Tim Jacobs \n
\n
// Unit Headers\n
#include <${rosettaPath}${classname}.hh>\n
\n
// Package Headers\n
\n
// Project Headers\n
\n
// Utility Headers\n
\n
// Numeric Headers\n
\n
// C++ headers\n
#include <stdlib.h>\n\n"

namespaceArray=`echo $rosettaPath | tr '/' '\n'`

for i in $namespaceArray 
do
	ccFile="${ccFile} ${i}{\n"
done

ccFile="${ccFile}\n
using core::Size;\n
\n
static Tracer TR(\"${tracerName}${classname}\");\n
\n
${classname}::${classname}() :\n
{}\n
\n
${classname}::~${classname}(){}\n\n"

for i in $namespaceArray 
do
	ccFile="${ccFile}} //namespace\n"
done

echo -e $ccFile > ${classname}.cc
#echo -e $ccFile 


hhFile="// -*- mode:c++;tab-width:2;indent-tabs-mode:t;show-trailing-whitespace:t;rm-trailing-spaces:t -*- \n
// vi: set ts=2 noet:\n
//\n
// (c) Copyright Rosetta Commons Member Institutions.\n
// (c) This file is part of the Rosetta software suite and is made available under license.\n
// (c) The Rosetta software is developed by the contributing members of the Rosetta Commons.\n
// (c) For more information, see http://www.rosettacommons.org. Questions about this can be\n
// (c) addressed to University of Washington UW TechTransfer, email: license@u.washington.edu.\n
\n
/// @file   ${rosettaPath}${classname}.hh\n
/// @brief  \n
/// @author Tim Jacobs \n
\n
#ifndef INCLUDED_${ifndefName}${classname}_hh\n
#define INCLUDED_${ifndefName}${classname}_hh\n
\n
// Unit Headers\n
\n
// Package Headers\n
\n
// Project Headers\n
\n
// Utility Headers\n
\n
// Numeric Headers\n
\n
// C++ headers\n
#include <stdlib.h>\n
\n"

for i in $namespaceArray 
do
	hhFile="${hhFile} ${i}{\n"
done

hhFile="${hhFile}\n
class ${classname} {\n
private:\n
\n
public:\n
	\t//constructor\n
	\t${classname}();\n
\n
	\t//destructor\n
	\t~${classname}();\n
\n
};//class\n
\n"

for i in $namespaceArray 
do
	hhFile="${hhFile}} //namespace\n"
done

hhFile="${hhFile}#endif // include guard\n"

echo -e ${hhFile} > ${classname}.hh

fwdFile="// -*- mode:c++;tab-width:2;indent-tabs-mode:t;show-trailing-whitespace:t;rm-trailing-spaces:t -*- \n
// vi: set ts=2 noet:\n
//\n
// (c) Copyright Rosetta Commons Member Institutions.\n
// (c) This file is part of the Rosetta software suite and is made available under license.\n
// (c) The Rosetta software is developed by the contributing members of the Rosetta Commons.\n
// (c) For more information, see http://www.rosettacommons.org. Questions about this can be\n
// (c) addressed to University of Washington UW TechTransfer, email: license@u.washington.edu.\n
\n
/// @file   ${rosettaPath}${classname}.fwd.hh\n
/// @brief  \n
/// @author Tim Jacobs \n
\n
#ifndef INCLUDED_${ifndefName}${classname}_fwd_hh\n
#define INCLUDED_${ifndefName}${classname}_fwd_hh\n
\n
// Utility headers\n
#include <utility/pointer/owning_ptr.hh>\n
\n"

for i in $namespaceArray 
do
	fwdFile="${fwdFile} ${i}{\n"
done

fwdFile="${fwdFile}\n
class HBondFeatures;\n
typedef utility::pointer::owning_ptr< HBondFeatures > HBondFeaturesOP;\n
typedef utility::pointer::owning_ptr< HBondFeatures const > HBondFeaturesCOP;\n
\n"

for i in $namespaceArray 
do
	fwdFile="${fwdFile}} //namespace\n"
done

fwdFile="${fwdFile}#endif // include guard\n"

echo -e ${fwdFile} > ${classname}.fwd.hh
