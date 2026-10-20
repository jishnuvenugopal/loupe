
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output wire z
);

    
    localparam [1:0] A = 2'b00;
    localparam [1:0] B = 2'b01;
    localparam [1:0] C = 2'b10;
    localparam [1:0] D = 2'b11;
    localparam [1:0] E = 2'b11;

    
    reg [1:0] state;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: if (w) state <= B;
 else state <= A;
                B: if (w) state <= C;
 else state <= D;
                C: if (w) state <= E;
 else state <= D;
                D: if (w) state <= F;
 else state <= A;
                E: if (w) state <= E;
 else state <= D;
                F: if (w) state <= C;
 else state <= D;
                default: state <= A;
            endcase
        end
    end

    
    assign z = ~state[0];

endmodule
