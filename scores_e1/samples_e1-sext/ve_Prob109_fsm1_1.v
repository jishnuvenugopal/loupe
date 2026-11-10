
module TopModule (
    input wire clk,
    input wire areset,
    input wire in,
    output reg out
);

    
    reg state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                B: begin
                    if (in == 1'b0) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                A: begin
                    if (in == 1'b0) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
            endcase
        end
    end

    
    always @(*) begin
        out = state;
    end

endmodule
