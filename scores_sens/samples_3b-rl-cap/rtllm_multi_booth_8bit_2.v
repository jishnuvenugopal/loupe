
module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplier;
    reg [15:0] multiplicand;
    reg [4:0] ctr;
    reg [7:0] a_ext;
    reg [7:0] b_ext;

    
    assign a_ext = {8'b0, a};
    assign b_ext = {8'b0, b};

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplier <= {{8{b_ext[7]}}, b_ext};
            multiplicand <= {{8{a_ext[7]}}, a_ext};
            p <= 16'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 16) begin
                if (multiplier[ctr] == 1'b1) begin
                    p <= p + multiplicand;
                end else if (multiplier[ctr] == 1'b0) begin
                    p <= p - multiplicand;
                end else if (multiplier[ctr] == 1'b-1) begin
                    p <= p + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1;
            end else begin
                rdy <= 1'b1;
            end
        end
    end

endmodule
