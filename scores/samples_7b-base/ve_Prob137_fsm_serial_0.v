
module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    
    localparam IDLE = 2'b00,
              RECEIVE_DATA = 2'b01,
              CHECK_STOP = 2'b10;

    
    reg [1:0] state;
    reg [7:0] data;
    reg [2:0] bit_count;

    
    assign done = (state == CHECK_STOP && bit_count == 3'b111);

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= RECEIVE_DATA;
                        bit_count <= 0;
                    end
                end
                RECEIVE_DATA: begin
                    if (bit_count < 3'b100) begin
                        data[7 - bit_count] <= in;
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= CHECK_STOP;
                    end
                end
                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
