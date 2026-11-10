
module TopModule (
    input wire a,
    input wire b,
    input wire cin,
    output reg cout,
    output reg sum
);

    
    reg [2:0] sumBits;
    reg [1:0] carryOut;

    
    always @(*) begin
        sumBits = {a, b, cin};
        carryOut = sumBits[2];
        sum = sumBits[1:0];
    end

endmodule
