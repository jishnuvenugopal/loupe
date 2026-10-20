
module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    
    localparam S_IDLE        = 2'd0,
               S_RECEIVE     = 2'd1,
               S_CHECK_STOP  = 2'd2,
               S_WAIT_STOP   = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;
 

            case (state)
                S_IDLE: begin
                    if (!in) begin 
                        state <= S_RECEIVE;
                        bit_count <= 0;
                        shift_reg <= 0;
                    end
                end

                S_RECEIVE: begin
                    
                    shift_reg <= {in, shift_reg[7:1]};
 
                    bit_count <= bit_count + 1;

                    if (bit_count == 3'd7) begin
                        state <= S_CHECK_STOP;
                    end
                end

                S_CHECK_STOP: begin
                    if (in == 1'b1) begin 
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= S_IDLE;
                    end else begin
                        
                        state <= S_WAIT_STOP;
                    end
                end

                S_WAIT_STOP: begin
                    if (in == 1'b1) begin 
                        state <= S_IDLE;
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
