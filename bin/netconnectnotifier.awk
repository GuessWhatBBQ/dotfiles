BEGIN {
    FS="[=]|[ ]"
    IGNORECASE=1
}
{
    if (match($0, /no answer yet for icmp_seq/)) {
        print "No response received yet from packet no. " $6; system("")
    }
    else if ($NF == "unreachable") {
        print "Network unreachable"; system("")
        exit 1
    }
    else if ((length($0)>0) && (NR>=2) && (NR<=(1+packets))) {
        print "Packet no. " $6 " took " $10 $11; system("")
    }
    if (match($0, /packets transmitted/)) {
        system("sleep 1")
        print $6 " " $7 " " substr($8, 1, length($8)-1); system("")
    }
    if ($1 == "rtt") {
        split($0,avg,"/| |=")
        system("echo 'Min: " avg[8] " ms, Avg: " avg[9] " ms, Max: " avg[10]" ms' > " pingres)
    }
}
