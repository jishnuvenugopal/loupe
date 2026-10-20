
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire ena,
    output reg pm,
    output reg [3:0] hh,
    output reg [3:0] mm,
    output reg [3:0] ss
);

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pm <= 1'b0;
 
            hh <= 4'b1100;
 
            mm <= 4'b0000;
 
            ss <= 4'b0000;
 
        end else begin
            
            if (ena) begin
                
                ss <= ss + 1'b1;
                if (ss == 4'b1000) begin
                    ss <= 4'b0000;
 
                    mm <= mm + 1'b1;
                    if (mm == 4'b1000) begin
                        mm <= 4'b0000;
 
                        hh <= hh + 1'b1;
                        if (hh == 4'b1100) begin
                            hh <= 4'b0000;
 
                            pm <= ~pm;
 
                        end
                    end
                end
            end
        end
    end

endmodule
