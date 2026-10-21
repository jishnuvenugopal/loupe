
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    enum logic [1:0] {B, A} state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= B;
        end else begin
            case (state)
                B: begin
                    if (in == 0) begin
                        state <= A;
                    end else if (in == 1) begin
                        state <= B;
                    end
                end
                A: begin
                    if (in == 0) begin
                        state <= B;
                    end else if (in == 1) begin
                        state <= A;
                    end
                end
            endcase
        end
    end

    
    assign out = state;

endmodule
