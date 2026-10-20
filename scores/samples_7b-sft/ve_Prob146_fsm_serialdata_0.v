
module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);


localparam IDLE = 2'b00;
localparam DATA = 2'b01;
localparam STOP = 2'b10;
localparam WAIT_IDLE = 2'b11;

reg [1:0] current_state, next_state;
reg [7:0] shift_reg;
reg [2:0] bit_counter;


always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        shift_reg <= 8'b0;
        bit_counter <= 3'b0;
    end else begin
        current_state <= next_state;
        if (current_state == DATA) begin
            shift_reg <= {shift_reg[6:0], in};
            bit_counter <= bit_counter + 1;
        end else begin
            shift_reg <= 8'b0;
            bit_counter <= 3'b0;
        end
    end
end


always @(*) begin
    case (current_state)
        IDLE: begin
            if (in == 0)
                next_state = DATA;
            else
                next_state = IDLE;
        end
        DATA: begin
            if (bit_counter == 3'd7)
                next_state = STOP;
            else
                next_state = DATA;
        end
        STOP: begin
            if (in == 1)
                next_state = IDLE;
            else
                next_state = WAIT_IDLE;
        end
        WAIT_IDLE: begin
            if (in == 1)
                next_state = IDLE;
            else
                next_state = WAIT_IDLE;
        end
        default: next_state = IDLE;
    endcase
end


assign done = (current_state == STOP) && (in == 1);
assign out_byte = shift_reg;

endmodule
