start-dfs.sh
start-yarn.sh
jps

hadoop version
hdfs dfsadmin -report

echo "hello hadoop this is a sample file for hdfs practical" > sample.txt

hdfs dfs -mkdir -p /user/student/input
hdfs dfs -ls /

hdfs dfs -put sample.txt /user/student/input/
hdfs dfs -copyFromLocal sample.txt /user/student/input/sample_copy.txt
hdfs dfs -ls /user/student/input

hdfs dfs -get /user/student/input/sample.txt downloaded.txt
hdfs dfs -copyToLocal /user/student/input/sample_copy.txt downloaded_copy.txt
cat downloaded.txt

hdfs dfs -rm /user/student/input/sample_copy.txt
hdfs dfs -ls /user/student/input

hdfs dfs -mkdir -p /user/student/output
hdfs dfs -mv /user/student/input/sample.txt /user/student/output/
hdfs dfs -ls /user/student/output
hdfs dfs -cat /user/student/output/sample.txt
hdfs dfs -tail /user/student/output/sample.txt

hdfs dfs -du -h /user/student
hdfs dfs -stat "%n %b %r" /user/student/output/sample.txt
hdfs dfs -setrep 2 /user/student/output/sample.txt
hdfs fsck /user/student/output/sample.txt -files -blocks

hdfs dfs -rm -r /user/student/output

stop-yarn.sh
stop-dfs.sh
