
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    
    typedef enum {IDLE, START, STOP, ERROR} state_t;
    state_t state = IDLE;

    
    reg [7:0] data;
    reg [3:0] bit_count;

    
    reg stop_bit;

    
    reg done_reg;

    
    reg [3:0] state_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset)
            state_reg <= IDLE;
        else
            state_reg <= state;
    end

    
    assign state = state_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data      <= 8'b0;
            bit_count <= 4'b0;
            stop_bit  <= 1'b0;
            done_reg  <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= START;
                        data  <= 8'b0;
                        bit_count <= 4'b0;
                        stop_bit <= 1'b0;
                    end
                    done_reg <= 1'b0;
                end
                START: begin
                    if (bit_count < 8) begin
                        data [bit_count] <= in;
                        bit_count <= bit_count + 1'b1;
                    end else begin
                        state <= STOP;
                        stop_bit <= in;
                    end
                    done_reg <= 1'b0;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                        done_reg <= 1'b1;
                    end
                    done_reg <= 1'b0;
                end
                ERROR: begin
                    if (in == 1'b0) begin
                        state <= START;
                        data  <= 8'b0;
                        bit_count <= 4'b0;
                        stop_bit <= 1'b0;
                    end
                    done_reg <= 1'b0;
                end
                default: begin
                    state <= IDLE;
                    data  <= 8'b0;
                    bit_count <= 4'b0;
                    stop_bit <= 1'b0;
                    done_reg <= 1'b0;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset)
            done <= 1'b0;
        else
            done <= done_reg;
    end

endmodule
