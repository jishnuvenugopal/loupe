
module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);

    
    wire [7:0] shifted4;
    wire [7:0] shifted2;
    wire [7:0] shifted1;

    
    assign shifted4 = {1'b0, in[7:4]};

    
    assign shifted2 = {1'b0, in[7:2]};

    
    assign shifted1 = {1'b0, in[7:0]};

    
    wire [7:0] shifted;
    wire sel4, sel2, sel1;

    assign sel4 = ctrl[2];
    assign sel2 = ctrl[1];
    assign sel1 = ctrl[0];

    
    mux2X1 mux4 (shifted4, shifted4, shifted4, sel4);
    
    mux2X1 mux2 (shifted2, shifted2, shifted4, sel2);
    
    mux2X1 mux1 (shifted1, shifted1, shifted2, sel1);

    
    assign shifted = sel4 ? shifted4 : (sel2 ? shifted2 : shifted1);

    
    assign out = shifted;

endmodule


module mux2X1 (
    input [7:0] data0,
    input [7:0] data1,
    input sel,
    output reg [7:0] out
);
    always @(*) begin
        if(sel)
            out = data1;
        else
            out = data0;
    end
endmodule
