# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# File Name: inscy-synth.sh
# Author:    Dave Hunn      
# Date:      1/21/2013
# Purpose:   This is a bash shell script to run parameter tuning on INSCY.
#

# non-algorithm specific settings
class_path="i9-weka.jar:weka.jar:i9-subspace.jar:Jama.jar:jsc.jar:commons-math-1.1.jar:vecmath.jar:j3dcore.jar:j3dutils.jar weka.subspaceClusterer.SubspaceClustererEvaluator"
dbs="Databases/synth_dbsizescale/*.arff Databases/synth_dimscale/*.arff Databases/synth_noisescale/*.arff"
metrics="Accuracy:CE:ClusterDistribution:Coverage:Entropy:F1Measure:RNIA"

# the algorithm
clusterer="INSCY"

# algorithm arguments
density=10
epsilon=10
gridSize=50
maximalClusterRate=0
minPoints=2
minSize=20
usingKernel=1

epsilon_offset=2
minPoints_offset=2
minSize_offset=2

echo "Running evaluations for ${clusterer}..."

for db in $dbs
do
	for in_file in $db
	do
		true_file=${in_file/arff/true}
		outfile="output/${clusterer}-synth"
		
		echo "Starting evaluation of ${in_file}..."
		
		epsilon=10  # initialize
		for i in {1..5}
		do
			minPoints=2 # initialize		
			for j in {1..5}
			do
				minSize=20  # initialize
				for k in {1..5}
				do
					echo "Running ${clusterer} with epsilon=${epsilon}, minPoints=${minPoints}, and minSize=${minSize}."
					java -Xmx1024m -cp $class_path -sc $clusterer -t $in_file -T $true_file -c last -M $metrics -timelimit 30 -density $density -epsilon $epsilon -gridSize $gridSize -maximalClusterRate $maximalClusterRate -minPoints $minPoints -minSize $minSize -usingKernel $usingKernel >> $outfile
					
					minSize="$(echo "$minSize * $minSize_offset" | bc)"
				done
				minPoints="$(echo "$minPoints * $minPoints_offset" | bc)"
			done
			epsilon="$(echo "$epsilon * $epsilon_offset" | bc)"
		done
		echo "Finished evaluation of ${in_file}..." 
	done
done


