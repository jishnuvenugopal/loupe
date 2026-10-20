
module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

    
    reg [8:0] data_reg;
    reg [2:0] state;

    
    localparam IDLE = 3'd0;
    localparam DATA_COLLECT = 3'd1;
    localparam DONE = 3'd2;

    
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'b0;
        end else begin
            out_byte <= data_reg[8:1];
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            done <= state == DONE;
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 9'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= DATA_COLLECT;
                        data_reg <= 9'b0;
                    end else begin
                        state <= IDLE;
                    end
                end
                DATA_COLLECT: begin
                    data_reg <= {data_reg[8:1], in};
                    if (state == DATA_COLLECT && in == 1'b1) begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    state <= IDLE;
                    data_reg <= 9'b0;
                end
                default: begin
                    state <= IDLE;
                    data_reg <= 9'b0;
                end
            endcase
        end
    end

endmodule
