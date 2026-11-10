
module adder_32bit (
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [31:0] S,
    output reg C32
);


module cla_16bit (
    input wire [3:0] A,
    input wire [3:0] B,
    input wire C_in,
    output reg [3:0] S,
    output reg C_out
);

    
    module cla_4bit (
        input wire [3:0] A,
        input wire [3:0] B,
        input wire C_in,
        output reg [3:0] S,
        output reg C_out
    );

        
        module cla_2bit (
            input wire [1:0] A,
            input wire [1:0] B,
            input wire C_in,
            output reg [1:0] S,
            output reg C_out
        );

            
            module cla_1bit (
                input wire [0:0] A,
                input wire [0:0] B,
                input wire C_in,
                output reg [0:0] S,
                output reg C_out
            );

                
                assign S = A ^ B ^ C_in;
                assign C_out = A & B | A & C_in | B & C_in;

                
                assign S = A ^ B ^ C_in;
                assign C_out = A & B | A & C_in | B & C_in;

                
                assign S = A ^ B ^ C_in;
                assign C_out = A & B | A & C_in | B & C_in;

                
                assign S = A ^ B ^ C_in;
                assign C_out = A & B | A & C_in | B & C_in;

            endmodule

        endmodule

    endmodule

endmodule
