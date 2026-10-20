
module TopModule (
    input  wire        clk,
    input  wire        in,
    input  wire        reset,
    output reg [7:0]   out_byte,
    output reg         done
);

    
    reg [7:0] data;
    reg stop;
    reg [2:0] state;

    
    localparam IDLE = 3'd0;
    localparam DATA_COLLECT = 3'd1;
    localparam DONE = 3'd2;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data <= 8'd0;
            stop <= 1'b0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= DATA_COLLECT;
                        data <= 8'd0;
                        stop <= 1'b0;
                    end
                end
                DATA_COLLECT: begin
                    data <= {data[6:0], in};
                    if (data[7] == 1'b0) begin
                        stop <= 1'b0;
                    end else begin
                        stop <= 1'b1;
                    end
                    if (stop) begin
                        state <= DONE;
                        out_byte <= data;
                        done <= 1'b1;
                    end
                end
                DONE: begin
                    state <= IDLE;
                    data <= 8'd0;
                    stop <= 1'b0;
                    out_byte <= 8'd0;
                    done <= 1'b0;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
