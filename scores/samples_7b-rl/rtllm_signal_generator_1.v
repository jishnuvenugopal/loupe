
module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 1'b0;
        wave <= 5'd0;
    end
    else begin
        case (state)
            
            1'b0: begin
                wave <= wave + 1;
                if (wave == 5'd30) begin
                    state <= 1'b1;
                end
                else begin
                    state <= 1'b0;
                end
            end
            
            1'b1: begin
                wave <= wave - 1;
                if (wave == 5'd1) begin
                    state <= 1'b0;
                end
                else begin
                    state <= 1'b1;
                end
            end
        endcase
    end
end

endmodule
