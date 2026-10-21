
module TopModule (
    input clk,
    input a,
    output q
);

    
    enum { Q0, Q1 } state;

    
    always @(posedge clk) begin
        case (state)
            Q0: begin
                if (a == 0) begin
                    state <= Q0;
                end else begin
                    state <= Q1;
                end
            end
            Q1: begin
                if (a == 0) begin
                    state <= Q0;
                end else begin
                    state <= Q1;
                end
            end
        endcase
    end

    
    assign q = state;

endmodule
