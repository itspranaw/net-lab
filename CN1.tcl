#===================================
#     Simulation parameters setup
#===================================
set val(stop)   10.0                         ;# time of simulation end
#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Open the NS trace file
set tracefile [open lab1.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open lab1.nam w]
$ns namtrace-all $namfile
#===================================
#        Nodes Definition        
#===================================
#Create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
#===================================
#        Links Definition        
#===================================
#Create links between nodes
$ns duplex-link $n0 $n2 500.0Mb 20ms DropTail
$ns queue-limit $n0 $n2 20					
$ns duplex-link $n1 $n2 500.0Mb 20ms DropTail
$ns queue-limit $n1 $n2 20                                               
$ns duplex-link $n2 $n3 500.0Mb 20ms DropTail 
$ns queue-limit $n2 $n3 20					
#Above Highlighted Bandwidth and Queue Size will be changed
#Give node position (for NAM)
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink2 [new Agent/TCPSink]
$ns attach-agent $n3 $sink2
$ns connect $tcp0 $sink2
$tcp0 set packetSize_ 1500
#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $tcp1 $sink3
$tcp1 set packetSize_ 1500
#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 1.0 "$ftp0 start"
$ns at 4.0 "$ftp0 stop"

#Setup a FTP Application over TCP connection
set ftp1 [new Application/FTP] 
$ftp1 attach-agent $tcp1
$ns at 5.0 "$ftp1 start"
$ns at 9.0 "$ftp1 stop"
#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam lab1.nam &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
