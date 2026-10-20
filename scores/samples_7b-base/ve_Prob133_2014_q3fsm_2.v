
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    
    localparam STATE_A = 2'b00;
    localparam STATE_B = 2'b01;

    
    reg [1:0] state;
    reg [2:0] w_count;
    reg z_reg;

    
    reg [1:0] next_state;
    reg [2:0] next_w_count;
    reg next_z;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_A;
            w_count <= 3'b000;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            z <= next_z;
        end
    end

    
    always @(*) begin
        if (reset) begin
            next_state = STATE_A;
            next_w_count = 3'b000;
            next_z = 1'b0;
        end else begin
            case (state)
                STATE_A:
                    if (s) begin
                        next_state = STATE_B;
                        next_w_count = 3'b000;
                    end else begin
                        next_state = STATE_A;
                        next_w_count = 3'b000;
                    end
                STATE_B:
                    begin
                        next_state = STATE_B;
                        if (w) begin
                            next_w_count = w_count + 1;
                        end else begin
                            next_w_count = w_count;
                        end
                        if (w_count == 3'b010 || w_count == 3'b100) begin
                            next_z = 1'b1;
                        end else begin
                            next_z = 1'b0;
                        end
                    end
            endcase
        end
    end

endmodule
