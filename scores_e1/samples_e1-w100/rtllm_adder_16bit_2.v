
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output reg [15:0] y,
    output reg Co
);

    
    adder_8bit adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Co)
    );

    
    adder_8bit adder2 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule

module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output reg [7:0] y,
    output reg Co
);

    
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            y <= 8'b0;
            Co <= 1'b0;
        end else begin
            y <= a + b + Cin;
            Co <= y[8];
        end
    end

endmodule
