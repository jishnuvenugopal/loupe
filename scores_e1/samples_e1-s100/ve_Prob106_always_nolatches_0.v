
module TopModule (
    input wire [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    always @(posedge clk) begin
        case (scancode[15:0])
            16'b16'he06b: left <= 1'b1;
 
            16'b16'he072: down <= 1'b1;
 
            16'b16'he074: right <= 1'b1;
 
            16'b16'he075: up <= 1'b1;
  
            default: left <= 1'b0;
       
        endcase
    end

endmodule
