
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    
    
    
    
    
    
    
    
    
    

    always @(posedge clk) begin
        if (load) begin
            
            q <= data;
        end else begin
            
            reg [511:0] next_q;
            for (integer i = 0;
 i < 512;
 i = i + 1) begin
                
                integer left = i - 1;
                integer right = i + 1;
                if (left == -1) left = 511;
                if (right == 512) right = 0;
                
                case ({q[right], q[i], q[left]})
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
