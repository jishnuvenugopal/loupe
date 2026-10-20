
module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    
    reg [3:0] count;

    
    always @(posedge reset) begin
        count <= 1'b1;
 
    end

    
    always @(posedge clk) begin
        if (reset) begin
            count <= 1'b1;
 
        end else begin
            count <= count + 1'b1;
 
            if (count == 4'b1000) begin
                count <= 1'b1;
 
            end
        end
    end

    
    assign q = count;

endmodule
