
module TopModule (
    input  [2:0] in,  
    output [1:0] out  
);

    
    reg [1:0] count;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            count <= 2'b00;
  
        end else begin
            count <= count + in;
  
        end
    end

    
    assign out = count;

endmodule
