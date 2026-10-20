
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    
    typedef enum {IDLE, START, DATA, STOP, DONE} state_t;
    state_t state;

    
    reg [7:0] data;
    reg [3:0] bit_count;

    
    reg stop;
    reg start;

    
    reg done_reg;

    
    reg [3:0] state_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            state_reg <= IDLE;
            data <= 8'b0;
            bit_count <= 4'b0;
            stop <= 1'b0;
            start <= 1'b0;
            done_reg <= 1'b0;
        end else begin
            state_reg <= state;
            data <= data;
            bit_count <= bit_count;
            stop <= stop;
            start <= start;
            done_reg <= done_reg;
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= START;
                    end else begin
                        state <= IDLE;
                    end
                end
                START: begin
                    state <= DATA;
                end
                DATA: begin
                    if (bit_count == 8) begin
                        state <= STOP;
                    end else begin
                        data[bit_count] <= in;
                        bit_count <= bit_count + 1;
                        state <= DATA;
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin
                        state <= DONE;
                    end else begin
                        state <= STOP;
                    end
                end
                DONE: begin
                    if (in == 1'b0) begin
                        state <= IDLE;
                    end else begin
                        state <= DONE;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            done_reg <= 1'b0;
        end else begin
            case (state)
                DATA: begin
                    if (bit_count == 8) begin
                        done_reg <= 1'b1;
                    end else begin
                        done_reg <= 1'b0;
                    end
                end
                default: begin
                    done_reg <= 1'b0;
                end
            endcase
        end
    end

    assign done = done_reg;

endmodule
