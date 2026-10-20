
module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] ena,
    output reg [15:0] q
);

    
    reg [3:0] count;
    reg [3:0] digit;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            digit <= 0;
            ena <= 4'b0000;
        end else begin
            
            count <= count + 1;

            
            if (count == 9) begin
                count <= 0;
                digit <= digit + 1;
                ena <= {ena[3:1], 1'b1};
            end else begin
                ena <= {ena[3:1], 1'b0};
            end
        end
    end

    
    always @(*) begin
        q = {count[3:0], count[7:4], count[11:8], count[15:12]};
    end

endmodule
