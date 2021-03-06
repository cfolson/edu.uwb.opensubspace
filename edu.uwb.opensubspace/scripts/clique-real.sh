# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# File Name: clique-synth.sh
# Author:    Dave Hunn      
# Date:      12/16/2012 (updated 9/1/2013)
# Purpose:   This is a bash shell script to run parameter tuning on clique.
#

# non-algorithm specific settings
dbs="Databases/real_world_data/*.arff"
metrics="Accuracy:CE:ClusterDistribution:Coverage:Entropy:F1Measure:RNIA"

# the algorithm
clusterer="Clique"

# algorithm arguments
TAU_OFFSET=10.0
XI_OFFSET=5

# I assume this file resides in the /scripts directory. Moving one directory up
# should take us into the parent directory where the runnable jar resides
# and the relative paths used in this script will be correct.
cd ..

echo "Running evaluations for ${clusterer}..."
for db in $dbs; do
	for in_file in $db; do
		true_file=${in_file/arff/true}
		outfile="output/clique-real"

		echo "Starting evaluation of ${in_file}..."
		TAU=0.001  # initialize
		for i in {1..3}; do
			let XI=5  # initialize
			for j in {1..6}; do
				echo "$(date): Running CLIQUE with XI=${XI} and TAU=${TAU}..."
				java -Xmx1024m -jar evaluator.jar -sc $clusterer -t $in_file -T $true_file -c last -M $metrics -XI $XI -TAU $TAU -timelimit 30 >> $outfile
				XI="$(echo "$XI + $XI_OFFSET" | bc)"
			done
			TAU="$(echo "$TAU * $TAU_OFFSET" | bc)"
		done
		echo "Finished evaluation of ${in_file}..." 
	done
done




