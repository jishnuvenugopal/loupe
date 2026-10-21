
module TopModule (
    input wire clock,
    input wire a,
    output reg p,
    output reg q
);

    
    reg [1:0] ff;

    
    always @(posedge clock) begin
        ff <= a;
    end

    
    always @(posedge clock) begin
        p <= ff[0];
        q <= ff[1];
    end

endmodule
