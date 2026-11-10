
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    
    reg state = 1'bB;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'bB;
        end else begin
            case (state)
                1'bB: begin
                    if (in == 1'b0) begin
                        state <= 1'bA;
                    end else begin
                        state <= 1'bB;
                    end
                end
                1'bA: begin
                    if (in == 1'b0) begin
                        state <= 1'bB;
                    end else begin
                        state <= 1'bA;
                    end
                end
            endcase
        end
    end

    
    assign out = state;

endmodule
