
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] s_prev;

    always @(posedge clk) begin
        if (reset) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            s_prev <= 3'b000;
        end else begin
            
            s_prev <= s;

            
            if (s[2] == 1'b1) begin
                
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end else if (s[0] == 1'b0) begin
                
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end else if (s[1] == 1'b1) begin
                
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end else begin
                
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end

            
            if (s_prev < s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
    end

endmodule
