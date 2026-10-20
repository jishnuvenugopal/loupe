
module barrel_shifter (
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    
    wire [7:0] shifted_in0, shifted_in1, shifted_in2, shifted_in3;

    
    assign shifted_in0 = (ctrl[2] ? {in[3:0], 4'b0000} : in);

    
    assign shifted_in1 = (ctrl[1] ? {shifted_in0[1:0], 2'b00} : shifted_in0);

    
    assign shifted_in2 = (ctrl[0] ? {shifted_in1[0], 1'b0} : shifted_in1);

    
    assign out = shifted_in2;

endmodule


module mux2X1 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       sel,
    output reg  [7:0] y
);
    always @(*) begin
        if (sel)
            y = a;
        else
            y = b;
    end
endmodule
