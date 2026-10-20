
module barrel_shifter (in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] temp0, temp1, temp2;

    
    module mux2X1 (sel, in0, in1, out);
        input sel, in0, in1;
        output reg out;

        always @(*) begin
            if (sel)
                out = in1;
            else
                out = in0;
        end
    endmodule

    
    wire shift4 = ctrl[2];
    assign temp0[7:4] = (shift4) ? 4'b0000 : in[7:4];
    assign temp0[3:0] = (shift4) ? in[3:0] : 4'b0000;

    
    wire shift2 = ctrl[1];
    assign temp1[7:6] = (shift2) ? temp0[7:6] : temp0[7:4];
    assign temp1[5:4] = (shift2) ? 2'b00 : temp0[3:2];
    assign temp1[3:0] = (shift2) ? temp0[3:0] : 4'b0000;

    
    wire shift1 = ctrl[0];
    assign temp2[7:7] = (shift1) ? temp1[7:7] : temp1[7:6];
    assign temp2[6:5] = (shift1) ? 2'b00 : temp1[5:4];
    assign temp2[4:3] = (shift1) ? 2'b00 : temp1[3:2];
    assign temp2[2:1] = (shift1) ? 2'b00 : temp1[2:1];
    assign temp2[0] = (shift1) ? temp1[0] : 1'b0;

    
    assign out = temp2;
endmodule
