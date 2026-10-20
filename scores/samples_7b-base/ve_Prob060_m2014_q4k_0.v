
module TopModule(
    input  clk,
    input  resetn,
    input  in,
    output out
);

    
    reg dff1, dff2, dff3, dff4;

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            dff1 <= 1'b0;
            dff2 <= 1'b0;
            dff3 <= 1'b0;
            dff4 <= 1'b0;
        end else begin
            
            dff4 <= dff3;
            dff3 <= dff2;
            dff2 <= dff1;
            dff1 <= in;
        end
    end

    
    assign out = dff1;

endmodule
