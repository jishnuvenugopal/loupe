
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    reg [1:0] state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    z <= x;
                    state <= 2'b01;
                end
                2'b01: begin
                    z <= ~x;
                    state <= 2'b00;
                end
                default: begin
                    state <= 2'b00;
                end
            endcase
        end
    end

endmodule
