
module barrel_shifter (in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output reg [7:0] out;

    
    reg [7:0] shifted4;
    reg [7:0] shifted2;
    reg [7:0] shifted1;

    
    assign shifted4 = {4'b0000, in[3:0]};

    
    mux2X1 shift2 (.in0(shifted4), .in1(shifted4), .sel(ctrl[1]), .out(shifted2));

    
    mux2X1 shift1 (.in0(shifted2), .in1(shifted2), .sel(ctrl[0]), .out(shifted1));

    
    assign out = shifted1;

endmodule


module mux2X1 (in0, in1, sel, out);
    input in0, in1;
    input sel;
    output out;

    assign out = (sel) ? in1 : in0;

endmodule
