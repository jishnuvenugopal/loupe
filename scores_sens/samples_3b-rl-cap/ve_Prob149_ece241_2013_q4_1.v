
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire [2:0] s,
    output reg  fr2,
    output reg  fr1,
    output reg  fr0,
    output reg  dfr
);

    
    reg [2:0] prev_s;
    reg       prev_dfr;
    reg       prev_fr2;
    reg       prev_fr1;
    reg       prev_fr0;

    always @(posedge clk) begin
        if (reset) begin
            
            fr2   <= 1'b1;
            fr1   <= 1'b1;
            fr0   <= 1'b1;
            dfr   <= 1'b1;
            prev_s <= 3'b000;
            prev_dfr <= 1'b1;
            prev_fr2 <= 1'b1;
            prev_fr1 <= 1'b1;
            prev_fr0 <= 1'b1;
        end else begin
            
            if ((s[0] && !prev_s[0]) || (s[1] && !prev_s[1]) || (s[2] && !prev_s[2])) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end

            
            if (s[2]) begin
                
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end else if (s[0]) begin
                
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end else if (s[1]) begin
                
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end else if (s[0]) begin
                
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end else begin
                
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end

            
            prev_s <= s;
            prev_dfr <= dfr;
            prev_fr2 <= fr2;
            prev_fr1 <= fr1;
            prev_fr0 <= fr0;
        end
    end

endmodule
