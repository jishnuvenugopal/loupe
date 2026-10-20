
module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    
    function logic get_neighbour(logic [3:0] input, int index);
        if (index == 3) begin
            get_neighbour = input[0];
        end else begin
            get_neighbour = input[index + 1];
        end
    endfunction

    
    assign out_both[0] = (in[0] & in[1]);
    assign out_both[1] = (in[1] & in[2]);
    assign out_both[2] = (in[2] & in[3]);

    
    assign out_any[0] = (in[0] | in[1]);
    assign out_any[1] = (in[1] | in[2]);
    assign out_any[2] = (in[2] | in[3]);
    assign out_any[3] = (in[3] | in[0]);

    
    assign out_different[0] = (in[0] != in[1]);
    assign out_different[1] = (in[1] != in[2]);
    assign out_different[2] = (in[2] != in[3]);
    assign out_different[3] = (in[3] != in[0]);

endmodule
