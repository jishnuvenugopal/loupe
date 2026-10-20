
module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

    
    reg [7:0] data_reg;
    reg [2:0] state;

    
    localparam IDLE   = 3'd0;
    localparam START  = 3'd1;
    localparam STOP   = 3'd2;

    
    always @(posedge clk) begin
        if (reset) begin
            state   <= IDLE;
            data_reg <= 8'd0;
            done    <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= START;
                    end else begin
                        state <= IDLE;
                    end
                end
                START: begin
                    if (in == 1'b1) begin
                        state <= STOP;
                    end else begin
                        data_reg <= data_reg << 1 | in;
                        state <= START;
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                        done  <= 1'b1;
                    end else begin
                        state <= STOP;
                        done  <= 1'b0;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    
    always @(posedge clk) begin
        if (done) begin
            out_byte <= data_reg;
        end else begin
            out_byte <= 8'd0;
        end
    end

endmodule
