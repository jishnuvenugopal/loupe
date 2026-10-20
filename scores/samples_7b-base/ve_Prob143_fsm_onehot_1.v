
module TopModule(
    input       in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg       out1,
    output reg       out2
);

    always @(*) begin
        
        if (state[0]) next_state = (in == 1) ? 10'b0000000001 : 10'b0000000000;
        else if (state[1]) next_state = (in == 1) ? 10'b0000000010 : 10'b0000000000;
        else if (state[2]) next_state = (in == 1) ? 10'b0000000100 : 10'b0000000000;
        else if (state[3]) next_state = (in == 1) ? 10'b0000001000 : 10'b0000000000;
        else if (state[4]) next_state = (in == 1) ? 10'b0000010000 : 10'b0000000000;
        else if (state[5]) next_state = (in == 0) ? 10'b0001010000 : (in == 1) ? 10'b0000000100 : 10'b0000000000;
        else if (state[6]) next_state = (in == 0) ? 10'b0010000100 : (in == 1) ? 10'b0000100000 : 10'b0000000000;
        else if (state[7]) next_state = 10'b0000101100;
        else if (state[8]) next_state = (in == 1) ? 10'b0000000011 : (in == 0) ? 10'b0010000000 : 10'b0000000000;
        else if (state[9]) next_state = (in == 1) ? 10'b0000000011 : (in == 0) ? 10'b0000100000 : 10'b0000000000;
        else next_state = 10'b0000000000;
  

        
        out1 = state[7] && state[1];
        out2 = state[7] && state[1];
    end

endmodule
