
module TopModule (
    input wire [254:0] in,
    output wire [7:0] out
);

    reg [7:0] count;

    always @(posedge in) begin
        count <= count + in;
    end

    assign out = count;

endmodule
