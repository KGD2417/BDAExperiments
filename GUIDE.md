# Big Data Analytics Lab: Complete Guide

## Folder layout

| Exp | Folder | Files | How to run |
|---|---|---|---|
| 1 | `Exp1_HDFS` | `hdfs_commands.sh` | Run commands one by one on a machine with Hadoop |
| 2 | `Exp2_WordCount` | `mapper.py`, `reducer.py`, `wordcount.py`, `input.txt` | `python wordcount.py` or the pipe/Hadoop commands below |
| 3 | `Exp3_FlajoletMartin` | `flajolet_martin.py` | `python flajolet_martin.py` |
| 4 | `Exp4_DGIM` | `dgim.py` | `python dgim.py` |
| 5 | `Exp5_MongoDB` | `mongodb_crud.js` | Paste into `mongosh` line by line |
| 6 | `Exp6_Visualization` | `visualization.R` | Open in RStudio, Source |
| 7 | `Exp7_Regression` | `regression.R` | Open in RStudio, Source |
| 8 | `Exp8_GirvanNewman` | `girvan_newman.R` | `install.packages("igraph")` once, then Source |

---

# PART A: Big Data Analytics Theory

## 1. What is Big Data?

Big Data means datasets so large, fast, or varied that traditional tools (one machine, one relational database) can't store or process them in reasonable time. Examples: Facebook posts, sensor readings from IoT devices, bank transactions, YouTube videos, clickstreams, weather data.

### The 5 V's of Big Data

| V | Meaning | Example |
|---|---|---|
| **Volume** | Huge amount of data (TB, PB, EB) | Facebook stores petabytes of photos |
| **Velocity** | Speed at which data arrives and must be processed | Stock ticks, tweets per second |
| **Variety** | Different formats | Structured (tables), semi-structured (JSON, XML), unstructured (video, text) |
| **Veracity** | Uncertainty and quality of data | Noisy sensor readings, fake reviews |
| **Value** | Useful insight extracted from data | Recommendations that increase sales |

Some syllabi add **Variability** (meaning changes with context) and **Visualization**.

### Types of data
- **Structured**: fixed schema, rows and columns (SQL tables, Excel).
- **Semi-structured**: has tags or keys but no strict schema (JSON, XML, CSV, logs).
- **Unstructured**: no predefined model (images, audio, video, emails, free text). About 80% of the world's data is unstructured.

## 2. What is Big Data Analytics?

The process of examining large, varied datasets to find hidden patterns, correlations, trends and customer preferences that support better decisions.

### Types of analytics
1. **Descriptive**: what happened? (sales reports, dashboards)
2. **Diagnostic**: why did it happen? (drill-down, root cause)
3. **Predictive**: what will happen? (regression, machine learning forecasts)
4. **Prescriptive**: what should we do? (optimization, recommendations)

### Big Data Analytics lifecycle
1. Business problem definition
2. Data identification and acquisition
3. Data filtering and cleaning (preprocessing)
4. Data extraction and transformation
5. Data aggregation and integration
6. Data analysis (statistics, ML, mining)
7. Data visualization
8. Using results for decisions

### Applications
Healthcare (disease prediction), banking (fraud detection), retail (recommendation engines, market basket analysis), telecom (churn prediction), social media (sentiment analysis), smart cities (traffic), and government (census, security).

### Challenges
Storage, processing speed, data quality, security and privacy, a shortage of skilled people, integrating different sources, and scalability.

## 3. Traditional systems vs Big Data systems

| Traditional RDBMS | Big Data (Hadoop/NoSQL) |
|---|---|
| Scales vertically (bigger server) | Scales horizontally (more cheap machines) |
| Schema on write | Schema on read |
| Structured data only | All types |
| GB to TB | TB to PB and beyond |
| ACID | Often BASE (eventual consistency) |
| Expensive specialised hardware | Commodity hardware |

## 4. Hadoop

**Apache Hadoop** is an open-source framework (Java, by Doug Cutting and Mike Cafarella, inspired by Google's GFS and MapReduce papers) for distributed storage and processing of big data on clusters of commodity hardware.

### Core components
1. **HDFS** (Hadoop Distributed File System): storage
2. **MapReduce**: processing
3. **YARN** (Yet Another Resource Negotiator): resource management and job scheduling (Hadoop 2+)
4. **Hadoop Common**: shared libraries and utilities

### HDFS architecture (master/slave)
- **NameNode (master)**: stores metadata (file names, permissions, which blocks are on which DataNode). It holds no actual data. Single point of failure in Hadoop 1.
- **DataNode (slave)**: stores the actual data blocks and sends a **heartbeat** to the NameNode every 3 seconds plus regular **block reports**.
- **Secondary NameNode**: periodically merges the **FsImage** (filesystem snapshot) with the **EditLog** (change log) as a checkpoint. It is **not** a backup NameNode.
- **Block size**: 128 MB by default in Hadoop 2/3 (64 MB in Hadoop 1). A 300 MB file is split into 128 + 128 + 44 MB blocks.
- **Replication factor**: 3 by default. Each block is stored on 3 DataNodes for fault tolerance.
- **Rack awareness**: first replica on the local node, second on a different rack, third on the same rack as the second but a different node.
- **Write once, read many**: files can't be edited in place, only appended.

### YARN components
- **ResourceManager**: master that allocates cluster resources
- **NodeManager**: runs on each slave and manages containers
- **ApplicationMaster**: one per job; negotiates resources and tracks tasks
- **Container**: a bundle of CPU and memory where a task runs

### Hadoop daemons (seen with `jps`)
NameNode, DataNode, SecondaryNameNode, ResourceManager, NodeManager.

### Hadoop ecosystem tools

| Tool | Purpose |
|---|---|
| **HDFS** | Distributed storage |
| **MapReduce** | Batch processing |
| **YARN** | Resource management |
| **Hive** | SQL-like queries (HiveQL) on HDFS; data warehouse; made by Facebook |
| **Pig** | Scripting language (Pig Latin) for data flows; made by Yahoo |
| **HBase** | Column-oriented NoSQL database on HDFS; real-time read/write (based on Google BigTable) |
| **Sqoop** | Transfers data between RDBMS and HDFS (SQL + Hadoop) |
| **Flume** | Collects and moves streaming log data into HDFS |
| **Kafka** | Distributed messaging / event streaming |
| **Oozie** | Workflow scheduler for Hadoop jobs |
| **ZooKeeper** | Coordination service (configuration, synchronization, leader election) |
| **Spark** | In-memory processing, up to 100x faster than MapReduce for iterative jobs |
| **Mahout** | Machine learning library |
| **Ambari** | Cluster provisioning, management and monitoring |
| **Avro** | Data serialization |

## 5. MapReduce

A programming model for processing large data in parallel across a cluster.

**Phases:**
1. **Input split**: input is divided into splits (usually one per HDFS block).
2. **Map**: each mapper reads records and emits intermediate `(key, value)` pairs.
3. **Combiner (optional)**: a "mini reducer" on the mapper side that cuts network traffic.
4. **Partitioner**: decides which reducer gets which key (default: hash(key) mod numReducers).
5. **Shuffle and sort**: all values for the same key are moved to the same reducer and sorted by key.
6. **Reduce**: aggregates values for each key and writes the final output to HDFS.

Word count example:
```
Input:   "big data big"
Map:     (big,1) (data,1) (big,1)
Shuffle: (big,[1,1]) (data,[1])
Reduce:  (big,2) (data,1)
```

**Data locality**: the code is moved to where the data is, not the data to the code.

## 6. Mining data streams

A **data stream** is data arriving continuously and quickly (sensor data, network packets, tweets). You can't store all of it, so algorithms must:
- read each element **once** (single pass)
- use **limited memory**
- give **approximate** answers quickly

Stream problems and algorithms:
- **Sampling**: reservoir sampling
- **Filtering**: Bloom filter
- **Counting distinct elements**: **Flajolet-Martin** (Exp 3)
- **Counting 1s in a sliding window**: **DGIM** (Exp 4)
- **Moments**: AMS algorithm

## 7. NoSQL

"Not Only SQL": non-relational databases built for scale, flexible schemas and distribution.

**CAP theorem**: a distributed system can guarantee only 2 of these 3:
- **C**onsistency: every read sees the latest write
- **A**vailability: every request gets a response
- **P**artition tolerance: works even if the network splits

MongoDB is CP; Cassandra is AP.

**BASE** (NoSQL) vs **ACID** (RDBMS): **B**asically **A**vailable, **S**oft state, **E**ventual consistency.

**Types of NoSQL:**

| Type | Example | Use |
|---|---|---|
| Key-value | Redis, DynamoDB | Caching, sessions |
| Document | MongoDB, CouchDB | JSON-like records, content management |
| Column-family | Cassandra, HBase | Time series, huge write loads |
| Graph | Neo4j | Social networks, recommendations |

## 8. Social network analysis
Graphs: nodes are people and edges are relationships. **Community detection** finds groups that are densely connected inside and sparsely connected to each other. Algorithms: Girvan-Newman (Exp 8), Louvain, label propagation.

---

# PART B: Experiments

## Experiment 1: Hadoop HDFS Practical

**Aim:** Study HDFS basics and the Hadoop ecosystem, and perform file operations: copy to HDFS, copy from HDFS, delete, move and display files.

**Theory:** See Part A, Section 4. Every HDFS command has the form `hdfs dfs -<command>` (`hadoop fs -<command>` also works).

**Commands used (`hdfs_commands.sh`):**

| Command | What it does |
|---|---|
| `start-dfs.sh` / `start-yarn.sh` | Start the HDFS and YARN daemons |
| `jps` | Lists running Java processes (check that NameNode, DataNode etc. are up) |
| `hdfs dfsadmin -report` | Cluster capacity and live DataNodes |
| `hdfs dfs -mkdir -p <dir>` | Create a directory (`-p` also creates parents) |
| `hdfs dfs -ls <dir>` | List files |
| `hdfs dfs -put <local> <hdfs>` | **Copy file to Hadoop** |
| `hdfs dfs -copyFromLocal` | Same as `-put` but the source must be local |
| `hdfs dfs -get <hdfs> <local>` | **Copy from Hadoop** to local |
| `hdfs dfs -copyToLocal` | Same as `-get` but the destination must be local |
| `hdfs dfs -rm <file>` | **Delete file** (`-rm -r` for a directory) |
| `hdfs dfs -mv <src> <dst>` | **Move/rename** inside HDFS |
| `hdfs dfs -cat <file>` | **Display** file contents |
| `hdfs dfs -tail <file>` | Show the last 1 KB of a file |
| `hdfs dfs -du -h` | Disk usage in human-readable form |
| `hdfs dfs -stat` | File statistics (name, size, replication) |
| `hdfs dfs -setrep` | Change the replication factor |
| `hdfs fsck <path> -files -blocks` | Check health and show blocks |
| `stop-yarn.sh` / `stop-dfs.sh` | Stop the daemons |

NameNode web UI: `http://localhost:9870` (Hadoop 3) or `50070` (Hadoop 2). YARN UI: `http://localhost:8088`.

**Conclusion:** We studied the HDFS architecture and ecosystem and performed copy, retrieve, delete, move and display operations on HDFS.

### Viva questions (Exp 1)
1. **What is Hadoop?** An open-source Java framework for distributed storage (HDFS) and processing (MapReduce) of big data on commodity hardware.
2. **What is HDFS?** Hadoop's distributed file system. It splits files into blocks and replicates them across DataNodes.
3. **What is the default block size?** 128 MB (Hadoop 2/3); 64 MB in Hadoop 1.
4. **Default replication factor?** 3.
5. **Why are HDFS blocks so large?** To reduce NameNode metadata and seek time, since big data is read sequentially.
6. **NameNode vs DataNode?** NameNode stores metadata (master); DataNodes store the actual blocks (slaves).
7. **Is the Secondary NameNode a backup?** No. It only checkpoints by merging the FsImage and EditLog.
8. **What is a heartbeat?** A signal each DataNode sends the NameNode every 3 seconds to show it's alive. After about 10 minutes without one, the node is marked dead and its blocks are re-replicated.
9. **What are FsImage and EditLog?** FsImage is a snapshot of the filesystem namespace; EditLog records every change since the last FsImage.
10. **`-put` vs `-copyFromLocal`?** Same function, but `-copyFromLocal` restricts the source to the local filesystem.
11. **`-get` vs `-copyToLocal`?** Same, but `-copyToLocal` restricts the destination to local.
12. **What is rack awareness?** Placing replicas on different racks so the data survives a whole rack failing.
13. **What is safe mode?** A read-only state of the NameNode at startup while it collects block reports. Leave it with `hdfs dfsadmin -safemode leave`.
14. **What does `jps` show?** The running Hadoop Java daemons.
15. **Name 5 ecosystem tools.** Hive, Pig, HBase, Sqoop, Flume, ZooKeeper, Oozie, Spark.
16. **Hive vs Pig?** Hive is SQL-like (declarative) for analysts; Pig is a scripting data-flow language (procedural) for programmers.
17. **What is YARN?** The resource manager of Hadoop 2+, which separates resource management from processing.
18. **Can you modify a file in HDFS?** No. HDFS is write-once, read-many; only appends are allowed.
19. **What is HA (High Availability) NameNode?** An active and a standby NameNode, which removes the single point of failure.
20. **What is data locality?** Running computation on the node where the data lives.

---

## Experiment 2: Word Count using MapReduce in Python

**Aim:** Implement word count using the MapReduce paradigm in Python.

**Theory:** Hadoop is written in Java, but **Hadoop Streaming** lets any language that reads stdin and writes stdout act as a mapper or reducer.
- `mapper.py` reads lines, splits them into words, cleans each word (lowercase, strips punctuation) and prints `word\t1`.
- Hadoop then **shuffles and sorts**, so identical words arrive next to each other.
- `reducer.py` reads the sorted pairs. While the word stays the same it adds to the count. When the word changes it prints the previous word's total.
- `wordcount.py` simulates all three phases (map, shuffle-sort, reduce) in a single program so you can see each stage's output without Hadoop.

**Run:**
```bash
python wordcount.py
```
Simulate the Hadoop pipeline locally (`sort` plays the role of shuffle-and-sort):
```bash
cat input.txt | python mapper.py | sort | python reducer.py
```
On real Hadoop:
```bash
hdfs dfs -put input.txt /wc/input
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar -files mapper.py,reducer.py -mapper "python3 mapper.py" -reducer "python3 reducer.py" -input /wc/input -output /wc/output
hdfs dfs -cat /wc/output/part-00000
```

**Output (verified):**
```
and 2, big 3, complex 1, data 4, hadoop 3, hdfs 1, in 2, is 3, large 1, mapreduce 1, ...
```

**Conclusion:** Word count was implemented with separate map and reduce phases, demonstrating parallel key-value processing.

### Viva questions (Exp 2)
1. **What is MapReduce?** A programming model that processes data in parallel in two phases: Map (transform into key-value pairs) and Reduce (aggregate by key).
2. **Input and output of the mapper?** Input is a (byte offset, line) pair; output is intermediate (key, value) pairs.
3. **What is shuffle and sort?** Moving all values with the same key to one reducer and sorting them by key. It happens between map and reduce.
4. **What is a combiner?** A local mini reducer on mapper output that cuts the data sent over the network. For word count, the reducer itself can be the combiner.
5. **What is a partitioner?** It decides which reducer gets a key. The default is HashPartitioner.
6. **Why does the reducer need sorted input?** It detects when a word changes. Without sorting, the same word would be counted in several pieces.
7. **What is Hadoop Streaming?** A utility that runs non-Java mappers and reducers through stdin/stdout.
8. **Can the number of reducers be 0?** Yes. That's a map-only job, and the mapper output is final.
9. **Who decides the number of mappers?** The number of input splits (roughly the number of blocks).
10. **What is an InputSplit?** A logical chunk of input processed by one mapper (a block is the physical chunk).
11. **Limitations of MapReduce?** Slow for iterative and real-time work because of disk I/O between stages. Spark solves this with in-memory processing.
12. **Where is mapper output stored?** On local disk, not HDFS, because it's temporary.

---

## Experiment 3: Flajolet-Martin Algorithm

**Aim:** Estimate the number of distinct elements in a data stream with the Flajolet-Martin (FM) algorithm.

**Problem:** Counting distinct elements exactly needs memory proportional to the number of distinct items (a set). For huge streams (unique website visitors, unique IPs) that's too much. FM estimates the count using only **O(log n)** bits.

**Algorithm:**
1. Pick a hash function `h(x) = (a·x + b) mod c` that maps each element to a number.
2. For each element, write `h(x)` in binary and count its **trailing zeros** `r(x)`.
3. Track `R = max r(x)` over the whole stream.
4. Estimate the distinct count as **2^R**.

**Why it works:** A random number ends in at least `r` zeros with probability `1/2^r`. To see a hash with R trailing zeros you need to have seen about `2^R` distinct items. Duplicates hash to the same value, so they don't change R.

**Improving accuracy:** One hash gives a power of 2 with high variance. So we:
- use many hash functions,
- split their estimates into groups and take the **average** of each group,
- take the **median** of the group averages.

The median removes outliers; the averages remove the "only powers of 2" problem.

**Code walkthrough:**
- `trailing_zeros(n)` divides by 2 while the number is even. (By convention we take `h = 0` as 0 trailing zeros here; some textbooks skip it.)
- The first part reproduces the classic textbook example: stream `1,3,2,1,2,3,4,3,1,2,3,1` with `h(x) = (3x+1) mod 5` gives R = 2, so the estimate is 4, which is exactly the actual distinct count.
- `flajolet_martin()` runs 30 random hash functions on a 5000-element stream and combines them with the median of averages.

**Output (verified):** small example gives estimate 4, actual 4. The large stream has 996 actual distinct values and the estimate is about 1779. FM gives an order-of-magnitude estimate, not an exact count; HyperLogLog is the modern, more accurate successor.

### Viva questions (Exp 3)
1. **What does FM estimate?** The number of distinct elements (cardinality) in a stream.
2. **What is a trailing zero?** A 0 bit at the end of a binary number. `12 = 1100` has 2 trailing zeros.
3. **Estimate formula?** 2^R, where R is the maximum number of trailing zeros.
4. **Space complexity?** O(log n) bits per hash function.
5. **Why use multiple hash functions?** One estimate has high variance; combining many with the median of averages reduces the error.
6. **Why median and not just average?** The average is skewed by one huge 2^R value; the median is robust to that.
7. **Why don't duplicates affect the result?** The same element always gives the same hash, so it can't increase R.
8. **Properties of a good hash function?** Uniform distribution, deterministic, fast.
9. **Real-life uses?** Counting unique visitors, unique search queries, distinct IPs in network monitoring, query optimizers.
10. **What improved on FM?** LogLog and HyperLogLog (used in Redis, Google BigQuery).

---

## Experiment 4: DGIM Algorithm

**Aim:** Count the number of 1s in the last N bits of a binary stream using the DGIM algorithm.

**Problem:** We want to know how many 1s are in the last N bits of a bit stream (for example, "how many of the last 1 million transactions were fraud?"). Storing N bits takes O(N) space. **DGIM** (Datar, Gionis, Indyk, Motwani) answers approximately using only **O(log² N)** bits, with **at most 50% error**.

**Buckets.** The window is summarised by buckets. Each bucket stores:
- the **timestamp** of its most recent 1
- its **size**: the number of 1s it contains, which is always a **power of 2**

**Rules:**
1. The right end of every bucket is a 1.
2. Every 1 belongs to exactly one bucket.
3. Bucket sizes are powers of 2.
4. There are **one or two** buckets of each size, never three.
5. Sizes never decrease as you go back in time.
6. A bucket is dropped once its timestamp is outside the window (`timestamp <= current_time - N`).

**Adding a new bit:**
- If it's 0, only check for expiry.
- If it's 1, create a bucket of size 1 at the current time. If there are now **three** buckets of size 1, merge the **two oldest** into one bucket of size 2 (keeping the more recent timestamp). This can cascade: three buckets of size 2 merge into one of size 4, and so on.

**Query:** Add up the sizes of all buckets in the window, but count only **half of the oldest bucket**, since we don't know how many of its 1s are still inside the window.

**Code walkthrough:**
- `self.buckets` is a list of `(timestamp, size)` pairs, newest first.
- `add()` removes an expired bucket from the end and inserts new 1s at the front, then calls `merge()`.
- `merge()` scans for three consecutive equal sizes and merges the older two.
- `count(k)` sums the buckets within the last k bits and subtracts half of the last one.

**Output (verified):**
```
Buckets (timestamp, size): [(40, 1), (39, 2), (35, 4), (28, 4), (21, 8)]
Last 20 bits -> actual 12, DGIM 15
Last 10 bits -> actual 5,  DGIM 5
Last 5 bits  -> actual 3,  DGIM 2
```
All estimates are within the guaranteed 50% error.

### Viva questions (Exp 4)
1. **Full form of DGIM?** Datar-Gionis-Indyk-Motwani.
2. **What problem does it solve?** Counting 1s in a sliding window of the last N bits of a binary stream.
3. **Space required?** O(log² N) bits: O(log N) buckets, each needing O(log N) bits.
4. **Maximum error?** 50%.
5. **Why are bucket sizes powers of 2?** So merging two equal buckets gives the next size and the number of buckets stays logarithmic.
6. **How many buckets of each size are allowed?** One or two.
7. **What happens when there are three buckets of the same size?** The two oldest are merged into one bucket of double the size.
8. **Why take half of the last bucket?** It may be only partly inside the window; half is the best guess and bounds the error.
9. **When is a bucket discarded?** When its timestamp is N or more steps older than the current time.
10. **How can the error be reduced?** Allow r-1 or r buckets of each size instead of 1 or 2. Error drops to about 1/(r-1), at the cost of more memory.
11. **Applications?** Network traffic monitoring, counting clicks or sales in the last hour, fraud detection.

---

## Experiment 5: NoSQL and MongoDB CRUD

**Aim:** Study the features of NoSQL and execute basic Create, Read, Update and Delete operations in MongoDB.

### Features of NoSQL
1. **Schema-less / flexible schema**: documents in the same collection can have different fields (Karan has `skills`, others don't).
2. **Horizontal scalability**: scale out by adding servers (sharding).
3. **Distributed and highly available**: replication across nodes (replica sets).
4. **Handles all data types**: structured, semi-structured and unstructured.
5. **High performance**: fast reads and writes; data is denormalized, so no joins are needed.
6. **BASE / eventual consistency** instead of strict ACID (configurable in MongoDB).
7. **Easy for developers**: data maps directly to objects (JSON).
8. **Open source and runs on cheap commodity hardware.**
9. **Supports big data and real-time web apps.**

### MongoDB terms

| RDBMS | MongoDB |
|---|---|
| Database | Database |
| Table | Collection |
| Row | Document (BSON, binary JSON) |
| Column | Field |
| Primary key | `_id` (automatic ObjectId) |
| Join | Embedded documents / `$lookup` |

**Run:** install MongoDB Community Server and mongosh, open `mongosh`, then paste the commands from `mongodb_crud.js`.

### Commands explained

**Create**
- `use college`: switch to the database (it's created on the first insert)
- `db.createCollection("students")`: create a collection explicitly
- `insertOne({...})`: insert one document
- `insertMany([...])`: insert several

**Read**
- `find()`: all documents. `.pretty()` formats them.
- `findOne({name:"Amit"})`: the first matching document
- `find({marks:{$gt:70}})`: comparison operators `$gt`, `$gte`, `$lt`, `$lte`, `$ne`, `$eq`
- `$and`, `$or`, `$in`: logical operators
- `find({}, {name:1, marks:1, _id:0})`: **projection** (choose which fields to show)
- `sort({marks:-1})`: descending (1 = ascending). `limit(n)` caps the result.
- `countDocuments()`: count matches

**Update**
- `updateOne(filter, {$set:{...}})`: change or add a field
- `updateMany`: update every match
- `$inc`: increment a number. `$push`: add to an array. `$unset`: remove a field.
- `replaceOne`: replace the whole document

**Delete**
- `deleteOne(filter)` / `deleteMany(filter)`
- `db.students.drop()`: delete the collection. `db.dropDatabase()`: delete the database.

**Extra:** `aggregate()` with `$group` (like SQL GROUP BY); `createIndex()` to speed up searches.

### Viva questions (Exp 5)
1. **What is NoSQL?** "Not Only SQL": non-relational databases with flexible schemas, built for scale.
2. **Types of NoSQL?** Key-value, document, column-family, graph.
3. **What type is MongoDB?** A document-oriented database storing BSON documents.
4. **What is BSON?** Binary JSON. It's faster to parse and supports extra types such as Date and ObjectId.
5. **What is `_id`?** A unique primary key, automatically an ObjectId (12 bytes: timestamp + machine + process + counter).
6. **Collection vs table?** A collection holds documents without a fixed schema.
7. **What is the CAP theorem?** You can only guarantee two of Consistency, Availability and Partition tolerance.
8. **ACID vs BASE?** ACID means strict transactions (RDBMS). BASE means Basically Available, Soft state, Eventually consistent (NoSQL).
9. **What is sharding?** Splitting data across machines using a shard key (horizontal scaling).
10. **What is a replica set?** A primary plus secondaries holding copies of the data, giving automatic failover.
11. **`$set` vs `replaceOne`?** `$set` changes the given fields only; `replaceOne` replaces the whole document.
12. **What is projection?** Choosing which fields to return.
13. **What is the aggregation pipeline?** A series of stages (`$match`, `$group`, `$sort`, `$project`) that transform documents.
14. **Why index?** To avoid scanning the whole collection, which speeds up queries.
15. **When would you choose SQL over NoSQL?** When you need complex joins and strict transactions, such as banking ledgers.

---

## Experiment 6: Five Visualization Techniques in R

**Aim:** Implement data visualization techniques in R.

**Theory:** Visualization shows data graphically so patterns, trends and outliers are easy to spot. It's the last step of the analytics lifecycle and is how results are communicated.

**Dataset:** `mtcars` is built into R: 32 cars with 11 variables (mpg = miles per gallon, cyl = cylinders, hp = horsepower, wt = weight, gear, am = transmission).

| # | Plot | Function | Shows | Use when |
|---|---|---|---|---|
| 1 | Bar chart | `barplot(table(x))` | Count per category | Comparing categories |
| 2 | Histogram | `hist(x)` | Distribution of a continuous variable | Checking shape, skew |
| 3 | Box plot | `boxplot(y ~ group)` | Median, quartiles, outliers | Comparing distributions |
| 4 | Scatter plot | `plot(x, y)` | Relation between two numeric variables | Correlation |
| 5 | Pie chart | `pie(table(x))` | Proportion of a whole | Percentage share |
| 6 | Line chart (bonus) | `plot(..., type="o")` | Trend | Time series, ordered data |

**Key parameters:** `main` (title), `xlab`/`ylab` (axis labels), `col` (colours), `pch` (point shape, 19 = solid circle), `breaks` (histogram bins), `par(mfrow=c(2,3))` (2×3 grid of plots).

**Observations:** Most cars have 8 cylinders. MPG is right-skewed. More cylinders means lower MPG. Heavier cars have lower MPG (negative correlation). Most cars have 3 gears.

### Viva questions (Exp 6)
1. **Why visualize data?** To understand patterns, trends and outliers quickly and to communicate results.
2. **Bar chart vs histogram?** A bar chart shows categorical data with gaps between bars; a histogram shows continuous data in bins with no gaps.
3. **What does a box plot show?** The 5-number summary (min, Q1, median, Q3, max) plus outliers beyond 1.5×IQR.
4. **What is IQR?** Q3 − Q1, the spread of the middle 50%.
5. **What does a scatter plot reveal?** Correlation (positive, negative or none) between two variables.
6. **Disadvantage of pie charts?** Angles are hard to compare, especially with many categories.
7. **What does `par(mfrow=c(2,3))` do?** Splits the plotting area into 2 rows and 3 columns.
8. **Other R visualization packages?** ggplot2, lattice, plotly, leaflet (maps).
9. **What is `table()`?** It counts the frequency of each value.
10. **Other techniques?** Heatmap, density plot, violin plot, word cloud, treemap.

---

## Experiment 7: Linear, Logistic and Multiple Regression in R

**Aim:** Implement linear, logistic and multiple regression in R with plots.

### 1. Simple linear regression
Predicts a **continuous** dependent variable Y from **one** independent variable X:

**Y = β₀ + β₁X + ε**

β₀ is the intercept, β₁ the slope and ε the error. The coefficients are found by **Ordinary Least Squares (OLS)**, which minimizes the sum of squared residuals.
- Code: `lm(mpg ~ wt)` models MPG as a function of weight.
- `abline()` draws the fitted line.
- Result: mpg ≈ 37.29 − 5.34·wt. Every extra 1000 lbs lowers MPG by about 5.3. R² ≈ 0.75, so weight explains about 75% of the variation in MPG.

### 2. Logistic regression
Predicts a **binary/categorical** outcome (0/1) as a probability:

**P(Y=1) = 1 / (1 + e^−(β₀ + β₁X))**, the **sigmoid** function, whose output is between 0 and 1.

- Code: `glm(am ~ wt, family = binomial)` predicts manual (1) vs automatic (0) from weight.
- `type = "response"` returns probabilities, which we classify with a 0.5 threshold.
- The S-shaped curve is the plot. The **confusion matrix** compares actual and predicted classes; accuracy = correct / total.
- Heavier cars are less likely to be manual (negative coefficient).

### 3. Multiple linear regression
**Y = β₀ + β₁X₁ + β₂X₂ + … + βₙXₙ**, with several predictors.
- Code: `lm(mpg ~ wt + hp + disp)`.
- `plot(model)` draws 4 diagnostic plots:
  1. Residuals vs Fitted: checks linearity
  2. Normal Q-Q: checks that residuals are normally distributed
  3. Scale-Location: checks constant variance (homoscedasticity)
  4. Residuals vs Leverage: finds influential points (Cook's distance)
- Actual vs Predicted plot: points near the red 45° line mean good predictions.

### Reading `summary()` output
- **Estimate**: the coefficient value
- **Pr(>|t|)** (p-value): below 0.05 means the predictor is significant (marked with stars)
- **R-squared**: fraction of variance explained (0 to 1)
- **Adjusted R²**: R² penalised for extra predictors; use it to compare multiple-regression models
- **F-statistic**: tests whether the model as a whole is significant
- **AIC** (logistic): lower is better

### Viva questions (Exp 7)
1. **What is regression?** A statistical method for modelling the relationship between a dependent variable and one or more independent variables.
2. **Linear vs logistic regression?** Linear predicts continuous values; logistic predicts the probability of a category.
3. **What is OLS?** Ordinary Least Squares: minimizes the sum of squared errors to find the coefficients.
4. **What is R²?** The proportion of variance in Y explained by the model, from 0 to 1.
5. **Why adjusted R²?** R² always rises when you add variables; adjusted R² penalises useless ones.
6. **What is the sigmoid function?** 1/(1+e^−z), which maps any value into the range 0 to 1.
7. **Why not use linear regression for classification?** It can predict values outside 0–1 and isn't suited to a binary outcome.
8. **What is a residual?** Actual value minus predicted value.
9. **Assumptions of linear regression?** Linearity, independence of errors, homoscedasticity, normally distributed errors, no multicollinearity.
10. **What is multicollinearity?** Independent variables that are highly correlated with each other (for example hp and disp). Check it with VIF.
11. **What is a p-value?** The probability of seeing the result if the coefficient were really 0. Below 0.05 means significant.
12. **`lm` vs `glm`?** `lm` is for linear models; `glm` is for generalized linear models (logistic with `family=binomial`, Poisson, etc.).
13. **What is a confusion matrix?** A table of TP, TN, FP and FN used to evaluate a classifier.
14. **What is the odds ratio?** `exp(coefficient)` in logistic regression: how the odds change per unit of X.

---

## Experiment 8: Girvan-Newman Community Detection in R

**Aim:** Detect communities in a network with the Girvan-Newman algorithm using the igraph package.

**Theory:**
- A **community** is a group of nodes with many edges inside it and few edges to other groups.
- **Edge betweenness** of an edge = the number of shortest paths between all pairs of nodes that pass through it. Edges that **connect** communities have high betweenness, because all traffic between the groups must cross them, like bridges.

**Girvan-Newman algorithm (divisive / top-down hierarchical clustering):**
1. Compute the edge betweenness of every edge.
2. Remove the edge with the **highest** betweenness.
3. Recompute betweenness for the remaining edges.
4. Repeat until no edges remain (or until you have the number of communities you want).
5. The result is a **dendrogram**. Choose the level with the highest **modularity**.

**Modularity (Q):** measures how good a division is by comparing the fraction of edges inside communities with what you'd expect at random. It ranges from −0.5 to 1; above roughly 0.3 indicates good community structure.

**Code walkthrough:**
- `install.packages("igraph")` and `library(igraph)` load the package.
- `graph_from_literal(A-B, ...)` builds a small graph with 3 obvious clusters: {A,B,C}, {D,E,F}, {G,H,I}.
- **Manual loop:** computes `edge_betweenness()`, removes the highest edge with `delete_edges()`, and repeats until there are 3 components. It prints which edge is removed at each step (C–D and F–G go first, since they're the bridges). This shows the algorithm step by step.
- `cluster_edge_betweenness(g)` is igraph's built-in Girvan-Newman.
- `membership()` shows which community each node belongs to; `modularity()` gives Q.
- `plot(communities, g)` colours the communities.
- The script then runs it on **Zachary's Karate Club**, a famous real social network of 34 members of a club that split into two.
- `dendPlot()` draws the hierarchical dendrogram.

**Complexity:** O(m²n) for m edges and n nodes, which is slow for very large graphs. Louvain is faster.

### Viva questions (Exp 8)
1. **What is a community in a network?** A group of nodes densely connected inside and sparsely connected to the rest.
2. **What is edge betweenness?** The number of shortest paths between pairs of nodes that pass through an edge.
3. **Why remove the edge with the highest betweenness?** It's most likely a bridge between communities.
4. **Why recompute betweenness after each removal?** Removing an edge changes the shortest paths, so the old values become wrong.
5. **What is modularity?** A quality score for a partition: edges inside communities minus the number expected at random.
6. **Divisive or agglomerative?** Divisive (top-down): it starts with one network and splits it.
7. **Time complexity?** O(m²n), or O(n³) for sparse graphs.
8. **Which igraph function implements Girvan-Newman?** `cluster_edge_betweenness()`.
9. **Other community detection algorithms?** Louvain (`cluster_louvain`), label propagation, Walktrap, fast greedy.
10. **What is the Zachary Karate Club?** A 34-node social network of a karate club that split in two after a dispute; the standard benchmark for community detection.
11. **What is a dendrogram?** A tree diagram showing the order in which clusters split or merge.
12. **Applications?** Friend suggestions, detecting fraud rings, protein interaction networks, customer segmentation, targeted marketing.
13. **Degree vs betweenness centrality?** Degree is the number of connections; betweenness is how often a node or edge lies on shortest paths.

---

# PART C: General Viva Questions (Big Data)

1. **Define Big Data.** Data too large, fast or varied for traditional systems to handle.
2. **The 5 V's?** Volume, Velocity, Variety, Veracity, Value.
3. **Structured vs unstructured data?** Fixed schema (tables) vs no schema (video, text).
4. **Why Hadoop?** Cheap, scalable, fault-tolerant storage and processing on commodity machines.
5. **Hadoop vs Spark?** Hadoop MapReduce is disk-based batch processing; Spark is in-memory, faster, and supports streaming, ML and SQL.
6. **What is a data lake?** A store of raw data in any format (schema-on-read). A data warehouse stores processed, structured data (schema-on-write).
7. **Batch vs stream processing?** Batch processes stored data in chunks (MapReduce); stream processes data as it arrives (Kafka, Spark Streaming, Flink).
8. **What is data mining?** Discovering patterns in large datasets (classification, clustering, association rules).
9. **What is a Bloom filter?** A space-efficient probabilistic structure that tests set membership. It can give false positives but never false negatives.
10. **Why are stream algorithms approximate?** Memory is limited and each element can only be seen once.
11. **What is commodity hardware?** Cheap, standard, non-specialised machines.
12. **What is fault tolerance in Hadoop?** Data is replicated, so a failed node's tasks and data are recovered from other nodes.
13. **Who created Hadoop?** Doug Cutting and Mike Cafarella (2005), named after Doug's son's toy elephant.
14. **What is R used for?** Statistical computing, data analysis and visualization.
15. **What is CRAN?** The Comprehensive R Archive Network, R's package repository.
