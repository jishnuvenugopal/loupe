
module TopModule (
    input  [3:0] in,
    output [1:0] pos
);

    
    reg [1:0] counter = 2'b00;

    
    always @(posedge in) begin
        if (in[3]) begin
            counter = 2'b01;
        end else if (in[2]) begin
            counter = 2'b10;
        end else if (in[1]) begin
            counter = 2'b11;
        end
    end

    
    assign pos = counter;

endmodule
