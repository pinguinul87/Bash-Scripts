#!/bin/bash
: '
The following script will check the file system and report any exeeding file systems.
It will create a log file where data will be dumped for future analysis.
'

LOGFILE=/var/log/file_system_monitor/file_system_monitor.log
RETAIN_LINES=2000

logsetup () {
    TMP=$(tail -n $RETAIN_LINES $LOGFILE 2>/dev/null) && echo "${TMP}" > $LOGFILE
    exec > >(tee -a $LOGFILE)
    exec 2>&1
}

logsetup

check_fs (){
        echo "[+] List file systems."
        echo "======================================================================="
        df -HPm | grep -vE '^Filesystem|tmpfs' | awk '{ print $5 " " $1}' | while read output;
        do
                usep=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
                fs=$(echo $output | awk '{print $2}')
                if [ $usep -ge 80 ]; then
                        echo "Low file system space $fs $usep% used, on $(hostname)"
                fi
        done
}
check_fstab(){
        echo "========================================================================="
        for i in $(cat /etc/fstab | awk '{print $2}');do
                findmnt -T $i | awk '{print $1, "          " $2}'
        done
        echo "========================================================================="

}

main () {
        echo -e "[+] Checking file system for available mounts. Running today $(date)\n"
        check_fs
        echo -e "\n[+] Check file system complete. List of results can be found at $LOGFILE. Finised today $(date)"
        echo -e "[+] Show target and source for all entries in /etc/fstab."
        check_fstab
        echo -e "[+] /etc/fstab task complete."
        echo -e "[+] Script finished $(date)"
}
main
