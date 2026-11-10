
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    parameter B = 1'b0,
              A = 1'b1;

    
    reg [1:0] state;

    
    always @(*) begin
        state = B;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= B;
        end else begin
            case (state)
                B: begin
                    if (in == 0) begin
                        state <= A;
                    end else begin
                        state <= B;
                    end
                end
                A: begin
                    if (in == 0) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
            endcase
        end
    end

    
    assign out = state;

endmodule
