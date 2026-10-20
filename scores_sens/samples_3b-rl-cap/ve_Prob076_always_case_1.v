
module TopModule (
    input  sel   ,
    input  data0 ,
    input  data1 ,
    input  data2 ,
    input  data3 ,
    input  data4 ,
    input  data5 ,
    output reg out
);

always @(*) begin
    case(sel)
        3'b000: out = data0;
        3'b001: out = data1;
        3'b010: out = data2;
        3'b011: out = data3;
        3'b100: out = data4;
        3'b101: out = data5;
        default: out = 4'b0000;
    endcase
end

endmodule
