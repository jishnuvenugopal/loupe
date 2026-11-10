
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge
);

    
    reg [7:0] q;
    reg [7:0] next_q;

    
    reg [3:0] transition_count;

    
    assign q = 8'b0;

    
    always @(posedge clk) begin
        
        next_q = in;

        
        if (in != q) begin
            transition_count = transition_count + 1;
            if (transition_count == 1) begin
                anyedge[transition_count-1] = 1'b1;
            end
        end else begin
            transition_count = 0;
        end

        
        q = next_q;
    end

endmodule
