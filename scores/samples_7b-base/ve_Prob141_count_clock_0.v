
module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [0:7] hh,
    output reg [0:7] mm,
    output reg [0:7] ss
);

reg [2:0] count_hh, count_mm, count_ss;
reg overflow_ss;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count_hh <= 3'b001;
        count_mm <= 3'b000;
        count_ss <= 3'b000;
        pm <= 1'b0;
 
    end else begin
        if (ena) begin
            if (overflow_ss) begin
                count_ss <= 3'b000;
                count_mm <= count_mm + 1;
            end else begin
                count_ss <= count_ss + 1;
            end

            if (count_mm == 3'b111) begin
                count_mm <= 3'b000;
                count_hh <= count_hh + 1;
            end

            if (count_hh == 3'b101) begin
                count_hh <= 3'b001;
                pm <= ~pm;
 
            end

            overflow_ss = (count_ss == 3'b011);
 
        end
    end
end

always @(count_hh, count_mm, count_ss) begin
    
    hh = {count_hh[2], count_hh[1:0]};
    mm = count_mm;
    ss = count_ss;
end

endmodule
