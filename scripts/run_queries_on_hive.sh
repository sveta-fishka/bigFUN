# get home path
# BENCH_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd );
BENCH_HOME="/home/cloudera/Desktop/test"
echo "\$BENCH_HOME is set to $BENCH_HOME"
DATABASE="tiny_social"
BENCHMARK="BigFun"
FILE_FORMAT="hql"
QUERY_DIR=$BENCH_HOME/hive-queries
TEST_QUERIES="1 2 3 4 5 6 7 8 9 1010 1011 1012 1013 1014 1015 1016 2012 2013 2014 2015"

# Read the TPC-H config parameters
# source $BENCH_HOME/tpch/conf/settings.sh
# Set path to the hive settings
#HIVE_SETTING=$BENCH_HOME/$BENCHMARK/queries/hive.settings
# Set path to tpc-h queries
# QUERY_DIR=$BENCH_HOME/$BENCHMARK/queries

# Create output directory
CURDATE="`date +%Y-%m-%d`"
RESULT_DIR=$BENCH_HOME/$CURDATE
mkdir $RESULT_DIR

# Initialize log file for data loading times
LOG_FILE_EXEC_TIMES="${BENCH_HOME}/logs/query_times.csv"
if [ ! -e "$LOG_FILE_EXEC_TIMES" ]
  then
    touch "$LOG_FILE_EXEC_TIMES"
    echo "STARTDATE_EPOCH|STOPDATE_EPOCH|DURATION_MS|STARTDATE|STOPDATE|DURATION|BENCHMARK|DATABASE|ENGINE|FILE_FORMAT|QUERY" >> "${LOG_FILE_EXEC_TIMES}"
fi

if [ ! -w "$LOG_FILE_EXEC_TIMES" ]
  then
    echo "ERROR: cannot write to: $LOG_FILE_EXEC_TIMES, no permission"
    return 1
fi

#HOSTFILE=$BENCH_HOME/bin/hostlist
#i=1
#while [ $i -le $NUM_QUERIES ]

for i in ${TEST_QUERIES}
do
	# Measure time for query execution time
	# Start timer to measure data loading for the file formats
	STARTDATE="`date +%Y/%m/%d:%H:%M:%S`"
	STARTDATE_EPOCH="`date +%s`" # seconds since epochstart
	
	# Execute query
	
	#default engine is hive
		ENGINE=hive
		echo "Hive query: ${i}"
		hive --database ${DATABASE} -f ${QUERY_DIR}/hive_query_${i}.hql > ${RESULT_DIR}/${DATABASE}_query${i}.txt 2>&1
	
	# Calculate the time
	STOPDATE="`date +%Y/%m/%d:%H:%M:%S`"
	STOPDATE_EPOCH="`date +%s`" # seconds since epoch
	DIFF_s="$(($STOPDATE_EPOCH - $STARTDATE_EPOCH))"
	DIFF_ms="$(($DIFF_s * 1000))"
	DURATION="$(($DIFF_s / 3600 ))h $((($DIFF_s % 3600) / 60))m $(($DIFF_s % 60))s"
	# log the times in load_time.csv file
	echo "${STARTDATE_EPOCH}|${STOPDATE_EPOCH}|${DIFF_ms}|${STARTDATE}|${STOPDATE}|${DURATION}|${BENCHMARK}|${DATABASE}|${ENGINE}|${FILE_FORMAT}|Query ${i}" >> ${LOG_FILE_EXEC_TIMES}	
	#i=$(( i+1 ))	
	#i=`expr $i + 1`
done
# clear the Hadoop logs
#  hadoop fs -rm -R -skipTrash /tmp/hive-root/*
