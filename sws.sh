#/bin/sh

Help(){
    echo usage: sws \<connect\|disconnect\> \<application name\>
    echo you can also use \"c\" instead of \"connect\" and \"d\" instead of \"disconnect\"
    echo note that the application name should be the name of the binary found in pw-dump.
    exit
}

if [ $1 == "connect" ] || [ $1 == "c" ];
then
    mode=1
elif [ $1 == "disconnect" ] || [ $1 == "d" ];
then
    mode=2
else
    Help
fi
if [ -z $2 ];
then
    Help
fi
program_name="$2"

GetOutput() {
    echo selecting a window...
    output_pid=$(xprop | grep PID | grep -o \[0-9\]\*)
    echo pid is: $output_pid
    output_nodes=$(pw-dump | jq '.[] | if(.info.props."application.process.id" == '$output_pid' and .type == "PipeWire:Interface:Node") then .id else null end'| grep -v null)
    echo id of output nodes: $output_nodes
}

GetInput() {
    #ipid=$(xprop | grep PID | grep -o \[0-9\]\*)
    echo finding the nodes for $program_name
    input_nodes=$(pw-dump | jq '.[] | if(.info.props."application.process.binary" == "'$program_name'" and .type == "PipeWire:Interface:Node" and .info."max-input-ports" > 0) then .id else null end' | grep -v null)
    echo id of input nodes: $input_nodes
    for i in $input_nodes
    do
        echo finding ports for $i
        new_ports=$(pw-dump | jq '.[] | if(.type == "PipeWire:Interface:Port" and .info.direction == "input" and .info.props."node.id" == '$i') then .id else null end' | grep -v null)
        echo found $new_ports
        input_ports="${output_ports} ${new_ports}"
    done
    echo id of input ports: $input_ports
}

Connect() {
for i in $output_nodes
do
    outs=$(pw-dump | jq '.[] | if(.type == "PipeWire:Interface:Port" and .info.direction == "output" and .info.props."node.id" == '$i') then .id else null end' | grep -v null)
    for j in $outs
    do
        if [ $mode -eq 1 ];
        then
            for k in $input_ports
            do
                pw-link $j $k
                echo connected $j to $k
            done
        else
            for k in $input_ports
            do
                pw-link -d $j $k
                echo disconnected $j from $k
            done
        fi
    done
done
}

GetOutput
GetInput
Connect
