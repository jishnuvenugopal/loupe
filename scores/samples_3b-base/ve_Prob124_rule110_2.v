
module TopModule (
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

    
    reg [511:0] next_q;

    
    always @(posedge clk) begin
        if (load) begin
            
            q <= data;
        end else begin
            
            for (int i = 1;
 i < 511;
 i++) begin
                case ({q[i-1], q[i], q[i+1]})
                    3'b111: next_q[i] = 1'b0;
                    3'b110: next_q[i] = 1'b1;
                    3'b101: next_q[i] = 1'b1;
                    3'b100: next_q[i] = 1'b0;
                    3'b011: next_q[i] = 1'b1;
                    3'b010: next_q[i] = 1'b1;
                    3'b001: next_q[i] = 1'b1;
                    3'b000: next_q[i] = 1'b0;
                    default: next_q[i] = 1'b0;
 
                endcase
            end
            
            q <= next_q;
        end
    end

endmodule
