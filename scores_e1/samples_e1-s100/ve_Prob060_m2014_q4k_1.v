
module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    
    reg [3:0] dff1, dff2, dff3, dff4;

    
    always @(posedge clk or posedge resetn) begin
        if (!resetn) begin
            dff1 <= 4'b0000;
            dff2 <= 4'b0000;
            dff3 <= 4'b0000;
            dff4 <= 4'b0000;
        end else begin
            dff1 <= dff2;
            dff2 <= dff3;
            dff3 <= dff4;
            dff4 <= in;
        end
    end

    
    assign out = dff4;

endmodule
