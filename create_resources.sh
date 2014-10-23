echo "<JD2ResourceManagerJobInputter>
    <ResourceOptions>
    </ResourceOptions>
    <Resources>
    </Resources>
    <Jobs>"
for i in `find ${1} -name "*.pdb" | grep -v multi`; do
    dirname=`dirname ${i}`
    basename=`echo ${i} | cut -d. -f1`
    jobname=`echo ${basename} | awk -F'/' '{ print $NF }'`
    echo "    <Job name=\"${jobname}\" nstruct=1>"
    echo "        <Option script_vars=\"rotfile=${basename}.rot startnode= important_residues=3,6,9,10,14,17,21\"/>"
    echo "    </Job>"
done
echo "    </Jobs>
</JD2ResourceManagerJobInputter>"
