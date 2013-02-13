sed -i 's/assert(/runtime_assert(/g' ~/rosetta/rosetta_source/src/core/conformation/Conformation.cc
sed -i 's/runtime_runtime_assert(/runtime_assert(/g' ~/rosetta/rosetta_source/src/core/conformation/Conformation.cc

sed -i 's/assert(/runtime_assert(/g' ~/rosetta/rosetta_source/src/utility/vectorL.hh
sed -i 's/runtime_runtime_assert(/runtime_assert(/g' ~/rosetta/rosetta_source/src/utility/vectorL.hh

#sed -i 's/ASSERT_ONLY//' ~/rosetta/rosetta_source/src/core/conformation/Conformation.cc

sed -i 's$#include <utility/vectorL.fwd.hh>$#include <utility/exit.hh>\n#include <utility/vectorL.fwd.hh>$' ~/rosetta/rosetta_source/src/utility/vectorL.hh
