
module TopModule (a, b, out_assign, out_alwaysblock);
    input a, b;
    output out_assign, out_alwaysblock;
    
    
    assign out_assign = a & b;
    
    
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule
