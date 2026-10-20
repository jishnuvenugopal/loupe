
module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

    
    reg [8:0] data_reg;
    reg [3:0] state;

    
    localparam IDLE = 4'd0;
    localparam STARTED = 4'd1;
    localparam DONE = 4'd2;

    
    
    
    

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 9'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= STARTED;
                        data_reg <= 9'd0;
                    end
                end
                STARTED: begin
                    data_reg <= {data_reg[8:0], in};
                    if (data_reg[8] == 1'b1) begin
                        state <= DONE;
                        out_byte <= data_reg[7:0];
                        done <= 1'b1;
                    end
                end
                DONE: begin
                    state <= IDLE;
                    done <= 1'b0;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
