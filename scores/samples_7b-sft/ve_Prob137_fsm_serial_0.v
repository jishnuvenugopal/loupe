
module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    localparam [1:0] IDLE = 2'b00;
    localparam [1:0] COLLECT_DATA = 2'b01;
    localparam [1:0] CHECK_STOP = 2'b10;
    localparam [1:0] WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] counter;
    reg [7:0] shift_reg;

    
    always @(*) begin
        case (state)
            IDLE: next_state = in ? IDLE : COLLECT_DATA;
            COLLECT_DATA: next_state = (counter == 3'd7) ? CHECK_STOP : COLLECT_DATA;
            CHECK_STOP: next_state = in ? IDLE : WAIT_STOP;
            WAIT_STOP: next_state = in ? IDLE : WAIT_STOP;
            default: next_state = IDLE;
        endcase
    end

    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 3'b0;
            shift_reg <= 8'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    if (next_state == COLLECT_DATA) begin
                        counter <= 3'b0;
                        shift_reg <= 8'b0;
                    end
                end
                COLLECT_DATA: begin
                    shift_reg <= {shift_reg[6:0], in};
                    counter <= counter + 1;
                end
                default: begin
                    
                end
            endcase
        end
    end

    
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule
