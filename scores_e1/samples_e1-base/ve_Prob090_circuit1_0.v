
module TopModule (
    input wire a,
    input wire b,
    output reg q
);

    
    reg and_gate;
    always @(a or b) begin
        and_gate = a & b;
    end

    
    reg flip_flop;
    always @(posedge and_gate or negedge a or negedge b) begin
        if (and_gate) begin
            flip_flop <= 1'b1;
        end else begin
            flip_flop <= 1'b0;
        end
    end

    
    assign q = flip_flop;

endmodule
