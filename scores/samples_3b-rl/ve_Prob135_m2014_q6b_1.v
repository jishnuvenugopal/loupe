
module TopModule (
    input  wire w,
    output wire Y1
);

    
    reg [2:0] y;

    
    always @(posedge w) begin
        case ({y[2:0], w})
            3'b000: y <= 3'b001;
 
            3'b001: y <= 3'b001;
 
            3'b010: y <= 3'b011;
 
            3'b011: y <= 3'b010;
 
            3'b100: y <= 3'b101;
 
            3'b101: y <= 3'b100;
 
            3'b110: y <= 3'b111;
 
            3'b111: y <= 3'b110;
 
            default: y <= 3'b000;
 
        endcase
    end

    
    assign Y1 = y[1];

endmodule
