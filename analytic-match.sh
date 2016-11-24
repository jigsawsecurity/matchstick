#!/bin/bash
DISPLAY=localhost:0.0 ; export DISPLAY
export TERM=xterm
clear
echo "Starting Matchstick IOC Matching Analytics..."
logger -p crit Starting IOC Matching Analytics
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
cd /tmp
mkdir match
cd /tmp/match
wget -O data.csv --header="Authorization: INSERT JIGSAW API KEY HERE" http://ui.slcsecurity.com/events/csv/download/false/false/MALWARE/false/false/true/false/false/1d
cat data.csv |grep domain > dataset.csv
cat data.csv |grep hostname >> dataset.csv
cat data.csv |grep ip-src >> dataset.csv
cat data.csv |grep ip-dst >> dataset.csv
rm -f data.csv
mv dataset.csv /opt/Analytics/
cd /tmp
rm -R -f match
cd /opt/Analytics/
/usr/bin/wineconsole --backend=user /opt/Analytics/ESA.exe > /dev/null 2>&1
sed 's/,/ /g' /opt/Analytics/output.txt > /opt/Analytics/outputx.txt
mv /opt/Analytics/outputx.txt /var/ingest/matches/$current_time.ingest.csv
rm /opt/Analytics/output.txt
logger -p crit Finished Running Matchstick Analytic Model
echo "Completed..."
