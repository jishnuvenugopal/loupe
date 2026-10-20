
module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    
    localparam IDLE = 2'b00;
    localparam RECEIVE_DATA = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state_reg, state_next;
    reg [2:0] bit_counter;
    reg [7:0] data_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            state_reg <= IDLE;
            bit_counter <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            state_reg <= state_next;
            if (state_reg == RECEIVE_DATA) begin
                data_reg <= {in, data_reg[7:1]};
                bit_counter <= bit_counter + 1;
            end else if (state_reg == IDLE) begin
                bit_counter <= 3'b0;
                data_reg <= 8'b0;
            end else begin
                bit_counter <= bit_counter;
                data_reg <= data_reg;
            end
        end
    end

    
    always @(*) begin
        case (state_reg)
            IDLE: state_next = (in == 0) ? RECEIVE_DATA : IDLE;
            RECEIVE_DATA: state_next = (bit_counter == 3'd7) ? CHECK_STOP : RECEIVE_DATA;
            CHECK_STOP: state_next = (in == 1) ? IDLE : WAIT_STOP;
            WAIT_STOP: state_next = (in == 1) ? IDLE : WAIT_STOP;
            default: state_next = IDLE;
        endcase
    end

    
    assign done = (state_reg == CHECK_STOP) && (in == 1);

endmodule
