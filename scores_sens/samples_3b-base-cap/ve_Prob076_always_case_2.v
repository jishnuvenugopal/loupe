
module TopModule (
    input  sel,  
    input  [3:0] data0, data1, data2, data3, data4, data5,  
    output [3:0] out  
);

    
    assign out = 4'b0;

    
    always @(*) begin
        case (sel)
            3'b000: out = data0;
            3'b001: out = data1;
            3'b010: out = data2;
            3'b011: out = data3;
            3'b100: out = data4;
            3'b101: out = data5;
            default: out = 4'b0;
  
        endcase
    end

endmodule
