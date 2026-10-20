
module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    
    localparam IDLE       = 2'b00;
    localparam RECEIVING  = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] count;
    reg [7:0] data_reg;
    reg done_reg;

    assign done = done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            data_reg <= 0;
            done_reg <= 0;
        end
        else begin
            done_reg <= 0;
 
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin 
                        state <= RECEIVING;
                        count <= 0;
                    end
                end

                RECEIVING: begin
                    data_reg[count] <= in;
 
                    if (count == 3'd7) begin 
                        state <= CHECK_STOP;
                    end
                    else begin
                        count <= count + 1;
                    end
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin 
                        done_reg <= 1'b1;
                        state <= IDLE;
                    end
                    else begin
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin 
                        state <= IDLE;
                    end
                    else begin
                        state <= WAIT_STOP;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
