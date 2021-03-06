#!/bin/sh

# File Name: sarc.sh
# Author:    Dave Hunn      
# Date:      5/21/2013
# Purpose:   This is a bash shell script to run parameter tuning on SARC.

# non-algorithm specific settings
metrics="Accuracy:CE:Coverage:Entropy:F1Measure:RNIA:ConfusionMatrix"

# the algorithm
clusterer="Sarc"

# algorithm arguments
ALPHA=0.05
BETA=0.2
EPSILON=0.001

# output file
outfile="output/${clusterer}-variance"

run_sarc () {
	in_file="$1"
	true_file=${in_file/arff/true}
	num_clusters="$2"

	for i in {1..11}; do
		echo java -Xmx1024m -jar evaluator.jar -sc $clusterer -t $in_file \
	    -c last -M $metrics -timelimit 90 -alpha $ALPHA \
		-beta $BETA -epsilon $EPSILON -numClusters $num_clusters -h_val $i #\
		#>> $outfile
	done
	# java -Xmx1024m -jar evaluator.jar -sc $clusterer -t $in_file \
 #    -c last -M $metrics -timelimit 90 -alpha $ALPHA \
	# -beta $BETA -epsilon $EPSILON -numClusters $num_clusters -h_val 100 \
	# >> $outfile

	echo "$(date): Finished evaluation of ${in_file}..." 
}

run_sarc_single_h () {
	in_file="$1"
	true_file=${in_file/arff/true}
	num_clusters="$2"

	for i in {1..20}; do
		java -Xmx1024m -jar evaluator.jar -sc $clusterer -t $in_file \
	    -c last -M $metrics -timelimit 90 -alpha $ALPHA \
		-beta $BETA -epsilon $EPSILON -numClusters $num_clusters -h_val 100 \
		>> $outfile
	done
	
	echo "$(date): Finished evaluation of ${in_file}..." 
}

# I assume this file resides in the /scripts directory. Moving one directory up
# should take us into the parent directory where the runnable jar resides
# and the relative paths used in this script will be correct.
cd ..

echo "$(date): Running evaluations for ${clusterer}..."

run_sarc "Databases/real_world_data/breast.arff" 2
# run_sarc "Databases/real_world_data/diabetes.arff" 2
# run_sarc "Databases/real_world_data/glass.arff" 6
# run_sarc "Databases/real_world_data/liver.arff" 2
# run_sarc "Databases/real_world_data/pendigits.arff" 10
# run_sarc "Databases/real_world_data/shape.arff" 9
# run_sarc "Databases/real_world_data/vowel.arff" 11

# run_sarc "Databases/synth-normal/dims/D05.arff" 10
# run_sarc "Databases/synth-normal/dims/D10.arff" 10
# run_sarc_single_h "Databases/synth-normal/dims/D20.arff" 10
# run_sarc "Databases/synth-normal/dims/D50.arff" 10
# run_sarc "Databases/synth-normal/dims/D100.arff" 10

# run_sarc "Databases/synth-normal/points/N1000.arff" 10
# run_sarc "Databases/synth-normal/points/N2000.arff" 10
# run_sarc "Databases/synth-normal/points/N4000.arff" 10
# run_sarc "Databases/synth-normal/points/N8000.arff" 10
# run_sarc "Databases/synth-normal/points/N16000.arff" 10

echo "$(date): Finished evaluation of all data sets for ${clusterer}"

exit 0

















