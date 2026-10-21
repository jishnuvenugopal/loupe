
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg [3:0] ena
);

    
    reg [3:0] counter1, counter2, counter3, counter4;

    
    reg [3:0] enable1, enable2, enable3, enable4;

    
    always @(posedge clk) begin
        if (reset) begin
            counter1 <= 4'b0000;
            counter2 <= 4'b0000;
            counter3 <= 4'b0000;
            counter4 <= 4'b0000;
            enable1 <= 4'b0000;
            enable2 <= 4'b0000;
            enable3 <= 4'b0000;
            enable4 <= 4'b0000;
        end else begin
            
            if (ena[0]) counter1 <= counter1 + 1'b1;
            if (ena[1]) counter2 <= counter2 + 1'b1;
            if (ena[2]) counter3 <= counter3 + 1'b1;
            if (ena[3]) counter4 <= counter4 + 1'b1;
        end
    end

    
    assign q = {counter4, counter3, counter2, counter1};

    
    assign ena = {enable4, enable3, enable2, enable1};

endmodule
