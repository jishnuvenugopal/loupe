
module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);


localparam IDLE       = 2'b00;
localparam RECEIVE    = 2'b01;
localparam CHECK_STOP = 2'b10;
localparam WAIT_STOP  = 2'b11;

reg [1:0] current_state, next_state;
reg [2:0] bit_count;
reg [7:0] data_reg;


always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        bit_count <= 3'b0;
        data_reg <= 8'b0;
    end else begin
        current_state <= next_state;
        
        if (current_state == RECEIVE) begin
            data_reg[bit_count] <= in;
            bit_count <= bit_count + 1;
        end else begin
            bit_count <= 3'b0;
        end
    end
end


always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = (in == 1'b0) ? RECEIVE : IDLE;
        end
        RECEIVE: begin
            next_state = (bit_count == 3'd7) ? CHECK_STOP : RECEIVE;
        end
        CHECK_STOP: begin
            next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
        end
        WAIT_STOP: begin
            next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
        end
        default: next_state = IDLE;
    endcase
end


always @(*) begin
    done = 1'b0;
    if (current_state == CHECK_STOP && in == 1'b1) begin
        done = 1'b1;
    end
end

endmodule
