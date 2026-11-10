
module TopModule (
    input  [7:0] in,
    output [8:0] parity
);

    assign parity = in ^ (in >> 1) ^ (in >> 2) ^ (in >> 3) ^ (in >> 4) ^ (in >> 5) ^ (in >> 6) ^ (in >> 7);

endmodule
