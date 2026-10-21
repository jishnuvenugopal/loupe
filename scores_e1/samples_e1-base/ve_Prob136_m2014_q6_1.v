
module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    
    reg [1:0] state;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    if (w) begin
                        state <= 2'b01;
                    end else begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    if (w) begin
                        state <= 2'b00;
                    end else begin
                        state <= 2'b01;
                    end
                end
                2'b02: begin
                    if (w) begin
                        state <= 2'b03;
                    end else begin
                        state <= 2'b02;
                    end
                end
                2'b03: begin
                    if (w) begin
                        state <= 2'b02;
                    end else begin
                        state <= 2'b03;
                    end
                end
                2'b04: begin
                    if (w) begin
                        state <= 2'b05;
                    end else begin
                        state <= 2'b04;
                    end
                end
                2'b05: begin
                    if (w) begin
                        state <= 2'b04;
                    end else begin
                        state <= 2'b05;
                    end
                end
                2'b06: begin
                    if (w) begin
                        state <= 2'b07;
                    end else begin
                        state <= 2'b06;
                    end
                end
                2'b07: begin
                    if (w) begin
                        state <= 2'b06;
                    end else begin
                        state <= 2'b07;
                    end
                end
                2'b08: begin
                    if (w) begin
                        state <= 2'b09;
                    end else begin
                        state <= 2'b08;
                    end
                end
                2'b09: begin
                    if (w) begin
                        state <= 2'b08;
                    end else begin
                        state <= 2'b09;
                    end
                end
                2'b10: begin
                    if (w) begin
                        state <= 2'b11;
                    end else begin
                        state <= 2'b10;
                    end
                end
                2'b11: begin
                    if (w) begin
                        state <= 2'b10;
                    end else begin
                        state <= 2'b11;
                    end
                end
                2'b12: begin
                    if (w) begin
                        state <= 2'b13;
                    end else begin
                        state <= 2'b12;
                    end
                end
                2'b13: begin
                    if (w) begin
                        state <= 2'b12;
                    end else begin
                        state <= 2'b13;
                    end
                end
                2'b14: begin
                    if (w) begin
                        state <= 2'b15;
                    end else begin
                        state <= 2'b14;
                    end
                end
                2'b15: begin
                    if (w) begin
                        state <= 2'b14;
                    end else begin
                        state <= 2'b15;
                    end
                end
                default: begin
                    state <= 2'b00;
                end
            endcase
        end
    end

    
    assign z = state[1];

endmodule
