#!/bin/bash 

set -e 

function adaptive_cpus_number (){
    PCPU=`cat /proc/cpuinfo |grep "physical id"|sort|uniq|wc -l`
    #Get current machine physical cpu number.
    sed -i "s/thread_pool_size = 4/thread_pool_size = $(( $PCPU*8 ))/g" /etc/my.cnf
    sed -i "s/innodb_read_io_threads = 16/innodb_read_io_threads = $(( $PCPU*2 ))/g" /etc/my.cnf
    sed -i "s/innodb_write_io_threads = 16/innodb_write_io_threads = $(( $PCPU*2 ))/g" /etc/my.cnf
}

function adaptive_buffersize_size (){
    PMEM=`cat /proc/meminfo |head -n1|awk -F' ' '{print $2}'`
    #Get current machine physical memory size (kb)
    sed -i "s/innodb_buffer_pool_size = 6G/innodb_buffer_pool_size = $(( $PMEM*60/100 ))K/g" /etc/my.cnf
}

function adaptive_running_environment (){
   if [ $1 -eq 1 ];then 
        #if is development environment.
        sed -i "s/sql_mode = NO_ENGINE_SUBSTITUTION/sql_mode = TRADITIONAL/g" /etc/my.cnf         
        sed -i "s/lower_case_table_names=1/lower_case_table_names=0/g" /etc/my.cnf
   elif [ $1 -eq 2 ];then
        #if is test environment.
        sed -i "s/sql_mode = NO_ENGINE_SUBSTITUTION/sql_mode = TRADITIONAL/g" /etc/my.cnf
        sed -i "s/lower_case_table_names=1/lower_case_table_names=0/g" /etc/my.cnf
   else 
        #if is production environment.
        sed -i "s/sql_mode = NO_ENGINE_SUBSTITUTION/sql_mode = TRADITIONAL/g" /etc/my.cnf
        sed -i "s/lower_case_table_names=1/lower_case_table_names=0/g" /etc/my.cnf
   fi
}

function enable_kernel_parameters (){
    sysctl -p
}

function main(){
    if [ -f /etc/my.cnf.sample ];then
        cp -f /etc/my.cnf.sample /etc/my.cnf
    fi
    if [ -f /etc/sysctl.conf.sample ];then
        cp -f /etc/sysctl.conf.sample /etc/sysctl.conf 
    fi 
    if [ -f /etc/security/limits.conf.sample ];then
        cp -f /etc/security/limits.conf.sample /etc/security/limits.conf 
    fi

    adaptive_cpus_number
    adaptive_buffersize_size
    adaptive_running_environment 3
    enable_kernel_parameters
    exit 0
}

main
