
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);
    reg [7:0] ss_reg;
    reg [7:0] mm_reg;
    reg [7:0] hh_reg;
    reg pm_reg;
    
    
    wire ss_ones = ss_reg[3:0];
    wire ss_tens = ss_reg[7:4];
    wire mm_ones = mm_reg[3:0];
    wire mm_tens = mm_reg[7:4];
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;
    assign pm = pm_reg;

    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;
            pm_reg <= 0;
        end
        else if (ena) begin
            
            if (ss_ones == 4'h9) begin
                ss_ones <= 4'h0;
                if (ss_tens == 4'h5) begin
                    ss_tens <= 4'h0;
                    
                    if (mm_ones == 4'h9) begin
                        mm_ones <= 4'h0;
                        if (mm_tens == 4'h5) begin
                            mm_tens <= 4'h0;
                            
                            if (hh_reg == 8'h12) begin
                                hh_reg <= 8'h01;
                                pm_reg <= ~pm_reg;
                            end
                            else if (hh_reg == 8'h11) begin
                                hh_reg <= 8'h12;
                            end
                            else begin
                                hh_reg <= hh_reg + 1;
                            end
                        end
                        else begin
                            mm_tens <= mm_tens + 1;
                        end
                    end
                    else begin
                        mm_ones <= mm_ones + 1;
                    end
                end
                else begin
                    ss_tens <= ss_tens + 1;
                end
            end
            else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end
endmodule
