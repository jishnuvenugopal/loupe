
module TopModule (
    input  d,
    input  ena,
    output q
);

    
    reg q = 0;

    
    always @(posedge ena or posedge d) begin
        if (ena) begin
            q <= d;
        end
    end

endmodule
