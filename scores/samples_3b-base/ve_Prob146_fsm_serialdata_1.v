
module TopModule (
    input  clk,
    input  in,
    input  reset,
    output out_byte,
    output done
);

    
    typedef enum {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    
    state_t state, next_state;

    
    reg [7:0] data;
    reg [7:0] out_byte_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data <= 8'b0;
            out_byte_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            data <= data;
            out_byte_reg <= out_byte_reg;
            done <= done;
        end
    end

    
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end
            START: begin
                if (in == 1'b1) begin
                    next_state = DATA;
                end else begin
                    next_state = START;
                end
            end
            DATA: begin
                if (in == 1'b1) begin
                    data <= {data[6:0], in};
                    next_state = DATA;
                end else begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in == 1'b0) begin
                    next_state = IDLE;
                    out_byte_reg <= data;
                    done <= 1'b1;
                end else begin
                    next_state = STOP;
                end
            end
        endcase
    end

    
    assign out_byte = out_byte_reg;

endmodule
