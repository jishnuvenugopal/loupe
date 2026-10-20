
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    
    typedef enum {IDLE, DATA, STOP, WAIT} state_t;
    state_t state = IDLE;

    
    reg [3:0] state_reg;

    
    reg [7:0] data;

    
    reg [3:0] bit_count;

    
    reg start;

    
    reg stop;

    
    reg byte_received;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= IDLE;
            data <= 8'b0;
            bit_count <= 0;
            start <= 0;
            stop <= 0;
            byte_received <= 0;
        end else begin
            case (state_reg)
                IDLE: begin
                    if (in == 1'b0) begin
                        state_reg <= DATA;
                        bit_count <= 0;
                        start <= 1;
                    end else begin
                        state_reg <= IDLE;
                        start <= 0;
                    end
                end
                DATA: begin
                    data[bit_count] <= in;
                    bit_count <= bit_count + 1;
                    if (bit_count == 7) begin
                        state_reg <= STOP;
                        stop <= 1;
                    end else begin
                        state_reg <= DATA;
                        stop <= 0;
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin
                        state_reg <= IDLE;
                        stop <= 1;
                        byte_received <= 1;
                    end else begin
                        state_reg <= WAIT;
                        stop <= 0;
                        byte_received <= 0;
                    end
                end
                WAIT: begin
                    if (in == 1'b0) begin
                        state_reg <= IDLE;
                        stop <= 1;
                        byte_received <= 1;
                    end else begin
                        state_reg <= WAIT;
                        stop <= 0;
                        byte_received <= 0;
                    end
                end
                default: state_reg <= IDLE;
            endcase
        end
    end

    
    always @(*) begin
        if (state_reg == STOP && byte_received) begin
            done = 1'b1;
        end else begin
            done = 1'b0;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= IDLE;
        end else begin
            state_reg <= state;
        end
    end

    
    assign state = state_reg;

endmodule
