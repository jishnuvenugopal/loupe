
module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);
    
    localparam S_IDLE = 4'b0000;
    localparam S_1 = 4'b0001;
    localparam S_11 = 4'b0010;
    localparam S_110 = 4'b0011;
    localparam S_1101 = 4'b0100;

    
    reg [1:0] state;

    
    assign start_shifting = (state == S_1101) ? 1'b1 : 1'b0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (data == 1'b1)
                        state <= S_1;
                end
                S_1: begin
                    if (data == 1'b1)
                        state <= S_11;
                    else
                        state <= S_IDLE;
                end
                S_11: begin
                    if (data == 1'b0)
                        state <= S_110;
                    else
                        state <= S_IDLE;
                end
                S_110: begin
                    if (data == 1'b1)
                        state <= S_1101;
                    else
                        state <= S_IDLE;
                end
                S_1101: begin
                    
                end
            endcase
        end
    end

endmodule
