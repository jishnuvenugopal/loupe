
module TopModule (
    input wire clk,
    input wire d,
    output reg q
);


reg q_next;


always @(posedge clk) begin
    q_next <= d;
 
end


assign q = q_next;

endmodule
