
module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    
    reg [8:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 9'b0;
            done <= 1'b0;
        end else begin
            case (state)
                9'b0: begin 
                    if (in == 1'b0) begin 
                        state <= 9'b1;
 
                    end else begin
                        state <= 9'b0;
 
                    end
                end
                9'b1: begin 
                    state[8] <= in;
 
                    state[7:0] <= state[7:0] << 1 | in;
                    if (in == 1'b1) begin 
                        state <= 9'b10;
 
                    end else begin
                        state <= 9'b1;
 
                    end
                end
                9'b10: begin 
                    if (in == 1'b1) begin 
                        state <= 9'b0;
 
                        done <= 1'b1;
 
                    end else begin
                        state <= 9'b10;
 
                    end
                end
                default: begin
                    state <= 9'b0;
 
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule
